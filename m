Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8E152AF55
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiERArr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiERArp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB204EF5F;
        Tue, 17 May 2022 17:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F2AB81D9B;
        Wed, 18 May 2022 00:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981BCC385B8;
        Wed, 18 May 2022 00:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834861;
        bh=fNKUfV1SV9M5mI6hr0ErzfCZ0VG41xjUAwF43KZD2eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lJr15sAUFzvzyN+kB+OMoXM6a6cHHNd/c0L51N78DhbMJgjRVZ2IUBpZfaufqIAVo
         C3ulfncmFHe9/i09xBJRFpkjUx65GI1IO0G73+kKViaJp+Yai2ZmCKywzZdqR/Tg9S
         GRlYXGkBiIf4/O0TvTAJlj/+ui2ZxkWwRiWxHZSLGhCGZ7lBgUSYBBkExkcSux7LpO
         q7GC6akLEKROVHZaO/8+6qe2UvCzhOLcIkY5srNhbgwGERBahvIrdbgXCcISGzD4cn
         T0YlHDUx+FaxyxN6fq5eqlUmneuWdUVrQvO/pYLhBqHuqc7bxgS3KGkBj7n/e2gPmI
         rI2PW5RqLQvAA==
Date:   Tue, 17 May 2022 17:47:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>, <wellslutw@gmail.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>, <pabeni@redhat.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next] net: ethernet: sunplus: add missing of_node_put()
 in spl2sw_mdio_init()
Message-ID: <20220517174740.2fe90ebb@kernel.org>
In-Reply-To: <20220516143734.1598316-1-yangyingliang@huawei.com>
References: <20220516143734.1598316-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 22:37:34 +0800 Yang Yingliang wrote:
> of_get_child_by_name() returns device node pointer with refcount
> incremented. The refcount should be decremented before returning
> from spl2sw_mdio_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Please add a Fixes tag, even if the change in question is only in
linux-next.

Wells Lu, the expectation for networking maintainers is that you will
review patches for your driver without 24, max 48 hours (not counting
weekends). Please respond with feedback or Acked-by / Reviewed-by tags
now that your driver has been merged. Thanks.
