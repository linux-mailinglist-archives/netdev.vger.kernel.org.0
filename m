Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59B464A326
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLLOXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiLLOXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:23:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1153F6249;
        Mon, 12 Dec 2022 06:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9417610A5;
        Mon, 12 Dec 2022 14:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA159C433EF;
        Mon, 12 Dec 2022 14:23:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jWEad5U3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670855017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EI3qlxgvMnT5OMYlRkhJ0Uy1WA8fWwEgE1pf1UuYfLA=;
        b=jWEad5U3zCZw+p1vKs1Thrb5KqB1Y7zb5iO1bjGmVU/XDI6V5zJrLjRTnPBM+nPEJy69bi
        EqF7CmUU03Phf+ktr+ubN8FH9Oykn3w8xX0H458rWKncg6hTdZz7+ttMrP5k8l7widxzzF
        ReZo17nkwnJzZnZppkCfy9a9StejSVM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8f7b6bc2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Dec 2022 14:23:37 +0000 (UTC)
Date:   Mon, 12 Dec 2022 15:23:34 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wireguard (gcc13): move ULLs limits away from enum
Message-ID: <Y5c5ZtXy2nQzBmGC@zx2c4.com>
References: <20221212114712.11802-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212114712.11802-1-jirislaby@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have this queued up already as:
https://git.zx2c4.com/wireguard-linux/commit/?id=3d9d8bba03db21f3276324cdba43c82be5d60729

I liked this variant better.

Jason
