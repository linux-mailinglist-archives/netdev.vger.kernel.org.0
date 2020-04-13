Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1F1A626E
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 07:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgDMFgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 01:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgDMFgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 01:36:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B979BC00860C;
        Sun, 12 Apr 2020 22:36:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0857127B91F1;
        Sun, 12 Apr 2020 22:36:06 -0700 (PDT)
Date:   Sun, 12 Apr 2020 22:36:04 -0700 (PDT)
Message-Id: <20200412.223604.1160930629964379276.davem@davemloft.net>
To:     leon@kernel.org
Cc:     bp@alien8.de, kuba@kernel.org, thomas.lendacky@amd.com,
        keyur@os.amperecomputing.com, pcnet32@frontier.com,
        vfalico@gmail.com, j.vosburgh@gmail.com, linux-acenic@sunsite.dk,
        mripard@kernel.org, heiko@sntech.de, mark.einon@gmail.com,
        chris.snook@gmail.com, linux-rockchip@lists.infradead.org,
        iyappan@os.amperecomputing.com, irusskikh@marvell.com,
        dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200413052637.GG334007@unreal>
References: <20200413045555.GE334007@unreal>
        <20200412.220739.516022706077351913.davem@davemloft.net>
        <20200413052637.GG334007@unreal>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Apr 2020 22:36:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 13 Apr 2020 08:26:37 +0300

> How do you want us to handle it? Boris resend, me to send, you to fix?

Anyone other than me can do it ;-)
