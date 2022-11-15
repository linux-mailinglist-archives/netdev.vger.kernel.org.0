Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8165E62948C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbiKOJkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiKOJkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:40:09 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3A00186E2;
        Tue, 15 Nov 2022 01:40:08 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:40:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 3/6] netfilter: nf_tables: Extend
 nft_expr_ops::dump callback parameters
Message-ID: <Y3Nedxg01XO0Zm2u@salvia>
References: <20221114104106.8719-1-pablo@netfilter.org>
 <20221114104106.8719-4-pablo@netfilter.org>
 <20221114190405.24cebc06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221114190405.24cebc06@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:04:05PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 11:41:03 +0100 Pablo Neira Ayuso wrote:
> > From: Phil Sutter <phil@nwl.cc>
> > 
> > Add a 'reset' flag just like with nft_object_ops::dump. This will be
> > useful to reset "anonymous stateful objects", e.g. simple rule counters.
> > 
> > No functional change intended.
> 
> This one appears to break the build transiently (next patch fixes it).
> Any chance for a rebase? Bisection potentially getting broken by this
> and all that..

I will send v2.
