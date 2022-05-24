Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD25B53305E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiEXSYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbiEXSYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC48A303;
        Tue, 24 May 2022 11:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFED2B817F2;
        Tue, 24 May 2022 18:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8C7C34100;
        Tue, 24 May 2022 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653416667;
        bh=PaaPMtyl3CpkNEzDJiWcGRpMZpJ/HowDIzdVOpjc9oA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A4U3hf5bmSfuPqXdP3wptw+XkYJoWkdqpnzsF6TmLspwyGau5Vu7YxxSt5fDY0F9Z
         DkQr0hyLbPbq6gD7obJvTo+NgO1vP9ol74qs7CflFz/6v3jznryTI09PynK06A564n
         Y4JI8c0FLCQpfPbpdufk6fbL4oHqUxZwIonp0K2upUWG1s5IKpV1wmpBShHuRJDx7w
         fYEPmZ/MgQtBuJC8ceHPR/UiXm60XdTvvmPMPwfv39HS0rOPT49q58HFN9leA02PD9
         U6g+/byi3Q3Fn2OOfhHdcxucVkTk9tlKPzpG4c/StyiNvjeq5OfvRTd2slmdj140be
         lDf4QZoFvCs0Q==
Date:   Tue, 24 May 2022 11:24:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Josua Mayer <josua@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock
 description syntax
Message-ID: <20220524112425.72f8c6e0@kernel.org>
In-Reply-To: <CAMuHMdU3efmsc0-o6DJb013dg83pfdM-e3WiS+CjgzSuTceEQA@mail.gmail.com>
References: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
        <CAMuHMdU3efmsc0-o6DJb013dg83pfdM-e3WiS+CjgzSuTceEQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 16:30:18 +0200 Geert Uytterhoeven wrote:
> On Tue, May 24, 2022 at 4:12 PM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > "make dt_binding_check":
> >
> >     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
> >
> > The first line of the description ends with a colon, hence the block
> > needs to be marked with a "|".
> >
> > Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-  
> 
> Alexandru Ardelean's email address bounces, while he is listed as
> a maintainer in several DT bindings files.

Let's CC Alexandru Tachici, maybe he knows if we need to update 
and to what.
