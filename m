Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97510454899
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKQO03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhKQOZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A266561A79;
        Wed, 17 Nov 2021 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637158921;
        bh=trOnlmJVc6C5eM46BUv9h3Tt463jIqPF9cnVUIlmBwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h4X+Yfr5oksj4iFHUZ5rwGWusA9e1RbGddzXrw96deYMDP3ZLE/X5zNoV664V3yOh
         FcJhxy97Goc/2K1haque6budAaw/0Jr01TAzgEcXIwyJRkrH9bWr1T4AIPMA0Asb8V
         0vB7gY+W/f9dmodDmOKYm2fmlyGf4uVKns6+gjzOQMM2c4J8Ujgun4mN6bMI1PHiwh
         Vt4VVadvZfTy6cH1YqnmASlwaOz0tNQlsdvt0d2fGyxVzCtfBZ67oJdMYoiDe2R6OG
         cJCun3tHfPEB3xoCWSAf7SU8kFMV8NKKKFY9ERBhjilM30ZJhxEEJUUeLTB8zyuquj
         gRNCnW0onARsQ==
Date:   Wed, 17 Nov 2021 06:22:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     syzbot <syzbot+6f8ddb9f2ff4adf065cb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: refcount bug in __linkwatch_run_queue
Message-ID: <20211117062200.1851f425@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117142012.GB6276@1wt.eu>
References: <000000000000e4810705d0e479d5@google.com>
        <20211117081907.GA6276@1wt.eu>
        <20211117061548.63c25223@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211117142012.GB6276@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 15:20:12 +0100 Willy Tarreau wrote:
> > The ref leak could come from anywhere, tho. Like:
> > 
> > https://lore.kernel.org/all/87a6i3t2zg.fsf@nvidia.com/  
> 
> OK thanks for the link, so better wait for this part to clarify itself
> and see if the issue magically disappears ?

Yeah, that's my thinking.
