Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F7B105BF5
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfKUV31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:29:27 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34884 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfKUV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:29:26 -0500
Received: by mail-oi1-f196.google.com with SMTP id n16so4629170oig.2;
        Thu, 21 Nov 2019 13:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eGbzdNGOz3Yt/u7Eg4Uy04gh1oqlzxGRM1Q5IoNwLyo=;
        b=oq+KBdWNqg48CN7mCNZVLmMylCyaroBTDIEad25MjBX1Nsfxk6oI9UOgM+OK0lMx0p
         WX6qldlPHvNMCsK4LJ7JoxVdD8P13Lh6Ib/PyNl11JAGqQTPQjtTYgn8Yc9bNusfeUj0
         nOJHT4lyww1SA8KTP8fFXiPGj8XwecCEXa6dHR3lO5S3gGTktPIEEFDo09simKLYLpHE
         ST1agA4yZ+kZC/ldtN0ySbFF1HWU8U0IPCZBpFr6N9SJCnWrTVmEsmb4AFYQ0kE19kfv
         PtRE7ICNjDHHHZT+NlUKEoD7zeov93v10T//Ist0nD8hNmAvB358hTUL/Lc4fAd6+sda
         znDA==
X-Gm-Message-State: APjAAAW9hIvuWaOOql1cVmLXAMfM0LBUVgzhSLo0Z/AiwWsAG4b+fRSC
        PsjQbEal8nNGs6AYvmjzJg==
X-Google-Smtp-Source: APXvYqzotq60JyOQtDHz/zQ7q1sK4SuGVHd+xXyqMSXmeZsC7zXDHbM2laGjpVcYF8WIemWHY5+y9Q==
X-Received: by 2002:aca:57d7:: with SMTP id l206mr9713923oib.32.1574371764980;
        Thu, 21 Nov 2019 13:29:24 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m20sm1408047otr.47.2019.11.21.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:29:24 -0800 (PST)
Date:   Thu, 21 Nov 2019 15:29:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
Message-ID: <20191121212923.GA24437@bogus>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 11:21:22AM -0800, Abhishek Pandit-Subedi wrote:
> Add documentation for pcm parameters.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None

Really? I'm staring at v2 that looks a bit different.

>  .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
>  include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
>  2 files changed, 48 insertions(+)
>  create mode 100644 include/dt-bindings/bluetooth/brcm.h
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index c749dc297624..8561e4684378 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -29,10 +29,20 @@ Optional properties:
>     - "lpo": external low power 32.768 kHz clock
>   - vbat-supply: phandle to regulator supply for VBAT
>   - vddio-supply: phandle to regulator supply for VDDIO
> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
> + - brcm,bt-pcm-frame-type: short, long
> + - brcm,bt-pcm-sync-mode: slave, master
> + - brcm,bt-pcm-clock-mode: slave, master

Little of this seems unique to Broadcom. We already have some standard 
audio related properties for audio interfaces such as 'format', 
'frame-master' and 'bitclock-master'. Ultimately, this would be tied 
into the audio complex of SoCs and need to work with the audio 
bindings. We also have HDMI audio bindings. 

Maybe sco-routing is unique to BT and still needed in some form though 
if you describe the connection to the SoC audio complex, then maybe 
not? I'd assume every BT chip has some audio routing configuration.

Rob
