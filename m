Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C53586FED
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbiHAR5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiHARzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:55:09 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BDB3205A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:55:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z25so18527858lfr.2
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 10:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0dGf0wQlT5nVscla096RlUxod41IYCPpARZuBEndXgw=;
        b=T6Yc3nNefe3TyXG0Vbq3cLSHdoLWMnMoLC1rCsAkOgbXk6qxf5NxTtsWLdlh+h8h+Y
         zy2IwEG5thASc8/tliCDThGrGmtCTEdm8IXEBOHigiClrMlsAzwm83kX6UzZ765pOx1e
         OclAzmznuvZ754z0Ve0hY1GPZHIA1OlVcjqd1pdshqzyg6rGVUId1LPHhOz3KeyYZFRc
         t/OHO6Ha6Awj4xVLh6Z29b7VRFpOctOrXQjlHsrwl4Qf09vAHD3rLXe3d64GSOjqOUXp
         pxqPLGY1Wx82yKUx05QB3V6cu+EFy6fNjGcOecN3bN3HXJRhuRdVTt0iyNgPggTgQqgE
         58kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0dGf0wQlT5nVscla096RlUxod41IYCPpARZuBEndXgw=;
        b=NF2l8HATNygp1sUBFX7cIQZiaVhVXSyhNCYaTHF/v28UAbFHHWvKNmj96WS1HxGIGe
         oHd045I4BpBXBYPBozqTTAS/EXYrWyYC3DSsB5oQfxLZeEKU9G3cwcD62fRl371VHH5Y
         VzoZn9yfBUWJWc3WzBcEZSHt7rKtmOPTZYY5rc/h0pX42WZmj4+q+uTohDra6Xotz/ZK
         QbyuM8FXUB0QRU9AphAdttXBnI4E0CfA532eS8eXcyruq8/NfwL4+QmRLY7xTdGGgJa5
         SCTgVpCbEA+O30vLeIFPnGdEa2EmJBq6Fvp4E9iimN7pO0LjkujYnDgjoaCxoVJXeJub
         ROYg==
X-Gm-Message-State: AJIora+Wg9Kfe8zmtsOJkr7sjBh6b+9/s7EZiYsj9zx0BZ1CIQMFVHla
        mnLGS671J4KxeyJMrrBNyy7g2g==
X-Google-Smtp-Source: AGRyM1sQPJdZYAWXfwoVj4Hz7Z7Cwylr4YwG9UFSXMVERZh0c/cbramPGiv0H/4T1qlznG/Ilz5Rxw==
X-Received: by 2002:ac2:4a8f:0:b0:48a:9705:c81d with SMTP id l15-20020ac24a8f000000b0048a9705c81dmr5760708lfp.63.1659376498624;
        Mon, 01 Aug 2022 10:54:58 -0700 (PDT)
Received: from [192.168.1.6] ([213.161.169.44])
        by smtp.gmail.com with ESMTPSA id bj38-20020a2eaaa6000000b0025d64453f4dsm1654422ljb.122.2022.08.01.10.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 10:54:57 -0700 (PDT)
Message-ID: <428fe2c1-3c70-5ae8-efcb-1e4a0426a972@linaro.org>
Date:   Mon, 1 Aug 2022 19:54:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220726122406.31043-1-arinc.unal@arinc9.com>
 <a8c778db-f52c-45cb-c671-556b24f3cb46@linaro.org>
 <a2dd1ce2-a23e-8894-5ef4-b73ef0dad89d@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <a2dd1ce2-a23e-8894-5ef4-b73ef0dad89d@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2022 10:24, Arınç ÜNAL wrote:
> Hi Krzysztof,
> 
> On 27.07.2022 13:29, Krzysztof Kozlowski wrote:
>> On 26/07/2022 14:24, Arınç ÜNAL wrote:
>>> Completely rework the binding for MediaTek MT7530 and MT7531 switches.
>>
>> Rules are the same for schema as for driver - one patch, one thing. You
>> mix here trivial style changes (removal of quotes) with functional stuff.
>>
>> Patch is unreviewable, so it must be split.
> 
> Thank you. I'm going to split it this way:
> - Trivial changes; fix title and property descriptions, remove quotes, 
> add me as maintainer, etc.
> - Update binding description
> - Update json-schema for compatible devices
> - Update examples
> 
> Let me know if you have any objections.


Depends what are these "udpates". One logical change = one patch. Adding
compatible in one patch and then adding example for it, is not correct.


Best regards,
Krzysztof
