Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7704284F6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhJKCFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbhJKCFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:05:16 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575A8C061570;
        Sun, 10 Oct 2021 19:03:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r18so61457921edv.12;
        Sun, 10 Oct 2021 19:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KJXce0Dfy/CltbodZR4nSYkzFQVsW666XbiANtrNeQw=;
        b=Hno2COTeQ1JRehZ2/b9h67IyZ6hdfxLZzeqoIjHvzszNa/vjZtOzpXQnrKY1Xb6+P6
         DO1ZzjAsK0t3Maw4O/20ObOibISfQQTlMdBtX5GxzIsSslLIkhFPM+GMaoTOdP8tGmXZ
         nD+wGSIrQrqVzwDSVOD9ANlCncRYZA2cQ1YXA4SqEAQCVKDm8UCl4QrQHsA91WOjRZzH
         SXS4Od0HS8qdWhgOsp3i5XOAxBY9vlFIVXQEcWlnZS2hGXClQMUEHklx4++/3ax3LgzO
         Hqj20WYcBWkRkMNXUe2AD5vXaotaYz7/QiGdB0teK6FI1JrYoGDiqEWcAMZ6C9ry9Wm6
         U+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KJXce0Dfy/CltbodZR4nSYkzFQVsW666XbiANtrNeQw=;
        b=6y5Vf8r5vi6LR8OtE9m2HUq3YzC2WjYc+wj3eAiHAxP83emNvEgM1ZSfItSAwVMLg/
         lMGeHpbCbaEdLWZVOjBzp9xO/Hc4HoC6uoHKcfG7PVJJEgOTn91WXdU6ItfStP9RylyG
         HUReIQMiK5OVuqU5g/hai8D6fZGgkmotiD4E3Np+AlD43ArW74NZxvH+qzefCsY37MiW
         +sNO1chYFiiG6iUSklvb1bYj8BmVT7qb4ZuPIHfhZwhJJrsis4j7bJ9KP47sP53Riz04
         KemiLcmAhqwQ4CmpV/a57wjdXJV1Ko/h5S6f606neYno3tCi1r/h2b1ZbF8ZkRjWjXzp
         d/aw==
X-Gm-Message-State: AOAM530O5kjziqbNdLiiM/qCjzlTycwFwGT2YxcJt0CMcxaw68Fh98rg
        1MkCgudswI2WNPF1ea1HdOE=
X-Google-Smtp-Source: ABdhPJwAp20VnhaG2e1KqRMhT/OIp2qWxCilKjAp4umuNUovhDX7cuPLHPI6jikh3IWXzijdllLFCA==
X-Received: by 2002:a50:cc03:: with SMTP id m3mr37924241edi.278.1633917795893;
        Sun, 10 Oct 2021 19:03:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id l8sm2695876ejn.103.2021.10.10.19.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 19:03:15 -0700 (PDT)
Date:   Mon, 11 Oct 2021 04:02:11 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/14] dt-bindings: net: dsa: qca8k: Document
 support for CPU port 6
Message-ID: <YWObIyEZvjpoKG00@Ansuel-xps.localdomain>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-5-ansuelsmth@gmail.com>
 <16d2a19b-5092-763b-230c-5b0a6237d852@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16d2a19b-5092-763b-230c-5b0a6237d852@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 06:50:39PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> > The switch now support CPU port to be set 6 instead of be hardcoded to
> > 0. Document support for it and describe logic selection.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index cc214e655442..aeb206556f54 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
> >   Don't use mixed external and internal mdio-bus configurations, as this is
> >   not supported by the hardware.
> > -The CPU port of this switch is always port 0.
> > +This switch support 2 CPU port.
> 
> Plural: ports.
> 
> > Normally and advised configuration is with
> > +CPU port set to port 0. It is also possible to set the CPU port to port 6
> > +if the device requires it. The driver will configure the switch to the defined
> > +port. With both CPU port declared the first CPU port is selected as primary
> > +and the secondary CPU ignored.
> 
> Is this universally supported by all models that this binding covers? If
> not, you might want to explain that?
> -- 
> Florian

Yes we tested this and both qca8327 and qca8337 work correctly with cpu
port6 set as primary port. (no cpu0 defined)
If you were referring to double cpu mode. That is the common
configuration with this switch but we currently doesn't support
multi-cpu in DSA.

-- 
	Ansuel
