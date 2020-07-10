Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364A621BF59
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgGJVpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJVpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:45:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90EBC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 14:45:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6601312860344;
        Fri, 10 Jul 2020 14:45:00 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:44:59 -0700 (PDT)
Message-Id: <20200710.144459.1317276747917429038.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux@roeck-us.net
Subject: Re: [PATCH net] cgroup: Fix sock_cgroup_data on big-endian.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710135424.609af50a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200709170320.2fa4885b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200710.134747.830440492796528440.davem@davemloft.net>
        <20200710135424.609af50a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:45:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 10 Jul 2020 13:54:24 -0700

> On Fri, 10 Jul 2020 13:47:47 -0700 (PDT) David Miller wrote:
>> From: Jakub Kicinski <kuba@kernel.org>
>> Date: Thu, 9 Jul 2020 17:03:20 -0700
>> 
>> > On Thu, 09 Jul 2020 16:32:35 -0700 (PDT) David Miller wrote:  
>> >> From: Cong Wang <xiyou.wangcong@gmail.com>
>> >> 
>> >> In order for no_refcnt and is_data to be the lowest order two
>> >> bits in the 'val' we have to pad out the bitfield of the u8.
>> >> 
>> >> Fixes: ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()")
>> >> Reported-by: Guenter Roeck <linux@roeck-us.net>
>> >> Signed-off-by: David S. Miller <davem@davemloft.net>  
>> > 
>> > FWIW Cong's listed in From: but there's no sign-off from him so the
>> > signoff checking script may get upset about this one.  
>> 
>> I wonder how I should handle that situation though?  I want to give
>> Cong credit for the change, and not take full credit for it myself.
> 
> Cong, would you mind responding with a Sign-off for the patch?

That's not useful for two reasons:

1) This commit is in my tree and the commit message is immutable.

2) I needed to apply this patch because I didn't have time to wait for
   a turn-around from Cong or anyone else.  That's the situation where
   I'm asking "what should I do in this situation?"  I don't have the
   luxury of waiting for the author to reply and add a signoff because
   I'm trying to get a pull request out to Linus with the fix or
   similar.

Is it more clear now? :-)
