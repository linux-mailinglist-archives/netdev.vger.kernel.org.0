Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C5B7324
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 08:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387984AbfISGZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 02:25:35 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40371 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfISGZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 02:25:35 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so2091229edm.7;
        Wed, 18 Sep 2019 23:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S/WyB4Tpel1GrWYeNWYAfgXloXn7pKmm9y9Bb7H6LV4=;
        b=cRfye87FPU+e4SZKUDwKUGB/xc5Y0V42ErhTBXH1lfLFad5X81iwkAEAcJiUbQkWE4
         kOHgcA7DnUXzcrN92MQbAaSolCYJs8t94d1eWTs8V2fE1l/NMzhcMN7wh76fpcSiAU+8
         n2tckXxWP7oRquemvr/mcw6jhW4toMfcDZfQfoaE8qSgIPZW2XpEajSSWRxMq8JX7BGB
         n8sxbzfm0d/9VLnL93eQ/8fXHDiqRI2lk/jolv1xOA+IZ5lkXNRzDbAKOOjd6Yl5PpJY
         nioxvTL8APpiRYqDme/VXgxB1khOKNJk4W3BNvw9pfZ5zzFF4lak1icNaOKOMvOdgZx0
         Md3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S/WyB4Tpel1GrWYeNWYAfgXloXn7pKmm9y9Bb7H6LV4=;
        b=rAox6GABW1JLT5IM9RUuq5sk5hBTTUEFSvit6X9Io02ZngpfL5sttmO57RdRUgeu2r
         p0SrRX2reHa5Kd3LKhKA4zTciCJ0uqcchG7pPQrUb4swdfuDN000LJqkO2hOTsuTOw3N
         PVdTn0UUeHuy2w59FuVXvvmqy9yeKl9l5vKAA+HfpfgCoPLa0yB6x4JV68Aw69gkVFCP
         cLC+V/Hhfs+Ufkyb3LvL5I25GZIsBsrexxfw3xE23WSKsQ2T08PkdOoZl8UyRzgIA+Fg
         Kz4cbxkOVDyGYA69ybjEIU12GlH68VN2m0Ho+tFROfBOYKEzJt3ge6b5lxBQR+Zy4AVx
         8v3A==
X-Gm-Message-State: APjAAAXRXvcDjaQvn8iB/QsZRHFzt+qXC1YWbl8VfSA73rErevuAoqm9
        0zTJcGBHgxIaa2kaU2BJJaG2z4zOGcMY8z3ZB3rI9g==
X-Google-Smtp-Source: APXvYqx88dInn36xM937T9Viz2kB510FhkQcsRnIG1Q+fdbQflufzSanL39M0wFu8j8RG1EUvn89yzUcVWST1l1bVhk=
X-Received: by 2002:a50:d552:: with SMTP id f18mr14653706edj.36.1568874333270;
 Wed, 18 Sep 2019 23:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190919063819.164826-1-maowenan@huawei.com>
In-Reply-To: <20190919063819.164826-1-maowenan@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 09:25:21 +0300
Message-ID: <CA+h21hqjrt2qcCAFosOC61QcsiHS1TYaR6u=SjMMFH8W+ZZYug@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Add dependency for NET_DSA_SJA1105_TAS
To:     Mao Wenan <maowenan@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 at 09:22, Mao Wenan <maowenan@huawei.com> wrote:
>
> If CONFIG_NET_DSA_SJA1105_TAS=y and CONFIG_NET_SCH_TAPRIO=n,
> below error can be found:
> drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_setup_tc_taprio':
> sja1105_tas.c:(.text+0x318): undefined reference to `taprio_offload_free'
> sja1105_tas.c:(.text+0x590): undefined reference to `taprio_offload_get'
> drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_tas_teardown':
> sja1105_tas.c:(.text+0x610): undefined reference to `taprio_offload_free'
> make: *** [vmlinux] Error 1
>
> sja1105_tas needs tc-taprio, so this patch add the dependency for it.
>
> Fixes: 317ab5b86c8e ("net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/sja1105/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
> index 55424f3..f40b248 100644
> --- a/drivers/net/dsa/sja1105/Kconfig
> +++ b/drivers/net/dsa/sja1105/Kconfig
> @@ -27,6 +27,7 @@ config NET_DSA_SJA1105_PTP
>  config NET_DSA_SJA1105_TAS
>         bool "Support for the Time-Aware Scheduler on NXP SJA1105"
>         depends on NET_DSA_SJA1105
> +       depends on NET_SCH_TAPRIO
>         help
>           This enables support for the TTEthernet-based egress scheduling
>           engine in the SJA1105 DSA driver, which is controlled using a
> --
> 2.7.4
>

Thanks!
-Vladimir
