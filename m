Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47827109366
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKYSUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:20:13 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39924 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfKYSUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:20:12 -0500
Received: by mail-qk1-f196.google.com with SMTP id z65so8857574qka.6
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 10:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W09lgIqIKvECTOE849gv8T7YDNLO2Wc4fhvJ0YJldxk=;
        b=ERy+HFLCmw98rZ+6jHEb6CK3h+hzq2Xd1fFuuD5w5bfjxs7aw6AgNsqMmhI3QlbWoC
         y0EfJHErAyaz5xlU7Jv89vsAFHpCFp5adnNr6SmEtm7k5JicUESHRlKQftaWhofNPGO/
         2k6Bym+4k9FYiNEA40m6ydBprmxzen/r0nvrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W09lgIqIKvECTOE849gv8T7YDNLO2Wc4fhvJ0YJldxk=;
        b=qJlmi8HOZFXc2DlCmNztSqykY6IXqgz2m3Us84UlnDuIzvEKsz7R9yiD6fCP05V7Qe
         F1KqgpCSWBfdJxBpNmmzsnFN6FISehPxFDI5KDMDNE1PNWn4sfzdLmH9CMv37WC/ugrO
         Ax1wNWGhSIBpOrfHEGz4R7VPT+v91b+PJEwYrO7A0TTGhFovpD57tAXYGadL5RDCcmce
         0pIzk3KmKUJ+tjhV74riEKWlOhZiYQP5XonKiYY/2HEcTlpYFBjlExQACb0g4Gr0SSlh
         D1CLu71hnaI9Ggh9EeJpKwSIRVDs8V2cw46+L2l6TLTe6MrXIRH+4OJPk+TBkcMAyjk+
         g9zQ==
X-Gm-Message-State: APjAAAWLLhC8cVydoJ+Pzw21dfRR30tv8WxmeJCWD3Z/TjZ3wGlv/U/p
        Zi60ir16mzyg85U5KS6av8tzuQMfWxVV2WI6//6Zjw==
X-Google-Smtp-Source: APXvYqyViSiFgUBvDzO1mVVyfrDrv1aJlHc6bYxT/J8Hw5dcdeuarzA4nQsAObckQJK0CIoKANHAPwHuY9MKcyA5yUo=
X-Received: by 2002:a37:5b02:: with SMTP id p2mr27051982qkb.419.1574706011770;
 Mon, 25 Nov 2019 10:20:11 -0800 (PST)
MIME-Version: 1.0
References: <20191118192123.82430-1-abhishekpandit@chromium.org> <1CEDCBDC-221C-4E5F-90E9-898B02304562@holtmann.org>
In-Reply-To: <1CEDCBDC-221C-4E5F-90E9-898B02304562@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 25 Nov 2019 10:20:00 -0800
Message-ID: <CANFp7mXNPsmfC_dDcxP1N9weiEFdogOvgSjuBLJSd+4-ONsoOQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354 support
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

It looks about the same as one of my earlier patch series. Outside a
few nitpicks, I'm ok with merging this.

Thanks
Abhishek

On Sat, Nov 23, 2019 at 2:04 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Abhishek,
>
> > While adding support for the BCM4354, I discovered a few more things
> > that weren't working as they should have.
> >
> > First, we disallow serdev from setting the baudrate on BCM4354. Serdev
> > sets the oper_speed first before calling hu->setup() in
> > hci_uart_setup(). On the BCM4354, this results in bcm_setup() failing
> > when the hci reset times out.
> >
> > Next, we add support for setting the PCM parameters, which consists of
> > a pair of vendor specific opcodes to set the pcm parameters. The
> > documentation for these params are available in the brcm_patchram_plus
> > package (i.e. https://github.com/balena-os/brcm_patchram_plus). This is
> > necessary for PCM to work properly.
> >
> > All changes were tested with rk3288-veyron-minnie.dts.
>
> so I have re-factored your patch set now to apply to latest bluetooth-nex=
t tree and posted it to the mailing list. Please have a look at it if this =
works for you. If it does, then we might just apply it this way and focus o=
n getting detailed PCM codec configuration for all vendors in once we have =
a second vendor to unify it.
>
> Regards
>
> Marcel
>
