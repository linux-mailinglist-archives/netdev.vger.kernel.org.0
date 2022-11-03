Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D808361743F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 03:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKCCdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 22:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKCCdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 22:33:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437B9261F;
        Wed,  2 Nov 2022 19:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D949EB82521;
        Thu,  3 Nov 2022 02:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC81BC433D7;
        Thu,  3 Nov 2022 02:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667442776;
        bh=chLCZ4O5F8L5nLqWIjg2FNqEgzk68hIq5LLfsxgk5kE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j3IMlGLi4p/ue9t+XSptU3IIF0xzvLodD8JWWFLXzOf/lmYDPF56KPu0fq/KQClct
         5g2WA9GAQrJjTh7ZNDhJTCmYlWxnHpe3QVi5hOh31h/O0N3TRiJcFTx3bkPoxrBCUM
         eZnM7Ze+KqqsRvDU9xlDD8+a+dLT1MEe5XqWrCegjeXa2ep3fdaob7Gh/LD/43W1KK
         HsFvRwoTajxlvpGGjYtj1aIHOpFqoh8Qm5o3uqGZn3EUwYU9wMhjnvtBjDEyHUNpUm
         ugozH7ejAHrh70cu/5bcBNy6UnIdjMbzyU1EEJcs3a0V7ZM93dCO+mo3G44nP3p/zY
         7/JIDEI0qbxxQ==
Date:   Wed, 2 Nov 2022 19:32:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/1] net: fec: add initial XDP support
Message-ID: <20221102193253.3c51a4ec@kernel.org>
In-Reply-To: <PAXPR04MB9185320671668838B48B575389389@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221031185350.2045675-1-shenwei.wang@nxp.com>
        <PAXPR04MB9185320671668838B48B575389389@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Nov 2022 02:07:19 +0000 Shenwei Wang wrote:
> A kind ping. =F0=9F=98=8A

Pong.

Don't top post.
