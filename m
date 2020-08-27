Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFA254B56
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgH0RA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0RA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 13:00:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4523C061264;
        Thu, 27 Aug 2020 10:00:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q16so3334209ybk.6;
        Thu, 27 Aug 2020 10:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xn9e8QiSfQjfmv9dvYGGI9EBZKWaBpd/I2U5mUE1tdE=;
        b=PS28p8gtpgp5Vzmtu8C8Fn69h9JbIZLvzinkhZ2VyIy3eTvrrbRHZKK4e0X+S2HoYc
         2ht0sqrAPSZP5wC4rEdgvlanP38jwoYA5gvs1a6CG9GeHyR6ac+LqKIr0bwn7rKWAksT
         +Jnz6WdeesntSn4mFO+1jVcTpyth5j7J+Vy/05SMpk56xcAWcqLVcn2GMXnukQUowFqk
         +Lwbfs1JMDSfElZQK2Vus32IYWbcURmEHaMfH2pztvogga5OyHAjbpZP8CIrX0OXtSrc
         MmZzCb5KDFWhzu+f2jWG6oR83iyADCOYDUjDiDurt8cV8fborBSzq1yr88HVmzwc8eiJ
         tPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xn9e8QiSfQjfmv9dvYGGI9EBZKWaBpd/I2U5mUE1tdE=;
        b=UNPO/PjxGsd0qgUbgjV0iKkSk/VGkHudUh/q2d+Y/WJDNOX2Ff+b9u17hbAzBzH6ql
         1Mfl0FPLCWKrN3pusNWV0XXVRiVPKfXYi6F0jQSgtcmoQZr6fSomLA3ISwOF77P8pzoF
         mgcb9EWX0eSHE63Hdr/WGrcAhTQOvlDFi+h+PJGSZxHVHnvD49r2gwhULCl/f1Kc+2iG
         3Kg9/M4m7345z75ZYhKLAMge7EiXcBctG6Mj805PLBBA4bw0Xxj4hazglEO7S1Ah8VC1
         C/I0f9ouXYFeqJZznxawk/qPQVqI/hzDuMkWnjaI/3RTIYo+ALugl2VjhchkpCTTee/l
         9/Vg==
X-Gm-Message-State: AOAM530ER8RXWUHa6d2E04BJMBLotc2wdZiREVoBTTJTa0vEe/B6I9O8
        nsx9+nFwMw1mCtYcWcBDiGyR/ty74FGYXJeJXXs=
X-Google-Smtp-Source: ABdhPJzWiP13RDlFWXYqZS9M+n/syiQtjHPq+mDPjJNKGxrQjLeEpeZ4VcNxTZaUseudqJ0OnSwa50hS9cPCBO2SK/M=
X-Received: by 2002:a25:e712:: with SMTP id e18mr28991911ybh.395.1598547655180;
 Thu, 27 Aug 2020 10:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Thu, 27 Aug 2020 18:00:29 +0100
Message-ID: <CA+V-a8sBF2ak+dYd9g=Tf_2Kwz_Om2mpK=z+KzGQQG4qJM-+zA@mail.gmail.com>
Subject: Re: [PATCH 05/20] dt-bindings: timer: renesas,cmt: Document r8a774e1
 CMT support
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel and Thomas,

On Wed, Jul 15, 2020 at 12:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> Document SoC specific bindings for RZ/G2H (r8a774e1) SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/timer/renesas,cmt.yaml | 2 ++
>  1 file changed, 2 insertions(+)
>
Gentle ping.

Cheers,
Prabhakar
