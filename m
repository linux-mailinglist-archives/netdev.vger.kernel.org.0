Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A189660D449
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiJYTAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiJYTAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:00:25 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413834703
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:00:19 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id hh9so8211143qtb.13
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSGZJo1bl3SUQkhMNqs386T667b+Vn5p187f1yr+7xA=;
        b=E2HOl9ixsstjpF60K2tQ9pSVnZ4xuFcgpP4Amkng6w5crg3brzdjJzEm6hsZjD1ePV
         hz1tvFrOXBsiHoQoa/9iv/eZ0YY/kFCSGcNYLHKEe1d9zBD8StU4EVcfZhmamPZHcVP+
         zTbTeTrlfoF8icVwrkWoJvXjopVL5OgyDYmrpuJokZMka+HcLR6YCVQIO7u+x9fdDXIV
         lfdvdes8cFgHIjuNfYALfdH1FRME9u6ufzs2GfSalBXDPsenHxz0ry96GiKzEZsdFoQs
         Sy5/z9778wRR/1Nw1ZTxA5oGgBnaVRnICCvTSFrlH0pS/ugoTs1wwPzokNLXAMXXbibe
         ADpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XSGZJo1bl3SUQkhMNqs386T667b+Vn5p187f1yr+7xA=;
        b=7IiJDh98XzA1CEUkKvcS3nP7mSEHJkVKd/VlDEFcuK+AOMpLZeDGih+5qcG9ijhcU3
         xllP6gDX+kDcl30NhHoJrtFtM1cNnRIPWnWBeCRG5KTkepmTiFQ2ss74e5WGa8wNEplY
         ejSRm4p21FpkZlD337XTbweJMrnzj2+9PF0QbQslj6jlLRkdwQYqgglhn53WMks7INjz
         mypL//mRhlbE/9wn86gnlvo0DLt8Mszr7ltOk7IpF8gJ+yYCPZoTVuCXgr9lu8oxo0pE
         5RJhzDKWiEhnl/CxrMMi9svAt6gIC1az8WT/v6V9SBafhFQ0Agl1Cl4XdMBmAd4ELSyi
         PPkQ==
X-Gm-Message-State: ACrzQf3SUfHYOz0x3yPiuRRwR5CNCoQbq7JLr0Wo1SmfbAx/ltp2xQSN
        37QrZVd8oVBSFeEuAsHxxnkH2A==
X-Google-Smtp-Source: AMsMyM42TQk+Zo4mpoK4izG3t0mNi637t/x1i9/FW4VVIot9yp2nF07SBAVNC4YiTTlKvyTHaZNuDA==
X-Received: by 2002:a05:622a:f:b0:39c:f320:f7a3 with SMTP id x15-20020a05622a000f00b0039cf320f7a3mr33350384qtw.101.1666724418798;
        Tue, 25 Oct 2022 12:00:18 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id x10-20020ac84a0a000000b00398ed306034sm1986707qtq.81.2022.10.25.12.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 12:00:18 -0700 (PDT)
Message-ID: <2fedd4a8-5b13-7049-7485-307e6d01f9f9@linaro.org>
Date:   Tue, 25 Oct 2022 15:00:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Camel Guo <camel.guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org> <Y1f6NmjrXh77DNxs@lunn.ch>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y1f6NmjrXh77DNxs@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 11:01, Andrew Lunn wrote:
>>> +      - enum:
>>> +          - mxl,gsw145-mdio
>>
>> Why "mdio" suffix?
> 
> I wondered about that as well. At some point in the future, there
> could be an SPI version of this driver, and a UART version. Would they
> all use the same compatible, and then context it used to determine the
> correct binding? I think the kernel would be happy to do that, but i
> don't know if the YAML tools can support that?

In general the bus should not be encoded in the device compatible. On
which bus this device sits, is determined from the parent, not from the
device compatible. As you wrote the context is used to determine
properties. There are few exceptions, though, but I think this is not a
candidate for such.

> 
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/gpio/gpio.h>
>>> +
>>> +    mdio {
>>
>> Hmmm... switch with MDIO is part of MDIO?
> 
> Happens a lot. Nothing wrong with this.

OK, everyday learning :)

Best regards,
Krzysztof

