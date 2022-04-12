Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266514FDC9D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiDLKg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381424AbiDLK3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:29:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2CAC580C5;
        Tue, 12 Apr 2022 02:31:30 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 32E19625B1;
        Tue, 12 Apr 2022 11:27:25 +0200 (CEST)
Date:   Tue, 12 Apr 2022 11:31:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: nft_parse_register can return a
 negative value
Message-ID: <YlVG75rC/SXj+/M5@salvia>
References: <20220412081459.263276-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220412081459.263276-1-atenart@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 10:14:59AM +0200, Antoine Tenart wrote:
> Since commit 6e1acfa387b9 ("netfilter: nf_tables: validate registers
> coming from userspace.") nft_parse_register can return a negative value,
> but the function prototype is still returning an unsigned int.

Applied, thanks
