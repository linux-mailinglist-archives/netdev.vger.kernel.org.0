Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BDB2B69
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfINNk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 09:40:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41588 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfINNk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 09:40:57 -0400
Received: by mail-ed1-f67.google.com with SMTP id z9so29323007edq.8
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Igjju/uWT+HHXrT4J23uMqu0yVRntSJQwG0KaHLfmfM=;
        b=bjh8kfHnhYbfX/XMoR4kkOF7WZdIcRNIlo7EOgU9/TgtoCrR3oFLmcjjSCrahHIZ5A
         xPGyQct0yTqg6BajgIwd9sXfQXmimviacdHABFCNsyx3zgnuLp1IEDCEB2vzNLd8Nfyi
         7JJhlLbj7WxAWaQBwFdi6ngOH86YCu6HtPKosoNMN6aw0B0tdEhDH4JEXQCtLwDR0RhT
         9YqbyKwS+qjG0WKgvcZ9e9GNOkq90tKLMp7OsSZmkIzNdGpdJC5QQzItTtO6PocGYHBo
         86jDr9Na3Sv4mQMgNvtrlmloOJPAX2XDK83A03zfRuDMx1yqVUqyG9fYDIvzeoTKehIi
         5I4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Igjju/uWT+HHXrT4J23uMqu0yVRntSJQwG0KaHLfmfM=;
        b=c36P04/QtX/mVaua526Q0md0fidjNZQ/vJFIgkZlgWavTZMNrZa/9XvygZH5Z1lpdc
         j/DGvqmX5tcAoI41uQEj9AaAH2m8558+ZIAKdP3qxyEPgJy7tPmADRl1pGehf0sOlbja
         xg4oQxt42rovap8FeBgzr0CdFgHMG5ro/6j1AcXgfAlIv4KNM5uBcMrdTK9Edq3Lv49W
         shWMqOjtk2UNvAOaJFN1HyIEnibeS8kz/tkHPipggJE2Lp3rNL5RszJEEgQok6aPOxDa
         4v3hInado/wqbFQEDBTuZ6yA0ftex31bOficDNx+pvwV5r3o9cKUlXMuiSx4IkRmb44G
         +gCQ==
X-Gm-Message-State: APjAAAWkFRD2uBErFlSwvBIvfDq0Y2aoGoYJxxY8rJ/T3ZOexs1RTu1Q
        gt/cny2WGcRUPu3HZ5tW6iGbUjyfzIRCWOB4J6E=
X-Google-Smtp-Source: APXvYqzOEi031+cbMOOfJ8zEtGhJcFbS6C78dknN5lhW010snKZNZbCQkQqPGNELGnj8Apt+SZuVE1A9JAB5c6iR65E=
X-Received: by 2002:a17:906:4f0e:: with SMTP id t14mr42827614eju.47.1568468453383;
 Sat, 14 Sep 2019 06:40:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:2417:0:0:0:0 with HTTP; Sat, 14 Sep 2019 06:40:52
 -0700 (PDT)
In-Reply-To: <201909141759.R0atrZ2e%lkp@intel.com>
References: <20190914011802.1602-7-olteanv@gmail.com> <201909141759.R0atrZ2e%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 14 Sep 2019 14:40:52 +0100
Message-ID: <CA+h21hrTv7B5_gbBhKP=iY1utaSqPYf0d3Qj2hjKtoOtfxRygA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 6/7] net: dsa: sja1105: Configure the
 Time-Aware Scheduler via tc-taprio offload
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2019, kbuild test robot <lkp@intel.com> wrote:
> Hi Vladimir,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:
> https://github.com/0day-ci/linux/commits/Vladimir-Oltean/tc-taprio-offload-for-SJA1105-DSA/20190914-154650
> config: i386-randconfig-b001-201936 (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from drivers/net/dsa/sja1105/sja1105.h:23:0,
>                     from drivers/net/dsa/sja1105/sja1105_spi.c:8:
>>> drivers/net/dsa/sja1105/sja1105_tas.h:38:45: warning: 'struct
>>> sja1105_private' declared inside parameter list will not be visible
>>> outside of this definition or declaration

Oops, I didn't realize I need the "struct sja1105_private;"
forward-declaration even if CONFIG_NET_DSA_SJA1105_TAS is not defined.
Never mind, I'll just make all prototypes take "struct dsa_switch *ds"
so the forward-declaration won't be needed at all. I'll send out a v3
soon.

>     static inline void sja1105_tas_setup(struct sja1105_private *priv) { }
>                                                 ^~~~~~~~~~~~~~~
>    drivers/net/dsa/sja1105/sja1105_tas.h:40:48: warning: 'struct
> sja1105_private' declared inside parameter list will not be visible outside
> of this definition or declaration
>     static inline void sja1105_tas_teardown(struct sja1105_private *priv) {
> }
>                                                    ^~~~~~~~~~~~~~~
> --
>    In file included from drivers/net/dsa/sja1105/sja1105.h:23:0,
>                     from drivers/net/dsa/sja1105/sja1105_main.c:24:
>>> drivers/net/dsa/sja1105/sja1105_tas.h:38:45: warning: 'struct
>>> sja1105_private' declared inside parameter list will not be visible
>>> outside of this definition or declaration
>     static inline void sja1105_tas_setup(struct sja1105_private *priv) { }
>                                                 ^~~~~~~~~~~~~~~
>    drivers/net/dsa/sja1105/sja1105_tas.h:40:48: warning: 'struct
> sja1105_private' declared inside parameter list will not be visible outside
> of this definition or declaration
>     static inline void sja1105_tas_teardown(struct sja1105_private *priv) {
> }
>                                                    ^~~~~~~~~~~~~~~
>    drivers/net/dsa/sja1105/sja1105_main.c: In function 'sja1105_teardown':
>>> drivers/net/dsa/sja1105/sja1105_main.c:1731:23: error: passing argument 1
>>> of 'sja1105_tas_teardown' from incompatible pointer type
>>> [-Werror=incompatible-pointer-types]
>      sja1105_tas_teardown(priv);
>                           ^~~~
>    In file included from drivers/net/dsa/sja1105/sja1105.h:23:0,
>                     from drivers/net/dsa/sja1105/sja1105_main.c:24:
>    drivers/net/dsa/sja1105/sja1105_tas.h:40:20: note: expected 'struct
> sja1105_private *' but argument is of type 'struct sja1105_private *'
>     static inline void sja1105_tas_teardown(struct sja1105_private *priv) {
> }
>                        ^~~~~~~~~~~~~~~~~~~~
>    drivers/net/dsa/sja1105/sja1105_main.c: In function 'sja1105_probe':
>>> drivers/net/dsa/sja1105/sja1105_main.c:2215:20: error: passing argument 1
>>> of 'sja1105_tas_setup' from incompatible pointer type
>>> [-Werror=incompatible-pointer-types]
>      sja1105_tas_setup(priv);
>                        ^~~~
>    In file included from drivers/net/dsa/sja1105/sja1105.h:23:0,
>                     from drivers/net/dsa/sja1105/sja1105_main.c:24:
>    drivers/net/dsa/sja1105/sja1105_tas.h:38:20: note: expected 'struct
> sja1105_private *' but argument is of type 'struct sja1105_private *'
>     static inline void sja1105_tas_setup(struct sja1105_private *priv) { }
>                        ^~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
> vim +/sja1105_tas_teardown +1731 drivers/net/dsa/sja1105/sja1105_main.c
>
>   1726	
>   1727	static void sja1105_teardown(struct dsa_switch *ds)
>   1728	{
>   1729		struct sja1105_private *priv = ds->priv;
>   1730	
>> 1731		sja1105_tas_teardown(priv);
>   1732		cancel_work_sync(&priv->tagger_data.rxtstamp_work);
>   1733		skb_queue_purge(&priv->tagger_data.skb_rxtstamp_queue);
>   1734		sja1105_ptp_clock_unregister(priv);
>   1735		sja1105_static_config_free(&priv->static_config);
>   1736	}
>   1737	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation
>

Thanks,
-Vladimir
