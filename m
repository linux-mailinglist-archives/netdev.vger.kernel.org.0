Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A17654A98
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 02:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiLWB4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 20:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLWB4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 20:56:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F85E1DA44;
        Thu, 22 Dec 2022 17:56:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F8C61D01;
        Fri, 23 Dec 2022 01:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC2BC433D2;
        Fri, 23 Dec 2022 01:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671760563;
        bh=QLHOFIxMAaRZFbEhphTQh3d6GJiGwh8Gyzy4bVbVsNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aakj2HGEDAo9GujVyn+9yRJKOH/pSg6B/RLNqUkHchRlHjypvTy689mSkFbCftpqU
         eSjkBnql2x3fscmbELyMlRdwYvta2hnYIia+pjt3ocKAnFZ0J2jCRzkUEDJeBEeS41
         aE9b2/Yfl3XauXIknrJnso2zC4I3hsdvyEhjF2XvPhajLFRsJOkt4tNB9dodqD2z/e
         bLlet89UhhoIbKDRqS1aNFyutPVoMoBAYYGyeuH/o4YsMky7+mIpN1FaXE/HnPPFDH
         /QVz7YB5dOdZc1S7LWstWEFmEmKj12T1sr4M1EkqL1cX3AB8ohtPEIGCTYO77YcLur
         QJPsIbxCv1klg==
Date:   Thu, 22 Dec 2022 17:56:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] powerpc: dts: t208x: Disable 10G on MAC1 and
 MAC2
Message-ID: <20221222175601.3cf5883e@kernel.org>
In-Reply-To: <87o7rvhv8j.fsf@mpe.ellerman.id.au>
References: <20221216172937.2960054-1-sean.anderson@seco.com>
        <VI1PR04MB5807014739D89583FF87D43EF2E59@VI1PR04MB5807.eurprd04.prod.outlook.com>
        <VI1PR04MB5807E65FA99FE10D53804445F2E89@VI1PR04MB5807.eurprd04.prod.outlook.com>
        <20221222110843.022b07b9@kernel.org>
        <87o7rvhv8j.fsf@mpe.ellerman.id.au>
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

On Fri, 23 Dec 2022 10:30:36 +1100 Michael Ellerman wrote:
> The commit it Fixes went in via the networking tree, so I think it would
> make sense for you to take this also via the networking tree.

Roger that, thanks for confirming.
