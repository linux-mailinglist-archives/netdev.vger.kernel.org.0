Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5F54BF7F
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbiFOBy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344884AbiFOBy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:54:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1B04B86D;
        Tue, 14 Jun 2022 18:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF53619B9;
        Wed, 15 Jun 2022 01:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE55C3411B;
        Wed, 15 Jun 2022 01:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655258096;
        bh=k+6sBNtX1U4+e4xzO0B87S0HSLGSaDJ+a98Z2JJx7U0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1QygX4pnbaZ3ILyVXehataxlp8GmGLAnkCBjDPIz6xpuy48GczclkfV3KuBes3kv
         hOp/xPAlvwIHmgunbLNgrBMfboQaFrY3+VtG+Wu+vRwyLWn+etQjVMZyGkuUz/cXHc
         62Rga45X/rGPiAEJ4eNxF4Aoi/L98QoJRcMqki/2vF6ZZppGw/fEoXsMdOle2hVT5z
         TkDiNhlsCDnZ9DUx1/MwpACsRQVxZi0waUbFZQoKB4UZhraw7Zvnw/mKR20Uvc5VpZ
         4JlkARzx/YrzbvzEDHVscyWpB3GxgYVQvDjkQ/Wle0wnfHp8hyS0ZHMTlDsDAJHIk1
         USm4mfc7oClTg==
Date:   Tue, 14 Jun 2022 18:54:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Message-ID: <20220614185454.7479405c@kernel.org>
In-Reply-To: <1ae6dce1-0c5c-64f0-c6a4-b0f11a82f315@linaro.org>
References: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
        <5e5580c4d3f84b9e9ae43e1e4ae43ac0a2162a75.camel@redhat.com>
        <MN0PR12MB5953590F8098E46C02943AFEB7AA9@MN0PR12MB5953.namprd12.prod.outlook.com>
        <1ae6dce1-0c5c-64f0-c6a4-b0f11a82f315@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 15:48:43 -0700 Krzysztof Kozlowski wrote:
> > I have seen a mixed set of the convention for dts patches. They are following
> > both routes i.e device tree or subsystem repos provided acked from device
> > tree maintainer.  If there is preference for device tree repo then I can drop
> > net-next from subject prefix and resend it for the dt repo.  
> 
> If you got Ack from Devicetree bindings maintainer (Rob Herring or me),
> then feel free to take it via net-next. I think, it is actually
> preferred, unless this is some fix which needs to go via DT (Rob's) tree.
> 
> If you don't have these acks, then better don't take it :) unless it's
> really waiting too long on the lists. I hope it's not that case.

GTK, thanks. I'm also often confused by the correct tree for DT patches.
I'll revive the patch in PW and apply it later today.
