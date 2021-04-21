Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4DB367338
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhDUTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235535AbhDUTNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ADA361450;
        Wed, 21 Apr 2021 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619032362;
        bh=b+GjSBhOfGIgAzi+201V/kAJ9Z2m1RYmE+LL59Jn8wY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bzkyH+Odfo6HMlnc5/MNGW0HHRfwTn9tnAq2OuyzkGQp+HP53VrRZUukjW8SpKfpF
         VItw5iwFrkmHzMbPTgq2UsesUhUgSZ7yvQEh6vZAZ3LXcmbtFwQokRt1/Dwfi7K2FS
         TkGfXOyfdOxTlOFTxESUmgMu24lp5YOu2tUn/jQeRgO3c4cYhVyAbinKM9eHJLvOrZ
         5RRTfPua0n8Au3+FJc8xCBlGZVNUFbaHwO2mEK5zN5EycJzPaffg79AAIOP4uOW2SY
         aJAVblaL0vteLImopHazVvPX39OxLMMbo9kXxdK6qhOKDBTZykgW5v4u5apYTgT7aA
         8od68r2KSHdaA==
Date:   Wed, 21 Apr 2021 12:12:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net-next] net/sched: act_vlan: Fix vlan modify to allow
 zero priority
Message-ID: <20210421121241.3dde83bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210421084404.GA7262@noodle>
References: <20210421084404.GA7262@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 11:44:04 +0300 Boris Sukholitko wrote:
> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.

Could you please resend without this legal prayer?
