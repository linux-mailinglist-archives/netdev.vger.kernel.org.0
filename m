Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5978B629BEE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiKOOWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiKOOWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:22:19 -0500
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F252C130;
        Tue, 15 Nov 2022 06:22:17 -0800 (PST)
Received: by mail-qk1-f171.google.com with SMTP id x21so9566946qkj.0;
        Tue, 15 Nov 2022 06:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MRPFekI2jAh+f9nYCsghmQc07s4JZ1qJBjgZserdqEc=;
        b=JG6/BdvXs0eYZ4n/wKAndSqNlILRYd+jyQERx0Hu+glV3ZsiJQv26+72Q3rfu9Wodj
         Duz5qcZ0px0UsGQzv4NB5MLHyrcQBB+KJ/9t53C0CS2qmY1GF44CqkhjOwkU1tJjwyhG
         n+7m+7NXMOzKe1URjbVMuhw65Ge7Q8PS8AgzjwHrB4vTUUNirhMsCkrnO7fs8iXxPvD/
         XgueruusmV52h6BCgB5rQVQH5+ZzEiVCRH9MAMjehstL6hIyw2F/FwajrK88Au97L57p
         qeN6XueHxkuULq0JJUEL0PVEi4KZYp7YiD9jev+snPEkJkiLZZfjuh17f8LTuc1Sq0kN
         zJYw==
X-Gm-Message-State: ANoB5plHvOZnHgvwmNlyDWKJRq0C88E0jw18YGjT3yNyIXXbHuiqqOyE
        phy0lnAv3BJozmsyn3XbnQ4cenyi4YZDng==
X-Google-Smtp-Source: AA0mqf7/sTbM2QX8z06HgLWFC5+0H5fYegSYZ+4+7JyYGsYDCiAbfzYsZxXsue+j7AKhnGSlqFEtGA==
X-Received: by 2002:a37:397:0:b0:6f4:ed58:b809 with SMTP id 145-20020a370397000000b006f4ed58b809mr14940284qkd.550.1668522136818;
        Tue, 15 Nov 2022 06:22:16 -0800 (PST)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id q6-20020a37f706000000b006ed61f18651sm8142448qkj.16.2022.11.15.06.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 06:22:15 -0800 (PST)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-3704852322fso138032477b3.8;
        Tue, 15 Nov 2022 06:22:14 -0800 (PST)
X-Received: by 2002:a81:4ed2:0:b0:370:202b:f085 with SMTP id
 c201-20020a814ed2000000b00370202bf085mr17460201ywb.502.1668522133942; Tue, 15
 Nov 2022 06:22:13 -0800 (PST)
MIME-Version: 1.0
References: <Y3OPo6AOL6PTvXFU@kili>
In-Reply-To: <Y3OPo6AOL6PTvXFU@kili>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 15 Nov 2022 15:22:02 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWqwVGYdxvMLCQ8uBLA+VoDYiMWOBMmCoKiQWqA52Uw2A@mail.gmail.com>
Message-ID: <CAMuHMdWqwVGYdxvMLCQ8uBLA+VoDYiMWOBMmCoKiQWqA52Uw2A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: renesas: Fix return type in rswitch_etha_wait_link_verification()
To:     Dan Carpenter <error27@gmail.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 2:14 PM Dan Carpenter <error27@gmail.com> wrote:
> The rswitch_etha_wait_link_verification() is supposed to return zero
> on success or negative error codes.  Unfortunately it is declared as a
> bool so the caller treats everything as success.
>
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
