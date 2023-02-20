Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3812D69D5F0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 22:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjBTVuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 16:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjBTVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 16:50:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05627C651;
        Mon, 20 Feb 2023 13:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7972AB80DFB;
        Mon, 20 Feb 2023 21:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E03C4339B;
        Mon, 20 Feb 2023 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676929798;
        bh=jynWOqndAYviDgNMr9Apo3QCedjur8URGys30KxSl6U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KYg/8Q0W0WpxC/zGOt1U3KVF/UKoNdSu42UHUqTyl6P0p35XUES19jLknCCdbwJmP
         l1XPM6bySbGP3tVO9gTQUf5yvrFwC1ui5LS/Anu8LwLaihr8N4wiSws28yZbKWxIr5
         +XPnGEVFFFHwis1ZxGddz4NCpQg4CsMW7vXzBUgeTVt0Qo8AFJGZdQ2Pe1zIYerA5X
         L3kOzQB0niYK1e+yCU+ZEFgBncO1SNMi/f5Rox+cUH0yCqCUQfehHR/6p0bKpLrjYe
         mTO02q4yFdd7L1JzXeBnIYkrbPQOUF/5auzqw21QFw0REgOi4OC0ENOn+iz/vdM5rK
         s0PadLj6PHIgQ==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-536bc31e50eso29341117b3.7;
        Mon, 20 Feb 2023 13:49:58 -0800 (PST)
X-Gm-Message-State: AO0yUKUnx1FYeLznMJayARn2BjbEMmGfhxmIjCsOimLDRDAUm8fwGcir
        EGSR8emC7I0vr5VqpeGRf7jkDmBglOEvjxoKbA==
X-Google-Smtp-Source: AK7set/LG9VtkJ4m+YgIay3yfirO9DvA4v1w3HJUqxHjaTJ+8Ymg8LHKudws65YFdiaHoY25yb2xyQEI91gEQGXA1NU=
X-Received: by 2002:a0d:dd4e:0:b0:52e:f77a:c3c with SMTP id
 g75-20020a0ddd4e000000b0052ef77a0c3cmr375594ywe.454.1676929797250; Mon, 20
 Feb 2023 13:49:57 -0800 (PST)
MIME-Version: 1.0
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net> <20230220114016.71628270@kernel.org>
In-Reply-To: <20230220114016.71628270@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 20 Feb 2023 15:49:44 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+2_gQzAjAZQVux1GOff5ocdSz5qQMhjRzvtyD+9C-TQQ@mail.gmail.com>
Message-ID: <CAL_Jsq+2_gQzAjAZQVux1GOff5ocdSz5qQMhjRzvtyD+9C-TQQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] dt-bindings: net: Add network-class.yaml schema
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Janne Grunau <j@jannau.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 1:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 12 Feb 2023 13:16:28 +0100 Janne Grunau wrote:
> > The Devicetree Specification, Release v0.3 specifies in section 4.3.1
> > a "Network Class Binding". This covers MAC address and maximal frame
> > size properties. "local-mac-address" and "mac-address" with a fixed
> > "address-size" of 48 bits are already in the ethernet-controller.yaml
> > schema so move those over.
> >
> > Keep "address-size" fixed to 48 bits as it's unclear if network protocols
> > using 64-bit mac addresses like ZigBee, 6LoWPAN and others are relevant for
> > this binding. This allows mac address array size validation for ethernet
> > and wireless lan devices.
> >
> > "max-frame-size" in the Devicetree Specification is written to cover the
> > whole layer 2 ethernet frame but actual use for this property is the
> > payload size. Keep the description from ethernet-controller.yaml which
> > specifies the property as MTU.
>
> Rob, Krzysztof - is this one on your todo list? It's been hanging
> around in my queue, I'm worried I missed some related conversation.

Andrew suggested changes on 1 and 2 which seem reasonable to me.

Rob
