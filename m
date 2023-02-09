Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B7F691079
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBISks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjBISka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:40:30 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B791026A;
        Thu,  9 Feb 2023 10:40:28 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id o5so3170509ljj.1;
        Thu, 09 Feb 2023 10:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cEWkppk5tnuyoz4P0mPatIFI0+KkmsGN120smDpkAh8=;
        b=dWB4DLPy0Yus65FV2pF5PDzvbnVK7Xjp0vv1yo7wjCrMsmc8laGqi48D2IRwJJO07R
         pua2sN5jOEEcJpCvZfPLfPbVJj74ptpgOGdRTOd0TlJ2vRSIj09HdCQr2LX46R0vCqBE
         z6/ECmuV7S2annlh6AZyAOmvL86x222zglj2Woo0NGGcgIDEsCp9+4EcTsxF+OTrDfUY
         mz1lZ1RNz4VpYOWm5RWE/IPqBy1pBsX8q/iLG2Uq0YlzTSgJPcCkbYWUzuu5N4vcAyJe
         fVNuv5cbdgPZqPPrvMfI2q6iLwewCzCyOwyABglKNc+N8HEZhBkyUocEojxd5SpYrf/k
         hqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEWkppk5tnuyoz4P0mPatIFI0+KkmsGN120smDpkAh8=;
        b=7b0346s+nDVt6p9qrvE1YWU8K5u24lokJvbLYrwliGm2nR5Cj1UFVd1/Z/nsIaUhZI
         TUtVQpWVZkjTX/CsD5Dam58zX2SC/05Puc3VcrVw9n7/1KqCqxgyOn1KY2uNQv2qeON8
         YTPRZKh1Lta+lL0Y0JIKhclEOPxuyS5ifXn9lOIM4l3XURiqFt/ZeFB30ytfOSMHWlSV
         O/D/Io9tjB10PsgZVIeG4vQACNxbQcDGmQ4/qovJj3V7tNBJOA9ZsN96Dk7KXZv/WvV1
         pcDVuz1gF5+dAUAm0hq5ydr4MSzTwXbGWujxALv7Otu1PlxbesCn5hQU1/SjwlGDwaiM
         sZJQ==
X-Gm-Message-State: AO0yUKWJbDOCfIK26tV62iZqs8jiQZurNx1m/vvklMgcXrqRKfVh7ZlY
        sARbe2nWyLaul2Img8J3tVCgM1dET2VKdDNn0oXeEb1VTZQ=
X-Google-Smtp-Source: AK7set/LmMiHEzIYbW7b6bLtrl48jQtRQB3aHjTRk9zAUoLvMUE98ctGoAzme/RyAlhy9xnow6kjaGG3lcWeCGPe3SE=
X-Received: by 2002:a2e:8406:0:b0:293:3580:8d74 with SMTP id
 z6-20020a2e8406000000b0029335808d74mr68038ljg.19.1675968026408; Thu, 09 Feb
 2023 10:40:26 -0800 (PST)
MIME-Version: 1.0
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
In-Reply-To: <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Thu, 9 Feb 2023 19:40:14 +0100
Message-ID: <CAEyMn7YnqhbmOnKQkks5OkGwuKoBPkQkfuWWJ2s_GAEY9WP4Wg@mail.gmail.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
To:     Ajay.Kathat@microchip.com
Cc:     Claudiu.Beznea@microchip.com, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, michael@walle.cc,
        netdev@vger.kernel.org, Amisha.Patel@microchip.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Do., 9. Feb. 2023 um 18:15 Uhr schrieb <Ajay.Kathat@microchip.com>:
>
> Hi Heiko,
>
> On 2/8/23 07:24, Heiko Thiery wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > Hi,
> >
> > I'm using the WILC1000 wifi and with NetworkManager [1] I see issues
> > in certain situations I see problems.
> >
> > I was able to reduce the problem and have now found out that the cause
> > is that the interface has the HW MAC address is 00:00:00:00:00 after
> > startup. Only when the interface is startup (ip link set dev wlan0
> > up), the driver sets a "valid" address.
> >
>
> IIUC network manager(NM) is trying to read the MAC address and write the
> same back to wilc1000 module without making the wlan0 interface up. right?

As far as I understand, network-manager will read the "real" HW
address. Then it sets a random
generated HW for scanning and after that switches back to the "real" HW address.

There seems to be circumstances where the wrong HW address
(00:00:00:00:00:00) is read and stored for
later reset after the scanning.

> Not sure about the requirement but if NM has a valid MAC address to
> assign to the wlan0 interface, it can be configured without making
> interface up("wlan0 up"). "ip link set dev wlan0 address XX:XX:XX:XX:XX"
> command should allow to set the mac address without making the interface
> up.
> Once the mac address is set, the wilc1000 will use that mac address [1]
> instead of the one from wilc1000 NV memory until reboot. However, after
> a reboot, if no MAC address is configured from application then wilc1000
> will use the address from its NV memory.
>
> > Is this a valid behavior and shouldn't the address already be set
> > after loading the driver?
> >
>
> Only when the interface is up(ifconfig wlan0 up), driver loads the
> firmware to wilc1000 module and after that the WID commands which allows
> to set/get the mac address from the wilc1000 works.

Is there a hard technical reason not to load the firmware and set the
HW address when
the driver is initialized and not only when its opened.

-- 
Heiko

>
> Regards,
> Ajay
>
> 1.
> https://github.com/torvalds/linux/blob/master/drivers/net/wireless/microchip/wilc1000/netdev.c#L600
