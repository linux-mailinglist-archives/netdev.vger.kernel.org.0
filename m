Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24E52955B9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894380AbgJVAk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395158AbgJVAk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 20:40:29 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85504C0613CE;
        Wed, 21 Oct 2020 17:40:27 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t22so23479plr.9;
        Wed, 21 Oct 2020 17:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sXxuJU6MPXl/18D00kPNzDn0CowkC3WiTbGwtlRZpQc=;
        b=SfbwQu02QhtBliWNIQXDgwN47rY8WkTcBE5C5aBgim4J+8GwCO8FKz0z6BXncGpSGM
         RAHoU1X6KXqnuZmrCEIrPqhzKVfpuV36Sac603xmoehNTXyS33/EQfyS8k7grlL4C52r
         5bFIxVa9tuKAc18RoI4uGo4sXeAvz5sB3RDGJzS2XaGzf+OUT5IKWe2/XZrSGPU+VLdG
         mT/qBCD2R4W6NZuPuZ2dwXAxA/GLTttjwRND0RL4ql1phzNIfwTER3rypnlMQwW+BQ0h
         7s+ujPB5trRDJPmIdTIRK5QcRlQFkvYtksmfFwlQiNpwUZxZJCJE/I6Z8bkaHFmtYVEf
         nPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sXxuJU6MPXl/18D00kPNzDn0CowkC3WiTbGwtlRZpQc=;
        b=N9Ug+YKCNZ+LPLDeFd0vnPNVKBQEA1Sb+DtsGQMgkKOCE9XhJpFpufr5FLD7saiqAT
         Pe9lFooU2ONv2ScdnVuRDn/rmZCJA12+ppViSu9E5qJ3umc/N5VD1f6KcZI4Sl/ZDYwu
         BeuaZx+DBsnzMvaRMEvbowjyIwqD67WrcA/GRif4+2DnlJe5tJi+ddPo/1hXKy8xG1gh
         VGhOp/508YxH4N2e7+eXyecdldSQArIfts47gbGsOL7y9o+ADDcrxHjjZuilvThRsA5L
         j5V4dp23lPAkLYUdg1BMJ6CY7Q3ejAnUJ+x1ASuBY5BKj9O30t/lgpUkrS85MD9gEAOO
         5NNg==
X-Gm-Message-State: AOAM531xSDodL5WcVSkp1AmZ9ckDJ0A06ap2m4ivENmW+Zld1OJvBDWA
        EmiPDGqYQv/VSKrOg/1C0tnF5XTPjbM=
X-Google-Smtp-Source: ABdhPJyz6tzBR2WqjkEmFwdFKMgqxB287u7ZVWebYoUhQoTi9c011FYAvgJ1l2UAiMSgQTiYsiNaTg==
X-Received: by 2002:a17:90a:cb86:: with SMTP id a6mr163887pju.161.1603327226629;
        Wed, 21 Oct 2020 17:40:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q4sm51542pgj.44.2020.10.21.17.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 17:40:25 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
To:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
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
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-2-ceggers@arri.de> <87lfg0rrzi.fsf@kurt>
 <20201022001639.ozbfnyc4j2zlysff@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3cf2e7f8-7dc8-323f-0cee-5a025f748426@gmail.com>
Date:   Wed, 21 Oct 2020 17:40:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201022001639.ozbfnyc4j2zlysff@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/2020 5:16 PM, Vladimir Oltean wrote:
> On Wed, Oct 21, 2020 at 08:52:01AM +0200, Kurt Kanzenbach wrote:
>> On Mon Oct 19 2020, Christian Eggers wrote:
>> The node names should be switch. See dsa.yaml.
>>
>>> +            compatible = "microchip,ksz9477";
>>> +            reg = <0>;
>>> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
>>> +
>>> +            spi-max-frequency = <44000000>;
>>> +            spi-cpha;
>>> +            spi-cpol;
>>> +
>>> +            ports {
>>
>> ethernet-ports are preferred.
> 
> This is backwards to me, instead of an 'ethernet-switch' with 'ports',
> we have a 'switch' with 'ethernet-ports'. Whatever.

The rationale AFAIR was that dual Ethernet port controllers like TI's 
CPSW needed to describe each port as a pseudo Ethernet MAC and using 
'ethernet-ports' as a contained allowed to disambiguate with the 'ports' 
container used in display subsystem descriptions. We should probably 
enforce or recommend 'ethernet-switch' to be used as the node name for 
Ethernet switch devices though.
-- 
Florian
