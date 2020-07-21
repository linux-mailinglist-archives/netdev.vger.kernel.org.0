Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349CA227458
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgGUBC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGUBC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:02:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C2AC061794;
        Mon, 20 Jul 2020 18:02:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2755111E8EC08;
        Mon, 20 Jul 2020 17:46:13 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:02:57 -0700 (PDT)
Message-Id: <20200720.180257.1845619055500130322.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hsr: check for return value of skb_put_padto()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720164327.16977-1-m-karicheri2@ti.com>
References: <20200720164327.16977-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:46:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Mon, 20 Jul 2020 12:43:27 -0400

> skb_put_padto() can fail. So check for return type and return NULL
> for skb. Caller checks for skb and acts correctly if it is NULL.
> 
> Fixes: 6d6148bc78d2 ("net: hsr: fix incorrect lsdu size in the tag of HSR frames for small frames")
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied, thank you.
