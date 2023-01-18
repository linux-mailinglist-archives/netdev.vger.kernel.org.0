Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD9670ED0
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjARAjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjARAim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:38:42 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD40741B5D;
        Tue, 17 Jan 2023 16:10:29 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e130so6705819yba.7;
        Tue, 17 Jan 2023 16:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqoGaxCv32d9QDH8rbs+wNFx+mRHisbPyzqWglfmzdo=;
        b=X8kEN2RCR0Z7j9dvYBPvrUngCUUeFWtb1S07rcVgUPJfjZWU74psq/1gmCn184hHsa
         uAze+wMWm/HhTilA6p92QH5ri8+IauhT90wWGY1gF+L4D1hxqn6EEUAC2u4NEpV9Nmvn
         x+3uw1f3Kj62qSMscS/TsPlYBzCYZoW6NNjmtZbAPUJ/5TKESadBgRtm8J1MdvDK06vz
         WYfkJ4Sp7G5/xmXAjhT1J6VJC34p+oXr1s/hPXo04xworQlkKedZ7oKdZ+cdRdRuwnLj
         FlNdnb/9pL7BHz0y6pWQYZ0EY4EDj4CwBCe3rsWwDGIkCSO63TNtAcqrhSR1ML+9G3SE
         inSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqoGaxCv32d9QDH8rbs+wNFx+mRHisbPyzqWglfmzdo=;
        b=CkWMK8SSgKtwWDurvooUxsnwFaOrfo0s/0lVapsSexK3ZlfjE/KFildOSMZhUbtipo
         Y2jlcU+lqWuvupbRvx7dfpm3OZkKnLe71kqG+1qYYDDMjEWG1m0b8p0YFbxFJ4aTJ9HU
         2UJ3+iqXiejc8axSpH5z2oAIG1eCujwx+zLVMSGTnWX8bETMTgZEeF8mA7Daah1gB4ng
         nUYC+t4YLxnxv7nXDsKGtwS+U3lFgmFxNaVdas9S74m55hz+ANQxTARJaWqq5GZXrDbl
         WxZYfqpOjSgiBEPZ7iTORwId6em8pNr2DPWKH3hRXqnB2vWzni3hZtk6jsZFhf3Sy5uM
         SaIg==
X-Gm-Message-State: AFqh2kph3v8kIbeohz3YGLHiCLvsDDqoxePReUF7rPv87rsowlfXUtnl
        HnXseFG/4YK/Pi70588+Opk=
X-Google-Smtp-Source: AMrXdXvLckhDa1bG5Pn2IzKkim7J+U5lK7NIKjwNimaDoNI+pnG9GJpZUGRqId1mcbsUGnMptZYX1A==
X-Received: by 2002:a25:4084:0:b0:7d8:aaf9:bdd7 with SMTP id n126-20020a254084000000b007d8aaf9bdd7mr4610072yba.3.1674000628976;
        Tue, 17 Jan 2023 16:10:28 -0800 (PST)
Received: from [192.168.0.14] (cpe84948cc906a3-cm84948cc906a0.cpe.net.cable.rogers.com. [99.231.72.42])
        by smtp.gmail.com with ESMTPSA id h18-20020a05620a401200b007064fa2c616sm6796318qko.66.2023.01.17.16.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 16:10:28 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: remove arch/sh
From:   "D. Jeff Dionne" <djeffdionne@gmail.com>
In-Reply-To: <c9ce648e-e63e-8a47-03c6-7c7e30d8dbc7@roeck-us.net>
Date:   Tue, 17 Jan 2023 19:10:25 -0500
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Landley <rob@landley.net>, Christoph Hellwig <hch@lst.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9FC76FF3-9DD4-48E2-BC39-479A50B40C1D@gmail.com>
References: <20230113062339.1909087-1-hch@lst.de>
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de>
 <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
 <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
 <c9ce648e-e63e-8a47-03c6-7c7e30d8dbc7@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.3608.120.23.2.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Since there are people around with real hardware .... is sh in big =
endian mode
> (sheb) real ? Its qemu support is quite limited; most PCI devices =
don't work
> due to endianness issues. It would be interesting to know if this =
works better
> with real hardware.

Hi Guenter,

SH big endian works very well, and is in use on J-Core J2 SMP (hardware =
w/FPGA, simulation and ASIC this year) as well as some of the Hitachi / =
Renesas IoT chips e.g. SH7619.

It=E2=80=99s the base of the real new line of development (as opposed to =
backward looking support of older SH chips).  New chipsets will be based =
on the same RTL.

But does it actually work?  Yes, we have (new) devices such as a USB =
Wireguard based VPN hardware dongle, that are J2 (SH2 2 core SMP) that =
are in use with Linux sheb, nommu and fdpic.  MMU chips will be little =
endian.

Cheers,
J.

> Thanks,
> Guenter
>=20

