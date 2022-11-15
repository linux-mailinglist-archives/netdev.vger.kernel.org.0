Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465B9629074
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbiKODGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiKODFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:05:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149571EAE5;
        Mon, 14 Nov 2022 19:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE56B81677;
        Tue, 15 Nov 2022 03:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FE7C433D6;
        Tue, 15 Nov 2022 03:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481446;
        bh=QxwKkP6Q+qUoh1LN69XVOuAMW05Ykni0F4xTp6dqPs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pU0qHKBbd+vdaP0KwoluboZHBlF9rAjXHhC/nxB6SAfAVh+Vds/xh4jliqea3LXqd
         gNL9+2qgQ9N5/XQy0X/oYoo+XBL7C40QUMR3y5e9PC8t2tHTNMnWqgASIufC0nltBt
         6KceNJCx97Xo/c2BIEuo1xPczpKCl4RuHE8gvR5MdVSWaZ0aE7oZ5VY91c6D/KCugB
         J+NeeAN4HHRYOpFFZg5o6ppQKXzxpxwm9EYoA6e+4Ltgy8jfiv++GBdn41E5+M9Rbo
         yVQfe/9B/w7jEK+kaxslU9VUKeWARkhsCg3ODkIgysqqdjfDehXUovWj6oMtyw/tHV
         BDportiFuVFxw==
Date:   Mon, 14 Nov 2022 19:04:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 3/6] netfilter: nf_tables: Extend
 nft_expr_ops::dump callback parameters
Message-ID: <20221114190405.24cebc06@kernel.org>
In-Reply-To: <20221114104106.8719-4-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
        <20221114104106.8719-4-pablo@netfilter.org>
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

On Mon, 14 Nov 2022 11:41:03 +0100 Pablo Neira Ayuso wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Add a 'reset' flag just like with nft_object_ops::dump. This will be
> useful to reset "anonymous stateful objects", e.g. simple rule counters.
> 
> No functional change intended.

This one appears to break the build transiently (next patch fixes it).
Any chance for a rebase? Bisection potentially getting broken by this
and all that..
