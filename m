Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A532F50E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbfE3EoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:44:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfE3EoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:44:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A095136E16A9;
        Wed, 29 May 2019 21:44:10 -0700 (PDT)
Date:   Wed, 29 May 2019 21:44:09 -0700 (PDT)
Message-Id: <20190529.214409.2156776359120413200.davem@davemloft.net>
To:     ldir@darbyshire-bryant.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:44:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Date: Tue, 28 May 2019 17:03:50 +0000

> ctinfo is a new tc filter action module.  It is designed to restore
> information contained in firewall conntrack marks to other packet fields
> and is typically used on packet ingress paths.  At present it has two
> independent sub-functions or operating modes, DSCP restoration mode &
> skb mark restoration mode.
 ...

Applied, thank you.
