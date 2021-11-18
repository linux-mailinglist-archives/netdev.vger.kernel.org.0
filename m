Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2088A455B80
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344672AbhKRMbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:31:43 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50889 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbhKRMbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:31:42 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M7bJ5-1mkgNx44bt-0086TT; Thu, 18 Nov 2021 13:28:41 +0100
Received: by mail-wm1-f41.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so4663088wme.4;
        Thu, 18 Nov 2021 04:28:40 -0800 (PST)
X-Gm-Message-State: AOAM531xTKoFdNiPxVl9NQTMYptgiWh2rYAFfNiOsvO3qrwrCoiOgotH
        0kNDEjvtqmmLYd8WCPmV/EPbWVGTb1SYiYZx/bk=
X-Google-Smtp-Source: ABdhPJwHPm5rqs1mRtoVU3VyAD82P9B5WdxoHRl5cSOj+PTUOb9M4G3I3oGcy5XOrtizC7TPV0BPZor0dkPA4ESo0Ng=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr9556680wmb.1.1637238520555;
 Thu, 18 Nov 2021 04:28:40 -0800 (PST)
MIME-Version: 1.0
References: <20211111073145.2504032-1-arnd@kernel.org>
In-Reply-To: <20211111073145.2504032-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 18 Nov 2021 13:28:24 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2hdrxz0rsDxWRu7B2Hfv-+Oo3yPndoLNH5KZw9Y2Knzg@mail.gmail.com>
Message-ID: <CAK8P3a2hdrxz0rsDxWRu7B2Hfv-+Oo3yPndoLNH5KZw9Y2Knzg@mail.gmail.com>
Subject: Re: [PATCH] [v2] iwlwifi: pcie: fix constant-conversion warning
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        Yaara Baruch <yaara.baruch@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:QTGlcYey+aabEMDF6hyOzBg6M9CKvuK1qfQmbCKDfkuxue5/sLk
 5W0gTvp+L4XkSLhyVBfOe7RjoDs5j/SV4hW7lqpaJ9+dmzX2bExcJbzXT3ByflUUTuVcBPb
 DplAkwRcDNRwz57Uldf9iLjzvTsOdwEBXL9xRb371Gm73dC/V5ake1+gVAZdIUBIYD047e4
 7Z/2GzHWLdvXYL0nUqu3Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/y+FUqUeiXE=:x8Ei40jSSi7VeLpUgTPAKA
 DtIH9B9dtKJJYdswiDq66WgHitXddkphKXO4dGpHEaEXNmdfG5nvDyC1Vu7kSk/T+u5Ca2tgK
 tT29bKvxUsJVT3OsWE8TJVpo4qu8KM+Sx6yDRv8tkV6npwe61yK8eDIqDsI4xIk5U+O3ki80k
 giM+rVbIXjnwwWPrxK1tdVMP7gCPN2rBDamLo26b+1kfGzUsN5AZiZ94tVb4YtxxrzcB0w4P/
 UXesDpO/Sza99u2xszJXnh+nVjQCNypuVFU/55vbBRvEJB8fIPq+4fS7+0KnLP/fxqsi1CyzZ
 mTPtZHDyMkVho7seZGfq1HCCsMrr7XMzXy9uAmznmFhyfB84UqrMg1yRMFiNtl3hMt1njPaj2
 q5bLMwgpyv/dmVQdqaYpgTCd4T710W3Utq51uKHBfdh4qOQ7rqGXe7XUioWQhKIrmhHokCmLX
 cg5EnI7pXo95ApIMOVmRdDUhIkJNF35YWxb6tONLKxPKdPJ/4kAcxJ2RW1Bdi5CN+POwQfQj+
 HxH67HNmWMvVQqkliaRCQKTgnRFqSRV7AhIGEnCvTfb1lEcDYFUCrOYnLEnCjB3j5Z1G+JpSn
 5fj0LfsqQ5zFkBMZB/jkVAWsNCVQ/dF95wIAmaqlPd8VuZiMTutWXWaC9q8upsGUvFgEnDXSJ
 elT3ZBwQy59aBp+LcmbihqcJSxZoHiuqCa3AVIOiXFdRJi3OQDCodv/C0z+O+gkaTtM0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 8:31 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> clang points out a potential issue with integer overflow when
> the iwl_dev_info_table[] array is empty:
>
> drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
>         for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
>                ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
>
> This is still harmless, as the loop correctly terminates, but adding
> an extra range check makes that obvious to both readers and to the
> compiler.
>
> Fixes: 3f7320428fa4 ("iwlwifi: pcie: simplify iwl_pci_find_dev_info()")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Something went wrong on my end: I thought this was a clang warning and
that I had
fixed it because it didn't come back with my v2 patch. However I now see it in
my gcc-11 test builds, so I assume this was a gcc warning all along, and that
my patch does nothing. Please disregard it if you have not already applied it.

       Arnd
