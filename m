Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574E741504B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhIVTBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 15:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhIVTBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 15:01:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A54C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:59:30 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m26so3539014pff.3
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADW9Q1AhmJCU2CH7lk1ti6HYbKSaGBYbzXWIvlOJ4Ug=;
        b=Rjn9Hc8Z8hK5l4XNotkA55aqrGOLjQ/6enredy1WjpRWwT7/MTzyLAR/TSHJWvf02d
         a4FVBb3XHlnzKmwaA5dd2HoWHnQe3s9n9RvdnbSnjXaWI1VjsqRyUoZGM0Wr48wYsqht
         lOZUeJLYP+1pH42mUHxWD3MnxpMejBLzwCFU2LxKlVeYJdLqbt/S5nQNDocQNueTCTrU
         deaNQJImpoQprjBxcAyUE44BkvlodoIhx/Ks2dtUdmX0Tx1FZ1THw+76yFaGpwqPtd0H
         8m7U2fMl3ahsdLQu6pWzghA/7F8czl2TUPSKRn29lq2SWXppLawhcnlMF4B455AwMw+9
         VVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADW9Q1AhmJCU2CH7lk1ti6HYbKSaGBYbzXWIvlOJ4Ug=;
        b=oEvOmBIIoLaXlkONIsR3CPNv5aG+OPDEpXnX9gsF6wdhcTWFRowzytfJxqYb2OFTVG
         lNPcjFqdiR/cNk72djZID/HmK8fVn0EofNNlwvz8npOoRxqk4KmBXqQmaohbYEUdClfG
         nsoFpohoiZIk49m2E3Rzc/K1YY5B0GhSAjmbSemTeEUsv4EoeDLqDecF5CC67dABiYmh
         Pgm+yUdelyZDIVK4yUUfxjdsf9g6BynRxumR6VgRnuC9A/dUOONAxljI40asCiAR/bL8
         90b0rkJZ2Ox6Pms6cVeh5VLVwcM3ucmK3cq5Al7RmJx624aRdHuy4XaZ2FtqPcB6xvMA
         Bktg==
X-Gm-Message-State: AOAM533v8G3qHXz/zxPn3KfGdpD5Au3MTBkKRGBaMm+ZQfAuBXk+Aew1
        K8lZGohyJUNKCA2fX+OtfaK+fuc5uHob2ehPkaQ=
X-Google-Smtp-Source: ABdhPJyVQd5G6amFmjo0x7NHmo9uDzNdsDV7b+N0AwpsanaD834/+ZRzH1GuT54y8if91kUgqT5ueGgH1z9sgOqbJeA=
X-Received: by 2002:aa7:9ac3:0:b0:440:4a66:50b5 with SMTP id
 x3-20020aa79ac3000000b004404a6650b5mr266384pfp.73.1632337169890; Wed, 22 Sep
 2021 11:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <CADZJnBbMmE-zktRyq-gZWPuEOHRLyuQRmheqKP1_HWuHRymK0g@mail.gmail.com>
 <YUs5s4AcZJrNhCqj@lunn.ch>
In-Reply-To: <YUs5s4AcZJrNhCqj@lunn.ch>
From:   John Smith <4eur0pe2006@gmail.com>
Date:   Wed, 22 Sep 2021 11:59:19 -0700
Message-ID: <CADZJnBZzA9U4dF=zQtDgJrn+u6TU-vqtgCZsxj9+HSa5EFhiAA@mail.gmail.com>
Subject: Re: stmmac: Disappointing or normal DMA performance?
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I have played with the RX coal values. My understanding is that
there is a hardware watchdog to trigger the DMA IRQ with a maximum
value of MAX_DMA_RIWT == 0xff.

rx_riwt = stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);

if ((rx_riwt > MAX_DMA_RIWT) || (rx_riwt < MIN_DMA_RIWT))
return -EINVAL;

This seems to lead to 326us. My 30000 frames per second arrive every
33us and 326 / 33 ~ 10 frames per interrupt...

In other words, I have the feeling that the answer to my subject
question is both: it's normal and it's disappointing.

Can ST confirm the hardware limit (the internal RX FIFO I guess) that
it's not possible to do better than 10 1280-byte frames per DMA
interrupt in my case?

John

On Wed, Sep 22, 2021 at 7:12 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Is there a way to increase the ratio of packets / IRQs? I want fewer
> > IRQs with more packets as the current performance overloads my
> > embedded chip,
>
> Have you played with ethtool -c/-C.
>
>      Andrew
