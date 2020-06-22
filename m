Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CBE204380
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbgFVWVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731048AbgFVWVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:21:01 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84AAC061573;
        Mon, 22 Jun 2020 15:21:00 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x18so17528275ilp.1;
        Mon, 22 Jun 2020 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZhNj1tixXIeix7bgn2AK1/llpYadGdoyoeJTRk7FmHc=;
        b=pGSVgug8N9vVzOkE03howsi5Vq6MyJbvzOTAOi7DznX22Li3JJVAjfrC+MPE66/oCz
         8ZyKIezBpo3sHf84gh2Yz9mi2jXomL/0iZl7hjE2sATDTDwDqM+WvVZ6mrSBfEL9HMg1
         /1G9HBC+R0S0a7ETECVHNDHum6EgJkOphvhyxQPmQGow2ZWeFcZzy9GX1nmw9be+B2qz
         St4YcGiJ/ZIIEt7Om7KGFgeLKXwMYagNNtxU1ylsbnLviV4ykuxAgSkhP9mcgZJbyNN5
         j/MLdjGnxmk/eHEOK4YDLC/NqAffeKRYlldcraBql4SseC5mygIT0KDVVWvTk3TgUq3J
         EkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZhNj1tixXIeix7bgn2AK1/llpYadGdoyoeJTRk7FmHc=;
        b=l7RUD1xPdTan2aysmW4bGXH/LvhFKM5lpKiX5SQEJhyXjCfSGTLd90/mifMLzQtfBo
         EYFC3Ushwf1+7HDO9ZSnFDTfYbNnrVl3AT3eGJmPnmP78Qk2XFSABkbEnWtXR3bOW8tg
         6DmdLSDlmiZ7wdTLIuS0EPiMTBdDjrvdePjP3geL8nVB3R/qm5fgkmNZkiDxaDMLHM8A
         MODPSBjUwG66bJv+hfDGy0FlWpYZDOO1K02eW3EohMBbVZgN4MdeZgh+x+RDoA2TCmCl
         yNMXbxd50fVSez3j5p8rVFWwt1LaU+aQ81k1Y30zz8HEOLq3vywd2g3xuCz4pSKh/DRp
         4jrw==
X-Gm-Message-State: AOAM5309RTPAYnr+LNoK9v0sUNbKP5I/5VRUxLInL0n6S2BGnoHtISmJ
        LcqQffE4iHKMArp9yMXuLHi0kiFe
X-Google-Smtp-Source: ABdhPJxoy4jzdBnIx5tHtjQV590Sv1JQpPSrF+wDm03m/P3oNNHCXXlfkRDK8ftHePsz7QpqyMd7gw==
X-Received: by 2002:a92:d984:: with SMTP id r4mr19796299iln.302.1592864459790;
        Mon, 22 Jun 2020 15:20:59 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m2sm1563327iln.1.2020.06.22.15.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:20:58 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/7] dt-bindings: net: add backplane dt
 bindings
To:     florinel.iordache@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-3-git-send-email-florinel.iordache@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <7035531d-3e74-6fd4-0df6-fa730998b065@gmail.com>
Date:   Mon, 22 Jun 2020 15:20:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592832924-31733-3-git-send-email-florinel.iordache@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 6:35 AM, Florinel Iordache wrote:
> Add ethernet backplane device tree bindings
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---

[snip]

> +properties:
> +  $nodename:
> +    pattern: "^serdes(@[a-f0-9]+)?$"
> +
> +  compatible:
> +    oneOf:
> +      - const: serdes-10g
> +        description: SerDes module type of 10G

Since this appears to be memory mapped in your case, it does not sound
like "serdes-10g" alone is going to be sufficient, should not we have a
SoC specific compatible string if nothing else?

> +
> +  reg:
> +    description:
> +      Registers memory map offset and size for this serdes module
> +
> +  reg-names:
> +    description:
> +      Names of the register map given in "reg" node.

You would also need to describe how many of these two properties are
expected.

> +
> +  little-endian:
> +    description:
> +      Specifies the endianness of serdes module
> +      For complete definition see
> +      Documentation/devicetree/bindings/common-properties.txt

This is redundant with the default binding then, and if it is not
already in the common YAML binding, can you please add little-endian and
native-endian added there?

> +
> +examples:
> +  - |
> +    serdes1: serdes@1ea0000 {
> +        compatible = "serdes-10g";
> +        reg = <0x0 0x1ea0000 0 0x00002000>;
> +        reg-names = "serdes", "serdes-10g";
> +        little-endian;
> +    };
> 


-- 
Florian
