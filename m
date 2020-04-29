Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB31BDF66
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgD2NqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:46:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34379 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgD2NqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:46:09 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200429134606euoutp01181d225b987644e5d23c56ede73e128c~KTlnqEAfA0217502175euoutp01g
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 13:46:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200429134606euoutp01181d225b987644e5d23c56ede73e128c~KTlnqEAfA0217502175euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588167966;
        bh=Iyco25skS+A3h6ng3DI6hlhHVx9kpvQeKmuPfKWu37g=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=ZkAWiLQhlRgOrcf2V4tPAY18tuujz7jKvS17wCcrzd84Oy/itLeoWMZx/B2tUYfWg
         cioi5BrT6MizQAxWBNX7yR/PmITZIkVj1QQUK+tPJK3jJ1j5eFgzzgxMkaA0zxlHvN
         yh3atvex4TZsjyTtUGVD6yRURQT9+v8h/81rlzZI=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200429134606eucas1p24180fbfd8776b6122330b148962defc2~KTlnL1UHq2629526295eucas1p2m;
        Wed, 29 Apr 2020 13:46:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 2F.E8.60698.E1589AE5; Wed, 29
        Apr 2020 14:46:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3~KTlmwvxog3187231872eucas1p2R;
        Wed, 29 Apr 2020 13:46:05 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200429134605eusmtrp1c165f577e5c9259ed853dbf82fccb3fa~KTlmv2G5v2400824008eusmtrp1a;
        Wed, 29 Apr 2020 13:46:05 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-f3-5ea9851e4daa
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BB.50.07950.D1589AE5; Wed, 29
        Apr 2020 14:46:05 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200429134604eusmtip23ead9bd52f9ed1b14da857e90b79928d~KTllgCQvv0786307863eusmtip2J;
        Wed, 29 Apr 2020 13:46:04 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] driver core: Revert default
 driver_deferred_probe_timeout value to 0
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <9e0501b5-c8c8-bc44-51e7-4bde2844b912@samsung.com>
Date:   Wed, 29 Apr 2020 15:46:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422203245.83244-2-john.stultz@linaro.org>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xbZRjH8547xOJZQXmEDWOZRImMEfzwJrKLiZITDZGh2QeToUVOuJem
        5SIaEaHDcQIIRQM0rNwUhHBJoKFAuEgxVGjpcERUhMQRhkLAC8iwVN12djbHlze///P8n/yf
        J3k5Ut3NhHAZujzRoNNmaxh/amjG64kKu9yVfPo3E4WXP/URuKq0nsCbNdMI/2ueYXHZ4uc0
        /uzGOoObrt21/G2dZvDG8jiBy9r7Gez2ReGFoWoaL5Rv0XhxtInBe1VfI9xwbYLAy7uP4pmW
        x7HbdZ3Gt8eGWTz1xzqNO+eGKbw/LsnPHnMehB5rDxJ8h2Yk2Lp+JIQRyyorDHRXMMLK0hgj
        lC91E4Jj+goSrLMXhMmrPaxg8x0wwi13LSXYvvuYEvYGwhID3vSPSxWzMwpEQ/TZt/3Tq9sk
        Vl8S/m6ltIFKUMkJCflxwD8Pk6ZmJCF/Ts1/iWBzsINVxF8IOg4/uS/2EOx/U088GLGZnYzS
        6ETQ6F28L35HcPWrUlJ2BfIp4PS6aJmD+Neg9mCGlk0kb2aht1NpMHwMSDsSI7OKPwvbB9Z7
        ERT/NPTPfUtJiOMe4y9B/dIbiuUYzDauUzL78XGwIrUimUn+SbDvNJEKB8PyejMhZwH/Kwcu
        60eUsvZLMGpqoBUOhC2njVX4OLjqKilloAzBDU8vq4hKBIulDUhxvQArnkNG3ojkn4X+0Wil
        /CIMLuwiuQx8APywc0xZIgDMQ/WkUlbBlXK14o4Ai7Pv/9iphetkDdJYjpxmOXKO5cg5loe5
        LYjqRsFivjEnTTTG6sTCU0ZtjjFfl3bqndycAXT3B7v+c+4Po4l/UhyI55DmEVVNWleymtYW
        GItyHAg4UhOkWkvvSFarUrVF74mG3LcM+dmi0YFCOUoTrIpt27yk5tO0eWKWKOpFw4MuwfmF
        lCB9e7rXux15IvPcrCdhPmv1dPTFILve3t5X59N3JVarbjlOnmkufuqXCyOJWWdKX+n1uf8M
        DZx/vSq0yL1y2G5X6RI8P1dkDrblPfPch++vfhHSsZYdQ0/sR6zZ538qMhlujsbmLr36sml3
        4/vwD4rz4pm41puBSQOFT+iT4ssbg3MLNJQxXRsTSRqM2jt3ZGKZvQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t/xe7qyrSvjDO51q1ncmvKbyaK3aTqT
        xcsJhxkt/k46xm7RfHkJq8XUh0/YLOacb2Gx+DHvMJvFs1t7mSyaF69nszjzW9fiwrY+VosL
        ba9YLS7vmsNm8bn3CKPFjPP7mCxufeK3OLZAzOLM6UusFv/37GC3OPjhCavF8lM7WCy+7u0C
        EZ/ZHCQ81sxbw+jx+9ckRo8tK28yeeycdZfdY9OqTjaPO9f2sHm0XVvF5HHocAejx7yTgR77
        565h99jy+zubx7czE1k8tlxtZ/H4vEkugC9Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
        0Ng81srIVEnfziYlNSezLLVI3y5BL6NvURd7QYNyRU/XM8YGxgbZLkZODgkBE4ktk46zdTFy
        cQgJLGWUmHjgOjtEQkbi5LQGVghbWOLPtS6ooreMErf/r2UESQgLJEkc/3kaqIiDQ0TAV2Lz
        TyeQGmaBGewSs/+8YAOpERLIlWj6OY0FxGYTMJToetsFFucVsJN4830eE4jNIqAqsf7URRaQ
        OaICsRItFzUhSgQlTs58AtbKKWAjcadrIdhaZgEziXmbHzJD2PIS29/OgbLFJW49mc80gVFo
        FpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAdLPt2M8tOxi73gUf
        YhTgYFTi4Z2QvjJOiDWxrLgy9xCjBAezkgjvo4xlcUK8KYmVValF+fFFpTmpxYcYTYF+m8gs
        JZqcD0yFeSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGGu4Nv4/
        e7N6vcTiiD2c8XvKPFy+5ybfnNfaoq1yfyn7U5nf7SkrjxzhLVqm9KVPSUWA+8PBT5ns+VIM
        jxVbVfdNXTM/6ZiQQIPo5fuxrzZMOKBboxXVmVGQ3WWs5FNh3WDLd27qm36nqGPrSw6mi+6t
        03ZaYlarNGHuSa9mCes1fC3SK4KfKrEUZyQaajEXFScCAGmkurZNAwAA
X-CMS-MailID: 20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3
References: <20200422203245.83244-1-john.stultz@linaro.org>
        <20200422203245.83244-2-john.stultz@linaro.org>
        <CGME20200429134605eucas1p2bd601082e7a6b8c8fdbe79c83972e2e3@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On 22.04.2020 22:32, John Stultz wrote:
> This patch addresses a regression in 5.7-rc1+
>
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we both cleaned up
> the logic and also set the default driver_deferred_probe_timeout
> value to 30 seconds to allow for drivers that are missing
> dependencies to have some time so that the dependency may be
> loaded from userland after initcalls_done is set.
>
> However, Yoshihiro Shimoda reported that on his device that
> expects to have unmet dependencies (due to "optional links" in
> its devicetree), was failing to mount the NFS root.
>
> In digging further, it seemed the problem was that while the
> device properly probes after waiting 30 seconds for any missing
> modules to load, the ip_auto_config() had already failed,
> resulting in NFS to fail. This was due to ip_auto_config()
> calling wait_for_device_probe() which doesn't wait for the
> driver_deferred_probe_timeout to fire.
>
> Fixing that issue is possible, but could also introduce 30
> second delays in bootups for users who don't have any
> missing dependencies, which is not ideal.
>
> So I think the best solution to avoid any regressions is to
> revert back to a default timeout value of zero, and allow
> systems that need to utilize the timeout in order for userland
> to load any modules that supply misisng dependencies in the dts
> to specify the timeout length via the exiting documented boot
> argument.
>
> Thanks to Geert for chasing down that ip_auto_config was why NFS
> was failing in this case!
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Please also revert dca0b44957e5 "regulator: Use 
driver_deferred_probe_timeout for regulator_init_complete_work" then, 
because now with the default 0 timeout some regulators gets disabled 
during boot, before their supplies gets instantiated.

This patch broke booting of Samsung Exynos5800-based Peach-Pi Chromeboot 
with the default multi_v7_defconfig.

> ---
>   drivers/base/dd.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 06ec0e851fa1..908ae4d7805e 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -224,16 +224,7 @@ static int deferred_devs_show(struct seq_file *s, void *data)
>   }
>   DEFINE_SHOW_ATTRIBUTE(deferred_devs);
>   
> -#ifdef CONFIG_MODULES
> -/*
> - * In the case of modules, set the default probe timeout to
> - * 30 seconds to give userland some time to load needed modules
> - */
> -int driver_deferred_probe_timeout = 30;
> -#else
> -/* In the case of !modules, no probe timeout needed */
> -int driver_deferred_probe_timeout = -1;
> -#endif
> +int driver_deferred_probe_timeout;
>   EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
>   
>   static int __init deferred_probe_timeout_setup(char *str)
> @@ -266,7 +257,7 @@ int driver_deferred_probe_check_state(struct device *dev)
>   		return -ENODEV;
>   	}
>   
> -	if (!driver_deferred_probe_timeout) {
> +	if (!driver_deferred_probe_timeout && initcalls_done) {
>   		dev_WARN(dev, "deferred probe timeout, ignoring dependency");
>   		return -ETIMEDOUT;
>   	}

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

