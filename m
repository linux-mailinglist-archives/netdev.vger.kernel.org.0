Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953C0287EA5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgJHW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgJHW02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 18:26:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F936206CA;
        Thu,  8 Oct 2020 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602195987;
        bh=gvdVAshFL0mQwrCjXave4Y+PCZLYKkAcLTXlSCDhrkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NA+gD1eGNc/kY+PlEs/I4hYZRQaQCiXgbuVxjoxOPGxx8r7Q0qES+7DchNJwc4uUe
         AblDSuHMqFuOHsx5odJk8jidJP8oyj9h7A4WVxIJhvxZCG2qGkc2f1cip1svMiLyD0
         PNjHGmoc1xwfdDA5Rb8n3Jz9j0EQnWKpKj7OpetU=
Date:   Thu, 8 Oct 2020 15:26:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
Message-ID: <20201008152625.721a6a89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <747813a4-eea4-b390-569e-44f8b3958fcb@pengutronix.de>
References: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
        <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <747813a4-eea4-b390-569e-44f8b3958fcb@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 23:47:38 +0200 Marc Kleine-Budde wrote:
> > Marc - should I take this directly into net, in case there is a last
> > minute PR to Linus for 5.9?  
> 
> Yes, of you can pull Cong Wang's patch and my patch, that fixes the other
> missing init of skbcnt.
> 
> That tag includes my previous oneline-patch-pull-request from 20201006, that
> fixes the c_can driver on basically all stm32mp1 based boards. Would be good to
> see that in 5.9, as well.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git
> tags/linux-can-fixes-for-5.9-20201008
> 
> I've send a proper pull request some seconds ago.

Sorry for the rush but I didn't want to wait too much, since we're
already at -rc8. I already sent the PR to Linus. I'll pull from you 
and queue the fixes up for stable, hope that works.
