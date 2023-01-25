Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905A667A917
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjAYDIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYDIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:08:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EC11A4A1;
        Tue, 24 Jan 2023 19:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D994B81892;
        Wed, 25 Jan 2023 03:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F1C433EF;
        Wed, 25 Jan 2023 03:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674616120;
        bh=5oiMg+0VyQdvhQHhZVkaJkLHhTmGPlkFp71iVLKtxVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZmJlHo6fbLCrgF1shrY34EQXgOctdb6su62XuEtOlDnSLQ8RqC4xQpvaynf4mHT72
         AOXwa/JQ9CZPHTvuPZY+7OqbTTne9tseZBdI7k4zrcA7r0wUWeMSzAY7KqDGT+BUqH
         2lEC4tdZh80XulhsultdF9gcd0EPADOy8h4glmn7tXcLM1ahfY8DwTNMfzgWuGWJsl
         6A9dvShd7H0s+7vkukzQqk6CQ9r8ma5H02rr0/ypAZME1dRVvuw1ASBf6GllvRzy6t
         o9Q7JQQPtXFJZIR2BUhGRJa7QKk0JCtkNSweoVEC/DvpSS4PLdFrQKvq5FFuWc9YkV
         QOSQHxJpW7gwg==
Date:   Tue, 24 Jan 2023 19:08:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: ls1046ardb: Use in-band-status for SFP module
Message-ID: <20230124190839.5b59e7aa@kernel.org>
In-Reply-To: <20230124174757.2956299-1-sean.anderson@seco.com>
References: <20230124174757.2956299-1-sean.anderson@seco.com>
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

On Tue, 24 Jan 2023 12:47:57 -0500 Sean Anderson wrote:
> This should likely go through Shawn Guo's tree, although it could also
> go through net-next. It will conflict with [1] which modifies the
> adjoining lines and is likely to go through the phy tree.

I'm dropping it from networking pw, FWIW.
