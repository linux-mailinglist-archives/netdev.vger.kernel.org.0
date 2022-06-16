Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A75B54D871
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348018AbiFPCgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiFPCgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C94369C6;
        Wed, 15 Jun 2022 19:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8AC761012;
        Thu, 16 Jun 2022 02:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACAAC3411A;
        Thu, 16 Jun 2022 02:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655346997;
        bh=MDZiaO2P1rcQkw19Fejs7IDBb8CZD93si4u3k3WSwrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hsGh1aQoYE1DbbhHVWuQbGq5IYfUB+DQCg4rYicr0PGHhevVldSkKJz15o1ZaLtI1
         mgBPzbLKnzLeIuABkJW+XqP/hbwWWMP9ZCuwOpVyOH/d+1+3CFefEzdiTCsCuqM7Xp
         y3XKmgdAx7mVf1OiBDC9ZbVY/1mEQxrpzflwPIoB0ocjP2D/P5mXNzTjmy4GBdFkb/
         UedcSvG7OH3WLIzk9Pk747RMGIES0LVpmSE2i9RyR3eUAcioQrZIaqUwnTcOFCOVpW
         GpnJJ3+gI7iySRd9x1emYJKUfgy94HPS1KuR9jQ/qNlpzOsRKHclT8ZoqA0VSww/jT
         7nW2SvjAUiJaA==
Date:   Wed, 15 Jun 2022 19:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <radhey.shyam.pandey@xilinx.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <andy.chiu@sifive.com>,
        <max.hsu@sifive.com>, <greentime.hu@sifive.com>
Subject: Re: [PATCH -next] net: axienet: add missing error return code in
 axienet_probe()
Message-ID: <20220615193635.1b927f12@kernel.org>
In-Reply-To: <20220615031810.1876309-1-yangyingliang@huawei.com>
References: <20220615031810.1876309-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 11:18:10 +0800 Yang Yingliang wrote:
> It should return error code in error path in axienet_probe().
> 
> Fixes: 00be43a74ca2 ("net: axienet: make the 64b addresable DMA depends on 64b archectures")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Please rebase on top of net/master and repost with [PATCH net] in the
subject. This is a fix for an issue in net/master, don't mindlessly 
put -next in the subject, it's hurting the automation not helping.
