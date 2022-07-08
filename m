Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3563F56BEC3
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiGHRY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbiGHRY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:24:56 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4E92F677;
        Fri,  8 Jul 2022 10:24:52 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id bn33so5291428ljb.13;
        Fri, 08 Jul 2022 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1M/U+j24sKAiVJ44WCcx1TYl/qaHboSDI0GHdo5qWjo=;
        b=qa4oW1G2Uws4jhB0YZkF7XwYSTtiEoZoZKbWCfdbbYUhNpJTfm/fN3zDL4gnMjDEAY
         fm7+x/oISow5UbuAOC7VGxufUKbVu1AEhFP2wou6/Y+dQrUkydg1QLccUSqfpvE2Oalf
         1ki2ZB2v2Nb0/6uHLgng7AZypCdEOxmg7iTMLBcTSoHI/AaPvYUn2M+SP8KU6Plzro88
         rRDU+5QTDoB+1g46A2VFBU33V/djmk4QuD5U0SCBfJLzYIyl2M7CeYARkw4VMMXLTorE
         Klitw+UX6Zpa8tTaYvswGKCkHnocSnR6vF8TeF7GnW1bg/qh/3kHCOEq9bXgHOF9Asta
         hF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1M/U+j24sKAiVJ44WCcx1TYl/qaHboSDI0GHdo5qWjo=;
        b=H79x87fAkSHhRmDtViNoYtJf8aLFFXUA5Uks+WcJwrxNVicD+aKW4llORtLTHlCwAP
         RNPhdDzcsy7IeW1TeHAlEdWaKZ6eriBwAEipWC+oISXEQkjSwXUeo3+DrvXOLJvKQ/OZ
         xLAHUNIPyB3P7s7FOZFPf9KR/9oue0JOkswqbwF5k4zpvy2q5KsZ9YiuVgFggJEGHOeQ
         g4esCuVGJsls7nNugd7jCtwhzMTBPJvp9+D+U+CE2n32oc8u0pb/Tqm+iBMk5JvqDXd7
         9u/HADylxrwqKb5TqQfknmZxGTO0h4/BjLoAPEmUFH4Meq9PM4w7OhdbXi/uie8uOgxu
         1uaw==
X-Gm-Message-State: AJIora+8wbyIQvtn77Oq1gaQfCpMvRio2jlctEICNu5o/EVXf633i2Cu
        27VUOMAAKfKFQxPmE/RuDJiefHOQfgnhmI6vUAo=
X-Google-Smtp-Source: AGRyM1sNrAQmx6pbx/jpvrulQkPO7P7hmCCf3z27UlyRz3qHp0ZKHMhcfN+IB1tfj6IcennK0gkuUbYsVMlne7Qo9kU=
X-Received: by 2002:a05:651c:545:b0:25b:c791:816c with SMTP id
 q5-20020a05651c054500b0025bc791816cmr2674846ljp.161.1657301090260; Fri, 08
 Jul 2022 10:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
 <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
In-Reply-To: <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 8 Jul 2022 10:24:38 -0700
Message-ID: <CABBYNZL5oXFsyBN6JRdt1JeD2v5h3MOpCAa4hF0sXfw5F6u3Pg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] Bluetooth: Add sysfs entry to enable/disable devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Jul 7, 2022 at 3:15 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Since device/firmware dump is a debugging feature, we may not need it
> all the time. Add a sysfs attribute to enable/disable bluetooth
> devcoredump capturing. The default state of this feature would be
> disabled and it can be enabled by echoing 1 to enable_coredump sysfs
> entry as follow:
>
> $ echo 1 > /sys/class/bluetooth/<device>/enable_coredump
>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
>
> Changes in v3:
> - New patch in the series to enable/disable feature via sysfs entry
>
>  net/bluetooth/hci_sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
> index 4e3e0451b08c..df0d54a5ae3f 100644
> --- a/net/bluetooth/hci_sysfs.c
> +++ b/net/bluetooth/hci_sysfs.c
> @@ -91,9 +91,45 @@ static void bt_host_release(struct device *dev)
>         module_put(THIS_MODULE);
>  }
>
> +#ifdef CONFIG_DEV_COREDUMP
> +static ssize_t enable_coredump_show(struct device *dev,
> +                                   struct device_attribute *attr,
> +                                   char *buf)
> +{
> +       struct hci_dev *hdev = to_hci_dev(dev);
> +
> +       return scnprintf(buf, 3, "%d\n", hdev->dump.enabled);
> +}
> +
> +static ssize_t enable_coredump_store(struct device *dev,
> +                                    struct device_attribute *attr,
> +                                    const char *buf, size_t count)
> +{
> +       struct hci_dev *hdev = to_hci_dev(dev);
> +
> +       /* Consider any non-zero value as true */
> +       if (simple_strtol(buf, NULL, 10))
> +               hdev->dump.enabled = true;
> +       else
> +               hdev->dump.enabled = false;
> +
> +       return count;
> +}
> +DEVICE_ATTR_RW(enable_coredump);
> +#endif
> +
> +static struct attribute *bt_host_attrs[] = {
> +#ifdef CONFIG_DEV_COREDUMP
> +       &dev_attr_enable_coredump.attr,
> +#endif
> +       NULL,
> +};
> +ATTRIBUTE_GROUPS(bt_host);
> +
>  static const struct device_type bt_host = {
>         .name    = "host",
>         .release = bt_host_release,
> +       .groups = bt_host_groups,
>  };
>
>  void hci_init_sysfs(struct hci_dev *hdev)
> --
> 2.37.0.rc0.161.g10f37bed90-goog

It seems devcoredump.c creates its own sysfs entries so perhaps this
should be included there and documented in sysfs-devices-coredump.

-- 
Luiz Augusto von Dentz
