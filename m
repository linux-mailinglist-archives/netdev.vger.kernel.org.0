Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A2B44AD19
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 13:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhKIMJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 07:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhKIMJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 07:09:24 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3C4C061764;
        Tue,  9 Nov 2021 04:06:38 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id i6so37948958uae.6;
        Tue, 09 Nov 2021 04:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoFuJCUkFN5FZfOrpbgUBLY2zsWBbOscul+PkeJej6A=;
        b=GXWQYa9KeSd+PpzF4X58/hEJHTKJoEdBL0JUuHsOThvIKx4njHCb+AMjDaE6MZ+TCJ
         w8zmMwVyS7RSBd4f6pLsBemh8tbTOyZlIaqJ6ArwzBT24OgSTMfvQWIGJqzd6emdsYDT
         JuIxDKkr8QbIc2M9HS4hVrd/14TSBOpWf3x+mj7DjIKLK/TFgft8nLg624Hh+7BiWXh8
         4yaogbdu6wZt6iPH07pY0Jt0+W/RRcZ274W0HSnxcEGzKi5/qBP+IbuYvr2Q9M7aamm6
         H/5qsZJW6X5ts1ySluHJFn2OsMowY1MH01yNvYJSc9KBgwhMrncN3/yjjVcTT2E6548S
         +Xcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoFuJCUkFN5FZfOrpbgUBLY2zsWBbOscul+PkeJej6A=;
        b=3F/qAfzhel9dIY0+6W+y2N9of4Pr4GX0St1U0vN6KAGjJ/FpsaIDsC8Xek32nV4Wno
         yypPDyQ5Lt/KMkAaRt4itwJBC952rrE1Q5UVomPbALq+Dp5/w07D6gk8FwUvNAv7hlxT
         /KAnNcZcDnc1OAHcDd9ZDFFAhlNXiwblONllXAnfAS5uyDt9Xt8dj+M8PbR/6BTRVYlh
         A4iI2it+6jbFFTgu/bd0DI4MuU4S5b/9NkZNpQV3DiKZLA55zpNKj37IhAZyCa/r3Sy2
         pqYEj6cQEWtb1/q7u69qFiKlIlKEO9oIqch7xJglEv7se1jIqYx/08tRmWAMhcanx66C
         P3tg==
X-Gm-Message-State: AOAM532ddhDQu1O8qprXQFZjwmxG6pmaDzxLMuYE6ADhW9u3w1+WlfOF
        QClJtZLH8G1lp/NsVHMbS8IzyAdiQ9CTHoPXrTs=
X-Google-Smtp-Source: ABdhPJxBrZRTEnwiKQmcdCCaPYoNwEbEoKa3nX+QnQZFdh5BdGZCw6XxcCYpVmZRzgcJpEvs64ZqyLrcupH1/WlvAL8=
X-Received: by 2002:a67:e9c4:: with SMTP id q4mr36553639vso.19.1636459597493;
 Tue, 09 Nov 2021 04:06:37 -0800 (PST)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-7-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-7-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 9 Nov 2021 15:06:26 +0300
Message-ID: <CAHNKnsRe-88_jXvW4=0rPSDhVTbnJnDoeLpjHS4ouDv3pJXWSg@mail.gmail.com>
Subject: Re: [PATCH v2 06/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
> ...
>  static struct t7xx_port md_ccci_ports[] = {
> +       {CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, DATA_AT_CMD_Q, 0xff,
> +        0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 0, "ttyC0", WWAN_PORT_AT},
> +       {CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
> +        PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", WWAN_PORT_MBIM},
> ...
> +               if (count + CCCI_H_ELEN > txq_mtu &&
> +                   (port_ccci->tx_ch == CCCI_MBIM_TX ||
> +                    (port_ccci->tx_ch >= CCCI_DSS0_TX && port_ccci->tx_ch <= CCCI_DSS7_TX)))
> +                       multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);

I am just wondering, the chip does support MBIM message fragmentation,
but does not support AT commands stream (CCCI_UART2_TX) fragmentation.
Is that the correct conclusion from the code above?

BTW, you could factor out data fragmentation support to a dedicated
function to improve code readability. Something like this:

static inline bool port_is_multipacket_capable(... *port)
{
        return port->tx_ch == CCCI_MBIM_TX ||
               (port->tx_ch >= CCCI_DSS0_TX && port->tx_ch <= CCCI_DSS7_TX);
}

So condition become something like that:

        if (count + CCCI_H_ELEN > txq_mtu &&
            port_is_multipacket_capable(port))
                multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);

-- 
Sergey
