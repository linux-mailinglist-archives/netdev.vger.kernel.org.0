Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC3331D99A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhBQMj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhBQMjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:39:22 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B52C061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:38:42 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id s24so13609454iob.6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=et0PDkogNSLHlwRuiXBSwyQzDeT0IQNGFUKhAXckYVo=;
        b=kpAjzUbhZqQ+7DZreULSzKyN7WzTErBybO0upPjeMM+ee1MBMoMHay1SDdS5nRQJEL
         Hkg7y4KvRSG6lCG7aFs+QM069JStWOHwsE/fXwWSUOlutOLh0LaEVO2/d7IxQ+I8fIj/
         g6Yd8DufPvk9gz2cfK0dlM8EP5M2sGUmnHf3bpm8dEU6rd1/CRw0Qs4v3LsxjNUooJur
         VnTPkXe77ifS28n8YlowCyINZkH8fzk3Mjn2k8Mqp5L1DJxZF+HjFpqdqOTUsywpuqlj
         ohgnZl9kZj2DzxEf4guoKvGtaBVVB3nBJHKTubge3fnyvesB4fwuAPY0+ZPqLM/BKhfK
         3m8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=et0PDkogNSLHlwRuiXBSwyQzDeT0IQNGFUKhAXckYVo=;
        b=MDcFy162zCOurw2d3NHKqP8yfO8sMSsQCeH6X2zNTq9i0M6Kd7amBLdxkFFTV854OD
         GBegRbBVquwnOY16FLk0HSXVqMzlvuwCQpNOhNHaY1+1iiddzfS0WAyarAdFNUcNMN7d
         1QtYAAQCgqyXRXQCLIu8/acAVEi3m2Ql94x9sswDWHxUELaWVY3Aj+OYKtuKqWG4Dx1s
         fNi1hWcwTyrUjPDC0lvgdpWaKNGOlW91+Ow6+5PmP3lUgp15xOW9r9ey0AhELQ1krORg
         LSEU7ASzqrE8WTVuWUpoz3l53fpENERKl11/bDkGVYKgXi8QT5XabGH9YPDfGTjV1FzE
         zyvA==
X-Gm-Message-State: AOAM532ILXuZznPv489lzJbQ9Ed4ai8zWPSrsEBgMI/NRxIXursontTZ
        c/E+W+QSwss19Q/MLc3wETMd4CliA7mYUsVHqg8=
X-Google-Smtp-Source: ABdhPJwOaKZlHh9w5kSu2iuLMpPgL9Q4kH/YRFHbJXAqpUw+z2qejSmuOqtqDhQToYSbp/5fIIPx5S6foWF8PUAqt24=
X-Received: by 2002:a02:82c7:: with SMTP id u7mr19252046jag.76.1613565521558;
 Wed, 17 Feb 2021 04:38:41 -0800 (PST)
MIME-Version: 1.0
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
In-Reply-To: <20210216235542.2718128-1-linus.walleij@linaro.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 17 Feb 2021 20:38:30 +0800
Message-ID: <CALW65jbEjWtb3ww=Bq5WKrjpQ=fjrxCBKyxxxi0CGRAVAkdO7g@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:55 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> +
> +       /* Pad out to at least 60 bytes */
> +       if (unlikely(eth_skb_pad(skb)))
> +               return NULL;

I just found that this will cause double free (eth_skb_pad will free
the skb if allocation fails, and dsa_slave_xmit will still try to free
it because it returns NULL.
Replace eth_skb_pad(skb) with __skb_put_padto(skb, ETH_ZLEN, false) to
avoid that.
