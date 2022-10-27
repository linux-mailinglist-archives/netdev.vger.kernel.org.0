Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD81960FFC8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiJ0SDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbiJ0SDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36127B25;
        Thu, 27 Oct 2022 11:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E08186240C;
        Thu, 27 Oct 2022 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D22C433C1;
        Thu, 27 Oct 2022 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666893793;
        bh=1IFNjCv1+T+3cxcUnE6Zy3IhTPzaEmS/uTw1aQ8VEow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UvHTmd8aGwd3+vgzSy7Iuo9pp7wACyzZxyQiQD9eO9Fk6civ6Rtpt7mFEeT39wHH2
         UI9rk+i+M1huqYX+pmhGGivQLyiSLVyakKRoW3EPMQZ71wj71VQHh58KG6vecjsy28
         zrcdmE3JnFAUOC+cWCAv3E0RhvQL54aQemucAV2p4XXJIAFiKG/vXnZZ9hyIOYNM6g
         P7qgXPOQp4XVtqSPiNemV51mlkydZhw1Bxs8jjzRMKIWMIdrEYfiG+BM4ypjWPM3Ei
         +rkpQc0fkrsxJzw5fbC9yn1RwbeBDBn7XR1xK25rcdZKUzPmVXc4WXuOIjh0gkmBo/
         LB8N2Nj4ps0TQ==
Date:   Thu, 27 Oct 2022 11:03:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221027110312.7391f69f@kernel.org>
In-Reply-To: <20221026125922.34080-2-cai.huoqing@linux.dev>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
        <20221026125922.34080-2-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 20:59:11 +0800 Cai Huoqing wrote:
> The control command only can be set to register in PF,
> so add support in PF driver for VF PMD driver control
> command when VF PMD driver work with linux PF driver.

For what definition of "work"?

The commands are actually supported or you're just ignoring them
silently?
