Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E8575C86
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiGOHlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiGOHlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67350753BD;
        Fri, 15 Jul 2022 00:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0173E615F2;
        Fri, 15 Jul 2022 07:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58255C341CE;
        Fri, 15 Jul 2022 07:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657870863;
        bh=prx18bORl5xayVstWwmiZFOyFEmOKbL1W8Z3hB00LP4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lkSiiafU5C45/C8bCakTdND+kvpTBdZ1iPuhSKPqrJpuQNfaqdrPYjzWrm1RPduFw
         MnPrbepf3yDR4tMiVdbEA0KP52NkJjp+Zv18wF70yfCpbRepWyKsXKxawkSeSeO6b7
         bMPw+CcpRRjmf84JRrbfbwcCtLXyvSkLqlO4dlxT6z8hS5UFRwJgJezlxVtnfeGg6U
         Sr39kbdd4e6rt8I0hhuYru5kwoJlg2+pDJbCj2Jtn2U3ukLGliQ4hWIOT91CEtYT1w
         BrpL++VSAl3vYTctfp3n3iazLzcNhSFepoYGdE1wvENxBIYC21ZKRFCWiZrUqYiXC9
         PIoR5KBfjetBw==
Received: by mail-yb1-f173.google.com with SMTP id i14so7218765yba.1;
        Fri, 15 Jul 2022 00:41:03 -0700 (PDT)
X-Gm-Message-State: AJIora/qoSeH8nypJNdFF8yUywMvsSdjfxYQ+wcpuWit00lgbP8WlkVM
        0Jc0F3o6b7SNuVq9xwYRQoOWQNsKYVi7MMhfdeg=
X-Google-Smtp-Source: AGRyM1vD8yRr3rCO2aad5yuzRxpfe+hXi9LJGGQdP4f74UITSslw7JOrGgrNF4WpUfUKerNzgWm0yWrbB1KQXCl+nfc=
X-Received: by 2002:a5b:b47:0:b0:66e:3617:d262 with SMTP id
 b7-20020a5b0b47000000b0066e3617d262mr12045942ybr.106.1657870862212; Fri, 15
 Jul 2022 00:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220715053334.5986-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220715053334.5986-1-arun.ramadoss@microchip.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 15 Jul 2022 09:40:46 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Egk5BA1Q155dSN=E0DvBmzGqQSqzDayYf6mZZ7oYVSg@mail.gmail.com>
Message-ID: <CAK8P3a1Egk5BA1Q155dSN=E0DvBmzGqQSqzDayYf6mZZ7oYVSg@mail.gmail.com>
Subject: Re: [Patch net-next] net: dsa: microchip: fix Clang
 -Wunused-const-variable warning on 'ksz_dt_ids'
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     clang-built-linux <llvm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Russell King <linux@armlinux.org.uk>
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

On Fri, Jul 15, 2022 at 7:33 AM Arun Ramadoss
<arun.ramadoss@microchip.com> wrote:
>
> This patch removes the of_match_ptr() pointer when dereferencing the
> ksz_dt_ids which produce the unused variable warning.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Looks good to me, thanks!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
