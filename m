Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66D12654C8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgIJWE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:04:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921CDC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 15:04:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50FF0135A8FD2;
        Thu, 10 Sep 2020 14:47:39 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:04:25 -0700 (PDT)
Message-Id: <20200910.150425.1073221782210309746.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        kuba@kernel.org, thomas.petazzoni@bootlin.com, brouer@redhat.com,
        echaudro@redhat.com
Subject: Re: [PATCH net] net: mvneta: fix possible use-after-free in
 mvneta_xdp_put_buff
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f203fdb6060bb3ba8ff3f27a30767941a4a01c17.1599728755.git.lorenzo@kernel.org>
References: <f203fdb6060bb3ba8ff3f27a30767941a4a01c17.1599728755.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:47:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 10 Sep 2020 11:08:01 +0200

> Release first buffer as last one since it contains references
> to subsequent fragments. This code will be optimized introducing
> multi-buffer bit in xdp_buff structure.
> 
> Fixes: ca0e014609f05 ("net: mvneta: move skb build after descriptors processing")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thank you.
