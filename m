Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82362647C35
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLICYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiLICX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:23:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D2C442FE;
        Thu,  8 Dec 2022 18:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2198620ED;
        Fri,  9 Dec 2022 02:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B310DC433F1;
        Fri,  9 Dec 2022 02:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670552638;
        bh=CAdDXASPJuVTiTyYmX/ahRhKRGqcFKDdXOfnZmg+ddM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKSa1L9+JV2m5oZySIFBpXnRmDQqwEapV6vAxuM9ItBO0Opkfh6M0gX8tbJXkKRSI
         OCudYTJuNXieAYmgTB/kyFRhncKROmbRTAYm6jcirWJEKseohmhZLmbz9Wlf6uiZm0
         KwXw05gISb4Z5zcn38/ccTWxthiHtteHDJDIEmyRAOlPh3oFfzxj5nh19u/XVvTn3h
         DBRFuDNefKdPOQzU685uLIsHIA9KX2PehwD9r3wCwkE7nMeHkMu+ujWXpQw+dP7HAQ
         YriuNSL4lpEljB269yk68kjfuZHJCG9hHjJrQ11BWIY84iRnGwjWQjWhahcdVyI9fs
         AY1QYphLYpQ+Q==
Date:   Thu, 8 Dec 2022 18:23:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <brianvv@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>
Subject: Re: [PATCH linux-next] ethtool: use strscpy() to instead of
 strncpy()
Message-ID: <20221208182356.0c06d5ce@kernel.org>
In-Reply-To: <202212081947418573438@zte.com.cn>
References: <202212081947418573438@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 19:47:41 +0800 (CST) yang.yang29@zte.com.cn wrote:
> Subject: [PATCH linux-next] ethtool: use strscpy() to instead of strncpy()

Also net-next, linux-next is an integration tree, not a development
tree. It does not accept patches.
