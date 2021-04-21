Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242636726E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242048AbhDUSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:21:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37892 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245224AbhDUSVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:21:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id F0FDC4D2493CD;
        Wed, 21 Apr 2021 11:20:23 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:20:20 -0700 (PDT)
Message-Id: <20210421.112020.2130812672604395386.davem@davemloft.net>
To:     sergei.shtylyov@gmail.com
Cc:     patchwork-bot+netdevbpf@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d5dd135b-241f-6116-466d-8505b7e7d697@gmail.com>
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
        <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
        <d5dd135b-241f-6116-466d-8505b7e7d697@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 21 Apr 2021 11:20:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Date: Wed, 21 Apr 2021 21:14:37 +0300

> 
>    WTF is this rush?! :-/
>    I was going to review this patch (it didn't look well to me from th 1s glance)...
> 

Timely reviews are really important.  If I've inspired you to review more quickly in the future,
then good. :)

Just responding "I will review this don't apply yet." as quickly as you can could avoid
this in the future.

Thanks.
