Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51B362EC73
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbiKRDrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKRDrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:47:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F028F3D3;
        Thu, 17 Nov 2022 19:47:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9346CCE1FCA;
        Fri, 18 Nov 2022 03:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53502C433D6;
        Fri, 18 Nov 2022 03:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668743232;
        bh=C7m/sVTiuCo7+83jx2vb6PbukCsp4bxe4KrVLF5Vjh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AuJiZBhUMMw2XiCX599EA0/Rb/tiDQshg+CTW+VWZV7kXpBNfn43rLo+6BWoaqUyq
         Xafc9BxgTDkhewD8QmM2dmphgKkEbssm4c85UPxrK/x16z3knS+xm+wnqrzEaqux4g
         Y1SlIEMIZ+6d18QStLOD9MWbP0jxqaVg7H2mg0DA/30YqQSezpi8mcrbVarw1idyTM
         l4v/KfRq5P613zpKM/q2S4otD5y4TtTrlXXbRmtZ9tWlzCctsB6bPgATFg83z2WD9d
         wcOrmPyL4Qjy9WlGTGs9+PBs+kQHq7bbNdKTItTNCmx98BpD4rQg5YISTTZLrrVY3O
         qmSAl7PxEnDVw==
Date:   Thu, 17 Nov 2022 19:47:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-patchest@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH v2] lag_conf: Added pointer check and continue
Message-ID: <20221117194711.607b27f7@kernel.org>
In-Reply-To: <Y3Sv6oZgi3k5VaLz@corigine.com>
References: <20221116081336.83373-1-arefev@swemel.ru>
        <Y3Sv6oZgi3k5VaLz@corigine.com>
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

On Wed, 16 Nov 2022 10:39:54 +0100 Simon Horman wrote:
> 1. I think the patch prefix should be 'nfp: flower:'
>    i.e., the patch subject should be more like
>    [PATCH v2] nfp: flower: handle allocation failure in LAG delayed work

One more note here, please add the tree name to the prefix:
  [PATCH net v2] ...
and a fixes tag right above the sign-off:

Fixes: bb9a8d031140 ("nfp: flower: monitor and offload LAG groups")
