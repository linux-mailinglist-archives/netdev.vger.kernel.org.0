Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E33DF664
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhHCUaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:30:22 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:38877 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhHCUaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:30:21 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MD9CZ-1mJVNR3xkf-009CkV; Tue, 03 Aug 2021 22:30:08 +0200
Received: by mail-wm1-f50.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so160936wmd.3;
        Tue, 03 Aug 2021 13:30:08 -0700 (PDT)
X-Gm-Message-State: AOAM531Ts/0/79wK+K0ZL+/BFUrdoerRuCMi7Y6GZkKdsfrtspedgqLY
        fe+SDyWy4sVlflWB4m0JDvHKqSy4yJBzSKytln4=
X-Google-Smtp-Source: ABdhPJztoKzXY55coEoAxL9y9oqrb//3AU6TiJB2JCKkwNmgNPh4QuyIuLKOpSM8h4lheCxSkbt8AoREssFdSqTTHoo=
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr14835788wmq.43.1628022608582;
 Tue, 03 Aug 2021 13:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
In-Reply-To: <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 3 Aug 2021 22:29:52 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1tKjWo6RQq9nxDAuEWyEF=p8HDBzYG+=r3HVG9k0oUEQ@mail.gmail.com>
Message-ID: <CAK8P3a1tKjWo6RQq9nxDAuEWyEF=p8HDBzYG+=r3HVG9k0oUEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:g7Q2adwBgwq78PvMJF2VqcKkj8n9+4XS9TETDHk7ZtOQBnoClFI
 SRjCD/VS8NCgCYMVVGIbOYPkEEvg6CWlWLFWQKMSbj22hSo0aVniiP5VIyuRyKZa0NaDKUQ
 yUknTe5ueaAg2l8YUg2kQ6QnW96INhIL7yg1o63wn49IKVTfDgjZFXzDD9s5g4B4PaR9WNX
 kgmib3eW9sS3vUqU+61Ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PwygCUm2s7E=:U4ZSBeSihNUCTR0YcJyOBI
 Mq22GPpMZL6ZHbP2muYgUK8DPJ5C9HJ9EYfQ6BwEDqFT0P/L1nzKr/3b8r1o3PhDMyMMtJujc
 LQnBt+hs+ACZlWFRNsYjJNu/1F6hBZodMHXs4hYk+w+7pf1+QTeCjif4mGThPqZK/17vLokEM
 IotMQahElvfa1Kd9J4ZxbRyuXiilBviFeMPa3QO3mtgkKa6wMRiZlHx2IFXJ5XO2B5WWQJVjJ
 JPExzcMcKYCTSuafcrNOJQdsDaGxCfu202cT3QnESgV7SP2iNid7FxyTaIj7A7p1gfFJQDwoQ
 xnAohwOVCMXulR/ouD/U64BqzU/EcJssDvMooa75qUWgsp/ewU8uXyF71PtsI8w0kBnYXAYC7
 40KPFISSqvaRSM5HTDookwPASMCsnspwoTUseXpC1L0EDhaA/00l0L5qcgEw81/vls3UUQhdt
 6q7bO9XLpx6vy/5JK42CxWDX1WFSC4S7JmyKFX3IxlKenAjWDM6lezb4MNROPIrH2wXXRZmDx
 rs5hmS3DvXacTM4mzaXcvSMthM3jM7Uk9BYOzUcy1Rk6jzRkKtrJzkRF3DFzrmQxcP4rZjl2O
 Yvf8N8KJ8xN0VRuY3HDpk3MjaIGlhTwwcWh/0fSFvFq6QNLwT6VJmjl6n91vFkD15Gvs0lVcL
 zNTPHRN2KEhwjU2F41gyg+RSbPrVj7y+pNFFfk30T2o35ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 10:32 PM Arnd Bergmann <arnd@kernel.org> wrote:

> config MAY_USE_PTP_1588_CLOCK
>        def_tristate PTP_1588_CLOCK || !PTP_1588_CLOCK
>
>  config E1000E
>         tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>         depends on PCI && (!SPARC32 || BROKEN)
> +       depends on MAY_USE_PTP_1588_CLOCK
>         select CRC32
> -       imply PTP_1588_CLOCK

I've written up the patch to do this all over the kernel now, and started an
overnight randconfig build session with this applied:

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/commit/?h=ptp-1588-optional&id=3f69b7366cfd4b2c048c76be5299b38066933ee1

       Arnd
