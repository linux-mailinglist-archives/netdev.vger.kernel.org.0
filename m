Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BB52A7048
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgKDWPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732110AbgKDWOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 17:14:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5EEA20870;
        Wed,  4 Nov 2020 22:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604528051;
        bh=p8WZNXhT84AyErnmCYGqiG2iQip7NSsmnxBg8O6JURI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jZ5+/TTE/rTQmNr4fSkxmBofK8zLbqT8HfOrqVmUgB+lpJmR5z25wXsv3xKRKneIm
         2IauI0ExQHu0kAbNCdmd9KQdTkiPFlJQnbivY/6xR7wQIDDEo9q22tuhluwEncceq0
         geenxQB3y6UGIWiUhJSZye5fGichA6LA5//3nfgk=
Date:   Wed, 4 Nov 2020 14:14:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     drt <drt@linux.vnet.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: merge do_change_param_reset into
 do_reset
Message-ID: <20201104141409.1a451f33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63365b7e683e2c3b1b8e41c51668b401@linux.vnet.ibm.com>
References: <20201031094645.17255-1-ljp@linux.ibm.com>
        <20201103150915.4411306e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <63365b7e683e2c3b1b8e41c51668b401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020 13:56:09 -0800 drt wrote:
> On 2020-11-03 15:09, Jakub Kicinski wrote:
> > On Sat, 31 Oct 2020 04:46:45 -0500 Lijun Pan wrote:  
> >> Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
> >> linkwatch_event can run") introduced do_change_param_reset function to
> >> solve the rtnl lock issue. Majority of the code in 
> >> do_change_param_reset
> >> duplicates do_reset. Also, we can handle the rtnl lock issue in 
> >> do_reset
> >> itself. Hence merge do_change_param_reset back into do_reset to clean 
> >> up
> >> the code.
> >> 
> >> Fixes: b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so 
> >> linkwatch_event can run")
> >> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>  
> > 
> > Applied, thanks!  
> 
> Hi Jakub,
> 
> Thank you for applying this patch so promptly. However, I would like to 
> ask that this patch be withdrawn.
> 
> 1. It needs more time in testing.
> 2. There are a number of bug fix patches being tested. This patch would 
> require rework of those patches.
> 3. As the lead maintainer for ibmvnic, I failed to communicate this to 
> Lijun. I will do better going forward.
> 
> Please revert this commit. We will resubmit this patch later.
> 
> I sincerely apologize for any trouble this may have caused.

No worries, please just send a revert patch with this information in
the commit message, and I'll apply right away.

BTW feel free to send a note if you need more time to review a
particular patch. Because of the volume of patches we get, I try to
apply things after a day or two. Otherwise the queue gets unmanageable.
