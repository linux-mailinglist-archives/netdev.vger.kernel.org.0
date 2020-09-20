Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E88271814
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgITVNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:13:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CEAC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:13:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDD2913BC9EDA;
        Sun, 20 Sep 2020 13:56:42 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:13:29 -0700 (PDT)
Message-Id: <20200920.141329.1221001950450369016.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        kuba@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: mvneta: avoid copying shared_info frags
 in mvneta_swbm_build_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <82d03019421ee256db1fc5d8df34da5cc2dd6abb.1600472391.git.lorenzo@kernel.org>
References: <82d03019421ee256db1fc5d8df34da5cc2dd6abb.1600472391.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 13:56:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 19 Sep 2020 02:03:26 +0200

> Avoid copying skb_shared_info frags array in mvneta_swbm_build_skb() since
> __build_skb_around() does not overwrite it
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thank you.
