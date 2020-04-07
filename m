Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD61A07A9
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgDGGvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 02:51:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35295 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGGvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 02:51:17 -0400
Received: by mail-qk1-f195.google.com with SMTP id k134so642772qke.2;
        Mon, 06 Apr 2020 23:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4FAoei46Tkc3HfHlCIKmv+2BjR5V8f9xenFoOtsKN4=;
        b=tQo4f6yKtMHTJ0hQi+oM3MZgcHaRvAV7aDsZGtxCuYln7mYN8W+9/TOLWGGm8S6wqa
         95cxOdNcctfI6yKkFwoL3+EDY+0FDcP5lM7hdhohRJevf91pNFlupKSOIELe9XPccwMh
         6N7ApC9NhFF8Scantpav7pS8TD21Oos/V0b4o0N3niIojk9Je+7GjdYvTvH1mccY4Nhl
         5G15tkjpkK4wGPyZvs/1f40gLbUcERdUif9Hsd1qNRoa1wv/nyZ8NU8MMysm+5OZqwqm
         rGHpvhZVnd8NttGewORj2Sd5not4n68zV3vJP8rtbJjKMtlkO01vWh1cx/YIFr0XMTt0
         xh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4FAoei46Tkc3HfHlCIKmv+2BjR5V8f9xenFoOtsKN4=;
        b=LY/mobUyh/9MA/l8M2Ffxyxh3jUw6FgixQzxq/uaA660nXWC8NCIZ9bi8WmGiFA0Yn
         bRzDGt3VVCKWMvE24/kW5UOHir05LWFKcLM8Ld9RWhnq5i5Eau9Ilgz0t0pnKvGa03ve
         BRIbKpYQ93UcMEWUbncqPTMdQL+DBCzfUu+gFaXdwiNLU/npm1p7TVzmOkAekLD9IAhH
         eo6rvoyaZt4STkDJK92HNF7J8afx9TCOFN51v/5yNj+e0iPBebpaduP05TrdS/9NYPE0
         T+J8JOaE3czLHyF0IV3llGY9nhNyEL29JsKcOtO80cHksP14arKCXhBvgJz858RX7Pae
         HlMg==
X-Gm-Message-State: AGi0PubIKpk1sQIE0QUIyJMupWmWdbjngnSJiNTru7Fk9rsSjWtMNBc+
        XrzV9Vt8GtTaUWYDM+gmB7z9XOrEOzXR1hv+98c=
X-Google-Smtp-Source: APiQypLLsOdvypIFNxuaVrbiZeeORo8cVXBYb0ZNxxDoZPkW/yNo1thc2t6Xj2qD9Chy7pElS4GccL0R0thQRTsHmNg=
X-Received: by 2002:a37:4ac2:: with SMTP id x185mr720414qka.413.1586242274672;
 Mon, 06 Apr 2020 23:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200407055837.3508017-1-alistair@alistair23.me> <20200407055837.3508017-2-alistair@alistair23.me>
In-Reply-To: <20200407055837.3508017-2-alistair@alistair23.me>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Mon, 6 Apr 2020 23:50:48 -0700
Message-ID: <CA+E=qVdQKS9TCG7Sa4aefAZbgWO3-rgA9u13v=iB6+TN7yQe=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] Bluetooth: hci_h5: Add support for binding
 RTL8723BS with device tree
To:     Alistair Francis <alistair@alistair23.me>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        devicetree <devicetree@vger.kernel.org>, alistair23@gmail.com,
        arm-linux <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 10:58 PM Alistair Francis <alistair@alistair23.me> wrote:
>
> From: Vasily Khoruzhick <anarsoul@gmail.com>
>
> RTL8723BS is often used in ARM boards, so add ability to bind it
> using device tree.
>
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Alistair Francis <alistair@alistair23.me>
> ---
>  drivers/bluetooth/hci_h5.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
> index 106c110efe56..b0e25a7ca850 100644
> --- a/drivers/bluetooth/hci_h5.c
> +++ b/drivers/bluetooth/hci_h5.c
> @@ -1019,6 +1019,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
>         { .compatible = "realtek,rtl8822cs-bt",
>           .data = (const void *)&rtl_vnd },
>  #endif
> +       { .compatible = "realtek,rtl8822bs-bt",

Wrong compatible? Also you probably want to keep it over #endif.

> +         .data = (const void *)&rtl_vnd },
>         { },
>  };
>  MODULE_DEVICE_TABLE(of, rtl_bluetooth_of_match);
> --
> 2.25.1
>
