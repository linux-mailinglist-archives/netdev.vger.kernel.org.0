Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE329486A
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 08:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394593AbgJUGgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 02:36:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56491 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732886AbgJUGgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 02:36:22 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201021063604euoutp023d753217ca42a5489564b4f7cb76358a~-7nHBVWfy2175621756euoutp02x
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 06:36:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201021063604euoutp023d753217ca42a5489564b4f7cb76358a~-7nHBVWfy2175621756euoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603262164;
        bh=ESAFEoSvJZv3zI6kdwpy5+Kf3FaMswyAoOzJ89FNF0c=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Wiy31xkqYu+kEfJWg/NQGWGP6WBpbTopPzosKjClUtFiBmtqf31Ro0CbCzELLzEVA
         kEmH3NNK3qWVgvdXZSlfUQQIQts3i4nNU63mtaT5wOi7jTaKX5/bxJa+GKOrOER4P3
         qbwxdASk5BunSwmjcTywLSkB6piCppiALR90eHbM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201021063556eucas1p22240959c43270ef52457c4d34c17c01f~-7m-San052167021670eucas1p2J;
        Wed, 21 Oct 2020 06:35:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 97.47.05997.CC6DF8F5; Wed, 21
        Oct 2020 07:35:56 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201021063555eucas1p24f8486354866fea4640a8f28e487d3c4~-7m_zTIUF2170121701eucas1p2J;
        Wed, 21 Oct 2020 06:35:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201021063555eusmtrp1866d482630cd1ddef9574a129274bc4b~-7m_yijaE0358403584eusmtrp1h;
        Wed, 21 Oct 2020 06:35:55 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-d5-5f8fd6cc173a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C4.00.06017.BC6DF8F5; Wed, 21
        Oct 2020 07:35:55 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201021063555eusmtip1000698fc810e12c390545db71534e0d7~-7m_IGsVT0811308113eusmtip1m;
        Wed, 21 Oct 2020 06:35:55 +0000 (GMT)
Subject: Re: arm64 build broken on linux next 20201021 -
 include/uapi/asm-generic/unistd.h:862:26: error: array index in initializer
 exceeds array bounds
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arch@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian@brauner.io>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <12dfa2bb-e567-fb42-d74f-5aaa0c5c43df@samsung.com>
Date:   Wed, 21 Oct 2020 08:35:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuL9O2BLDfCWN7+aJRER3sQW=C-ayo4Tb7QKdffjMYKDw@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7djP87pnrvXHG8yaJWLxd9IxdovPR46z
        Wbxf1sNo0fhO2aJj11cWi02Pr7FaXN41h83i4MI2Rout96axW9z6xG9xbIGYxda9V9ktWu6Y
        OvB6rJm3htHj969JjB5/535k9mi8cYPNY9OqTjaPO9f2sHlsXlLvcfvfY2aPz5vkAjijuGxS
        UnMyy1KL9O0SuDL+rzrHVvCJu2LmrwPMDYwdXF2MnBwSAiYSK3acYOti5OIQEljBKPH40Q0o
        5wujxNdFd6Gcz4wSHSsmssO0fPh/kBEisZxRYueGuVBV7xklpv1Yzw7iCAvMZZR4M/85WIuI
        wEsmiRUNkSA2s8B0RokF1zRBbDYBQ4mut11A3RwcvAJ2EkceWIGEWQRUJU79XMICYosKJElc
        ut8ENoZXQFDi5MwnYHFOgUCJXx/vsECMlJdo3jqbGcIWl7j1ZD4TyA0SAj/ZJV5uWMwKcbaL
        xLLZ39kgbGGJV8e3QL0jI3F6cg8LREMzo8TDc2vZIZweRonLTTMYIaqsJe6c+wV2KbOApsT6
        XfogpoSAo8S71eoQJp/EjbeCEDfwSUzaNp0ZIswr0dEmBDFDTWLW8XVwWw9euMQ8gVFpFpLP
        ZiH5ZhaSb2YhrF3AyLKKUTy1tDg3PbXYKC+1XK84Mbe4NC9dLzk/dxMjML2d/nf8yw7GXX+S
        DjEKcDAq8fBWMPXHC7EmlhVX5h5ilOBgVhLhdTp7Ok6INyWxsiq1KD++qDQntfgQozQHi5I4
        r/Gil7FCAumJJanZqakFqUUwWSYOTqkGRivVyyFpCz7v5/tqevT8lUXZDbreS8Ln1KruuftB
        c9rqTzViX9aL3rDzly5Y/itDNqrO5uKbnf/W/oi5ERLxSNlqrWpBjbLO1cidsm85a9zPL32t
        9tbo84k/8i6+k84tktP2DSny2+GeXl9f4dv+eNLSzTLTf2ns7i6zSV+jn5So8Xml9+P4d0os
        xRmJhlrMRcWJABblmihrAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t/xu7qnr/XHG/QeM7L4O+kYu8XnI8fZ
        LN4v62G0aHynbNGx6yuLxabH11gtLu+aw2ZxcGEbo8XWe9PYLW594rc4tkDMYuveq+wWLXdM
        HXg91sxbw+jx+9ckRo+/cz8yezTeuMHmsWlVJ5vHnWt72Dw2L6n3uP3vMbPH501yAZxRejZF
        +aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehn/V51jK/jE
        XTHz1wHmBsYOri5GTg4JAROJD/8PMnYxcnEICSxllJh85wErREJG4uS0BihbWOLPtS42iKK3
        jBInjlxmBXGEBeYySryZ/5wdxBEReMkk8envdRaQFmaB6YwSk3oDQWwhgQCJ91dXM4PYbAKG
        El1vQUZxcPAK2EkceWAFEmYRUJU49XMJWKuoQJLE/hM3wWxeAUGJkzOfgNmcAoESvz7egRpv
        JjFv80NmCFteonnrbChbXOLWk/lMExiFZiFpn4WkZRaSlllIWhYwsqxiFEktLc5Nzy020itO
        zC0uzUvXS87P3cQIjOhtx35u2cHY9S74EKMAB6MSD+8Flv54IdbEsuLK3EOMEhzMSiK8TmdP
        xwnxpiRWVqUW5ccXleakFh9iNAV6biKzlGhyPjDZ5JXEG5oamltYGpobmxubWSiJ83YIHIwR
        EkhPLEnNTk0tSC2C6WPi4JRqYCzNVl5zu3X+1ZYV31/xNCfWTFHgv85ydg1LW67e1hWFtfJl
        PxbY7o/juzetobduWYa7l/98C9NfL44Wftklknps0XxmocfHZmaJPz63Yallw4Lza6K6f9/S
        VhNuXL891f1Q233TdNkoV6l5s2Zl/LxZ0hFWe9R93jqz92+OlVknvVj7Z/J1YQ8lluKMREMt
        5qLiRAD8wt3P/gIAAA==
X-CMS-MailID: 20201021063555eucas1p24f8486354866fea4640a8f28e487d3c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021063555eucas1p24f8486354866fea4640a8f28e487d3c4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021063555eucas1p24f8486354866fea4640a8f28e487d3c4
References: <CA+G9fYuL9O2BLDfCWN7+aJRER3sQW=C-ayo4Tb7QKdffjMYKDw@mail.gmail.com>
        <CGME20201021063555eucas1p24f8486354866fea4640a8f28e487d3c4@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Naresh,

On 21.10.2020 07:05, Naresh Kamboju wrote:
> arm64 build broken while building linux next 20201021 tag.
>
> include/uapi/asm-generic/unistd.h:862:26: error: array index in
> initializer exceeds array bounds
> #define __NR_watch_mount 441
>                           ^
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Conflict resolution in commit 5394c6318b32f is incomplete.

This fixes the build:

diff --git a/arch/arm64/include/asm/unistd.h 
b/arch/arm64/include/asm/unistd.h
index b3b2019f8d16..86a9d7b3eabe 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
  #define __ARM_NR_compat_set_tls (__ARM_NR_COMPAT_BASE + 5)
  #define __ARM_NR_COMPAT_END            (__ARM_NR_COMPAT_BASE + 0x800)

-#define __NR_compat_syscalls           441
+#define __NR_compat_syscalls           442
  #endif

  #define __ARCH_WANT_SYS_CLONE
diff --git a/include/uapi/asm-generic/unistd.h 
b/include/uapi/asm-generic/unistd.h
index 094a685aa0f9..5df46517260e 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -863,7 +863,7 @@ __SYSCALL(__NR_process_madvise, sys_process_madvise)
  __SYSCALL(__NR_watch_mount, sys_watch_mount)

  #undef __NR_syscalls
-#define __NR_syscalls 441
+#define __NR_syscalls 442

  /*
   * 32 bit systems traditionally used different


Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

