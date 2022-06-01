Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB007539C57
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiFAEhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349561AbiFAEhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:37:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F113BB1FC;
        Tue, 31 May 2022 21:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5ADEB81772;
        Wed,  1 Jun 2022 04:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197A0C385A5;
        Wed,  1 Jun 2022 04:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654058215;
        bh=0b7FhMrfel9ZIyv8cXBQQTDp9VpRBLBHMcpZwe5oWWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i8op8iMzkrH7M1X8vwKldS7h7S0Gt2H0V8pOi17ZfrKVjA2Rb0B/Qunvfb1KccKzW
         495i2AVU+no8DnYyakFeb0sROfSBBnGcyFxoOkg6E51afxICOptWiU2e2RPXPqBJXh
         vdGSxqtS0OYQYubHe/KH/fM/VgQcZBZgAa+jTwfDdAxSVanjyzWcr8KfKhjlDQrF59
         kZrqHsV49bXWIGVlCflXCG56L+yhu4HBtE1msNW3HyGbdLZkcK2yyYk/niE9NB28Sm
         aX77/E0Z4zb907FhQsI9aJBiavvv9dHHP118av++h1Fj8ajrKMdBZA+PRLZD3e/XSg
         q9xEUbcn97+Fw==
Date:   Tue, 31 May 2022 21:36:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] net: fman: Various cleanups
Message-ID: <20220531213653.4f9b2b17@kernel.org>
In-Reply-To: <20220531195851.1592220-1-sean.anderson@seco.com>
References: <20220531195851.1592220-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 15:58:46 -0400 Sean Anderson wrote:
> This series performs a variety of cleanups for dpaa/fman, with the aim
> of reducing unused flexibility. I've tested this on layerscape, but I
> don't have any PPC platforms to test with (nor do I have access to the
> dtsec errata).

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
