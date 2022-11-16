Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3388A62B57C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiKPIrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiKPIrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:47:17 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114F19009;
        Wed, 16 Nov 2022 00:47:16 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id v81so17747763oie.5;
        Wed, 16 Nov 2022 00:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EFx3ADTqPQnIUoerCbcND56+lAT60nhJaC7HSWp/txE=;
        b=RIGCpjYQFDBQjvYxCTHdkSWgTFx4vhsfeZYj86W1gUcNtLxbbOfB+qDH9MB4fb8RJf
         MARkgbwU/sYvEV1k86jwlYsHiiqPiFmeKPRsmRmX5QI7EndW1zUDZC0zmllO6lKQxGDm
         jmllwCwvQc49N62wCkABlEumaIy7OuYsG4NR3O+cds4pmgv8YgxTn4LPgeUU3EW6g9vE
         fgmdVysxGSgR9a2N8430h636GB2iGUZlm1NV8WpT+i7DnFQwwemqBiwF2PRGzfBuB0zS
         rIxfTJvoxY5EY4FeJwxclF85nG/kdCLqJVM9h1sZ7H9bCtmpNQ6ffAX8qgU2i/FAkzNI
         Q4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EFx3ADTqPQnIUoerCbcND56+lAT60nhJaC7HSWp/txE=;
        b=2bmogAyqCm3QENX9Tvu96DJ9AiAjg62y3E++MsHOjDEE3E7lu0pm8M4Y+r5BxMcQco
         o5wihZ6eeT2+RE93038zOyL6hg5D+gYgHRC3TsbHGzvMR7WoyfKfo5iPX496ro+Qojtb
         qkEoFe48VJEsS2n++dBPMix+9I0h3fwfeuSxGvLUJ7B4BL8IkDWYv74sTXJuAxKzp7hE
         YGi9ZMvxJ7wgWtBVJNITWd7dA2o7ELrMipwSph62GL6ddcqnnNqVrEFB2MO6zsFwmQI2
         ZRlSSBgBquhAU3udhu+zoJdSdK22/hMD9qj6lf35fIdM+uR7bx2Qn5kfBGmz98Ht3+g5
         SZaw==
X-Gm-Message-State: ANoB5pkRSSM3pIgzWakgOP/TDkbxa/U54saHO8mWTE0W5U3zS1HDI9vg
        Ufwb8y7MVHNJ0gbwL9BKmJnH4MeHdQnfduBoYMcdSrkOwAa1CKHRTT0=
X-Google-Smtp-Source: AA0mqf7qE3nYJW8kHOhm1O2gl+T62j32ZFd5tMwnG6tPZCbzUm4wcO50MIa/a4qTgqv3yxc8wBEulTeJIzHf3IYqzL4=
X-Received: by 2002:a54:468f:0:b0:35a:3c4d:9c9e with SMTP id
 k15-20020a54468f000000b0035a3c4d9c9emr1053445oic.97.1668588435747; Wed, 16
 Nov 2022 00:47:15 -0800 (PST)
MIME-Version: 1.0
References: <20221116173353.19c17173@canb.auug.org.au>
In-Reply-To: <20221116173353.19c17173@canb.auug.org.au>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Wed, 16 Nov 2022 19:47:04 +1100
Message-ID: <CAAvyFNgZjPQger6E7cVHkRLcic85RwKz7opd2Tmf2MdyWt8QmQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 at 17:34, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> pseries_le_defconfig) failed like this:
>
>
> Caused by commit
>
>   d9282e48c608 ("tcp: Add listening address to SYN flood message")
>
> CONFIG_IPV6 is not set for this build.
>
> --
> Cheers,
> Stephen Rothwell

Yes, Geert already sent a patch:

 tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
 https://lore.kernel.org/netdev/d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be/

Jamie
