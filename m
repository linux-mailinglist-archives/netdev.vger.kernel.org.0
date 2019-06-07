Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9625395E2
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfFGTiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:38:23 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45126 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbfFGTiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:38:23 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so2672837edv.12;
        Fri, 07 Jun 2019 12:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zaTwR61OvFbwg4aUVtbQv05SUHVgNDxvbWkcGwjcChk=;
        b=iwCzrrnF9dOrUNSpiNLz+zbd62iB967NcOq0S8G1ZKt8FlP3QKo+hQo/qNieQh3lXZ
         Bn+n6ts/4mluCe5KTVccUZvFPphSgTHJgbiJII+9cD20+yplxS47yUTQLb1jXCI3M6uS
         lN/9HEnpvYKfTaBmRTJ3PZI3Rc1JzrGvCbn5I6DiY2NjrpuoAQIqagyxxbtOtsGpBU3G
         tDEYhGRKR/e4xPfmFyREvHONON2RN4FWqp6kFis1Znd2/XYbEP1Fm8V5aBg1jbFkXTbc
         ax9h82u2IcwfQ4FJMZfv5SQVfOxcljCAt5au8umXq0iUIPNmfcNkiBeD3gfM/LTK9nv4
         Lq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zaTwR61OvFbwg4aUVtbQv05SUHVgNDxvbWkcGwjcChk=;
        b=cc2pDhHDX8ysBx3xVUm/YO5821b1Su9K9k890xRBO8EstzMGvPOVkPtLnuT+1PEqtZ
         PZRK9g8qiu0nAilXSc7XqyGbmmLJawdT29Z+05VpxJkmgnxfszDdzgmz78ivRD4ZZrR8
         v2bJq8W83epTUMg1Kq5u3fwTlILwZhTmoQDf3XH673C9OouSV8jKTtPlZXZ5fHRARD6m
         pgCYxHynZWhclMpFnjIZnmy4s2w/P/SmUd4KNae1+q5tW8Aud3W8QVhEHozyfbNKkvWP
         VmVQIgjNBfaImo6zY51fOEhu9tvZmM7cZYYoeO9j79I3QUt0yh2mrAaKoR+EJkVclRil
         MEfg==
X-Gm-Message-State: APjAAAXA9x8jPh3LuWQDuRuefsVIt3EAD5P82JLVa5vvPNtIsL6xjYRU
        XzSfGgSL+XLxmqjfuDrFVADov2BlIPNtIkaurRE=
X-Google-Smtp-Source: APXvYqx+KVVO17c7aZO9447Pi7PBlltD3Jf63c8dfUVuA4gihVOsP/HGJQFrjbxqAH54FXPn83IUpviRzztY6lF2xdI=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr51300775eds.36.1559936301614;
 Fri, 07 Jun 2019 12:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <20190605.114429.1672040440449676386.davem@davemloft.net> <20190607.121538.2106706546161674940.davem@davemloft.net>
In-Reply-To: <20190607.121538.2106706546161674940.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 7 Jun 2019 22:38:10 +0300
Message-ID: <CA+h21hqGWhpkHx_yG3PJbQPxv7iKuLMrD3H7GhjfzRr+TZ-wrQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 at 22:15, David Miller <davem@davemloft.net> wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Wed, 05 Jun 2019 11:44:29 -0700 (PDT)
>
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Wed, 5 Jun 2019 12:13:59 +0300
> >
> >> It is conflicting because net-next at the moment lacks this patch that
> >> I submitted to net:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=e8d67fa5696e2fcaf956dae36d11e6eff5246101
> >> What would you like me to do: resubmit after you merge net into
> >> net-next, add the above patch to this series (which you'll have to
> >> skip upon the next merge), or you can just cherry-pick it and then the
> >> series will apply?
> >
> > So let me bring this series back to state "Under Review" and I'll apply it
> > after I next merge net into net-next.
>
> So I applied the series but it doesn't even build:
>
> ERROR: "sja1105_unpack" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
> ERROR: "sja1105_spi_send_packed_buf" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
> ERROR: "sja1105_pack" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
> ERROR: "sja1105_spi_send_int" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
> ERROR: "sja1105_get_ts_info" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105pqrs_ptp_cmd" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105_ptp_clock_unregister" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105_ptpegr_ts_poll" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105et_ptp_cmd" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105_ptp_reset" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105_tstamp_reconstruct" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
> ERROR: "sja1105_ptp_clock_register" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
>
> You have to test better with the various modular/non-modular combinations.
>
> Thanks.

Ok, my bad, I'll resubmit it tomorrow.

Thanks!
-Vladimir
