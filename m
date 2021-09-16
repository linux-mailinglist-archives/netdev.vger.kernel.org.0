Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8240D584
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhIPJFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:05:55 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:18443 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhIPJFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 05:05:54 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 18G943If031888;
        Thu, 16 Sep 2021 18:04:04 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 18G943If031888
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1631783044;
        bh=/Me94CHI6D7Grr/8zySCJznRVytvYJSDU0FIaolkDBw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fVl8pB5YtiFRnT0CZxZbTo+FfRuYBSqrQgg1faX3k5qXdY/eT1ZTr2uc+vJVu/wIc
         yl85E+hBYJN5tLSdYBauy+5PIF1Ip044qrNNkW7QMiiqPDxO3gDgbc3HyKrt/+wFAA
         m65HJ72UWerudX+gQT2IDU0Gad9hyfqDq8F5ja4yK3RyE4vhucQ+IWVaH9f1J+N+jk
         EJfa6FkcNLhiIgXj7ncf4wlL6oVIZoD/qG9bO1WiuGbaw2+tPUoDscCm472NOSDN7a
         +BKR0FnOqx/k4bd+SF+G6xz/pycaPdoYsBCorOBmd8cwE+lg7QKhcrWtfDqNfIS6S+
         HTNwe502FDWKw==
X-Nifty-SrcIP: [209.85.214.174]
Received: by mail-pl1-f174.google.com with SMTP id v2so3372604plp.8;
        Thu, 16 Sep 2021 02:04:03 -0700 (PDT)
X-Gm-Message-State: AOAM533p76oBGSRxjymM71Sk39JfgHi3OZy+Zg8TgGimsTjlrBuje+TX
        fEcFjAHP/erYEn8f5TO42wtqBxKQ8LTUtnCTSU0=
X-Google-Smtp-Source: ABdhPJxEnFljfssNoXutqySyeUzI+AmBXxzdw4JCokqyxa1jombHYCaZ+PLCvcYjvH94X4x99MQ7AZPxoetqYajKAS0=
X-Received: by 2002:a17:90a:192:: with SMTP id 18mr13726656pjc.119.1631783043186;
 Thu, 16 Sep 2021 02:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210914121550.39cfd366@canb.auug.org.au>
In-Reply-To: <20210914121550.39cfd366@canb.auug.org.au>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 16 Sep 2021 18:03:26 +0900
X-Gmail-Original-Message-ID: <CAK7LNASCbVJ0EYoGN8iz+yskpHUuR_PZnePUUtgJu9UZqGW2cg@mail.gmail.com>
Message-ID: <CAK7LNASCbVJ0EYoGN8iz+yskpHUuR_PZnePUUtgJu9UZqGW2cg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 11:15 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from drivers/net/wwan/iosm/iosm_ipc_task_queue.c:6:
> drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No such file or directory
>    10 | #include <stdbool.h>
>       |          ^~~~~~~~~~~
> In file included from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_mux.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_imem_ops.c:8:
> drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No such file or directory
>    10 | #include <stdbool.h>
>       |          ^~~~~~~~~~~
> In file included from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_mux.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h:9,
>                  from drivers/net/wwan/iosm/iosm_ipc_imem.c:8:
> drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No such file or directory
>    10 | #include <stdbool.h>
>       |          ^~~~~~~~~~~
>
> Caused by commit
>
>   13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump collection")
>
> interacting with commit
>
>   0666a64a1f48 ("isystem: delete global -isystem compile option")
>
> from the kbuild tree.
>
> I have reverted the kbuild tree commit for today.  Please provide a
> merge resolution patch.

I am sad to see the kbuild change reverted, not the net one.

13bb8429ca98 is apparently doing wrong.

Including <linux/types.h> should be fine.
















> --
> Cheers,
> Stephen Rothwell



-- 
Best Regards
Masahiro Yamada
