Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A61398D0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgAMSY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMSY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 13:24:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF02A2075B;
        Mon, 13 Jan 2020 18:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578939896;
        bh=TYiZmS2cqXFcdDYMRtOojvE8nEkWO/1mqNQOHr06Hng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksoFWtmxRVCf4m6bN5P40SIXujcajkqcH8upObCEW4MYXEPKPraNMwcRKkrefKpIx
         Ccc7xtown4SLfKsTOvyiz2mwi7nU9BzvvXdXuoEav2L3yKq65+Ys/7tYcnBCWhVuDh
         hudI+prtkqCuntIPK/KPK2uRzlHBN2iNk1Bue1Rg=
Date:   Mon, 13 Jan 2020 19:24:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Tim Sander <tim@krieglstein.org>,
        Jayati Sahu <jayati.sahu@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
        netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        andriy.shevchenko@linux.intel.com
Subject: Re: Commit bfdbfd28f76028b960458d107dc4ae9240c928b3 leads to crash
 on Intel SocFPGA Cyclone 5 DE0 NanoSoc
Message-ID: <20200113182453.GD411698@kroah.com>
References: <1758567.4I393bidJ1@dabox>
 <d10a0557-cca0-64a9-9971-7455d67d0dc3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d10a0557-cca0-64a9-9971-7455d67d0dc3@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 09:51:54AM -0800, Florian Fainelli wrote:
> On 1/13/20 9:37 AM, Tim Sander wrote:
> > Hi
> > 
> > I just found out that the commit bfdbfd28f76028b960458d107dc4ae9240c928b3
> > which also went in the stable release series causes an oops
> > in the stmicro driver an a Terrasic DE0 NanoSoc board with Intel SocFPGA 
> > CycloneV chip. I am currently following Preempt-RT that's why i just noticed 
> > only yet when testing 5.4.10-rt5 but this also occurs without any Preempt-RT 
> > patchset. Reverting the patch fixes the oops.
> > 
> > It would be nice if this change could be reverted or otherwise fixed.
> 
> This should be fixed with:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=da29f2d84bd10234df570b7f07cbd0166e738230
> 
> which will likely make it so stable soon.

It was already in the 5.4.11 kernel release.  Tim, can you try that?

thanks,

greg k-h
