Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D519F613
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgDFMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:50:52 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:47017 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgDFMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:50:52 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MvKTJ-1j3ljn1L61-00rI73; Mon, 06 Apr 2020 14:50:50 +0200
Received: by mail-qk1-f175.google.com with SMTP id b62so15938640qkf.6;
        Mon, 06 Apr 2020 05:50:49 -0700 (PDT)
X-Gm-Message-State: AGi0PubHeqKzu3SRo9sjhdRnscnXaK8k2VRFKPFoC8Jsh3/xysIrk5yl
        zBrxgmzNOCXgTM0nAnBEBb0KQomxhaP/vLtsHjY=
X-Google-Smtp-Source: APiQypICKUA2vrOK5Bc2jX1TRNULphU8psoKiSX0vN3LLQCWOU+hQ1MKp843zvn0fSuU8msATIvGOPavJwM6FiL0u+U=
X-Received: by 2002:a37:a52:: with SMTP id 79mr871336qkk.3.1586177448981; Mon,
 06 Apr 2020 05:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200406121233.109889-1-mst@redhat.com> <20200406121233.109889-3-mst@redhat.com>
In-Reply-To: <20200406121233.109889-3-mst@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 6 Apr 2020 14:50:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
Message-ID: <CAK8P3a1nce31itwMKbmXoNZh-Y68m3GX_WwzNiaBuk280VFh-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vhost: disable for OABI
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "christophe.lyon@st.com" <christophe.lyon@st.com>,
        kbuild test robot <lkp@intel.com>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        Jason Wang <jasowang@redhat.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:26QQv3e+Y1jY5LDzJy0GTFuham3+RzcH1XBOTiRIjx3FRDJsjhr
 85rbr0xxslB9KcIDoKgM86eyDuFsSv5TMEKfdXcaVE9GCDCS/uksezYKBheXKx8qwQLv8Zc
 n1HLheczU7fFudq5WLf7ZDArFB8W/gWL0Kzht48sbstT2u1MGX+ENOlljKGEsstZex0Tw3N
 fl7RoftQdSoaGfpKD+mRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9jL3oX02Ddo=:mUenTKD+/d5TmDQsE5ElK/
 LuBvGlIC1f43HcvwHRmvN0FueMJ92fgSbKT5+BNAREJULYHT8rR/v1OZ/Lk5rilA9i750EHsr
 EqYvrwUq4yAVH7rCm0Y3bikqtm/lh8c/6OrHm/7cfJZsjr12Z06CapxhZMM1y30v5lO5lEPwH
 EHJqtpCK6ULmFw6IqXQ1TIO67KgtwwZ2VNoGJHpNvjnWHTCZP0ZPR/6Qy2q7toljJOo5+iEqt
 hX0wr85blBy5UnFtMuoCDmLPgMTqDeEcNxz/5Kte8+17cYr7vNvNR44SH5Y/WRWPI82ZhZTZl
 8L/PkzB2YI8RiuBPTvNzNOQ2JNRFWn+Mc66IGgU40fuNFx1cuUx7kix/KWYtw1A8DCsYg7jTF
 CzWKNdtnKjwS7i1B6kFCFO62UplDwX5tzu7nSAPAR70zrvHU9LJXxp6SmB0sqmwhUyryegyzP
 +8fcp1ZXkTDBuy/W3kC0tr7qX5P8ofCUs1CpqDKUfx9wlMySxEBkLB1Wi0PJcZR1aWTh+Oy0N
 walPat7Vfd9VB3fI7Yn/67FmBS69jDEUsDCdSLlcrWet4Fezdhu6+BIH6aN9C/y2IBn6AEJ/b
 8MT5QBQlQIIe+JUdkR99U/AdO51pVObzHhTzahS8n+bc46WxPXaeb/oreVdcuvUgZHsdMc8Tk
 NjEKHlreloyUoWs/O5atIm10RKmyhmS2ld2Fme8mSSurv62wd9tytbMLZ9LsMwcRh2/V32v5C
 XW86HMJRiUWifXjqISGIGLjaUIy1gqmB8XO39ggVXUryPHPwoAY3O+KZwZNqKMPoVfIs4ZyRe
 if63NylMKlxuKLamFrXFN04J7r5gFv3jXlP1ZHXrAjm6rtvTJQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 2:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:

>
> +config VHOST_DPN
> +       bool "VHOST dependencies"
> +       depends on !ARM || AEABI
> +       default y
> +       help
> +         Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> +         This excludes the deprecated ARM ABI since that forces a 4 byte
> +         alignment on all structs - incompatible with virtio spec requirements.
> +

This should not be a user-visible option, so just make this 'def_bool
!ARM || AEABI'

      Arnd
