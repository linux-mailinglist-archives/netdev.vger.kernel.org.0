Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D8627DD9A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgI3BKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgI3BKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:10:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E81DC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 18:10:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5ED8F127ECB44;
        Tue, 29 Sep 2020 17:54:04 -0700 (PDT)
Date:   Tue, 29 Sep 2020 18:10:48 -0700 (PDT)
Message-Id: <20200929.181048.2023249117997275289.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: mvneta: avoid possible cache misses in
 mvneta_rx_swbm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6284e8e13117c87470d412e930cfff23b9ce6f16.1601416347.git.lorenzo@kernel.org>
References: <6284e8e13117c87470d412e930cfff23b9ce6f16.1601416347.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 17:54:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 29 Sep 2020 23:58:57 +0200

> Do not use rx_desc pointers if possible since rx descriptors are stored in
> uncached memory and dereferencing rx_desc pointers generate extra loads.
> This patch improves XDP_DROP performance of ~ 110Kpps (700Kpps vs 590Kpps)
> on Marvell Espressobin
> 
> Analyzed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied.
