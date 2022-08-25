Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3FB5A1566
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiHYPPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbiHYPP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DE918B28;
        Thu, 25 Aug 2022 08:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21D90B82A12;
        Thu, 25 Aug 2022 15:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48B7C433C1;
        Thu, 25 Aug 2022 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661440520;
        bh=GLChFzUGs8GVVNUhC6wb73XfZUqR7G4/+nAYTdWObeA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uhDSCpOcTZPed/N0Nd11OBZzL7nJGDwP4rsBH+Em+AWcKn1fwDpCnnTDY1ZLWhqPR
         48cKOD83JMNKjchGTpkCUMk8KEvDzk4yNWiy7P5P9UOj1T8LKXtPPMJ1kuhN41v9Of
         aWvuYeNBivAkCoav9rdj/GTOrVPksK6UrF9eiklMxMlWhrGnU1AX+faWTogyOVklq0
         JTZGxHnMsTM7QxDeUoukHsyb47U0ZHjj9C/j6+rSwf72vKjrbdSjy79Fro9xrQADK9
         /VyR7TM21LppCtJS5LPLQ23Emygt+HmB4Uk0hFe/+moJKKx8kdvoRJt3XBTvH2RyeN
         yKhmc7caa6pcg==
Received: by mail-vk1-f177.google.com with SMTP id q14so10338986vke.9;
        Thu, 25 Aug 2022 08:15:20 -0700 (PDT)
X-Gm-Message-State: ACgBeo31k8VDD8ix3nlDSH5Wt/FDkOEM5TZpqklwlp3gVGpsQ1OxpqNP
        x+6yQ7oCwettLsix7/NaRMUczqco5+zhimv+IA==
X-Google-Smtp-Source: AA6agR4iu6jSkKeVPC33nDOlssDIK1jrZSrmgKXA6T6zfcamhzM2PVxvbmTTF/xYsdglmwLIzzGgNE4soLyV7FkmpD4=
X-Received: by 2002:a1f:23c6:0:b0:38c:88f3:f55c with SMTP id
 j189-20020a1f23c6000000b0038c88f3f55cmr1674826vkj.19.1661440519809; Thu, 25
 Aug 2022 08:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220823145649.3118479-5-robh@kernel.org> <20220824185058.554b6d37@kernel.org>
In-Reply-To: <20220824185058.554b6d37@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 25 Aug 2022 10:15:07 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKWb=jnACOs=PmMSUg=oTAWn9eLaSb7R6GVrJWeQXaFMQ@mail.gmail.com>
Message-ID: <CAL_JsqKWb=jnACOs=PmMSUg=oTAWn9eLaSb7R6GVrJWeQXaFMQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: Add missing (unevaluated|additional)Properties
 on child nodes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 8:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 23 Aug 2022 09:56:36 -0500 Rob Herring wrote:
> > In order to ensure only documented properties are present, node schemas
> > must have unevaluatedProperties or additionalProperties set to false
> > (typically).
>
> Would you like this in 6.0 or 6.1? Applies to both, it seems.

6.1 is fine, but I found a few more cases, so let me send a v2.

Rob
