Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3826380E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgIIU4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:56:32 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:37228 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbgIIU4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:56:32 -0400
Received: by mail-il1-f194.google.com with SMTP id b17so3692114ilh.4;
        Wed, 09 Sep 2020 13:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q00VE50B8xJP+HSBXFHIpu0Gw7Wz20ZIBGmaaL0kq8Q=;
        b=TiApGSQFPfFnpqheg5V3m+NQgHdxWplnBYgaAkxMzJqeImPL9jCjhJRJGZHn18A2Z7
         4BbBnZFnj0z6uQa00HKR3EQwqfgIIPzP5k1kiGA7UFRwTbOnHe8fKTqHxi7zDTEikC6x
         ys4bEzPbGyay3g+m+FktOmhrV4N+xS2Z0uJTdZCpTqQSQXxykNnDAAjS0k6Q4SYd+6fA
         p0PswvHnov0Rn2HVmuTRrz14CdlyxGQy4FzRN2QVRGIno+/1FBEdLbFZQBw/BiqdLYmv
         CrZM++7e6FO7MKFqDRE99Opb1RNBxn7JPhQWQ5meVgfcfNf7am0dC73UfY3bvW+5P+7/
         86QA==
X-Gm-Message-State: AOAM532rquEcW7ttRQGNabDxwl57rCWDRXRVVvjNFzaPtsaeYW1Yjv5f
        EZC9Q80ceUgumadB+FnV1w==
X-Google-Smtp-Source: ABdhPJyRAAxofQvHmZQAc2mmsb8kK8Muc7VoHcjUpOXg21heO7buqjy9KWGWlb6HvMEpF7nA9U9rjg==
X-Received: by 2002:a05:6e02:673:: with SMTP id l19mr5283707ilt.225.1599684989408;
        Wed, 09 Sep 2020 13:56:29 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id u81sm2090317ilc.52.2020.09.09.13.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 13:56:28 -0700 (PDT)
Received: (nullmailer pid 3061959 invoked by uid 1000);
        Wed, 09 Sep 2020 20:56:15 -0000
Date:   Wed, 9 Sep 2020 14:56:15 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Rob Herring <robh+dt@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909205615.GA3056507@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909162552.11032-2-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Sep 2020 18:25:46 +0200, Marek Behún wrote:
> Document binding for LEDs connected to and controlled by various chips
> (such as ethernet PHY chips).
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> ---
>  .../leds/linux,hw-controlled-leds.yaml        | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

Error: Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.example.dts:34.33-41 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:342: Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1366: dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1360778

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

