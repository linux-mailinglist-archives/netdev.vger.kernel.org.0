Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FA9FCC4B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfKNR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:58:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40433 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfKNR6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:58:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so2954609plt.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 09:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xtjRZ4N/dj5TnunKPr1ub8m5J6PxcC016TNe/Bh9Z1k=;
        b=EZv+Wg45gytZ+SSGZ2MxGiIv9faCbFgA5DBq38RREWXPPOYxT+1YkOhGIBThM1zv2s
         TR/ceK4mmS3CtlaSEFdD51xZIXTwPfo9bq+cgqr+TzMCuaniV2rwiM15zbih8G8djOBO
         1qkqwFzqGT11ywk/B3nSxFkc47m8FodSOHUBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xtjRZ4N/dj5TnunKPr1ub8m5J6PxcC016TNe/Bh9Z1k=;
        b=dCTQX68H23olah5bvJF5L/PiKb1SDuTs2ElZakmhxQSkWDfBzjn/eEIevWikTkSZlb
         o0wRvUxmSbkCC2O9a1j0luZBlCdEULALjVWqUZrpu4cVidRcbX/IPOr14mN3G9dtGbGk
         D6IFrcZSOshsU6Fa6Er3p7t4jmtSM+UJBUzJb6HEU0zHsNvdIwQFHRNOa331kLmWOY+z
         laB7O0aj9+lSDLxeSoNd0VVPruC0TC8eV6HbUT5GJCwjDe52J+ooHMs2b/H9sQjzAQMY
         pwmX/NPq/u+RbtE10qdIzX8Qvrytp18+EdqbM0d9HEMs0EniwgA2wRLwt/wXNFpo8EgY
         r1zA==
X-Gm-Message-State: APjAAAVCyTRxR0Shsw2qysViuB0GKGVy7VyP7XRplEbGns4h+KuUyBVR
        HjHKaFNMV+MrRtVsyQQ8bOszBw==
X-Google-Smtp-Source: APXvYqzLuxA1NXzpc+PtqUC7hvdD8QB6bq/rvafa9MU7QspCSAYdGw0pn8iQHHA0/Bk6SqzTzc8SsQ==
X-Received: by 2002:a17:902:d917:: with SMTP id c23mr10706341plz.199.1573754318761;
        Thu, 14 Nov 2019 09:58:38 -0800 (PST)
Received: from localhost ([2620:15c:202:1:4fff:7a6b:a335:8fde])
        by smtp.gmail.com with ESMTPSA id 13sm6901904pgu.53.2019.11.14.09.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 09:58:37 -0800 (PST)
Date:   Thu, 14 Nov 2019 09:58:36 -0800
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH v4 4/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
Message-ID: <20191114175836.GI27773@google.com>
References: <20191112230944.48716-1-abhishekpandit@chromium.org>
 <20191112230944.48716-5-abhishekpandit@chromium.org>
 <0642BE4E-D3C7-48B3-9893-11828EAFA7EF@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0642BE4E-D3C7-48B3-9893-11828EAFA7EF@holtmann.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 01:21:06AM +0100, Marcel Holtmann wrote:
> Hi Abhishek,
> 
> > Add documentation for pcm parameters.
> > 
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > 
> > ---
> > 
> > Changes in v4:
> > - Fix incorrect function name in hci_bcm
> > 
> > Changes in v3:
> > - Change disallow baudrate setting to return -EBUSY if called before
> >  ready. bcm_proto is no longer modified and is back to being const.
> > - Changed btbcm_set_pcm_params to btbcm_set_pcm_int_params
> > - Changed brcm,sco-routing to brcm,bt-sco-routing
> > 
> > Changes in v2:
> > - Use match data to disallow baudrate setting
> > - Parse pcm parameters by name instead of as a byte string
> > - Fix prefix for dt-bindings commit
> > 
> > .../devicetree/bindings/net/broadcom-bluetooth.txt    | 11 +++++++++++
> > 1 file changed, 11 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > index c749dc297624..42fb2fa8143d 100644
> > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > @@ -29,6 +29,11 @@ Optional properties:
> >    - "lpo": external low power 32.768 kHz clock
> >  - vbat-supply: phandle to regulator supply for VBAT
> >  - vddio-supply: phandle to regulator supply for VDDIO
> > + - brcm,bt-sco-routing: 0-3 (PCM, Transport, Codec, I2S)
> > + - brcm,pcm-interface-rate: 0-4 (128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps)
> > + - brcm,pcm-frame-type: 0-1 (short, long)
> > + - brcm,pcm-sync-mode: 0-1 (slave, master)
> > + - brcm,pcm-clock-mode: 0-1 (slave, master)
> 
> I think that all of them need to start with brcm,bt- prefix since it is rather Bluetooth specific.
> 
> > 
> > 
> > Example:
> > @@ -40,5 +45,11 @@ Example:
> >        bluetooth {
> >                compatible = "brcm,bcm43438-bt";
> >                max-speed = <921600>;
> > +
> > +               brcm,bt-sco-routing = [01];
> > +               brcm,pcm-interface-rate = [02];
> > +               brcm,pcm-frame-type = [00];
> > +               brcm,pcm-sync-mode = [01];
> > +               brcm,pcm-clock-mode = [01];
> >        };
> 
> My personal taste would be to add a comment after each entry that gives the human readable setting.

I'd suggest to define constants in include/dt-bindings/bluetooth/brcm.h
and use them instead of literals, with this we wouldn't rely on (optional)
comments to make the configuration human readable.
