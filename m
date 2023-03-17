Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D156BF1E6
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCQTu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQTuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:50:25 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878E530B09;
        Fri, 17 Mar 2023 12:50:23 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e194so6973354ybf.1;
        Fri, 17 Mar 2023 12:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679082622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b3CQ8WGc4w2GVbQ+AHog+uRw/SumpjFjDyqWJL60hI0=;
        b=paYhQ9HyuGNRZhcX+W+4wkvn49Zl73wDxF4NFJxzuc1lFNhTty3Zzjl6En/7ixGVcJ
         DRevvNT0lj+toUBebDZYr87DPb4a/y4d82jfNLOrBrl6cPnv7zfpXiJ/VvhEsCw6Pj5L
         O0Nd0MhGXYztpw/BnZUkpdmg/DXvpyTQNNYZRuyDS9hR1kO3SNpYRTX7QUcjqhMXw2Kf
         a6cxw9oC9shZs8YqTn3m+AU1i34IdXxRBvQv0xEsIzG1ec+7z30Nsgmd4Hl8amvp8Hae
         xO20DAhReNI3KkuZ9kBqlSg4gdGPXcu4msryUzBC8G7nZrmdmYMt/K597LuScKXoDv+i
         wSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3CQ8WGc4w2GVbQ+AHog+uRw/SumpjFjDyqWJL60hI0=;
        b=27uhgJ0TyisLdxgHqjR11XwvZbGS5uGHrLBg4ara29FaxDqc3NjuSO3mS21JVJYjRu
         9y2kDprYNplkQtwiKu/jkOy7a06MO+WmgSn0sTgSZ8IQx76em06b1FoEneMrb/TH77Co
         ogacSi4Qj7czc3uTstZDKaEuIgYxYoQjoDvJYL31ZHTekPpYnB1yfX+JLEBLyz+pjCW9
         lpXGwsm5BwAbnLjWRHS+XTwKtYL7UPyv4ZAjQdvFOr3IklB0Mb4yj9kv/spvLXlAgN5q
         pGpHe07LJSw0UBpnaW6rx4nsEs1Qtr73bEPvX9tZbOoCgDNHaHAy57+4QJdfRfdEcbmq
         IHTg==
X-Gm-Message-State: AO0yUKU/rFYH8da+da4nf0JyhVKHx4TH6/aBaaPS6Hh2WPjBhbwEn1NU
        Hp5KPVCtyb4+3wLXE1EhCG8WlBtHqHXhpiKa2g==
X-Google-Smtp-Source: AK7set8TKJGwscidXv9PDMw39S7PyU+VEVKzDYJObGO75JeJd57fC94Asa1qL2/ZU+c85KzeRGGrt/90is3aHzUu/3w=
X-Received: by 2002:a5b:611:0:b0:b67:f07:d180 with SMTP id d17-20020a5b0611000000b00b670f07d180mr235414ybq.5.1679082622364;
 Fri, 17 Mar 2023 12:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230123090555.21415-1-git@qrsnap.io>
In-Reply-To: <20230123090555.21415-1-git@qrsnap.io>
From:   Nick Morrow <morrownr@gmail.com>
Date:   Fri, 17 Mar 2023 14:49:56 -0500
Message-ID: <CAFktD2eFdaCAdE=zxVx05QYWPRcr5StompKr+ehn7piYpQHjzA@mail.gmail.com>
Subject: Re: [PATCH] Added Netgear AXE3000 (A8000) usb_device_id to mt7921u_device_table[]
To:     Reese Russell <git@qrsnap.io>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
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

> Issue: Though the Netgear AXE3000 (A8000) is based on the mt7921
> chipset because of the unique USB VID:PID combination this device
> does not initialize/register. Thus making it not plug and play.
>
> Fix: Adds support for the Netgear AXE3000 (A8000) based on the Mediatek
> mt7921au chipset. The method of action is adding the USD VID/PID
> pair to the mt7921u_device_table[] array.
>
> Notes: A retail sample of the Netgear AXE3000 (A8000) yeilds the following
> from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This pair
> 0846:9060 VID:PID has been reported by other users on Github.
>
> Signed-off-by: Reese Russell <git@qrsnap.io>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> index 5321d20dcdcb..62e9728588f8 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
> @@ -15,6 +15,8 @@
>  static const struct usb_device_id mt7921u_device_table[] = {
>         { USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7961, 0xff, 0xff, 0xff),
>                 .driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
> +       { USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
> +               .driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
>         { },
>  };
>
> --
> 2.37.2


I can confirm this VID/PID needs to go into 6.1 LTS and the current
testing version of the kernel as I am getting an increasing amount of
traffic from users that have purchased the Netgear A8000.

My site is github.com/morrownr/USB-WiFi

Helping Linux users with USB WiFi is what we do.

The OP could have added a comment to the patch showing the adapter
that is causing this patch to be submitted. Maybe he can submit a v2
that can be expedited?

Guidance?

Nick
github.com/morrownr/USB-WiFi
