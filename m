Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8BD54E8C5
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiFPRq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiFPRq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:46:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DD242489;
        Thu, 16 Jun 2022 10:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D54B824F8;
        Thu, 16 Jun 2022 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCE8C341C4;
        Thu, 16 Jun 2022 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655401614;
        bh=a3Z5yeH3jen1/5E0ibGP8X9xUa5ldCFEjepDQx1NRsY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d0kdz0DzHwhcGptroXeLu+3qcuAfPo/3Rzhf+RDVWqfzk9wL3r7PSedONUhdaY29n
         /nhab28u086NtFzQLMiLNQKT9iToUwMPCTJ7uN1URhP6lQfWrQSqRIT/bHh9LnBH+L
         /LzAzGTbtQQjAFB4gUYhmdq8g5AUJGvO6TA60GqjT4qeJJo97pi6YQceAJrZDEuTEZ
         vXdTjLjR8RISzkbHuEXn4dfvaUpPP+kIQHaIYHhmsLrqly8MFmM1O+L/nYJ0szcLyX
         veNECykkqaoNxyudT03b+jc3dvpDg83YFBGpucM9owWuShDBdKG7EnlPYftfFDs48+
         cJszjRzqyIZew==
Received: by mail-vs1-f47.google.com with SMTP id e20so1917515vso.4;
        Thu, 16 Jun 2022 10:46:54 -0700 (PDT)
X-Gm-Message-State: AJIora/P9vwCQ6EstqexlIm2+tBKm2n7oxMM36iFuPo9dSKHO9TJJr5T
        8PumwXWhxSU10F/dqh8XTj1iZMHxj4ID9ezVNg==
X-Google-Smtp-Source: AGRyM1vGAqdzOalUBqekYDSJugHvCocjWd/glXnsxxGXG96fj+Wiea2ZNDAp6I7ij/DVFmUPO/pfYWyNZ3oXE7Owq1w=
X-Received: by 2002:a05:6102:3d0f:b0:34b:bdd0:baef with SMTP id
 i15-20020a0561023d0f00b0034bbdd0baefmr2813780vsv.85.1655401613705; Thu, 16
 Jun 2022 10:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5e5580c4d3f84b9e9ae43e1e4ae43ac0a2162a75.camel@redhat.com>
 <MN0PR12MB5953590F8098E46C02943AFEB7AA9@MN0PR12MB5953.namprd12.prod.outlook.com>
 <1ae6dce1-0c5c-64f0-c6a4-b0f11a82f315@linaro.org> <20220614185454.7479405c@kernel.org>
In-Reply-To: <20220614185454.7479405c@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 16 Jun 2022 11:46:42 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+32b6GcoX4+d7bnu512-FFaFgb3AEn=iEM_54Mp59RHQ@mail.gmail.com>
Message-ID: <CAL_Jsq+32b6GcoX4+d7bnu512-FFaFgb3AEn=iEM_54Mp59RHQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 7:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 14 Jun 2022 15:48:43 -0700 Krzysztof Kozlowski wrote:
> > > I have seen a mixed set of the convention for dts patches. They are following
> > > both routes i.e device tree or subsystem repos provided acked from device
> > > tree maintainer.  If there is preference for device tree repo then I can drop
> > > net-next from subject prefix and resend it for the dt repo.
> >
> > If you got Ack from Devicetree bindings maintainer (Rob Herring or me),
> > then feel free to take it via net-next. I think, it is actually
> > preferred, unless this is some fix which needs to go via DT (Rob's) tree.
> >
> > If you don't have these acks, then better don't take it :) unless it's
> > really waiting too long on the lists. I hope it's not that case.
>
> GTK, thanks. I'm also often confused by the correct tree for DT patches.

It is documented in
Documentation/devicetree/bindings/submitting-patches.rst, section II.

The default is bindings should go thru subsystem trees. Given netdev's
tendency to apply bindings before DT review and even semi-automated
checks, but skipping standalone patches, I haven't minded picking them
up.

Rob
