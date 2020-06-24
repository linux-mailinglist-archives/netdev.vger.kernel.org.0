Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE8206A84
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbgFXDYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXDYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:24:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD71AC061573;
        Tue, 23 Jun 2020 20:24:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C128129847C5;
        Tue, 23 Jun 2020 20:24:04 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:24:03 -0700 (PDT)
Message-Id: <20200623.202403.1704397333023796145.davem@davemloft.net>
To:     likaige@loongson.cn
Cc:     kuba@kernel.org, benve@cisco.com, _govind@gmx.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn, yangtiezhu@loongson.cn
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f12f40fe-7c9a-6ba8-f2ff-daf315030258@loongson.cn>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
        <20200623135007.3105d067@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f12f40fe-7c9a-6ba8-f2ff-daf315030258@loongson.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:24:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>
Date: Wed, 24 Jun 2020 10:07:16 +0800

> You are right. Should I do spin_unlock before the enic_open, or remove
> spin_lock in enic_reset?

You need to learn how this driver's locking works and design a correct
adjustment.
