Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86B3602B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfFEPRH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jun 2019 11:17:07 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33804 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbfFEPRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:17:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id y198so8894799lfa.1;
        Wed, 05 Jun 2019 08:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ZDwihMraH0/UeXMGo6VxX/h+FGTCHAr18lAotP3W/o=;
        b=EMyFJ9Fm50n5fMj2Uwl+/MzyCU1Hpss0wfXITPTe0r2+sNWQ5L5tq8ZWAhP34FRDRD
         WKQVS/p2n7w+py/9nFT84A80tp0oKd2WrZ8aFyMyUEnkHS6gFgbzZqc8IOlbRGbOIAsM
         g7T8KGSfdBRwdRh1+ldDsXpjTUpOZgvTPx0/OA2qU5E5mm+9PSUF5VDC3elk+CujrAZd
         0nW/sAA5ia549CABKnjEzlwx0q50F3DaCJICJoDqpwj4izGayVSAk46p+e+ReX7JzDwW
         xjJupANV9Cy8JJhdhJLwAqgiJNZuuzm/yjShgdW1oiLW0Oa2kms0UVFSbfcazQ7v3lyc
         IOVg==
X-Gm-Message-State: APjAAAXSnCX0IZHjKvfr+NxhpUg3b0fRZIyjk5nw/GETex/vavKKgYlc
        iQDbNZ2Bmg5/2ZEP10Dwb0Ebmybu2pr/I0ngHKc=
X-Google-Smtp-Source: APXvYqwnahJWRbBNqZloWzQgYOc8LotxrUUSMRWrJGEacaPDeMBX02rjSlhg9N1zdQ1iLajO5cX9nUc2wicrIbTApGo=
X-Received: by 2002:a19:6e41:: with SMTP id q1mr12977958lfk.20.1559747825230;
 Wed, 05 Jun 2019 08:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
In-Reply-To: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 5 Jun 2019 17:16:52 +0200
Message-ID: <CAMuHMdWi2F5K9yf009F-6wj_5eqZ-9ueyhKpAVZvEUheWS-4Zw@mail.gmail.com>
Subject: Re: [PATCH v2] ravb: implement MTU change while device is up
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Wolfram Sang <wsa@the-dreams.de>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 5:15 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Uses the same method as various other drivers: shut the device down,
> change the MTU, then bring it back up again.
>
> Tested on Renesas D3 Draak board.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
