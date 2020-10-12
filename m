Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2291728BFFB
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbgJLSsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:48:06 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37936 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgJLSsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 14:48:05 -0400
Received: by mail-ot1-f66.google.com with SMTP id i12so16771743ota.5;
        Mon, 12 Oct 2020 11:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6XXJOfO7U4hxEa5RGS+xMQKrs9V5PRPthZW1rOFN0zg=;
        b=lKQWoVXqhV4Bf/VFkJfoZNCWxPisDAAzEdQD0+REe8/0DNyAYRs9EB8M5JxtSI9YQl
         yBcdrnk79vHj3gglT5mkEeOf1yWqgVOBOLuuuuL0julgVk3mjZte0EUDgJ1WTgK0FLOU
         wi7yLK2D08sev8IWi45PqN+N+iJNESK6sDZAPpGHp/yKWiG+LDQlb26cxiYN2/M3sE10
         8MpBcx84yIIkRqGo2jqhSDeKZQVbJOlwUkLJpJ3QqxKKGrpzcZGNjCDrgGUdC0dijWc9
         m4a932euHSciSyFuhOGPl/iHMOLlyEvT4oSIxAWcB8zJmCxnTvTzntSWyHN3aftBUo8Z
         5tDg==
X-Gm-Message-State: AOAM533J65wLTCeeoRcWPpfLneWTHJuiiYLPg8+3qjP3SaLb5t20LAcU
        tDHJLRYhCfY7Up+bleNs7g==
X-Google-Smtp-Source: ABdhPJyutzG/CtBSo2AbNwxTQRPhoMC69LSSASIpnyv8Pknp6DCor79KIyNjWfH7xwLJ0tgZgDRPng==
X-Received: by 2002:a9d:2087:: with SMTP id x7mr19777191ota.119.1602528484942;
        Mon, 12 Oct 2020 11:48:04 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w30sm403234oow.15.2020.10.12.11.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 11:48:04 -0700 (PDT)
Received: (nullmailer pid 1895055 invoked by uid 1000);
        Mon, 12 Oct 2020 18:48:03 -0000
Date:   Mon, 12 Oct 2020 13:48:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML
 bindings
Message-ID: <20201012184803.GB1886314@bogus>
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-2-kurt@kmk-computers.de>
 <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com>
 <877drxp3i5.fsf@kmk-computers.de>
 <08c1a0f5-84e1-1c92-2c57-466a28d0346a@gmail.com>
 <87o8l8f15l.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8l8f15l.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 07:45:10AM +0200, Kurt Kanzenbach wrote:
> On Sun Oct 11 2020, Florian Fainelli wrote:
> > On 10/11/2020 1:32 AM, Kurt Kanzenbach wrote:
> >> How should we proceed? Adding the missing compatible strings and ports
> >> to the DTS files? Or adjusting the include files?
> >
> > The include is correct as it provides the fallback family string which 
> > is what the driver will be looking for unless we do not provide a chip 
> > compatible. The various DTS should be updated to contain both the chip 
> > compatible and the fallback family (brcm,bcm5301x-srab) string, I will 
> > update the various DTS and submit these for review later next week.
> 
> OK. It's not just the compatible strings, there are other issues as
> well. You can check with `make dtbs_check DT_SCHEMA_FILES=path/to/b53.yaml'.
> 
> >
> > Then we could imagine me taking this YAML change through the Broadcom 
> > ARM SoC pull requests that way no new regressions are introduced.
> >
> > Sounds good?
> 
> Sounds like a plan. But, Rob or other device tree maintainers should
> have a look at the YAML file to spot issues in there first.

Looks pretty good to me.

Rob
