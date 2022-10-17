Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09453601736
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiJQTTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiJQTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:19:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E210E6172;
        Mon, 17 Oct 2022 12:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F0161202;
        Mon, 17 Oct 2022 19:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9B9C433C1;
        Mon, 17 Oct 2022 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666034369;
        bh=Qr818kc1xI8X7W0RLObQ/uwj/M89QgsXdWjiM4pDHzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RYSrfixV7H4m8Bq9qKrOvE5+I10CcI1GmMEGUCZP3wdLcmijp9XkwxL+5DnslgW5x
         Rp/uJCAiFqp/f5aVODOXEu9RXvXk8wl5jQMBroBXMxmIPW/DXSfywCX24g1mgOWuG9
         s94/yqeqz6oItVb3SqdztNfTbGXJrRn/nqXrJ45z9tnGhIaDaHWK/xNJTg3D1UDEIa
         JY03M2nxymtIhdbs1j1rwFxJtRMkGqn3proUNXjBI2raT89OVINb70LG2+7bjixnzV
         /K+g4gv1TpGb7tpP1wWa9F11cu5leYpW5VNJTcEy15ua7MrtTp6oCaWSaZ02NS/5xL
         ZJRsJqhWgWerQ==
Date:   Mon, 17 Oct 2022 12:19:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jerry.Ray@microchip.com
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        krzysztof.kozlowski@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221017121928.36b582c3@kernel.org>
In-Reply-To: <20221017191311.mxkjfz75pgzbcwcz@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
        <20221003164624.4823-1-jerry.ray@microchip.com>
        <20221008225628.pslsnwilrpvg3xdf@skbuf>
        <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
        <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
        <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
        <20221010102914.ut364d57sjhnb3lj@skbuf>
        <MWHPR11MB16938D7BA12C1632FF675C0AEF299@MWHPR11MB1693.namprd11.prod.outlook.com>
        <20221017191311.mxkjfz75pgzbcwcz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 22:13:11 +0300 Vladimir Oltean wrote:
> The portion I highlighted of the change you're making includes your name
> into the output of $(./scripts/get_maintainer.pl drivers/net/dsa/lan9303-core.c).
> In other words, you're voluntarily subscribing to the responsibility of
> being a maintainer for the driver, getting emails from other developers,
> reviewing patches. Furthermore, you also maintain the code in the stable
> trees, hence your name also gets propagated there so people who use
> those kernels can report problems to you.
> 
> The MAINTAINERS entry for lan9303 needs to go to the "net" tree, from
> where it can be backported. This covers the driver + schema files as
> they currently are. The change of the .txt to the .yaml schema then
> comes on top of that (and on "net-next").

And FWIW net gets merged into net-next every Thu so (compared to how
long this patch had been in review) it won't be a large delay to wait
for the MAINTAINERS patch to propagate.
