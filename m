Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E0465465E
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 20:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiLVTIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 14:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLVTIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 14:08:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F5810B77;
        Thu, 22 Dec 2022 11:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5F8ACE1BBF;
        Thu, 22 Dec 2022 19:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA23C433EF;
        Thu, 22 Dec 2022 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671736124;
        bh=v7ujKq38V/S7LgWeN+6hzTleK2M7lVikFbmjRd4KjEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CDid/fHMNttr0Ku3tg2xXVkAhBeLuydsZ20BjO8q/aYS7FCVEMPw/cpHNT9XXk8lL
         qpNvw/JHHzYKQcwd+Vymhc1L06BRGu3yGkAJlTrNNSAucUQLbhotWSWyBfbydtv61z
         NfCORu37UiZ6chVmu+FbGmD/L0XgtE6eYVSRHNaA9mZLvtA4qO9LuQIPZyC/B2U/6I
         mkbvrk21FiMuWuOl4qOaXJrSVp5yVe2E1XGufZU9sQuEe0LLbXldv+ZvENT0HuPc3k
         gvUf/jHxHIVONu3majiuQZXk+/kPKVLadxQQojMSOfuoUxuqRYxkriO3miXJYRwsbV
         xgh7K524DTKXA==
Date:   Thu, 22 Dec 2022 11:08:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and
 MAC2
Message-ID: <20221222110843.022b07b9@kernel.org>
In-Reply-To: <VI1PR04MB5807E65FA99FE10D53804445F2E89@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20221216172937.2960054-1-sean.anderson@seco.com>
        <VI1PR04MB5807014739D89583FF87D43EF2E59@VI1PR04MB5807.eurprd04.prod.outlook.com>
        <VI1PR04MB5807E65FA99FE10D53804445F2E89@VI1PR04MB5807.eurprd04.prod.outlook.com>
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

On Thu, 22 Dec 2022 15:41:00 +0000 Camelia Alexandra Groza wrote:
> > Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
> > Tested-by: Camelia Groza <camelia.groza@nxp.com>  
> 
> I see the patch marked Not Applicable in the netdev patchwork.
> What tree will it go through?

I could be wrong but I think DTS patches are supposed to go via the
platform / arch trees. We mostly take bindings via the networking trees
(and DTS changes if they are part of a larger code+binding+dts set).
But we can obviously apply this patch if that's the preference of
the PowerPC maintainers..
