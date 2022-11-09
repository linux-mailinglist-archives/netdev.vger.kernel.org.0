Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35011622175
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKIBxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKIBxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADE61A05A;
        Tue,  8 Nov 2022 17:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F8CA6186E;
        Wed,  9 Nov 2022 01:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09173C433D6;
        Wed,  9 Nov 2022 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667958824;
        bh=2iV55U4SXwwrEvQj2zg5THjw7EtUBO0/5hi7eOHXfLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YrQsZiKLS0L/xOfBiLOYacR86o0TROzNvGn5/WtzLJHh6jB+aFAjgdK3NpZHjZ2A7
         A9LTAIvbedLeVm5mpgPFlE8jNjO4AqJNDAcRobGlgN+d8y8uyJA/dDMiE4aNIdyZ2S
         8mGr7rSIGUb/Ujf6YlQWSSsZ/GHD6Wmr6HVf20JYfTP/mlnG4oOGEy/WMTSnDyBqlO
         9ixiDMbS4f4DRAQBVfi6D8etY0sAxvdbCYDkKoQi3zlZcy387IEkwyUlwlul2rEhrj
         qKHNWmavoEWfTn9J4Qj1sNh0iNELS2xL5d5NZ3xf5uM0Y3VCaJb9Hx/n9Ku3obxqiN
         rVA83M8fpHIzA==
Date:   Tue, 8 Nov 2022 17:53:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>
Subject: Re: [PATCH v4 0/3] Add support for QSGMII mode for J721e CPSW9G to
 am65-cpsw driver
Message-ID: <20221108175343.57f3998d@kernel.org>
In-Reply-To: <20221108080606.124596-1-s-vadapalli@ti.com>
References: <20221108080606.124596-1-s-vadapalli@ti.com>
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

On Tue, 8 Nov 2022 13:36:03 +0530 Siddharth Vadapalli wrote:
> 2. Rebase series on linux-next tree tagged: next-20221107.

You need to based on the tree which you're expecting to apply the patch.
Which should be net-next here-  throw that into the subject while at it
([PATCH net-next v5 0/3] ....). v4 does not apply cleanly.
