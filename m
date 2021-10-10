Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2FF42803D
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhJJJkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhJJJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 05:40:21 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60756C061570
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 02:38:23 -0700 (PDT)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C85A94D558ABB;
        Sun, 10 Oct 2021 02:38:18 -0700 (PDT)
Date:   Sun, 10 Oct 2021 10:38:12 +0100 (BST)
Message-Id: <20211010.103812.371946148270616666.davem@davemloft.net>
To:     s.shtylyov@omp.ru
Cc:     biju.das.jz@bp.renesas.com, kuba@kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com, andrew@lunn.ch,
        geert+renesas@glider.be, aford173@gmail.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Chris.Paterson2@renesas.com,
        biju.das@bp.renesas.com
Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
        <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 10 Oct 2021 02:38:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Sat, 9 Oct 2021 22:27:52 +0300

>    DaveM, I'm going to review this patch series (starting on Monday). Is that acceptable forewarning? :-)

Yes, thank you.
