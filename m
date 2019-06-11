Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4F3D74C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406367AbfFKTzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:55:14 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35776 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406242AbfFKTzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:55:13 -0400
Received: by mail-ot1-f65.google.com with SMTP id j19so13141798otq.2;
        Tue, 11 Jun 2019 12:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2i3vf0rvzIrUcS429y9/vh3HAalX4Oc5g7401Bit/+o=;
        b=dtGsnv2yPE5aM4SpEjmjnV37V3jfaNlPDNkHOKNFiuRUzfgMcy9gJ9TOZQuwsPdmlO
         ccQnpyuLiAn+grFpsdWaMy5oDsPqnvdW6ydLhvWpG9YBBzBU5Ou8LuKUVEeefVrdyM5H
         7Nv/HN7DOURw0JuLBj4ifWjs91K6mrHe2K9Z4xP7oDwEbSSgDDmrSi8hhsY92HoBjhUS
         JbOrOLrkustJ2PbA9kr/3vfdpnml6BjuTxGfsVwo/f8fFZHWNBGb+M9ZepxmbDMMWm77
         O9UwSNY1M20+PU7eGRCyEXQOeMc48xIW8IX9XiHJx7sMii+RKPjZ+aMORy3UDFUwovQJ
         3Iog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2i3vf0rvzIrUcS429y9/vh3HAalX4Oc5g7401Bit/+o=;
        b=cK+2YUjBrZRLzSEFHz8YInA9FVIckSGy3I0ZLY/kOyM6vbcaJb4fzLkBnqz/N/grb9
         hNcLIoGdULlqsFRukFxk6/4ThWVWt7D7J0aJyRXebfWp32q0jXsfKQ+xIOdqeP3LWS/4
         VqKJ5O6psKmAgsQI6L8xQH6fiqh3+xRiN4ZdZDMrgxJUqnZf3NebO02uKf3YvRPtRsQQ
         5Hji82KgGvmVUGTwz7yslSXCjJvzEux9Ye/eBrRGjJH2UzlxBrxMswzAiUlA7vVUQMCz
         hZ+Abm6od4yLOvqOQHdHYwf8kh5YKqWcF1xt0IucbelefIlrO6vTW1VXDRvDwIEnptws
         uMgw==
X-Gm-Message-State: APjAAAWmixi+acmhOsMzzqDiDpFCRoKF65d/yP1+R7GgLaVNLB/sSGte
        ULwXQGliRvcMyUamfR47GoV+3+S00u+XYHfHFfc=
X-Google-Smtp-Source: APXvYqzsQM9kPsCqm9oHigjo0WuLHVlsFvcp2RFkRgadZQhoVDfqn8f7WCfVTe6ekcSET4BOaM8howSBFhMuozDOY8k=
X-Received: by 2002:a9d:32a1:: with SMTP id u30mr35281383otb.371.1560282912579;
 Tue, 11 Jun 2019 12:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190522052002.10411-1-anarsoul@gmail.com> <6BD1D3F7-E2F2-4B2D-9479-06E27049133C@holtmann.org>
 <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org> <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
In-Reply-To: <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Tue, 11 Jun 2019 12:56:02 -0700
Message-ID: <CA+E=qVdLOS9smt-nBxg9Lon0iTZr87kONSp-XPKj9tqB4bvnqw@mail.gmail.com>
Subject: Re: [PATCH] Revert "Bluetooth: Align minimum encryption key size for
 LE and BR/EDR connections"
To:     Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg,

Can we get this revert merged into stable branches? Bluetooth HID has
been broken for many devices for quite a while now and RFC patch that
fixes the breakage hasn't seen any movement for almost a month.

Regards,
Vasily

On Thu, May 23, 2019 at 7:52 AM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> On Wed, May 22, 2019 at 12:08 AM Marcel Holtmann <marcel@holtmann.org> wrote:
> >
> > Hi Vasily,
> >
> > >> This reverts commit d5bb334a8e171b262e48f378bd2096c0ea458265.
> > >>
> > >> This commit breaks some HID devices, see [1] for details
> > >>
> > >> https://bugzilla.kernel.org/show_bug.cgi?id=203643
> > >>
> > >> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > >> Cc: stable@vger.kernel.org
> > >
> > > let me have a look at this. Maybe there is a missing initialization for older HID devices that we need to handle. Do you happen to have the full btmon binary trace from controller initialization to connection attempt for me?
> > >
> > > Are both devices Bluetooth 2.1 or later device that are supporting Secure Simple Pairing? Or is one of them a Bluetooth 2.0 or earlier device?
> >
> > I am almost certain that you have a Bluetooth 2.0 mouse. I made a really stupid mistake in the key size check logic and forgot to bind it to SSP support. Can you please check the patch that I just send you.
> >
> > https://lore.kernel.org/linux-bluetooth/20190522070540.48895-1-marcel@holtmann.org/T/#u
>
> This patch fixes the issue for me. Thanks!
>
> >
> > Regards
> >
> > Marcel
> >
