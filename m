Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4E2C2C5C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390130AbgKXQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgKXQJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:09:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F777206FB;
        Tue, 24 Nov 2020 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606234139;
        bh=NpR85UpwSmxbQV0TV7clYCW3T/LbfOg5VMBGqSXsGQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wsTwP0eGqn3fzOMYzJcIXcOkoHZXcj92lq4m9HJ9xJrIs5ebO1RZZA1R8MvaCrhN5
         8wjNEbqff6RyU0zTBFfSgqU6bOmo/cXaA0pKuD1LfZgpnQtnufJ1ezHiDe/sKmI+A5
         tc+/TOQ5mzTwXT0Lp/Jpnk8pxwGekC5adfIKwKXw=
Date:   Tue, 24 Nov 2020 08:08:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-11-23
Message-ID: <20201124080858.0aa8462b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87im9vql7i.fsf@codeaurora.org>
References: <20201123161037.C11D1C43460@smtp.codeaurora.org>
        <20201123153002.2200d6be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87im9vql7i.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 09:15:45 +0200 Kalle Valo wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Mon, 23 Nov 2020 16:10:37 +0000 (UTC) Kalle Valo wrote:  
> >> wireless-drivers fixes for v5.10
> >> 
> >> First set of fixes for v5.10. One fix for iwlwifi kernel panic, others
> >> less notable.
> >> 
> >> rtw88
> >> 
> >> * fix a bogus test found by clang
> >> 
> >> iwlwifi
> >> 
> >> * fix long memory reads causing soft lockup warnings
> >> 
> >> * fix kernel panic during Channel Switch Announcement (CSA)
> >> 
> >> * other smaller fixes
> >> 
> >> MAINTAINERS
> >> 
> >> * email address updates  
> >
> > Pulled, thanks!
> >
> > Please watch out for missing sign-offs.  
> 
> I assume you refer to commit 97cc16943f23, sorry about that. Currently
> I'm just manually checking sign-offs and missed this patch. My plan is
> to implement proper checks to my patchwork script so I'll notice these
> before I commit the patch (or pull request), just have not yet find the
> time to do that.

Check out verify_fixes and verify_signoff in Greg's repo:

https://github.com/gregkh/gregkh-linux/tree/master/work
