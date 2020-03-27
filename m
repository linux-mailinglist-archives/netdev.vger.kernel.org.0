Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4783C194DC4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgC0ALe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:11:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46159 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0ALe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 20:11:34 -0400
Received: by mail-lj1-f194.google.com with SMTP id r7so758664ljg.13
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 17:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Om0czkdlZ/W7CWzm10Sp8n/DnGjyBb+31UnGPUf/8ao=;
        b=bdxLoqgsqXEsawKrEEQCjxEEU4SVqGM7oftF1iV9Uv3/ABxpystWJhynlOqOLrU4Hi
         hx6k8DReGKF6ijQ3b+bSrJfho9k8R8jP3/0xDRIAzQzUadL9wUHkv+yI5J5m8czH9knK
         d8NtmT64PYlpoxQR0zgJLnadnFbDL9hsxNndQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Om0czkdlZ/W7CWzm10Sp8n/DnGjyBb+31UnGPUf/8ao=;
        b=mZfnLDiqwytq2wNhsWHrMQWUzhdlkxNHUf9pu214w+xkqYVRi3Cy/HNd3qjzflODMr
         +ZG4/wVBmqsCABmCyLQd489nwtMQYTqfcHWz7mcrURHQa1ckEZN0X5kNf/29YAw8c914
         dw4PUI/Hku8MJEeg4a9/mSUGVAaNmn31QVHTWYDRtdSfp550OzjC9wRooSBWDUWpkrsP
         zlLNgXnkkdtcMuzAFvDziq04qI3ITpUqrQYhfP3Ilb4x1FKfhgrb7NRjS1fgVJJYLxpG
         b9kHwMHyu1L7/B0Bax7um3Co6ZCLfhQZYFs3wHst8IjhdR7FcyH3og+nXl603aBsQxug
         LZVg==
X-Gm-Message-State: ANhLgQ23/SIeRuRNbhDMs3jLRDDysYxlc16zJjL3iHJvO/Xkd++OTLML
        v6YumfmmIXdL0UI6icruxs9HaGsVNPigyCBdBff2Og==
X-Google-Smtp-Source: ADFU+vsUOMh8Po1kt6T0m/lsy5OkGbexpu112fy3gnBAGNzZ5mv6hf9SyERLmZOD9NOtJV13YX15ZgAmSTIvz0Xi+fg=
X-Received: by 2002:a2e:9ad2:: with SMTP id p18mr6574780ljj.15.1585267892097;
 Thu, 26 Mar 2020 17:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200326075938.65053-1-mcchou@chromium.org> <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <0cb96a93000c02e4c4816c64492afef10bc76fd9.camel@perches.com>
In-Reply-To: <0cb96a93000c02e4c4816c64492afef10bc76fd9.camel@perches.com>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Thu, 26 Mar 2020 17:11:21 -0700
Message-ID: <CABmPvSGbVqnE82Se=ZfTM=h=WTJaibRfP+0Prvz2yxsDLK7Ukw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
To:     Joe Perches <joe@perches.com>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 1:16 AM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2020-03-26 at 00:59 -0700, Miao-chen Chou wrote:
> > This adds a bit mask of driver_info for Microsoft vendor extension and
> > indicates the support for Intel 9460/9560 and 9160/9260. See
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > microsoft-defined-bluetooth-hci-commands-and-events for more information
> > about the extension. This was verified with Intel ThunderPeak BT controller
> > where msft_vnd_ext_opcode is 0xFC1E.
> []
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> []
> > @@ -414,6 +414,8 @@ struct hci_dev {
> >       void                    *smp_data;
> >       void                    *smp_bredr_data;
> >
> > +     void                    *msft_ext;
>
> Why should this be a void * and not a msft_vnd_ext * ?
The intention is to hide msft_vnd_ext from the driver.
