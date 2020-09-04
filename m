Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8991025E1F4
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgIDT0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIDT0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:26:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F615C061244;
        Fri,  4 Sep 2020 12:26:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bh1so1592003plb.12;
        Fri, 04 Sep 2020 12:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFzHYAnJjeew+/VoFDw5WYkblYa09ONtC+TDOJdOTh4=;
        b=sRbOUOb7rppBXwuOmSwJptyYN5iBNXrPCq6JLgMewS7Owl7fM4PfCOQANGIlNzcbpk
         H7z5tBddzPa4x0inJuV1jUSbVLXWL3zHsQ8NV2JP9uiP/JiGgL3efJfggarjLAwd+cvY
         uJ0JAQ5bD3Fv7fQjbF70tzr1yvNdgbFaGQ7gHWwNuxpRVWatgg8dPgto1ycW8Vvzn8+0
         B1cnazFpmBo1m2RG+g7RGKCz+CKwPl773U6o4x/MQ7DVjhjEYJbrYeCi6gY/blNEnaiy
         trKLqTRs4L6X5pf1KWlWmR+BQYaqg1ecUEvI3gb8D+8X9hWA+wwjjETPZFTQBdXe+FQw
         7Qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFzHYAnJjeew+/VoFDw5WYkblYa09ONtC+TDOJdOTh4=;
        b=gkOv6JnP7/LN+XsSPoYvWvrX9U+cWR7cgxy0uBZZycDINTqDZuh5iQ/klGOxQ5XFo8
         tYN31e4EcYTr/WIanGpBjDahRIRhIOmmuRZf22/XqeaIqQ+w7DPa/gUnicdk4ON/bSDb
         t9ojhUluAXDmlUUmPnYhrSk8/gRn0PU0EDkvyxmpS5ZeI7rcnj9+5RQzF/AuHeDN3bO+
         +q+n4ZMf+88iJT12etzS1qVlduK40EiMv3bvkrOxIFii+baeCkAGwmzyFSJT6WY1uZqJ
         LcqW710/i+iLMpFp19MHf3wvpLTd1y+vW/q5cq6MyniP+4zRbjlM9YObeHeGJnP1tkJv
         3zhQ==
X-Gm-Message-State: AOAM532B2tlZ7goCrQLKB3cwUvrGX1XBUD5S9wybv866HdkIloHTyFoT
        /g8tEprWqXFA0wMzqs60FFjRiiZl8LZ6Zu4YYAw=
X-Google-Smtp-Source: ABdhPJycXs81cFywcafg76vAWpKAlUxjd+vGb3FswAonbvhiioLYqMQhEWrdgSxHoiIv5GOc+8HXsJkSdf/+RwGR1Yo=
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr9818922pjr.228.1599247560759;
 Fri, 04 Sep 2020 12:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu> <20200904165222.18444-3-vadym.kochan@plvision.eu>
In-Reply-To: <20200904165222.18444-3-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 4 Sep 2020 22:25:43 +0300
Message-ID: <CAHp75VcEC=sHardyv1jkpQ1o=MUhxPzMzehNtq0uN0hoEYoDwg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/6] net: marvell: prestera: Add PCI interface support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> Add PCI interface driver for Prestera Switch ASICs family devices, which
> provides:
>
>     - Firmware loading mechanism
>     - Requests & events handling to/from the firmware
>     - Access to the firmware on the bus level
>
> The firmware has to be loaded each time the device is reset. The driver
> is loading it from:
>
>     /lib/firmware/mrvl/prestera/mvsw_prestera_fw-v{MAJOR}.{MINOR}.img
>
> The full firmware image version is located within the internal header
> and consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> hard-coded minimum supported firmware version which it can work with:
>
>     MAJOR - reflects the support on ABI level between driver and loaded
>             firmware, this number should be the same for driver and loaded
>             firmware.
>
>     MINOR - this is the minimum supported version between driver and the
>             firmware.
>
>     PATCH - indicates only fixes, firmware ABI is not changed.
>
> Firmware image file name contains only MAJOR and MINOR numbers to make
> driver be compatible with any PATCH version.

...

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/circ_buf.h>
> +#include <linux/firmware.h>
> +#include <linux/iopoll.h>

Perhaps sorted?

...

> +enum prestera_pci_bar_t {
> +       PRESTERA_PCI_BAR_FW = 2,
> +       PRESTERA_PCI_BAR_PP = 4

Comma?

> +};

...

> +       return readl_poll_timeout(addr, rd_idx,
> +                                CIRC_SPACE(wr_idx, rd_idx, buf_len) >= len,
> +                                1 * USEC_PER_MSEC, 100 * USEC_PER_MSEC);

> +       return 0;

dead code.

...

> +       if (err) {
> +               dev_err(fw->dev.dev, "Timeout to load FW img [state=%d]",
> +                       prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG));

> +               return err;
> +       }
> +
> +       return 0;

return err;

> +}

...

> +       status = prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG);

> +       if (status != PRESTERA_LDR_STATUS_START_FW) {

Point of this check?

> +               switch (status) {
> +               case PRESTERA_LDR_STATUS_INVALID_IMG:
> +                       dev_err(fw->dev.dev, "FW img has bad CRC\n");
> +                       return -EINVAL;
> +               case PRESTERA_LDR_STATUS_NOMEM:
> +                       dev_err(fw->dev.dev, "Loader has no enough mem\n");
> +                       return -ENOMEM;
> +               default:
> +                       break;
> +               }
> +       }
> +
> +       return 0;

...

> +       err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
> +                                     PRESTERA_LDR_READY_MAGIC, 5 * 1000);

1000? MSEC_PER_SEC?

> +       if (err) {
> +               dev_err(fw->dev.dev, "waiting for FW loader is timed out");
> +               return err;
> +       }

...

> +       if (!IS_ALIGNED(f->size, 4)) {
> +               dev_err(fw->dev.dev, "FW image file is not aligned");

> +               release_firmware(f);
> +               return -EINVAL;

 err = -EINVAL;
 goto out_release;
?

> +       }

Is it really fatal?

> +
> +       err = prestera_fw_hdr_parse(fw, f);
> +       if (err) {
> +               dev_err(fw->dev.dev, "FW image header is invalid\n");

> +               release_firmware(f);
> +               return err;

goto out_release; ?

> +       }
> +
> +       prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
> +       prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
> +
> +       dev_info(fw->dev.dev, "Loading %s ...", fw_path);
> +
> +       err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);

out_release: ?

> +       release_firmware(f);
> +       return err;

-- 
With Best Regards,
Andy Shevchenko
