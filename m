Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D281F78
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfHEOu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:50:27 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43311 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbfHEOu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:50:27 -0400
Received: by mail-lf1-f68.google.com with SMTP id c19so58216409lfm.10;
        Mon, 05 Aug 2019 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F862krckXOX344fCimCqRO8x8WuPKfh9vUzQq4I4yF4=;
        b=MyQVXRRksG0El5/VFPisuOZ/4de/ARUzE1OhaPAnPYDtkZlChwkEMTR5rE+nVqvdtR
         TVk0tmsIiVO9x9CIBS6knv37UoPJ7dN3aqLeWdetN87vKNO1Pzi2ZjNVJQcozOS11Vop
         QANFoIxfvDg8TRjr5HAeUu8xW7rCVsNIyOBYPLXp2BgiYA/mCRhF+ecOj/9Efyzdhnyg
         pVEcwiOCja7qL8AU1QH7VGyJmPSp7c8X8iWORkA69fyljoLbXWB0ApLWxTYfkE7WDazQ
         gsdnbD3NNRleCzhhwzkJVPcIpUy3gPuAQm41xzoPf2rEFcInXX3VLNxLKvz4QnUUZGT9
         FVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F862krckXOX344fCimCqRO8x8WuPKfh9vUzQq4I4yF4=;
        b=szaB18GKLHbHUV4OGygMuyuYAo2idRE/yF5ayt1VY2rMTLeoKJvAVgNFZX5KcIWHLG
         xewOGxaiDlnykGjRkcXalEJbuNJUNQAYOoeunI1np1sLecy8pJanXcGZTPtyvh7fGd6h
         d2ptyjO7Rhqb7ZThysuDikvSYi6Lb9DHumsDdGDCk0+eUPg+RTy2XNJtqEq/U+fHxO3d
         z3yWSeIgJh+ajFe0eLZvKcxHeLQh4nsEPOjS9fF3Pa8/813xI9YeLUdG2PTC/3y/C6IL
         l6uGykx05w4lcxW1u48SYP3FXOP9D8W8ibPofu3rQ1RK9SevoKItufmGMinj9++YjPcW
         2NvQ==
X-Gm-Message-State: APjAAAUxAxaUAq51lsm5mmZpMtV6lZsSneqDEq/2Uju0+ZqYljMdlVPq
        KoXd3UVB0tvd5TSOUyVlorIoiWqmYfEoKOPQ2fE=
X-Google-Smtp-Source: APXvYqxF5vYMfF3gM9OzkbRzmI2xcdjsC7DvfhpBD/fUlQ52XHpAr5n6UjjOejUTKa+U7w4mEdF3YuMYpZZy9jWUnKI=
X-Received: by 2002:ac2:59dd:: with SMTP id x29mr3721990lfn.140.1565016624236;
 Mon, 05 Aug 2019 07:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190802163248.11152-1-h.feurstein@gmail.com> <CA+h21hr835sdvtgVOA2M9SWeCXDOrDG1S3FnNgJd_9NP2X_TaQ@mail.gmail.com>
In-Reply-To: <CA+h21hr835sdvtgVOA2M9SWeCXDOrDG1S3FnNgJd_9NP2X_TaQ@mail.gmail.com>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Mon, 5 Aug 2019 16:50:12 +0200
Message-ID: <CAFfN3gVTVwsqvLEYEczDsxdXQ6Ru2gWpECA2P+thh5buGmNHSw@mail.gmail.com>
Subject: Re: [RFC] net: dsa: mv88e6xxx: ptp: improve phc2sys precision for
 mv88e6xxx switch in combination with imx6-fec
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     mlichvar@redhat.com, Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am Mo., 5. Aug. 2019 um 11:55 Uhr schrieb Vladimir Oltean <olteanv@gmail.com>:
[...]
> You guessed correctly (since you copied me) that I'm battling much of
> the same issues with the sja1105 and its spi-fsl-dspi controller
> driver.
I've copied you, because of this discussion on github:
https://github.com/openil/linuxptp/issues/5
There you said: "In fact any MDIO access will make the latency
unpredictable and hence
 throw off the time."
I thought you might be interested in how to make MDIO latency predictable.

[...]
> - You said you patched linuxptp master. Could you share the patch? Is
> there anything else that's needed except compiling against the board's
> real kernel headers (aka point KBUILD_OUTPUT to the extracted location
> of /sys/kernel/kheaders.tar.xz)? I've done that and I do see phc2sys
> probing and using the new ioctl, but I don't see a big improvement in
> my case (that's probably because my SPI interface has real jitter
> caused by peripheral clock instability, but I really need to put a
> scope on it to be sure, so that's a discussion for another time).

My compiler used kernel headers where the ioctl was not yet defined.
So I simply defined it in the linuxptp source directly:

diff --git a/sysoff.c b/sysoff.c
index b993ee9..b23ad2f 100644
--- a/sysoff.c
+++ b/sysoff.c
@@ -27,6 +27,20 @@

#define NS_PER_SEC 1000000000LL

+#ifndef PTP_SYS_OFFSET_EXTENDED
+struct ptp_sys_offset_extended {
+    unsigned int n_samples; /* Desired number of measurements. */
+    unsigned int rsv[3];    /* Reserved for future use. */
+    /*
+     * Array of [system, phc, system] time stamps. The kernel will provide
+     * 3*n_samples time stamps.
+     */
+    struct ptp_clock_time ts[PTP_MAX_SAMPLES][3];
+};
+#define PTP_SYS_OFFSET_EXTENDED \
+    _IOWR(PTP_CLK_MAGIC, 9, struct ptp_sys_offset_extended)
+#endif
+
#ifdef PTP_SYS_OFFSET

static int64_t pctns(struct ptp_clock_time *t)

> - I really wonder what your jitter is caused by. Maybe it is just
> contention on the mii_bus->mdio_lock? If that's the case, maybe you
> don't need to go all the way down to the driver level, and taking the
> ptp_sts at the subsystem (MDIO, SPI, I2C, etc) level is "good enough".

I would say there are many places, where we introduce unpredictable jitter:
- The busy-flag polling
- The locking of the chip- and mdio-bus-mutex
- The mdio_done completion in the imx_fec
- Scheduling latencies

> - Along the lines of the above, I wonder how badly would the
> maintainers shout at the proposal of adding a struct
> ptp_system_timestamp pointer and its associated lock in struct device.
> That way at least you don't have to change the API, like you did with
> mdiobus_write_nested_ptp. Relatively speaking, this is the least
> amount of intrusion (although, again, far from beautiful).

It is important to make sure to hook up the right mdio_write access, that is
why the ptp_sts pointer is passed under the mdio_lock. Of course It would
be nicer, to pass through the pointer as an argument, instead of bypassing it to
the mii_bus struct. In the case of SPI it could be added to the spi_transfer
struct.

> - The software timestamps help you in the particular case of phc2sys,
> but are they enough to cover all your needs?
For now it's all I need.

> I haven't spent even 1
> second looking at Marvell switch datasheets, but is its free-running
> timer only used for PTP timestamping? At least the sja1105 does also
> support time-based egress scheduling and ingress policing, so for that
> scenario, the timecounter/cyclecounter implementation will no longer
> cut it (you do need to synchronize the hardware clock). If your
> hardware supports these PTP-based features as well, I can only assume
> the reason why mv88e6xxx went for a timecounter is the same as the
> reason why I did: the MDIO/SPI jitter while accessing the frequency
> and offset correction registers is bad enough that the servo loop goes
> haywire. And implementing gettimex64 will not solve that.
>
[...]

Hubert
