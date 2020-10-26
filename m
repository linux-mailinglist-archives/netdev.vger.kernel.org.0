Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CFE298E8D
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780749AbgJZNyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:54:55 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40076 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780737AbgJZNyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:54:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id f97so8051861otb.7;
        Mon, 26 Oct 2020 06:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b7baIeex9tBAg+HC/pCtQM4CcA9Yu/P2Kiz6rbkWWFQ=;
        b=MtYW6Ad6rR+kaOc5JUFmVJKy7bNon8ZWrlNEuTOe1QIEPgFd4JIQCS7cGdbPSJEPGL
         NC3/pf2WeY/quN4BSScvztd9/1/XroHjGgbg6/7pmTmYpl/W2bAZPcPllzdlmw0wovlN
         7GL8sdPo0tdPERTb4ZO2x/T0fSA200sxicK15PBnFJQPIx1ph6IGRcgxYafimvT0y5B2
         azMqZrKQ++Cc8t+n95kYTF8b//nTRogJ0+cwsND3lTZSCwUNdHtq+WFXmjm88U96Pw3n
         L3FFVUjqvm5EGEktMyQY090KD1qO0XgN20xc+POCuPK2dD/NfWTnmDlqjTsEHjSVj4ky
         hiDQ==
X-Gm-Message-State: AOAM530xEmhrt1xGqMFE7ajQfxo/PNo7OnlhIqt4T0bDokO9F1QqBfE3
        RVsbTDbHYkFJwQvIrvthbQ==
X-Google-Smtp-Source: ABdhPJy+AVVJtyh1P388ilZ7a32F26K4IYL2djBrl+syNcAqhG7//EwYrauP3uzH8LOgA6YbEu+okg==
X-Received: by 2002:a9d:2389:: with SMTP id t9mr10836030otb.329.1603720493673;
        Mon, 26 Oct 2020 06:54:53 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f9sm3903361ooq.9.2020.10.26.06.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 06:54:52 -0700 (PDT)
Received: (nullmailer pid 65566 invoked by uid 1000);
        Mon, 26 Oct 2020 13:54:51 -0000
Date:   Mon, 26 Oct 2020 08:54:51 -0500
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Christian Eggers <ceggers@arri.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201026135451.GA57974@bogus>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-2-ceggers@arri.de>
 <87lfg0rrzi.fsf@kurt>
 <20201022001639.ozbfnyc4j2zlysff@skbuf>
 <3cf2e7f8-7dc8-323f-0cee-5a025f748426@gmail.com>
 <87h7qmil8j.fsf@kurt>
 <20201022123735.3mnlzkfmqqrho6n5@skbuf>
 <63bc70fe-30b3-43f1-a54c-b8c82bbdc048@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63bc70fe-30b3-43f1-a54c-b8c82bbdc048@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:17:26PM -0700, Florian Fainelli wrote:
> On 10/22/20 5:37 AM, Vladimir Oltean wrote:
> > On Thu, Oct 22, 2020 at 12:54:52PM +0200, Kurt Kanzenbach wrote:
> >> On Wed Oct 21 2020, Florian Fainelli wrote:
> >>> On 10/21/2020 5:16 PM, Vladimir Oltean wrote:
> >>>> On Wed, Oct 21, 2020 at 08:52:01AM +0200, Kurt Kanzenbach wrote:
> >>>>> On Mon Oct 19 2020, Christian Eggers wrote:
> >>>>> The node names should be switch. See dsa.yaml.
> >>>>>
> >>>>>> +            compatible = "microchip,ksz9477";
> >>>>>> +            reg = <0>;
> >>>>>> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> >>>>>> +
> >>>>>> +            spi-max-frequency = <44000000>;
> >>>>>> +            spi-cpha;
> >>>>>> +            spi-cpol;
> >>>>>> +
> >>>>>> +            ports {
> >>>>>
> >>>>> ethernet-ports are preferred.
> >>>>
> >>>> This is backwards to me, instead of an 'ethernet-switch' with 'ports',
> >>>> we have a 'switch' with 'ethernet-ports'. Whatever.
> >>>
> >>> The rationale AFAIR was that dual Ethernet port controllers like TI's 
> >>> CPSW needed to describe each port as a pseudo Ethernet MAC and using 
> >>> 'ethernet-ports' as a contained allowed to disambiguate with the 'ports' 
> >>> container used in display subsystem descriptions.
> >>
> >> Yes, that was the outcome of previous discussions.
> > 
> > And why would that disambiguation be necessary in the first place? My
> > understanding is that the whole node path provides the necessary
> > namespacing to avoid the confusion. For example, the 'reg' property
> > means 100 things to 100 buses, and no one has an issue with that. I am
> > not expecting an Ethernet switch to have an HDMI port, I might be wrong
> > though.
> 
> The disambiguation is more of a hint given to DT analysis tools to
> validate a given node with little to no knowledge of the containing
> node. I don't really have a dog in the fight here.

A node name should mean 1 and only 1 type/class of node. 'ports' (and 
'port') is for the graph binding.

Rob
