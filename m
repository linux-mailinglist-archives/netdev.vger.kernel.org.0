Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C675FCEB4
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKNTVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:21:54 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40388 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfKNTVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:21:54 -0500
Received: by mail-qk1-f194.google.com with SMTP id z16so6017766qkg.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2+dA9T6MH4sNbOzz4jWY/HUz9UYvTwVEPvgzw5IY25o=;
        b=JX54imOvMkg6TCZIIl7TjVODjvdE3eJWOBIn/TFXI/K3XBbyoUgnyMHp3+jWXwZcpA
         qC9dQDhc9YTs0ZD5QD1D5sVEP0wVu3UriNJS/O8GlMjey/Yo50i1c5JxHNugoR7fOFse
         v1ZuqMc/cGqti3BKA5y6oQGs2EJ00KMkWFCU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2+dA9T6MH4sNbOzz4jWY/HUz9UYvTwVEPvgzw5IY25o=;
        b=U1koht0XxuF6Jr2Z5p4noAhQwh4j6algmvqziqkJVRWKBGUL2YcOU+xcZi2RLNqxOo
         VGijSovU/QHgsFTixu+vQU4I9X4ZcHbtMqqCZ3iWxwWxx4BpiqGv74yeZjQCMmbtYpCM
         32UXTIqjYSAKGGx6E3ec65JIASPALskKse1845N/mW+4UBdvTMCrUX/HrwF62SdeTdYV
         rnsqncwe5dtNa0l8OVpvLLm2VyFXeX7oPd2L/nhUuk0DnlszT/SbopKe2bOsXax0hDYS
         LZrGac8YSeEESiodN8dUe/u6Mbd1yS8HKebfdcFx9OmgWswtiQ9hyeICjSbdB7fhp3AS
         Xn3w==
X-Gm-Message-State: APjAAAXrE7Zba/x+A2ZpTCuOIVcWLL0dzh2kfqLcyHqkWCjChInEOi/n
        tfCqFue/5etLWEun/IEZDSqre8n0DMJRss4lbqZCyw==
X-Google-Smtp-Source: APXvYqzt7LFP6F0xw3d3PYvSjUoOlxGbFwywBADu+rd0E/KeDMf/vRwQbeoderg31GWDs+7zrfVUalr6EybZ5j7ItHM=
X-Received: by 2002:a05:620a:1032:: with SMTP id a18mr7536658qkk.305.1573759313671;
 Thu, 14 Nov 2019 11:21:53 -0800 (PST)
MIME-Version: 1.0
References: <20191112230944.48716-1-abhishekpandit@chromium.org>
 <20191112230944.48716-5-abhishekpandit@chromium.org> <0642BE4E-D3C7-48B3-9893-11828EAFA7EF@holtmann.org>
 <20191114175836.GI27773@google.com>
In-Reply-To: <20191114175836.GI27773@google.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Thu, 14 Nov 2019 11:21:42 -0800
Message-ID: <CANFp7mXfhs3mw_QuVQHcQwkz8+4DpJ8SMbTiwS=7fo5kXGrBQQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] dt-bindings: net: broadcom-bluetooth: Add pcm config
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 9:58 AM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> On Wed, Nov 13, 2019 at 01:21:06AM +0100, Marcel Holtmann wrote:
> > Hi Abhishek,
> >
> > > Add documentation for pcm parameters.
> > >
> > > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > >
> > > ---
> > >
> > > Changes in v4:
> > > - Fix incorrect function name in hci_bcm
> > >
> > > Changes in v3:
> > > - Change disallow baudrate setting to return -EBUSY if called before
> > >  ready. bcm_proto is no longer modified and is back to being const.
> > > - Changed btbcm_set_pcm_params to btbcm_set_pcm_int_params
> > > - Changed brcm,sco-routing to brcm,bt-sco-routing
> > >
> > > Changes in v2:
> > > - Use match data to disallow baudrate setting
> > > - Parse pcm parameters by name instead of as a byte string
> > > - Fix prefix for dt-bindings commit
> > >
> > > .../devicetree/bindings/net/broadcom-bluetooth.txt    | 11 +++++++++++
> > > 1 file changed, 11 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > > index c749dc297624..42fb2fa8143d 100644
> > > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > > @@ -29,6 +29,11 @@ Optional properties:
> > >    - "lpo": external low power 32.768 kHz clock
> > >  - vbat-supply: phandle to regulator supply for VBAT
> > >  - vddio-supply: phandle to regulator supply for VDDIO
> > > + - brcm,bt-sco-routing: 0-3 (PCM, Transport, Codec, I2S)
> > > + - brcm,pcm-interface-rate: 0-4 (128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps)
> > > + - brcm,pcm-frame-type: 0-1 (short, long)
> > > + - brcm,pcm-sync-mode: 0-1 (slave, master)
> > > + - brcm,pcm-clock-mode: 0-1 (slave, master)
> >
> > I think that all of them need to start with brcm,bt- prefix since it is rather Bluetooth specific.
> >
> > >
> > >
> > > Example:
> > > @@ -40,5 +45,11 @@ Example:
> > >        bluetooth {
> > >                compatible = "brcm,bcm43438-bt";
> > >                max-speed = <921600>;
> > > +
> > > +               brcm,bt-sco-routing = [01];
> > > +               brcm,pcm-interface-rate = [02];
> > > +               brcm,pcm-frame-type = [00];
> > > +               brcm,pcm-sync-mode = [01];
> > > +               brcm,pcm-clock-mode = [01];
> > >        };
> >
> > My personal taste would be to add a comment after each entry that gives the human readable setting.
>
> I'd suggest to define constants in include/dt-bindings/bluetooth/brcm.h
> and use them instead of literals, with this we wouldn't rely on (optional)
> comments to make the configuration human readable.

:+1: Sounds like a good idea; expect it in next patch revision
