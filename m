Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A57421BEC6
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGJUy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJUy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:54:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E14206C3;
        Fri, 10 Jul 2020 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594414465;
        bh=9J5cIbPkhb/OW9O7rePCefcfgVdcFk9N0AecoRP0UkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tSd2lUkhdxEELbVcw6DvTTO4y3L+tL0p3Dslgai0mPx9L8yt22OYC19P7lW1C4kFo
         C+m2aTOmbYAiIpk4LK5766WgUc72WbLfkjcwQuY6rvIEw8eg3D+VlenLsuYeBkB5NY
         UeURIFH6hv/ved6fztLq4j5e7i7sFUgVda2EZXIM=
Date:   Fri, 10 Jul 2020 13:54:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, linux@roeck-us.net
Subject: Re: [PATCH net] cgroup: Fix sock_cgroup_data on big-endian.
Message-ID: <20200710135424.609af50a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200710.134747.830440492796528440.davem@davemloft.net>
References: <20200709.163235.585914476648957821.davem@davemloft.net>
        <20200709170320.2fa4885b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200710.134747.830440492796528440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 13:47:47 -0700 (PDT) David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 9 Jul 2020 17:03:20 -0700
> 
> > On Thu, 09 Jul 2020 16:32:35 -0700 (PDT) David Miller wrote:  
> >> From: Cong Wang <xiyou.wangcong@gmail.com>
> >> 
> >> In order for no_refcnt and is_data to be the lowest order two
> >> bits in the 'val' we have to pad out the bitfield of the u8.
> >> 
> >> Fixes: ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()")
> >> Reported-by: Guenter Roeck <linux@roeck-us.net>
> >> Signed-off-by: David S. Miller <davem@davemloft.net>  
> > 
> > FWIW Cong's listed in From: but there's no sign-off from him so the
> > signoff checking script may get upset about this one.  
> 
> I wonder how I should handle that situation though?  I want to give
> Cong credit for the change, and not take full credit for it myself.

Cong, would you mind responding with a Sign-off for the patch?
