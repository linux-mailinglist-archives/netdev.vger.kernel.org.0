Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7610C2C24D7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbgKXLl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:41:56 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33500 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732548AbgKXLl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:41:56 -0500
Received: by mail-ed1-f66.google.com with SMTP id k4so20537389edl.0;
        Tue, 24 Nov 2020 03:41:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OuWuDtQpe3gLLoCvV3TSZsRvGbsd7x5eT2lI0ArbwK4=;
        b=dR3m3NVYnkyA7ypS79Rur2Z1QHdlDhLLb8JRGhxgMtASVB3P1M2UcCYpKjvu+JQm1p
         y153dcQCcXdVsaTo7ejunJPJnqh+UA7itVAeGzgWDgjxxDQb0DJViyU5Iz9SOOjTdg8+
         zzGy/Kq+DN9axFki9jJkLu0uXL7v9ttj5fJzsDjshOdGJlH4J26DCSVguSsVwim6Ye9q
         thMfpOkhwrMJCYkaWOx7GBGYAF3WpVSZfPGnDjdQa9EDAF0M44cdBSqhl//5Zk1cFMcE
         gkDoQ81exNBXoDTbhndeCXcD2UrtDummsZNfSt0p1KHSXOAES+c9jFvtthI/cIpytd4T
         NXeA==
X-Gm-Message-State: AOAM532POSHzSDztB/X99bESnb1ajrYKGGiTghjvIXWQrTlfxLbt0pcR
        1fBWcBO0nke6pznGNdmU92Y=
X-Google-Smtp-Source: ABdhPJxIubTB3KIMkbTAqjZj968UiXkQgXME39M860y8SovpFjszvM1mKrVv9MmjhuYudLM5KIhu4g==
X-Received: by 2002:a50:eb0a:: with SMTP id y10mr3723877edp.342.1606218113995;
        Tue, 24 Nov 2020 03:41:53 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id i2sm2886628ejs.17.2020.11.24.03.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 03:41:52 -0800 (PST)
Date:   Tue, 24 Nov 2020 12:41:51 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
Message-ID: <20201124114151.GA32873@kozik-lap>
References: <CGME20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123080123.GA5656@kozik-lap>
 <CACwDmQBh77pqivk=bBv3SJ14HLucY42jZyEaKAX+n=yS3TSqFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACwDmQBh77pqivk=bBv3SJ14HLucY42jZyEaKAX+n=yS3TSqFw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 08:39:40PM +0900, Bongsu Jeon wrote:
> On Mon, Nov 23, 2020 at 5:02 PM krzk@kernel.org <krzk@kernel.org> wrote:
> >
> > On Mon, Nov 23, 2020 at 04:55:26PM +0900, Bongsu Jeon wrote:
 > >  examples:
> > >    - |
> > >      #include <dt-bindings/gpio/gpio.h>
> > > @@ -71,3 +81,17 @@ examples:
> > >              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> > >          };
> > >      };
> > > +  # UART example on Raspberry Pi
> > > +  - |
> > > +    &uart0 {
> > > +        status = "okay";
> > > +
> > > +        s3fwrn82_uart {
> >
> > Just "bluetooth" to follow Devicetree specification.
> Sorry. I don't understand this comment.
> Could you explain it?
> Does it mean i need to refer to the net/broadcom-bluetooth.txt?

The node name should be "bluetooth", not "s3fwrn82_uart", because of
Devicetree naming convention - node names should represent generic class
of a device.

Best regards,
Krzysztof

