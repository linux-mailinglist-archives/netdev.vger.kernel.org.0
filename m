Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7552B250E1C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgHYBRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgHYBRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:17:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B5FC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 18:17:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1C18129553D6;
        Mon, 24 Aug 2020 18:00:35 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:17:21 -0700 (PDT)
Message-Id: <20200824.181721.1474055236164070521.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/3] pull request for net: batman-adv 2020-08-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824162111.29220-1-sw@simonwunderlich.de>
References: <20200824162111.29220-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 18:00:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Mon, 24 Aug 2020 18:21:08 +0200

> here are some bugfixes which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks.
