Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B942F1F8C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390979AbhAKTdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733211AbhAKTdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:33:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ADB422CAD;
        Mon, 11 Jan 2021 19:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610393570;
        bh=nQNm2QaBMaUDcE8z4FwngPZORNpwur7SNDOEKELgtjo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+rua0ZJo43uJ8Th+NO9N4NRAqOFH/P+TqMpyd8wbKvBqqaJhpGWqAqSj59oZhYue
         pSn/xx5bDfvRalcDp2L1/ByWccvjdNkiUTyRmQEJyITSNQQPlfOt7Vx85aaYXzdyvU
         Q8ORlLI2+yG4Bk2cKkQThsLjDuUA+kxisE7ErMXz125DFvDuhn91N1UkoHAzgPWsfu
         v92JE1jwad+Hh3AU6uyAlX8EH7D4VSRAUx+jlsKFMk1px+S5BAPn/OPZlySfglQ6sH
         wWw3JX8WF7hg7YBZwsWbmyZLH3/ncAJyzIvRMj5oyoJUv+oSUl1Tky7hVB7UL83pUM
         wQ4WDE85sPiBA==
Date:   Mon, 11 Jan 2021 11:32:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 2/7] ibmvnic: update reset function prototypes
Message-ID: <20210111113249.1026433f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111031221.GA165065@us.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
        <20210108071236.123769-3-sukadev@linux.ibm.com>
        <20210109193755.606a4aef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111031221.GA165065@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 19:12:21 -0800 Sukadev Bhattiprolu wrote:
> Jakub Kicinski [kuba@kernel.org] wrote:
> > On Thu,  7 Jan 2021 23:12:31 -0800 Sukadev Bhattiprolu wrote:  
> > > The reset functions need just the 'reset reason' parameter and not
> > > the ibmvnic_rwi list element. Update the functions so we can simplify
> > > the handling of the ->rwi_list in a follow-on patch.
> > > 
> > > Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
> > >   
> > 
> > No empty lines after Fixes tags, please. They should also not be
> > wrapped.  
> 
> Ah ok, will fix.
> >   
> > > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>  
> > 
> > Are these patches for net or net-next? It looks like they are fixing
> > races, but at the same time they are rather large. Can you please
> > produce minimal fixes, e.g. patch 3 should just fix the existing leaks
> > rather than refactor the code to not do allocations. 130+ LoC is a lot
> > for a fix.  
> 
> This is a set of bug fixes, but yes a bit large. Should I submit to
> net-next instead?

I'd rather you tried to address the problems with minimal patches, then
you can refactor the code in net-next.
