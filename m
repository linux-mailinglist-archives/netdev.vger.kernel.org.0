Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516B856AF62
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbiGHAYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B536EEBE;
        Thu,  7 Jul 2022 17:24:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CFBEB824A5;
        Fri,  8 Jul 2022 00:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD757C3411E;
        Fri,  8 Jul 2022 00:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657239874;
        bh=a5FeKJO7w4Mvn7Dj8VS7sxWFdZ43pR/WOTDj+raYDPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TK043CSkF31k4mTJX+rMbyWjCfk1JH/3bs+6VZO+XcOTQ1f6rkmLw2hPB9ZlX1tba
         02CNfIlVWRi3zkx1g0F/q6EPs++6HEoFfhFMLHQ3918h3iK9sEGncg9CM90jsrFRSD
         gGQ9tkRSA4+TfmFkGWvcN2gmuRmBZ47ByfvMARluQResWJ6DGHiBS15FJAqM93p9By
         ltSGce3oiEFL/oct8JDy+WNmKmyDsD+u2gPpknV2l+UFmuJgmlnUUBM25H0Qp6fMds
         zLQT05fG+PRFgtNPEInUqyKm7zjvVDGziHhuKJmus0/yb+unsRcX3ofklNO5HSSrHz
         Xxnwoo2Ht4nKg==
Date:   Thu, 7 Jul 2022 17:24:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     <paul@paul-moore.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <keescook@chromium.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <mcgrof@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yzaikin@google.com>
Subject: Re: [PATCH v2 net 10/12] cipso: Fix data-races around sysctl.
Message-ID: <20220707172424.2b280154@kernel.org>
In-Reply-To: <20220707221537.29461-1-kuniyu@amazon.com>
References: <CAHC9VhQMigGi65-j0c9WBN+dWLjjaYqTti-eP99c1RRrQzWj5g@mail.gmail.com>
        <20220707221537.29461-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 15:15:37 -0700 Kuniyuki Iwashima wrote:
> I was wondering if both CC and Acked-by should stay in each commit, but
> will do so in the next time.

For Paul only, don't take that as general advice.
