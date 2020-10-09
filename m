Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C982288667
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbgJIJxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733300AbgJIJxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:53:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE1A522258;
        Fri,  9 Oct 2020 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602237221;
        bh=6HSAtlosTuvLii0lDuA/eNQB3cDV1llV2Y9So14ol98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DhjVpKS/sUD+sNm36heb0uEqyGLycaVWCPLkXUGjQc123/UT07IdckpOb0G+sGSgD
         in7XddYYACRE9ehiZ3f23Plo5mKLancoOZaVk0pwCKYPs4DrnTUTH4/pwUO3/BqA6/
         k/o8gfgFrgWhInAgnyXM3ioiejQRVacSbRyGeFCM=
Date:   Fri, 9 Oct 2020 11:54:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: repair "fixed-link" support
Message-ID: <20201009095427.GA489317@kroah.com>
References: <20200108160957.253567-1-alexander.sverdlin@nokia.com>
 <d86d096a-c62a-88fb-c251-6a991b26ddd8@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86d096a-c62a-88fb-c251-6a991b26ddd8@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 11:40:24AM +0200, Alexander Sverdlin wrote:
> Hello Greg, Dave and all,
> 
> the below patch is still applicable as-is, would you please re-consider it now,
> as the driver has been undeleted?
> 
> On 08/01/2020 17:09, Alexander X Sverdlin wrote:

Why would we have a patch from January still in our inboxes? :)

Please resend.

thanks,

greg k-h
