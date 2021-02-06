Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF1311FDF
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBFUOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFUOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A0C164E02;
        Sat,  6 Feb 2021 20:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612642404;
        bh=f8qhTJD7/YtaUs4LthL3OvIjhVnr54iLSmkEkhXsffc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ssXGiEGMXN/CyrtSbqgy7H31M6MViVUzi+fhIppB03f0J2s2Sb4QRS3G5QTrNhl30
         282cSoVV5P04O8WlffI5b6vRLAhHDuLYUjdH4zBXSEOd6cB3MhXWxx0z0O+EWMM2W0
         Zhf/kG4GDN/Jc/XGglckrJucEvep5jh+DjIs+6uY1ZdqHbNpKDMWMWPMV8lUEQ7LjK
         RotzTCbTEmD+dt+A6PxQCedx2QhdiII7gmTfPlALLpz5aVKA4yB+/YBX7GZTn7dL+Q
         uEtkdwIoEPFzVybpTUVGPh0BVCJ3H8dnZ7ED6NmeQoL6FZI7oQvIih7TXlADl+tEsS
         HHbhgX3TnkISA==
Date:   Sat, 6 Feb 2021 12:13:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Message-ID: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
References: <20210205173904.13916-1-lech.perczak@gmail.com>
        <20210205173904.13916-2-lech.perczak@gmail.com>
        <87r1lt1do6.fsf@miraculix.mork.no>
        <0264f3a2-d974-c405-fb08-18e5ca21bf76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 15:50:41 +0100 Lech Perczak wrote:
> >> Cc: Bj=C3=B8rn Mork<bjorn@mork.no>
> >> Signed-off-by: Lech Perczak<lech.perczak@gmail.com> =20
> > Patch looks fine to me.  But I don't think you can submit a net and usb
> > serial patch in a series. These are two different subsystems.
> >
> > There's no dependency between the patches so you can just submit
> > them as standalone patches.  I.e. no series. =20
> Actually, there is, and I just noticed, that patches are in wrong order.
> Without patch 2/2 for 'option' driver, there is possibility for that=20
> driver to steal
> interface 3 from qmi_wwan, as currently it will match interface 3 as=20
> ff/ff/ff.
>=20
> With that in mind I'm not really sure how to proceed.
>=20
> What comes to my mind, is either submit this as series again, with=20
> ordering swapped,
> or submit 2/2 first, wait for it to become merged, and then submit 1/2.

Send patch 2, wait for it to hit net, send 1 seems like the safest
option. If we're lucky Johan can still send patch 2 for 5.11, otherwise
we'll wait until the merge window - we're at rc7 already, it won't take
too long.
