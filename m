Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30843241F51
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgHKRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgHKRg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:36:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A34AC06174A;
        Tue, 11 Aug 2020 10:36:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A05712880A35;
        Tue, 11 Aug 2020 10:19:41 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:36:26 -0700 (PDT)
Message-Id: <20200811.103626.1076774285411123636.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     snelson@pensando.io, drivers@pensando.io, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810023807.9260-1-vulab@iscas.ac.cn>
References: <20200810023807.9260-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:19:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Mon, 10 Aug 2020 02:38:07 +0000

> A multiplication for the size determination of a memory allocation
> indicated that an array data structure should be processed.
> Thus use the corresponding function "devm_kcalloc".
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied, thanks.
