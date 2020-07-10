Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB621B262
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 11:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGJJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 05:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJJg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 05:36:57 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEC8C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:36:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id o4so2832042lfi.7
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 02:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=E8HjmpxrwdpS9dPRr9mJPtyj1djsjqFeEs1mfrwR2Gc=;
        b=V247YxggWqQttnAv++aU1Bb5IDcoTlJ4/La2oD4NHfdT/SJkuz1H17I5QnVPW5ZYqE
         OqmrhQnV1MPJr72n2Rdun8UtJHiLML0By53pArWHOOQa+LmzRZA75yxBXxvVzagLXl28
         O2vBmLdlc5qFG74JbKexMDQUjXLfCvnFydg40Nro8t9+HLNwmRuE+lc5L29YADiPWcbO
         9vkLmWKav60J4VLDuhDTT4ZqwBJKuObjYe3uxFiNLBQBbKXeNm4Dngg/47Iujduq6q00
         Iex8tfuxymTyZJfuGy4KRbcmeV8h8zrTLdKoWkylH0ftsD5S0ITf1aBGurj48BqYFNTd
         UBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=E8HjmpxrwdpS9dPRr9mJPtyj1djsjqFeEs1mfrwR2Gc=;
        b=XbLeFHpFff6zD8Dti0vLRl7blOU0imnvHVoVR/sjPl+jm8nx5nOGaRWKZqs/DVSiY4
         Gb9Dv6PMTd4uKgC4ueDDuzXhGnUIbziD3HSfzgZOu03crfnirJzkv50Kie6JS4FNUif3
         iA6g7xk9Cpwg6O3bPHI/WwgegGZEswAyBLEzKrtjyLLN8DEIHDYq6uBX266zlU/ffPJM
         dJKFAVuuemFI77Xmw94etbQ0gbqpLXPuY+j9cC1VMq1Ys0zAizeL7ZwXKXoc05hF2swK
         rZStVz2D39lA+YqPnMfZEsudWRF/Q2QAEFGBtH3FMdL5BX2D/Rhv/zFpzPAB/hkE5c/e
         h/xw==
X-Gm-Message-State: AOAM531IYKvsaoz/VWYlgHVT2sKNvXdo+G1p2CbuRx7WB6NTzsXrvQH1
        lYKKvAzn+BMJzjZNrG53jXK9SQ==
X-Google-Smtp-Source: ABdhPJw+Rjh+CNopge8GTT7QqAgtx9+y8vnbjoHh2LU36C/AVE6wZBODj2S7rwV+2tQ+nLwpVL3TBA==
X-Received: by 2002:a19:ccd0:: with SMTP id c199mr42789526lfg.194.1594373815411;
        Fri, 10 Jul 2020 02:36:55 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id u25sm2494425lju.54.2020.07.10.02.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 02:36:54 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "Tobias Waldekranz" <tobias@waldekranz.com>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
Subject: Re: MDIO Debug Interface
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>
Date:   Fri, 10 Jul 2020 11:30:21 +0200
Message-Id: <C42U7ICFS9TP.3PIIHGICUXOC4@wkz-x280>
In-Reply-To: <20200709233337.xxneb7kweayr4yis@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jul 10, 2020 at 4:33 AM CEST, Vladimir Oltean wrote:
> On Fri, Jul 10, 2020 at 01:20:35AM +0200, Andrew Lunn wrote:
> > > Virtualization is a reasonable use case in my opinion and it would
> > > need something like this, for the guest kernel to have access to its
> > > PHY.
> >=20
> > And i would like a better understanding of this use case. It seems odd
> > you are putting the driver for a PHY in the VM. Is the MAC driver also
> > in the VM? As you said, VM context switches are expensive, so it would
> > seem to make more sense to let the host drive the hardware, which it
> > can do without all these context switches, and export a much simpler
> > and efficient API to the VM.
> >=20
> >     Andrew
>
> The MAC driver is also in the VM, yes, and the VM can be given
> pass-through access to the MAC register map. But the PHY is on a shared
> bus. It is not desirable to give the VM access to the entire MDIO
> controller's register map, for a number of reasons which I'm sure I
> don't need to enumerate. So QEMU should be instructed which PHY should
> each network interface use and on which bus, and it should fix-up the
> device tree of the guest with a phy-handle to a PHY on a
> para-virtualized MDIO bus, guest-side driver of which is going to be
> accessing the real MDIO bus through this UAPI which we're talking about.
> Then the host-side MDIO driver can ensure serialization of MDIO
> accesses, etc etc.
>
> It's been a while since I looked at this, so I may be lacking some of
> the technical details, and brushing them up is definitely not something
> for today.
>
> -Vladimir

Have you considered the case where the PHY is only a slice of a quad-
or octal PHY?

I know that on at least some of these chips, all slices have access to
global registers that can have destructive effects on neighboring
slices. That could make it very difficult to implement a secure
solution using this architecture.
