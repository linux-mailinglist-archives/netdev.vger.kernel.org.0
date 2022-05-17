Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0026B529629
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 02:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiEQArL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 20:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiEQArJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 20:47:09 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A00A13E29;
        Mon, 16 May 2022 17:47:07 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id r1so20666995oie.4;
        Mon, 16 May 2022 17:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iJgSIj5Vbgqm2lP3FwW0wvqzkGV+5Vch0R+WtavPeG0=;
        b=W6Iaxo2tTFnThXN2NtnFkpzgiSOSvv5Irqvx6XBdsnSbQcR4kQ1Q2l/rO+o76W0Ky6
         Ncv5M4w6c/XHLsbqcUbZkd9CJb1/y+awEgq/Dd06FPkUwbCoqJaIteTFNyAzUmbv3sJU
         AhPzCeQ0p8AThNuf8Epc7ax6dfQkKIlunk61k3ShWNTbs3oHQXuiaXzSjMj58o1qN4pb
         YyJ9fKLbxqDzmRgpqEpfeiKR2+XxU93/sJwuP4vtAp3c48qvTaO2tkjG3HRUR2h6hrwX
         yu8IAaz72LGJPRq/jEq/1Pec8LFVRFqi3tqtnNWZ/DZyng5jm7+oJc2fv6WNCGriPMxW
         C3kA==
X-Gm-Message-State: AOAM531qgZP4KLzD2R3a+N1zBPKPTaHFp/obln92Vq8pKQaBeEzaY9Xt
        PFzxpn8zxYEuZpMNtjWKwQ==
X-Google-Smtp-Source: ABdhPJzxUe7lRWwSsk4LYTIlf0trAXfo6l1O3t5y3u2IE0dc+3FfnlSJCRjFtF4GffGFbK7487ochw==
X-Received: by 2002:a05:6808:1585:b0:326:6477:64b2 with SMTP id t5-20020a056808158500b00326647764b2mr9172703oiw.173.1652748426873;
        Mon, 16 May 2022 17:47:06 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g9-20020a05683030a900b0060603221248sm4499696ots.24.2022.05.16.17.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 17:47:06 -0700 (PDT)
Received: (nullmailer pid 3682863 invoked by uid 1000);
        Tue, 17 May 2022 00:47:04 -0000
Date:   Mon, 16 May 2022 19:47:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Brown <broonie@kernel.org>,
        LABBE Corentin <clabbe@baylibre.com>,
        alexandre.torgue@foss.st.com, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, samuel@sholland.org, wens@csie.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/6] dt-bindings: net: Add documentation for phy-supply
Message-ID: <20220517004704.GA3654797-robh@kernel.org>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
 <Ynk7L07VH/RFVzl6@lunn.ch>
 <Ynk9ccoVh32Deg45@sirena.org.uk>
 <YnlDbbegQ1IbbaHy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnlDbbegQ1IbbaHy@lunn.ch>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 06:38:05PM +0200, Andrew Lunn wrote:
> > No, that's not a thing - the supplies are individual, named properties
> > and even if there were a list we'd still want them to be named so it's
> > clear what's going on.
> 
> So we have a collection of regulators, varying in numbers between
> different PHYs, with different vendor names and purposes. In general,
> they all should be turned on. Yet we want them named so it is clear
> what is going on.

In what order do we turn the supplies on? How much time in between each 
one? Does an external clock need to be running before or after (and how 
long after). Oh, and what about resets and the order and timing of them 
relative to everything else?

This always happens in the same order. First, it's just one resource 
like a regulator or reset. Then one more. Then another device with some 
timing constraints. If we wanted a generic solution in DT, it would need 
to be able to describe any power sequencing waveform. But we don't have 
that because we don't want it. 

> Is there a generic solution here so that the phylib core can somehow
> enumerate them and turn them on, without actually knowing what they
> are called because they have vendor specific names in order to be
> clear what they are?

Other devices have specific compatibles so that the device can be 
identified and powered up. Once again, MDIO should not be special here.

> There must be a solution to this, phylib cannot be the first subsystem
> to have this requirement, so if you could point to an example, that
> would be great.

Well, no one seems to want to make non-discoverable devices on 
'discoverable' buses work. Still an issue for PCI and USB. I thought 
MDIO had a solution here to probe any devices in the DT even if not 
discovered.

Rob
