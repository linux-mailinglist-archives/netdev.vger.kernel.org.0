Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB34A5BD4F8
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 20:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiISS6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 14:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISS6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 14:58:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA179326FE;
        Mon, 19 Sep 2022 11:58:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B9A6B80A07;
        Mon, 19 Sep 2022 18:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989C1C433D6;
        Mon, 19 Sep 2022 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663613894;
        bh=e66b2uQnaC4+5BG8+ZrFCQhRMwPA0fSmIpCCQsV1mkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Goh8Zi7Q65rrxP63D7sY5xY4+lE6K8goou+SD+BxqMCkOMeAqZYjT+iJrCIdoR1J3
         pnEpWRh/X1yEyuSIRg2FMjaCL/nE/ZQqh36r3O+kSgys0CBp+yclXbUVQhs3CMJfvP
         JXAfwszYOuyY58sMUiXsOHeHC2UhNM7NUPUBWay6Sa04toKcdUScrL8VAY/+DctDu8
         rfzAejF32aFJqUjccBOQv71aTSmTUhteaLTXUWCSi1ErCuDAWFio1r1xur5YGm3zwl
         xqFFnN06glwhSbDx3at75/jOyvLnpHuvrgQX7p4iKzRDamDgdhjJ9mroQ0DM1A/eXe
         PwDphK358GdBA==
Date:   Mon, 19 Sep 2022 11:58:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anand Moon <anand@edgeble.ai>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 1/2] dt-bindings: net: rockchip-dwmac: add rv1126
 compatible
Message-ID: <20220919115812.6cc61a8e@kernel.org>
In-Reply-To: <20220907210649.12447-1-anand@edgeble.ai>
References: <20220907210649.12447-1-anand@edgeble.ai>
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

On Wed,  7 Sep 2022 21:06:45 +0000 Anand Moon wrote:
> Add compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.

Hi, these patches don't seem to apply cleanly to net-next, a 3-way
merge is needed. Please rebase and repost. Please put [PATCH net-next
v3] in the subject as you expect them to be applied to the networking
trees.
