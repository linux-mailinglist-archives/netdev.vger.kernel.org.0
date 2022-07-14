Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B074D574585
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiGNHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiGNHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:09:04 -0400
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B501903F;
        Thu, 14 Jul 2022 00:09:03 -0700 (PDT)
Received: by mail-qv1-f47.google.com with SMTP id r12so847975qvm.3;
        Thu, 14 Jul 2022 00:09:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T0TGzHJ/d88sjvucmzrmHfr2w3pyHWB6L9OYmNBsm0w=;
        b=O2nHyfeeyJtoK+5rSSf9i1yQuTds1Fi3By82z54ItHDp1b/KD3f8tLFmExu8gK7hkT
         1NdxsX04JPsSuPp2B3xh8HpIGWNzWnaNhRXrumRoOmH4R0H1tdKSCXIC9qqO5JKXVMke
         JHT2CJz1HIrqe8vsg3fmi6ffwaLkHpZgYYPVou6n78MTrQUZcilkrX2H0ZisVUd/JbL4
         x2+BDxTyY68LrKoEQ48c0NXE51KYJMh2wiA2AoZg8g63ORkPQTOXkNVSyogadwk0wm7V
         jfXZNnk1cZiE9y5vgTO4NnODKdn7wL23CEa2A73kaGwFLWWuEBDzsFXOdx7b7pO6lK3m
         Bz5A==
X-Gm-Message-State: AJIora/9M8/e+BXHt7GQfThBEPfncHzrNWnH1qjjtJkEOQETyZSGWSrS
        puYJmI38YHPpN/tr8az6FPW1p8B2oDJpXQ==
X-Google-Smtp-Source: AGRyM1tnClzyP0ypUH6cJ/Q1DKTs5xvyrdwVNH4AjfK3QF1RIbxw3yLvV9ABmkEA+h2vnqwAqshjhA==
X-Received: by 2002:ad4:596f:0:b0:473:2ebe:db7e with SMTP id eq15-20020ad4596f000000b004732ebedb7emr6643117qvb.106.1657782542296;
        Thu, 14 Jul 2022 00:09:02 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id k19-20020ac84793000000b0031ece8b6666sm901796qtq.43.2022.07.14.00.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 00:09:01 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id y195so1817054yby.0;
        Thu, 14 Jul 2022 00:09:01 -0700 (PDT)
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr7497019ybh.36.1657782541422; Thu, 14
 Jul 2022 00:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220714042221.281187-1-sashal@kernel.org> <20220714042221.281187-39-sashal@kernel.org>
In-Reply-To: <20220714042221.281187-39-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 14 Jul 2022 09:08:49 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWumKeJmsOsd7_=F-+8znY=0YtH-CbeLN7knSJ1LDOR_w@mail.gmail.com>
Message-ID: <CAMuHMdWumKeJmsOsd7_=F-+8znY=0YtH-CbeLN7knSJ1LDOR_w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.18 39/41] wireguard: selftests: use virt machine
 on m68k
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, wireguard@lists.zx2c4.com,
        netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Thu, Jul 14, 2022 at 6:29 AM Sasha Levin <sashal@kernel.org> wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>
> [ Upstream commit 1f2f341a62639c7066ee4c76b7d9ebe867e0a1d5 ]
>
> This should be a bit more stable hopefully.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Thanks for your patch!

> --- a/tools/testing/selftests/wireguard/qemu/arch/m68k.config
> +++ b/tools/testing/selftests/wireguard/qemu/arch/m68k.config
> @@ -1,10 +1,7 @@
>  CONFIG_MMU=y
> +CONFIG_VIRT=y

The m68k virt machine was introduced in v5.19-rc1, so this patch
must not be backported to v5.18 and earlier.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
