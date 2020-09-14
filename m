Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A4E269868
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgINVyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgINVyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:54:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B860C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:54:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0460912837DDA;
        Mon, 14 Sep 2020 14:37:33 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:54:20 -0700 (PDT)
Message-Id: <20200914.145420.2047501244140998418.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 0/4] net: lantiq: Fix bugs in NAPI handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200912193629.1586-1-hauke@hauke-m.de>
References: <20200912193629.1586-1-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:37:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Sat, 12 Sep 2020 21:36:25 +0200

> This fixes multiple bugs in the NAPI handling.
> 
> Changes since:
> v1:
>  - removed stable tag from "net: lantiq: use netif_tx_napi_add() for TX NAPI"
>  - Check the NAPI budged in "net: lantiq: Use napi_complete_done()"
>  - Add extra fix "net: lantiq: Disable IRQs only if NAPI gets scheduled"

Series applied and queued up for -stable.

Please answer Jakub's question about patch #4.

Thanks.
