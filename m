Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296C94FDCD
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFWTMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 15:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfFWTMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 15:12:52 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E215B215EA;
        Sun, 23 Jun 2019 19:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561317171;
        bh=AsxupFvBvqb1mH3XUIHGLPhSXMlhWmiYztuijWSq/GQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uJbKaQIyzSWaWU00fx8r+BgyZH9qH3M1R9/GjS5amJxhq2/wMRfKlESl/AGt7ycXB
         ha0lnIyzb/RrBbLBKIida0P9PPS0bf0gRIpgT8FKt2U21oHebm129KzlVwMeLB3caD
         MszeI+AS46K1WmuMqEvYmziFe5DO20u0Zy+g9YF0=
Received: by mail-lj1-f181.google.com with SMTP id 205so1667253ljj.8;
        Sun, 23 Jun 2019 12:12:50 -0700 (PDT)
X-Gm-Message-State: APjAAAVyih0uk2fF1U3ZGyOS4oqfIBKd5qK5QkrdweGrbLxmIV0Tl+Uj
        faEJqYQYpRG+Xa1RhqE1inUDwF+9U5igdawMqbA=
X-Google-Smtp-Source: APXvYqzc0BAAUk0GcaZ6RKalll+UsB43Pr/w/hhGJmdfj5xhmoT71i8jk/2UViGqeh/ujennhK/FVzPhSD/yw16ZWlw=
X-Received: by 2002:a2e:8155:: with SMTP id t21mr26819194ljg.80.1561317169025;
 Sun, 23 Jun 2019 12:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190623151313.970-1-tranmanphong@gmail.com> <20190623151313.970-5-tranmanphong@gmail.com>
In-Reply-To: <20190623151313.970-5-tranmanphong@gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Sun, 23 Jun 2019 21:12:37 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfCrgS_iJAK0cxm0-XyGt6P2vq1FH4v2_8LSbfUp8gwUw@mail.gmail.com>
Message-ID: <CAJKOXPfCrgS_iJAK0cxm0-XyGt6P2vq1FH4v2_8LSbfUp8gwUw@mail.gmail.com>
Subject: Re: [PATCH 04/15] ARM: exynos: cleanup cppcheck shifting error
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, peterz@infradead.org,
        nsekhar@ti.com, ast@kernel.org, jolsa@redhat.com,
        netdev@vger.kernel.org, gerg@uclinux.org,
        lorenzo.pieralisi@arm.com, will@kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, daniel@iogearbox.net,
        festevam@gmail.com, gregory.clement@bootlin.com,
        allison@lohutok.net, linux@armlinux.org.uk,
        haojian.zhuang@gmail.com, bgolaszewski@baylibre.com,
        tony@atomide.com, mingo@redhat.com, linux-imx@nxp.com, yhs@fb.com,
        sebastian.hesselbarth@gmail.com, illusionist.neo@gmail.com,
        jason@lakedaemon.net, liviu.dudau@arm.com, s.hauer@pengutronix.de,
        acme@kernel.org, lkundrak@v3.sk, robert.jarzmik@free.fr,
        dmg@turingmachine.org, swinslow@gmail.com, namhyung@kernel.org,
        tglx@linutronix.de, linux-omap@vger.kernel.org,
        alexander.sverdlin@gmail.com, linux-arm-kernel@lists.infradead.org,
        info@metux.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, alexander.shishkin@linux.intel.com,
        hsweeten@visionengravers.com, kgene@kernel.org,
        kernel@pengutronix.de, sudeep.holla@arm.com, bpf@vger.kernel.org,
        shawnguo@kernel.org, kafai@fb.com, daniel@zonque.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jun 2019 at 17:14, Phong Tran <tranmanphong@gmail.com> wrote:
>
> [arch/arm/mach-exynos/suspend.c:288]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
>
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/mach-exynos/suspend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Let's switch to BIT macro. It will solve the problem and is preferred
way of coding.

Best regards,
Krzysztof
