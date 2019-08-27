Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0719E759
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfH0MIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbfH0MIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 08:08:17 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF36217F5
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566907696;
        bh=ZXrh/71UPVJ3Yf3x2mVq5mE78nzCTmY0D/aUQjt98r0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T1gS1wWMho+CTgt8KUiCYbJ6pz/2jK4TTqHvVFEi9Hy8mVVHnQpMnoE9aRlKBfY0i
         +YJuHFvBiNl/SqEOdzZ1+s0pRqZMwQpMNQ1nAQyE2vNsl3SpyTQ3b44v64G/1KkJ1U
         1OlJzF6oUO0sOh6NvRHjfTXEZFYyHkhlQKLByf1M=
Received: by mail-qt1-f176.google.com with SMTP id k13so20935666qtm.12
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 05:08:16 -0700 (PDT)
X-Gm-Message-State: APjAAAU1Orug89Xxb/Hb4DdLbseSI4jJiELrrwCQ04Rn68hLp9nvzbdS
        Q0cMkWq4X5aGD6ON3MH7qFlgr5Z54dy93N46uww=
X-Google-Smtp-Source: APXvYqwk8g8kFkOg4s/Rtlig+3e+GeUm/9a3Cdu9YmKJJ5cX6CatAWhcmJNK4k3q13pet/xlZmc+shh6XcEWO1vztik=
X-Received: by 2002:ad4:434e:: with SMTP id q14mr18935634qvs.225.1566907695500;
 Tue, 27 Aug 2019 05:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <dd3220fb-7ed3-c5d1-d501-5e94f270a6b4@gmail.com>
In-Reply-To: <dd3220fb-7ed3-c5d1-d501-5e94f270a6b4@gmail.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 27 Aug 2019 08:08:04 -0400
X-Gmail-Original-Message-ID: <CA+5PVA54CyX1od+drTF+R0cp-Kf5L51CxHf473R-FJd1HZA2-g@mail.gmail.com>
Message-ID: <CA+5PVA54CyX1od+drTF+R0cp-Kf5L51CxHf473R-FJd1HZA2-g@mail.gmail.com>
Subject: Re: [PATCH] rtl_nic: add firmware rtl8125a-3
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Chun-Hao Lin <hau@realtek.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 6:23 PM Heiner Kallweit <hkallweit1@gmail.com> wrot=
e:
>
> This adds firmware rtl8125a-3 for Realtek's 2.5Gbps chip RTL8125.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> Firmware file was provided by Realtek and they asked me to submit it.

Can we get a Signed-off-by from someone at Realtek then?

josh

> The related extension to r8169 driver will be submitted in the next days.
> ---
>  WHENCE                |   3 +++
>  rtl_nic/rtl8125a-3.fw | Bin 0 -> 3456 bytes
>  2 files changed, 3 insertions(+)
>  create mode 100644 rtl_nic/rtl8125a-3.fw
>
> diff --git a/WHENCE b/WHENCE
> index fb12924..dbec18a 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2906,6 +2906,9 @@ Version: 0.0.2
>  File: rtl_nic/rtl8107e-2.fw
>  Version: 0.0.2
>
> +File: rtl_nic/rtl8125a-3.fw
> +Version: 0.0.1
> +
>  Licence:
>   * Copyright =C2=A9 2011-2013, Realtek Semiconductor Corporation
>   *
> diff --git a/rtl_nic/rtl8125a-3.fw b/rtl_nic/rtl8125a-3.fw
> new file mode 100644
> index 0000000000000000000000000000000000000000..fac635263f92e8d9734456b75=
932b2088edd5ef9
> GIT binary patch
> literal 3456
> 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
6
> DeEY6F
>
> literal 0
> HcmV?d00001
>
> --
> 2.23.0
>
