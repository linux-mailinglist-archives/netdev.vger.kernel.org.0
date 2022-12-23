Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5050654B0D
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiLWCQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbiLWCPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBE935784
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 18:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D8D1B81F51
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E94DC433D2;
        Fri, 23 Dec 2022 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671761571;
        bh=oTXTOz5AvMs7nL71W85s98wTaAF+WeWpMaNhpeFmHGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUqkn5tfP1owLaTkw1XTMa9G/4ACQktSCGKDe36YKdYGP6J0BlcCreUUtuZO0LYM/
         nnAIMGBJ6kpWwzkKWRVVRPuo2uGo5Q+e/ye4jQAlwg7gZjPej/GPyYdZ8eFA1S0d19
         k1oXT0r64l6XHxitw9lB8LRIuye/8FryWpFC7my3PKUHqhiGuTSrSZpmGcuCSXIiGB
         YnTYEyhXZo0TCkRCfm7yzLS/uWKpWEMM7TMLKGTdpYof6sJrOg+B3YS+Z9niHmgLDd
         IULkzoSPDH7jiU6mVuObKqW+mUa2l0gyVUBEVd3pwwbPHJaiavjHT+i+AOWWB0S5ZZ
         /tG/a5T5aPuow==
Date:   Thu, 22 Dec 2022 18:12:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH next] sysctl: expose all net/core sysctls inside netns
Message-ID: <20221222181250.23c6a4ee@kernel.org>
In-Reply-To: <20221222191005.71787-1-maheshb@google.com>
References: <20221222191005.71787-1-maheshb@google.com>
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

On Thu, 22 Dec 2022 11:10:05 -0800 Mahesh Bandewar wrote:
> All were not visible to the non-priv users inside netns. However,
> with 4ecb90090c84 ("sysctl: allow override of /proc/sys/net with
> CAP_NET_ADMIN"), these vars are protected from getting modified.
> A proc with capable(CAP_NET_ADMIN) can change the values so
> not having them visible inside netns is just causing nuisance to
> process that check certain values (e.g. net.core.somaxconn) and
> see different behavior in root-netns vs. other-netns

SG, but net-next is closed, please repost after New Year.
