Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0462C9EBA4
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbfH0OzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:55:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38925 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfH0OzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 10:55:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id g8so31761913edm.6;
        Tue, 27 Aug 2019 07:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J28up6uPKD34qaYuEApixR8UwpIcwgN+tKjvn/kdwk8=;
        b=pMVrBsv09u5KWA+6vj2Cr0qR0GSZe6r8BMU1JSA+mY2m8bDJ+IdYJXV+hJDfmP273h
         03KsR0CTQqVWzTM8EllBHW37q99IulCpwRlLntm1wh7QpBeheqcUWjdGcF92vEjKdwGe
         JWg1stYWqsmHKwaAOkhxXnI4at6LB104kKnM4BFKCBSqOUYTlJLleTaPM+cWFcES1i88
         zXTO9JvkAZyanLSswiDgGLU/w5Lg9OUsu2V4nZRlg9a47CKLJgik6d2SfwFNb8UzzLdP
         TduGiWMz2vDnqLl/Tjwin5PPv0YyzSGJtEK4Qh0lsI17GPFMi0jTeoxn4o37yhTPsYs/
         Yajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J28up6uPKD34qaYuEApixR8UwpIcwgN+tKjvn/kdwk8=;
        b=ZqxUsczPBiPFBMK5XZlZPVniX1hsWyMq3pzntgIbxB1hH70yGkODme5tXDJbS87Y4o
         U93W3dBXWldkcqz8tiNYJMuitURVfOu3xgfA2NwbSVQXN+Mi8c31DNSUdIhEna4dRbaX
         OfChr0VM6VtAsXFaAZezwiGIgky0HT6xwhLnXt8pHDaXs7d95ZTrW9bDXHajhc2jQZ05
         heCOI74UlRmC5NgLNPAf7c/uc4ezQf/PxdJ8BQLXeFYxA4K5NNK/2kE3qvkC7i5e0VpR
         IDtj8qpeqN7JwaOL7lDjSkQoptYJSKqauEjQs0xku0/xyRFhgbfcyS6mZoqAs0Gr2Nii
         lecg==
X-Gm-Message-State: APjAAAUtey+eXkR7Iq91j9H48jW3SvqmodP63Iqf2SZo42Tp55DI00iM
        uWiyKDEZAspKhCoOGVvvrxo0Pku9xcGPH1DnbhQ=
X-Google-Smtp-Source: APXvYqwpdkTQqMFYaHNmnBUxl9LiyKGwNSuxlXy0J60wneAG3Ifqr5uUMFvDC7+xGCyeK/INY6fNuNmfO28F3cIuk8s=
X-Received: by 2002:a17:906:9607:: with SMTP id s7mr21872991ejx.300.1566917712168;
 Tue, 27 Aug 2019 07:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
 <20190826123811.GA13411@lunn.ch> <20190827101033.g2cb6j2j4kuyzh2a@soft-dev3.microsemi.net>
 <20190827131824.GC11471@lunn.ch>
In-Reply-To: <20190827131824.GC11471@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 27 Aug 2019 17:55:00 +0300
Message-ID: <CA+h21hrRafYQm8eOcXjNVwudDbu-2=miWD6nCUJdh0jAGE319w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Add NETIF_F_HW_BR_CAP feature
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 at 16:20, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > That sounds like a great idea. I was expecting to add this logic in the
> > set_rx_mode function of the driver. But unfortunetly, I got the calls to
> > this function before the dev->promiscuity is updated or not to get the
> > call at all. For example in case the port is member of a bridge and I try
> > to enable the promisc mode.
>
> Hi Horatiu
>
> What about the notifier? Is it called in all the conditions you need
> to know about?
>
> Or, you could consider adding a new switchdev call to pass this
> information to any switchdev driver which is interested in the
> information.
>
> At the moment, the DSA driver core does not pass onto the driver it
> should put a port into promisc mode. So pcap etc, will only see
> traffic directed to the CPU, not all the traffic ingressing the
> interface. If you put the needed core infrastructure into place, we
> could plumb it down from the DSA core to DSA drivers.
>
> Having said that, i don't actually know if the Marvell switches
> support this. Forward using the ATU and send a copy to the CPU?  What
> switches tend to support is port mirroring, sending all the traffic
> out another port. A couple of DSA drivers support that, via TC.
>

But the CPU port is not a valid destination for port mirroring in DSA,
I might add.

>         Andrew

Regards,
-Vladimir
