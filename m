Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D05654943
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 00:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiLVXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 18:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVXaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 18:30:46 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0392C9;
        Thu, 22 Dec 2022 15:30:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NdRPm4yv8z4x1G;
        Fri, 23 Dec 2022 10:30:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1671751838;
        bh=kLkQ4YA9j/wR8/NPUjzPAw1z0oTUa/gM29aYgHgT9qQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XV3Y2ns6eGjvlX3vQX2vmnZooeWhKyp9TjlVNfKm9SNzCI3crRhIqdgt/kODHlESQ
         ce0ydOLIDVz/CGcMz58ZyDM3VzZC8aMrCqPN87Gha5LmReHc7gjb3pwXftMhHbqIBi
         BeIQNleWqHpSKuBT9n13Vte2w/SIBkf7mzT7LJwUC7Bd/7XxRmHISD9CbDrjlIfCjD
         TUoVwX/Iy2PZoU/R3J+YjDeXkfkwzZtph7m2UpcDonAEryaMbggC7WqQDfSE6xvvzF
         /y8XMaDFa9GHUTN/JMGLOovyHKZqaeCUYC/uKsHjtnHV/ZkhdaLlH5/gXmlZenzx9x
         dv4gbQaWr9BAw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jakub Kicinski <kuba@kernel.org>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
In-Reply-To: <20221222110843.022b07b9@kernel.org>
References: <20221216172937.2960054-1-sean.anderson@seco.com>
 <VI1PR04MB5807014739D89583FF87D43EF2E59@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <VI1PR04MB5807E65FA99FE10D53804445F2E89@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <20221222110843.022b07b9@kernel.org>
Date:   Fri, 23 Dec 2022 10:30:36 +1100
Message-ID: <87o7rvhv8j.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> On Thu, 22 Dec 2022 15:41:00 +0000 Camelia Alexandra Groza wrote:
>> > Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
>> > Tested-by: Camelia Groza <camelia.groza@nxp.com>  
>> 
>> I see the patch marked Not Applicable in the netdev patchwork.
>> What tree will it go through?
>
> I could be wrong but I think DTS patches are supposed to go via the
> platform / arch trees. We mostly take bindings via the networking trees
> (and DTS changes if they are part of a larger code+binding+dts set).
> But we can obviously apply this patch if that's the preference of
> the PowerPC maintainers..

The commit it Fixes went in via the networking tree, so I think it would
make sense for you to take this also via the networking tree.

cheers
