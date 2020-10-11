Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1042428A808
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgJKPqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgJKPqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 11:46:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668EDC0613CE;
        Sun, 11 Oct 2020 08:46:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p11so7091467pld.5;
        Sun, 11 Oct 2020 08:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zY2KoSzbfaIhwVkFIO/ZqrFUXtDY2dm2OAO420Dfc8w=;
        b=q4ZRIJJalbaG0vKscrvfgPa9OHtp3gMj6npLFoXv/SelwlmDh6JVUrLoYtgGitLQkv
         f4/zI91OCQJCEjqnKWnoO6KauQsSUM0dRARMcKOUZDmcC7SUr7/lc3/NJ3GuA0CRvf3H
         dc51JDPyyemXgObDsdsWekbHqzQzYb27valCRnXxwkA42sjTrPpe8jM2oxeNbZjTAJLv
         b0UqWB5fvhm6jTBqO8A1hOvI7yyazE6Vb6Rqoyl/cQ3VPGVmspq3BcauKlNVhkyW06Ss
         Wnl98aEDL05vP5z/6toxsWm4pBKndWUiEzNa0/hTCwZsw6qG2oUtuhqhDo2mXIW2ktW7
         7e8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zY2KoSzbfaIhwVkFIO/ZqrFUXtDY2dm2OAO420Dfc8w=;
        b=DpnEJuxrnjzKTtdfWXrWs0MES6XYOXTpoe4n9lT9mP16vsA7adL2cErbVBB8sOsnh8
         LMTK5+GS6qbO/rEXamsGGylKQoncm9G5oTJ7Ht0XhEB+afN/CsJ2QnHINTke58TVKgSb
         CW0TeqMp/aMLSiMvoLSOjGqWOwRKX/FZrlNHGOb3AxyLctyxtK/ixin5QHqzd1u8B9ar
         B7Bzp9jJgX/GM74VsTSPIcsq523aWZthgFFOFguz2KfUQ2FvnWC8DNTiV1DOslaH6NSk
         iXeIQd3MFZwgG3/M2j2RCyr7r7vQZJarNnHH1snnY7kX+XPrIJ9QZHa3eOhzX9jXsbb/
         0C1g==
X-Gm-Message-State: AOAM533oRoIrRc0uf1zTU22yO9YuIQe1yL2ovrioXpILvPXyb9G9usbA
        YXJeVY1qvrDOd6PovpVZAHs=
X-Google-Smtp-Source: ABdhPJzIt0mNVAyA9y2OeJQOVFWBaVnMBTxEgP6rLj5RbAkSfk5UxdA0nOfJY0lSN+wASIU87b0K5w==
X-Received: by 2002:a17:902:ee01:b029:d1:8c50:aa89 with SMTP id z1-20020a170902ee01b02900d18c50aa89mr19751874plb.6.1602431176919;
        Sun, 11 Oct 2020 08:46:16 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e16sm14654085pjr.36.2020.10.11.08.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 08:46:15 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML
 bindings
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-2-kurt@kmk-computers.de>
 <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com>
 <877drxp3i5.fsf@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <08c1a0f5-84e1-1c92-2c57-466a28d0346a@gmail.com>
Date:   Sun, 11 Oct 2020 08:46:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <877drxp3i5.fsf@kmk-computers.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/11/2020 1:32 AM, Kurt Kanzenbach wrote:
> On Sat Oct 10 2020, Florian Fainelli wrote:
>> On 10/10/2020 9:46 AM, Kurt Kanzenbach wrote:
>>> Convert the b53 DSA device tree bindings to YAML in order to allow
>>> for automatic checking and such.
>>>
>>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>>> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
>>
>> Thanks for making this change, there are quite a few warnings that are
>> going to show up because the binding was defined in a way that it would
>> define chip compatible strings, which not all DTS files are using.
> 
> Oh, I didn't know there is a second make command for doing the actual
> check against the dtbs. I've just used `make dt_binding_check'.
> 
> So, it seems like a lot of the errors are caused by the include files
> such as
> 
> [linux]/arch/arm/boot/dts/bcm5301x.dtsi
> 
> 	srab: srab@18007000 {
> 		compatible = "brcm,bcm5301x-srab";
> 		reg = <0x18007000 0x1000>;
> 
> 		status = "disabled";
> 
> 		/* ports are defined in board DTS */
> 	};
> 
> The nodename should be "switch" not "srab" as enforced by
> dsa.yaml. Furthermore, some DTS files are not adding the chip specific
> compatible strings and the ports leading to more errors.
> 
> There are also some minor errors regarding the reg-names and such for
> specific instances.
> 
> How should we proceed? Adding the missing compatible strings and ports
> to the DTS files? Or adjusting the include files?

The include is correct as it provides the fallback family string which 
is what the driver will be looking for unless we do not provide a chip 
compatible. The various DTS should be updated to contain both the chip 
compatible and the fallback family (brcm,bcm5301x-srab) string, I will 
update the various DTS and submit these for review later next week.

Then we could imagine me taking this YAML change through the Broadcom 
ARM SoC pull requests that way no new regressions are introduced.

Sounds good?
-- 
Florian
