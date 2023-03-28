Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C3C6CB2D6
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 02:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjC1AiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 20:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjC1AiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 20:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9A32113;
        Mon, 27 Mar 2023 17:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC83261522;
        Tue, 28 Mar 2023 00:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CBAC433D2;
        Tue, 28 Mar 2023 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679963884;
        bh=u9KFs6cotcR9My14LoQOcoE33Db8Gtr5qkuqQI/KgnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AVej+MU/db/2tSiT+WNdJ/9mXqO2M/zoBQug4Wvl+ZD+g70dpYJCqQ/ysxPj4QtHT
         kaitS+Z47ZzDM0TMym3/ZQv0+YWUJOkwsIvCetnnvAF3JWRWowA0VnFvNA5AWOlzoU
         5uvauJHC4uQcVHqHtBi094OY454r8E/1dhVh1/tPyWMJx6Dc5leRJ6VmW2m5J2L5VR
         jN1+L8DcoaULekM+203NU80i0Ld8kzyBZvcz8osP9o6FODHF9CE5P7BFzppACRdpKC
         8q/rJ4Zjxx0QKmI7ezu3mJD0HhC1Bd4Pw561QkiH97oqcwoYlbg56WGRJbMEELHbnr
         hE+Th33GpjVTQ==
Date:   Mon, 27 Mar 2023 17:38:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Samin <samin.guo@starfivetech.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
Message-ID: <20230327173802.0ceb89df@kernel.org>
In-Reply-To: <b20de6ba-3087-2214-eea2-bdd111d9dcbc@starfivetech.com>
References: <20230324022819.2324-1-samin.guo@starfivetech.com>
        <20230324022819.2324-5-samin.guo@starfivetech.com>
        <20230324192419.758388e4@kernel.org>
        <b20de6ba-3087-2214-eea2-bdd111d9dcbc@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 09:53:22 +0800 Guo Samin wrote:
> Thanks,  I will resent with [PATCH net-next v9].
> My series of patches will depend on Hal's minimal system[1] and william's syscon patch[2], and this context comes from their patch.
> 
> [1]: https://patchwork.kernel.org/project/linux-riscv/cover/20230320103750.60295-1-hal.feng@starfivetech.com
> [2]: https://patchwork.kernel.org/project/linux-riscv/cover/20230315055813.94740-1-william.qiu@starfivetech.com
> 
> Do I need to remove their context?

If the conflict is just on MAINTAINERS it should be safe to ignore.
Resend your patches on top of net-next as if their patches didn't
exist. Stephen/Linus will have not trouble resolving the conflict.
