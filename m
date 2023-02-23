Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047EC6A03C0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 09:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjBWIXI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Feb 2023 03:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbjBWIXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 03:23:07 -0500
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C662A99A;
        Thu, 23 Feb 2023 00:23:04 -0800 (PST)
Received: by mail-il1-f178.google.com with SMTP id 4so342016ilz.6;
        Thu, 23 Feb 2023 00:23:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5ZeLpAcytC9nMrYmKqdNZD2wZe3vrvrg8zHDxhEqxY=;
        b=cwg97HL5i6mhMLXr/SQVdhPD7Uw+z/70+NcTRtuMnVoUOsaAqqkVzd7hi9FTiR8Qxv
         8VBI8yG8d0s/V+/KnPxE2FqHfrTh2drbqUSghjht9go6kKVLK7MVwXTLtpiuzyPmolZb
         ZR+ybLs/E0E05aAmrSh1m2r75QEDJIEtP2IC+XBgI0VqX7tVoIAUmoeEG5htMhBptj/f
         G4erkFeGAP7mXHtfE/eLnG9dSIOi8OyXNjcLOnNcyK7nI0qxK8Ctu8+otfbiyo/OYew8
         ePRzoc0nrkadJeha6e36SyETIaqWZ4rSnOePV3xN22AWT1A96/HhtHhZzBj2Z7VyalNG
         s7sA==
X-Gm-Message-State: AO0yUKX3PrgB7wrx+iMOgK8ghkD5pYAhH9+CZUBGJfdWkBLI+MYo4JMU
        cOtykJCo7dUFEt/t/LLcOujDn1OIJw8n9Mby
X-Google-Smtp-Source: AK7set/cF3VqPmHxeuxCXtSIoYd7NvfPk5ETYtO6IcJTIE2wLlUPsBukI1WQb7tKtlZ/VC3gWCG3iw==
X-Received: by 2002:a92:c564:0:b0:316:e457:489 with SMTP id b4-20020a92c564000000b00316e4570489mr5886124ilj.32.1677140583375;
        Thu, 23 Feb 2023 00:23:03 -0800 (PST)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com. [209.85.166.53])
        by smtp.gmail.com with ESMTPSA id k6-20020a02a706000000b003c505bdf305sm1788969jam.141.2023.02.23.00.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 00:23:03 -0800 (PST)
Received: by mail-io1-f53.google.com with SMTP id v10so1797708iox.8;
        Thu, 23 Feb 2023 00:23:02 -0800 (PST)
X-Received: by 2002:a6b:c8cf:0:b0:71b:8c6:6123 with SMTP id
 y198-20020a6bc8cf000000b0071b08c66123mr362773iof.3.1677140582746; Thu, 23 Feb
 2023 00:23:02 -0800 (PST)
MIME-Version: 1.0
References: <20230223145519.11eb6515@canb.auug.org.au>
In-Reply-To: <20230223145519.11eb6515@canb.auug.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Feb 2023 09:22:50 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUa+RiSx1SdKSbYb6mCbQHY6V2oer=awkaWCuHuk1cayQ@mail.gmail.com>
Message-ID: <CAMuHMdUa+RiSx1SdKSbYb6mCbQHY6V2oer=awkaWCuHuk1cayQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 23
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, Feb 23, 2023 at 5:18 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Merging net/master (5b7c4cabbb65 Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next)

> Merging net-next/master (5b7c4cabbb65 Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next)

Niklas Söderlund has just made me aware of the following "private"
netdev announcement, which you seem to have missed:
"[ANN] netdev master branches going away tomorrow!"
https://lore.kernel.org/netdev/20230222102946.7912b1b9@kernel.org

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
