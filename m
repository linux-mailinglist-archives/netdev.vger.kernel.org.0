Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D71505DB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 13:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgBCMGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 07:06:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54353 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgBCMGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 07:06:16 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so15564413wmh.4;
        Mon, 03 Feb 2020 04:06:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qk2Jt3O1erIU7dk9h6hySa8WTi0Ubkco0XQalim8jms=;
        b=CE7tCvhl/y7wecdqEHnmgytH9yeu3Ya1/fULl4Yx1GNjCeYENmrF5/32BF3NO4wLXR
         4uyAyIVKH0grZyW4ccawak3YHuMON/5SHg9N16zG5G1CUlViI65YN6KNGyH9ciLAIy6z
         gMsWPg1sMP8AJ3Xnvr8Xf1PtxDifN68+LEHkcDhTQLH39U0Ph4Tq1Zjg88fso5qq5zgY
         YlkmJOmBYyUXotmMkrBHmQ7ZhOGEYL2Pp7HZqIcDx6Nh6jPqU5up/xsFJpVz0WSmY6Q8
         uq9lfCEmepei9GqDRJDR8vhju4zivSviFY+p06jFTzB0ga2/z+PGKDigbSW+GV6TNC78
         yyJQ==
X-Gm-Message-State: APjAAAXrZCq/t1YbDqEhRiEVXD5Cj1rhO2S4EV+2WMs268aJYGNgNMi/
        S2dsHVj4PeM00fGwdoNADg==
X-Google-Smtp-Source: APXvYqx7nsm5FWekL3BKJELtK3DXarxIJmSasrulMuL/e1k/RgaRA6fRJdz1qpC/FrkmEVy7vvzz8A==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr28804908wme.30.1580731573508;
        Mon, 03 Feb 2020 04:06:13 -0800 (PST)
Received: from rob-hp-laptop ([212.187.182.163])
        by smtp.gmail.com with ESMTPSA id b11sm9698643wrx.89.2020.02.03.04.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 04:06:12 -0800 (PST)
Received: (nullmailer pid 28482 invoked by uid 1000);
        Mon, 03 Feb 2020 12:06:10 -0000
Date:   Mon, 3 Feb 2020 12:06:10 +0000
From:   Rob Herring <robh@kernel.org>
To:     Faiz Abbas <faiz_abbas@ti.com>
Cc:     Dan Murphy <dmurphy@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, davem@davemloft.net, mkl@pengutronix.de,
        wg@grandegger.com, sriram.dash@samsung.com, nm@ti.com,
        t-kristo@ti.com
Subject: Re: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for
 stb-gpios
Message-ID: <20200203120610.GA9303@bogus>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
 <20200122080310.24653-2-faiz_abbas@ti.com>
 <c3b0eeb8-bd78-aa96-4783-62dc93f03bfe@ti.com>
 <8fc7c343-267d-c91c-0381-60990cfc35e8@ti.com>
 <f834087b-da1c-88a0-93fe-bc72c8ac71ff@ti.com>
 <57baeedc-9f51-7b92-f190-c0bbd8525a16@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57baeedc-9f51-7b92-f190-c0bbd8525a16@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 01:09:41PM +0530, Faiz Abbas wrote:
> Hi,
> 
> On 22/01/20 8:04 pm, Dan Murphy wrote:
> > Sekhar
> > 
> > On 1/22/20 8:24 AM, Sekhar Nori wrote:
> >> On 22/01/20 7:05 PM, Dan Murphy wrote:
> >>> Faiz
> >>>
> >>> On 1/22/20 2:03 AM, Faiz Abbas wrote:
> >>>> The CAN transceiver on some boards has an STB pin which is
> >>>> used to control its standby mode. Add an optional property
> >>>> stb-gpios to toggle the same.
> >>>>
> >>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> >>>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> >>>> ---
> >>>>    Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
> >>>>    1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt
> >>>> b/Documentation/devicetree/bindings/net/can/m_can.txt
> >>>> index ed614383af9c..cc8ba3f7a2aa 100644
> >>>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
> >>>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
> >>>> @@ -48,6 +48,8 @@ Optional Subnode:
> >>>>                  that can be used for CAN/CAN-FD modes. See
> >>>>                
> >>>> Documentation/devicetree/bindings/net/can/can-transceiver.txt
> >>>>                  for details.
> >>>> +stb-gpios        : gpio node to toggle the STB (standby) signal on
> >>>> the transceiver
> >>>> +
> >>> The m_can.txt is for the m_can framework.  If this is specific to the
> >>> platform then it really does not belong here.
> >>>
> >>> If the platform has specific nodes then maybe we need a
> >>> m_can_platform.txt binding for specific platform nodes.  But I leave
> >>> that decision to Rob.
> >> Since this is transceiver enable, should this not be in
> >> Documentation/devicetree/bindings/net/can/can-transceiver.txt?
> > 
> 
> The transceiver node is just a node without an associated device. I had
> tried to convert it to a phy implementation but that idea got shot down
> here:
> 
> https://lore.kernel.org/patchwork/patch/1006238/

Nodes and drivers are not a 1-1 thing. Is the transceiver a separate h/w 
device? If so, then it should be a separate node and properties of that 
device go in its node. Also, nothing is stopping you from using the PHY 
binding without using the kernel's PHY framework.

As to whether it should be a separate phy driver, I think probably the 
wrong decision was made. We always seem to start out with no PHY on 
these things and the complexity just grows until we need one. 

Rob
