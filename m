Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACF46BD4D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbhLGON6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:13:58 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:51659 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhLGON5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:13:57 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mzy6q-1mfq0V1ZHq-00x3Qy; Tue, 07 Dec 2021 15:10:25 +0100
Received: by mail-wm1-f45.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so1875312wme.0;
        Tue, 07 Dec 2021 06:10:25 -0800 (PST)
X-Gm-Message-State: AOAM5337vgAZyyuPJvl5HLtEs64AFxqWm9WbFiEnEGSu2Llum1/KyTvT
        QrkxrVIVQhNedPGhUSL0XKCs7wunamd7GkyIS+k=
X-Google-Smtp-Source: ABdhPJxzYIaZyD07IEwH3J9HMGNIhqGAWZ3zGdm59Whd0a71CdI2ssR4a+ilh0TymsuKXM7V3KAqtDlm32UnFlbGssQ=
X-Received: by 2002:a1c:770e:: with SMTP id t14mr7177099wmi.173.1638886224981;
 Tue, 07 Dec 2021 06:10:24 -0800 (PST)
MIME-Version: 1.0
References: <20211207125430.2423871-1-arnd@kernel.org>
In-Reply-To: <20211207125430.2423871-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Dec 2021 15:10:08 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1uMmgKw=drPhJWCdatzbm1+9FPZ6=-YMme+9n+f3xuXQ@mail.gmail.com>
Message-ID: <CAK8P3a1uMmgKw=drPhJWCdatzbm1+9FPZ6=-YMme+9n+f3xuXQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: work around reverse dependency on MEI
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:/nRy2E8cQ9ecITUKNHJeEG4LL+dPwsNKOW2ejiYquEJxDStU7if
 sJEX5LgxNRReffJMf0Tirwe9QF/hoygLHN0h0L2lt5qM45szh26HnAqLi3X+w1eeCCXvW35
 dBKsdS83JmquZ6r4MlmXcJVIJz2KvMun2uGSm0p2NvtxKRRV9aL6g2yflxU09TLtw8B8B1k
 CJ8chUbSrKOINDit5mWPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:omN3Ka5GG4Q=:0+k2uG/7PU8KNeMeMpSkHB
 DyL5zg9CSHJenWflWSAW43MzsWc+lLJWHVDGxUShrcDQ3uqwnwT3vF27eKAA89Hckf4E1A2oz
 qAPeEBaf0l79DqjuAQs2XqxSG3UcTYb1km8VLM8z4UgAGv+QPC4RdMw+rfasrr1ftjWeLOTHn
 Mi2NJBxeroM8/RbGyvMvXDA8jjAeUbGaIzF04K0oW2PmztdUS9ChBVqA1JtnMAr9sqLi3I7l/
 XTGXP9fZTqHEZ7LKMDhFbWtRe1uNH0tyaU7ZBtQAkIEB2skMoM7irE1kC7E+vaYkeLMX1AJnD
 3iK5fqVE3MKuCRbq4+3fjedqe7XP0PMPytqALoms3rNo3bza+r4FsADVonr9UEXrZi+ZshjIM
 DDQJCwjjVh//MO6zMdHf9aRyXEL7cmhk6zhIy+qFNg+amWuvdtGiNEAE/7+bhzJCiU6SHXBvD
 yj6Ztn5d3U/NRUPsveW7FAWYXmzBJnLFA45qjeUwBr/4Tj+LP7hlz06Jrsy/sG7/MWt/dPpu9
 bGpcpqg5wcJx5xztunPPXzKYLn+35oeap0N93DFa9Ho4FIE+0euJIzR+eIvbgxuczJwclWAFm
 BF5e/Pq74jpHdcszLxfCRTSjnQNd5Sys7mS8Y0R14yOCMxy9Vkh9CpVjg4mLlaEaDT4vu3Y0+
 VTDS2lD4fQpwdXKxAeSEy6kQjwcVPp5iGmS68KHYZ9MOJryJGVpr1fPbCrUwBbpJpWSU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 1:54 PM Arnd Bergmann <arnd@kernel.org> wrote:
> diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
> index cf1125d84929..474afc6f82a8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -93,10 +93,10 @@ config IWLWIFI_BCAST_FILTERING
>           expect incoming broadcasts for their normal operations.
>
>  config IWLMEI
> -       tristate "Intel Management Engine communication over WLAN"
> -       depends on INTEL_MEI
> +       bool "Intel Management Engine communication over WLAN"
> +       depends on INTEL_MEI=y || INTEL_MEI=IWLMVM
> +       depends on IWLMVM=y || IWLWIFI=m

For reference, that line is wrong, and I still see the same problem
with my patch
applied. It should work after changing it to

        depends on IWLMVM=y || IWLMVM=m

but I'm still testing for further problems.

             Arnd
