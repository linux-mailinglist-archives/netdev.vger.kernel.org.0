Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C70ED6080
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbfJNKqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:46:40 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33807 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731441AbfJNKqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 06:46:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id j8so2706869eds.1;
        Mon, 14 Oct 2019 03:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SLSvROGsgOrUEvNT81BjHG6mslyR1XuSE3aUVvnJ/5Q=;
        b=j849QrP2XfeeotlfzRkJWeOvRSueIN9CrbsKHiomuUpyreoDfReAZklyPkAPK1rZLV
         W58mh9mu0aas/jIM8FgnALyPAGukYRgbMX3r+c8/jUk50QP0kmHsFCAOzkxOSkV0XkDs
         1zBjCk1NUmtMS4olXHqUwm+odOYByEa+72HVtr21yPo1MVr8MTHXPBVOuTlF1RMRTIMa
         Ti/ek/JKF3J/fYVc3lGWLGKJIZadG8uWflM7fQiquvD+XjC2ClEiHW3hhz8tqFjvkWIA
         Id+dly3FnyybqdV1gjrPwsQlkkCsn6wtu3jMgv2G/7Xtbl9QQpgcB8XJdES/pSFoKzEo
         pMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SLSvROGsgOrUEvNT81BjHG6mslyR1XuSE3aUVvnJ/5Q=;
        b=AM0mZxoWQywZ7WCwWJxVVb66FXYYmjlFwAVv0rpxosweMeFE3EVeJCEyOquDil2Gp+
         zbq5QYZ/hsDHTIeTHzOgWI81QS00wIEoBA5hcj3lzkSUgOuwQRiu9fPgylFpkA/VHFOI
         rP1EyMpDTwxrkz8RRsBH6EjMtm7zPu5Y6TKLDHhQyp2cK/RCZRKLf6e6yOmD7GaQSau6
         RSnGHFNQKMDybLtEf0/6CJ6R71QFWPvAn3O6cdPbNC3AlwpLPNK5baUzeovLGwWCvdAK
         XB429zxvv5V4HW82UhjpRcrSrjFj9uwXRkkxlf/lbPOBUEQRQ63Gj66nzvs/zmwMEw1F
         MpUQ==
X-Gm-Message-State: APjAAAVu8cBYU+xTtmHvL0N9fbyfYG0Rv+f3IZmxEnQwQgPQ1sf7VEdO
        74FG8Pe2r4ZdT4pseaVYgm3+eeinDz6aC98SboQ=
X-Google-Smtp-Source: APXvYqxiQSx8EAdJ5BZuRodetUcHE9C3Ym1rIP7KlT1XS6absJoC+IJ/Bb/9oya679tjoHehHULVk/uPNJBVQLmrzMY=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr27338068edv.123.1571049996979;
 Mon, 14 Oct 2019 03:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191012123938.GA6865@nishad>
In-Reply-To: <20191012123938.GA6865@nishad>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 14 Oct 2019 13:46:26 +0300
Message-ID: <CA+h21hr=Wg7ydqcTLk85rrRGhx_LCxu2Ch3dWCt1-d1XtPaAcA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Use the correct style for SPDX License Identifier
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nishad,

On Sat, 12 Oct 2019 at 15:39, Nishad Kamdar <nishadkamdar@gmail.com> wrote:
>
> This patch corrects the SPDX License Identifier style
> in header files related to Distributed Switch Architecture
> drivers for NXP SJA1105 series Ethernet switch support.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
>
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
>
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> ---

Your commit message has nothing to do with what you're fixing, but
whatever. The SPDX identifiers _are_ using C-like comments.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/sja1105.h                | 4 ++--
>  drivers/net/dsa/sja1105/sja1105_dynamic_config.h | 4 ++--
>  drivers/net/dsa/sja1105/sja1105_ptp.h            | 4 ++--
>  drivers/net/dsa/sja1105/sja1105_static_config.h  | 4 ++--
>  drivers/net/dsa/sja1105/sja1105_tas.h            | 4 ++--
>  5 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
> index 8681ff9d1a76..fb7a6fff643f 100644
> --- a/drivers/net/dsa/sja1105/sja1105.h
> +++ b/drivers/net/dsa/sja1105/sja1105.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - * Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*  Copyright (c) 2018, Sensor-Technik Wiedemann GmbH
>   * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
>   */
>  #ifndef _SJA1105_H
> diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
> index 740dadf43f01..4f64adb2d26a 100644
> --- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
> +++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
>   */
>  #ifndef _SJA1105_DYNAMIC_CONFIG_H
>  #define _SJA1105_DYNAMIC_CONFIG_H
> diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
> index af456b0a4d27..c7e598fd1504 100644
> --- a/drivers/net/dsa/sja1105/sja1105_ptp.h
> +++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
>   */
>  #ifndef _SJA1105_PTP_H
>  #define _SJA1105_PTP_H
> diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
> index 7f87022a2d61..ee66fae6128b 100644
> --- a/drivers/net/dsa/sja1105/sja1105_static_config.h
> +++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: BSD-3-Clause
> - * Copyright (c) 2016-2018, NXP Semiconductors
> +/* SPDX-License-Identifier: BSD-3-Clause */
> +/*  Copyright (c) 2016-2018, NXP Semiconductors
>   * Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
>   */
>  #ifndef _SJA1105_STATIC_CONFIG_H
> diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
> index 0b803c30e640..c3ea7be52b9c 100644
> --- a/drivers/net/dsa/sja1105/sja1105_tas.h
> +++ b/drivers/net/dsa/sja1105/sja1105_tas.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - * Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*  Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
>   */
>  #ifndef _SJA1105_TAS_H
>  #define _SJA1105_TAS_H
> --
> 2.17.1
>
