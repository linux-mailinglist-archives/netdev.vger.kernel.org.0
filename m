Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0703380BBD
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhENO1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhENO1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:27:12 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CC3C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 07:26:01 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id ee9so5228132qvb.8
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 07:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FpTvFQJrnNK/eV5EDnxsSGUVAlc8R32pjHB6ZjHCF3c=;
        b=vO1IitILypXNKLqrMrmMCroEVcFoBuVIx6eI5JU6CJPqEUK1PT8/JZORt2AbDosAzE
         8SaEZmZuDrrWKXPFx8XfuB/cif0GJj8ccByaIUUv7IZ0pMgK5p9ijHbKmuMl0NA4lBMr
         Myf+r31h/fB84anWNeoDK4t0yb5OI8XCI+VXBb0GZo1CfoeUVq+drcmgx0dgLnwZl1GO
         +G0+Q3iM/X3VUZz+JvN93iwffD6jfgi+n1WYmPDhzjUjW5INgMRP4Llav21hM0IUvBpE
         BmwH0VFkc16O44GJV1JpUWUDh1zp5Xf7GNV5ANVuULTcSJYQszX0dZQPbFefiHXOwBAe
         boMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FpTvFQJrnNK/eV5EDnxsSGUVAlc8R32pjHB6ZjHCF3c=;
        b=YDaqbeYeEbimAbnBUFHFVtF1E4j3BSis7a7/5ElgPgp0T1G5GKFtBYgMDm5zFHe3tw
         /jgrN/ytykDOlp1wAlUAB9xKWLfwZ4PmvmvKl0DjhWuO6Xcy1fXbaZhO6M8UPsBXuiiB
         V6eGm5VmI0EAXsKFdWcpekq1DjBlI1h5EsLehSoe7VhJy/cY8tQEcoD2uyAR+h0yVCbI
         dXkEs6bjSLiSbtXLf+xmFvsxKQ6zmH+2yWuinKtEDOHrazUhd8KBwzSdLyd5qr0Z5G++
         yfuhj1KsV3b2038I/1E01lqTDgZxbNrEVzBa6mMEHo2ziJ4L0W7UfaZADJIw5nzJ5v1B
         T65Q==
X-Gm-Message-State: AOAM531kWAkYlcfgEKtWMlCnmh68BRc9Z6GagrM2b4/ZCF0vZatSit6/
        /z8d82ntXE6YszbUI6wTveLOKsPhYjpYxWAkImKuoWxl8s++xn04
X-Google-Smtp-Source: ABdhPJwpxBswr8Dyk85cY10GlhUqtrR5XOXXmvhMsb2Wklnjj2cT2OiVP2dGQdoym+cncT9W+C2ROP82y6WPfQyv3Zo=
X-Received: by 2002:a0c:a163:: with SMTP id d90mr46528162qva.24.1621002360572;
 Fri, 14 May 2021 07:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210514130018.GC12395@shell.armlinux.org.uk>
In-Reply-To: <20210514130018.GC12395@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 14 May 2021 16:25:48 +0200
Message-ID: <CAPv3WKcRpk+7y_TN1dsSE0rS90vTk5opU59i5=4=XP-805axfQ@mail.gmail.com>
Subject: Re: mvpp2: incorrect max mtu?
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,


pt., 14 maj 2021 o 15:00 Russell King (Oracle) <linux@armlinux.org.uk>
napisa=C5=82(a):
>
> Hi all,
>
> While testing out the 10G speeds on my Macchiatobin platforms, the first
> thing I notice is that they only manage about 1Gbps at a MTU of 1500.
> As expected, this increases when the MTU is increased - a MTU of 9000
> works, and gives a useful performance boost.
>
> Then comes the obvious question - what is the maximum MTU.
>
> #define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */
>
> So, one may assume that 9856 is the maximum. However:
>
> # ip li set dev eth0 mtu 9888
> # ip li set dev eth0 mtu 9889
> Error: mtu greater than device maximum.
>
> So, the maximum that userspace can set appears to be 9888. If this is
> set, then, while running iperf3, we get:
>
> mvpp2 f2000000.ethernet eth0: bad rx status 9202e510 (resource error), si=
ze=3D9888
>
> So clearly this is too large, and we should not be allowing userspace
> to set this large a MTU.
>
> At this point, it seems to be impossible to regain the previous speed of
> the interface by lowering the MTU. Here is a MTU of 9000:
>
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  1.37 MBytes  11.5 Mbits/sec   40   17.5 KBytes
> [  5]   1.00-2.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes
> [  5]   2.00-3.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   3.00-4.00   sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes
> [  5]   4.00-5.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   5.00-6.00   sec  1.28 MBytes  10.7 Mbits/sec   39   8.74 KBytes
> [  5]   6.00-7.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   7.00-8.00   sec  1.25 MBytes  10.5 Mbits/sec   39   8.74 KBytes
> [  5]   8.00-9.00   sec  1.13 MBytes  9.45 Mbits/sec   36   17.5 KBytes
> [  5]   9.00-10.00  sec  1.13 MBytes  9.45 Mbits/sec   39   8.74 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  11.9 MBytes  9.99 Mbits/sec  379             sen=
der
> [  5]   0.00-10.00  sec  11.7 MBytes  9.80 Mbits/sec                  rec=
eiver
>
> Whereas before the test, it was:
>
> [ ID] Interval           Transfer     Bitrate
> [  5]   0.00-1.00   sec   729 MBytes  6.11 Gbits/sec
> [  5]   1.00-2.00   sec   719 MBytes  6.03 Gbits/sec
> [  5]   2.00-3.00   sec   773 MBytes  6.49 Gbits/sec
> [  5]   3.00-4.00   sec   769 MBytes  6.45 Gbits/sec
> [  5]   4.00-5.00   sec   779 MBytes  6.54 Gbits/sec
> [  5]   5.00-6.00   sec   784 MBytes  6.58 Gbits/sec
> [  5]   6.00-7.00   sec   777 MBytes  6.52 Gbits/sec
> [  5]   7.00-8.00   sec   774 MBytes  6.50 Gbits/sec
> [  5]   8.00-9.00   sec   769 MBytes  6.45 Gbits/sec
> [  5]   9.00-10.00  sec   774 MBytes  6.49 Gbits/sec
> [  5]  10.00-10.00  sec  3.07 MBytes  5.37 Gbits/sec
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate
> [  5]   0.00-10.00  sec  7.47 GBytes  6.41 Gbits/sec                  rec=
eiver
>
> (this is on the server end of iperf3, the others are the client end,
> but the results were pretty very similar to that.)
>
> So, clearly something bad has happened to the buffer management as a
> result of raising the MTU so high.
>
> As the end which has suffered this issue is the mcbin VM host, I'm not
> currently in a position I can reboot it without cause major disruption
> to my network. However, thoughts on this (and... can others reproduce
> it) would be useful.
>

Thank your for the information. I will take a look after the weekend.
To be aligned - what exactly kernel baseline are you using?

Best regards,
Marcin
