Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECE598B0A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiHRSVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiHRSU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:20:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2A3CE31D;
        Thu, 18 Aug 2022 11:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D88AB823A6;
        Thu, 18 Aug 2022 18:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606ABC433C1;
        Thu, 18 Aug 2022 18:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660846855;
        bh=1kMkNkUHY/JY7PcVcwI9S6QtIB1nJgM373f3ZZep8lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8C4AgkofOFMA1fsWl3SxL2XRA53UBBQwQVZD205NCvL44pfFjDYGsldA7vYWy4gm
         67Lm8kYDnP+F2zNYylvpdshQDLBx3H8gX4XuziAPrldQnOAad3EcjgsNj/j2UJhaLb
         nM0KbRhPT00dL9uzSLVpUj6xQxyYHWrXdzPbWV+v5veyc2deHeV+PrtkwIinib5TvN
         OGALZIEHa9b+dzk+4fvpuqACaRY9IqLfYhf6XnnFsEKMLKJhDZDSDxmeZX4v3aS1x9
         uy2v0GCUL0g+CQV0aA8gTV4g7DqEu6V+8QFxRfOHB0rKfJn/5zaL82DCbM3fkC2KtF
         w47fbkJOKRoUA==
Date:   Thu, 18 Aug 2022 11:20:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in
 preparation for phylink conversion
Message-ID: <20220818112054.29cd77fb@kernel.org>
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 12:16:24 -0400 Sean Anderson wrote:
> This series contains several cleanup patches for dpaa/fman. While they
> are intended to prepare for a phylink conversion, they stand on their
> own. This series was originally submitted as part of [1].

Still over the limit of patches in a patch series, and looks pretty
easy to chunk up. We review and apply patches in netdev in 1-3 days,
it really is more efficient to post smaller series. 

And with the other series you sent to the list we have nearly 50
patches from you queued for review. I don't think this is reasonable,
people reviewing this code are all volunteers trying to get their
work done as well :(
