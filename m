Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3582713B0D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfEDQBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:01:12 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43313 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEDQBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:01:11 -0400
Received: by mail-ot1-f66.google.com with SMTP id e108so7932472ote.10;
        Sat, 04 May 2019 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9t8LCWyfp/pOAtfgPb8iwJH/k7FZiFO2TuX9+ZiH3e8=;
        b=XDst6UReaqewQc01UyXXsd9Cde8Cl/0ul6VQbBK/rPCuWcURU0P/u2JCu+gbJcdw0Y
         rpYVuoIasC9ghLEO/DnX83JS7wqZlvEuEJD3A73XkXn3Cra9Mh6m1qQcfDzaZXVw02gx
         +wCHGkUFJuxm+soaWav453qgAxRh4xsftNKZGBw3eCDE5d9BsTl4zShNGq4aT0AlU9eh
         wYFRkhK+r0mb8QwJY9VEMw3/gDaxXJ5YmWXt5UPBBAAEKoY1xkL3qspj1rwAjFpWj9iq
         KYStV1TQzFFTse0VkFBqWzwFkAHTQxg3o3DoZjwyV7q4e/rmMWn+W2JeceC4Y4cY5r2T
         iADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9t8LCWyfp/pOAtfgPb8iwJH/k7FZiFO2TuX9+ZiH3e8=;
        b=rXN+z7HMt+tFMyiYMk7F6RXTNeiadmOTkzK+qkT26lbdA8W3KKL0mHvtn/4/4IFEJe
         yaqWxSHYRUwkHpGxf1sIY2mlVFwzQwTCdzO4MsgqtDjyp3KP/rBbE402wKILC1z87zwv
         VU91CqUUs2WS4V61mtEDheJaOfoOGkmzPss3cwKJB+tAtB2pXuBKBdBWL0Q3Y0pR6KxC
         QPkieF4vxxxygy154VI6rBmsqRThVo8C5QVyWP9FE7KslPdMDf3FHN1jAvFISiv8YB+Z
         +GzJfT3sjmn3n6g8YGqNfgMU6pMBFKKtipKkRODlxED+Wh7RcqoZuE+yHMWYXEkim7b6
         1FKg==
X-Gm-Message-State: APjAAAUvUFQ7cdILgrp+DXydjyIBUzumhq14NBokrkhR4Yco3y1hgSab
        rJaC28eOvUIJwRGmmXiBzRFYMKwmxvF6Ljmegfk=
X-Google-Smtp-Source: APXvYqxjdCLLQjiN6f/+hMfblnZSqvLsRxwwQad7eZvZjFfwokiUdx1JaLIvkLHcv1cUqulotQHYpffhDAYbxZ0DLXk=
X-Received: by 2002:a9d:6153:: with SMTP id c19mr10865780otk.110.1556985670995;
 Sat, 04 May 2019 09:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190422064046.2822-1-o.rempel@pengutronix.de>
In-Reply-To: <20190422064046.2822-1-o.rempel@pengutronix.de>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sun, 5 May 2019 00:01:00 +0800
Message-ID: <CAJsYDV+1dXfQ3qKMDkbbXa94UQ+DiNCQ3YQB=PTkeXJ19Xa8uQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] MIPS: ath79: add ag71xx support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Mon, Apr 22, 2019 at 2:41 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> [...]
> - most of deficetree bindings was removed. Not every thing made sense
>   and most of it is SoC specific, so it is possible to detect it by
>   compatible.

I noticed that you've dropped all PLL and gmac-config stuff. These are
board-specific properties and PLL registers should be changed
accroding to negotiated ethernet speed. By dropping them, you rely on
bootloader to configure everything corectly for you (which has been
proven unreliable for many ath79 routers) and ethernet won't work if
negotiated speed changed after u-boot's configuration.

Regards,
Chuanhong Guo
