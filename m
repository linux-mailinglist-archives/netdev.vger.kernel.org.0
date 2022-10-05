Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766585F5836
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJEQSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJEQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10B043E70;
        Wed,  5 Oct 2022 09:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4ADE61756;
        Wed,  5 Oct 2022 16:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF3C433C1;
        Wed,  5 Oct 2022 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664986683;
        bh=jTFSY/LXZitt+tjuL1epWeJ5HqwW2iI22Nd4jOlij0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9b5dxaxaXLu75NUUrJyaLYNYJiPDXNztIT+lfhNH0q5ScL9Ogw//ZeXbtE6/zUlZ
         vFN4n/JT4i8phmzEimBYkzU58rHNBfYLIizjtoxGFA0KDI/mPCKTh4L1ShJwbcRd7J
         RxTZiYFxzmsl0uXyhKAkrtmycf7UivyMLG+M9rN2S8UbgdxLExwnHAfNkjf4v3lcZ+
         ObVWimCrrrf1Ar3EbrPWAKIZqUAZub1eEwsW/G9XFkOVGNahKiThDwmWHZa57hSK0k
         v7FsNfzsxlVoFz1H6BMqX0fuSiUBFM8UWhPzAyH4zA8JOHGBD/h5Dk5QAgkwTq6Ztl
         oxLmrbr/rmhsA==
Date:   Wed, 5 Oct 2022 09:18:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221005091801.38cc8732@kernel.org>
In-Reply-To: <20221005084442.48cb27f1@kernel.org>
References: <20221003190545.6b7c7aba@kernel.org>
        <20221003214941.6f6ea10d@kernel.org>
        <YzvV0CFSi9KvXVlG@krava>
        <20221004072522.319cd826@kernel.org>
        <Yz1SSlzZQhVtl1oS@krava>
        <20221005084442.48cb27f1@kernel.org>
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

On Wed, 5 Oct 2022 08:44:42 -0700 Jakub Kicinski wrote:
> Hm, I was compiling Linus's tree not linux-next.
> Let me try linux-next right now.
> 
> Did you use the 8.5 gcc (which I believe is what comes with 
> CentOS Stream)?  I only see it there.

Yeah, it's there on linux-next, too.

Let me grab a fresh VM and try there. Maybe it's my system. Somehow.
