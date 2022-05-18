Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A2F52BCCE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiERNxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiERNxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:53:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 272D31C72E9;
        Wed, 18 May 2022 06:53:44 -0700 (PDT)
Date:   Wed, 18 May 2022 15:53:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
        nbd@nbd.name, fw@strlen.de, paulb@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: flowtable: fix TCP flow teardown
Message-ID: <YoT6ZE83J4fIfmMO@salvia>
References: <20220517094235.10668-1-pablo@netfilter.org>
 <f8247247-4109-18bc-c422-a69619b50258@nvidia.com>
 <20220518041613.4caq2xneizazsaao@svensmacbookpro.sven.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518041613.4caq2xneizazsaao@svensmacbookpro.sven.lan>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applied to nf.git, thanks
