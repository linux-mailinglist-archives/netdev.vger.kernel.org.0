Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017466191B0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 08:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKDHRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 03:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKDHRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 03:17:49 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3A327B0D
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 00:17:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a5so6306743edb.11
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 00:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ztKT9w6RIk8X4v+7zU6phgitJO+2+RvlgOkmKCtGqNE=;
        b=RE04PQy/aZ994XSK2FZKlOeZgB5P7/6aqfcEhMKGLC0ugatlYunNnqkUbby2ryX7Kc
         Oblg0VYidM97iTpQHEWozvS78pFGJHT8GCMiJNBVobIAgYMMW6EjQ95bznY0XppTfQwB
         N5X9lSUY2hGOMucGCcIgWUQlem47U4M1kmxGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ztKT9w6RIk8X4v+7zU6phgitJO+2+RvlgOkmKCtGqNE=;
        b=YJSe2Dh/dHZx0Jfbd2VoCbG3Bx6GNepHFqBWpaa7Gpj11u8iOI4lJbnwDY0bCCwhbL
         f0+Obs6vcm+3uvcREP2n33mFOD1slZMSG9UpHQUVoD9St7oeJ3CQ79hHEX3UOOrlkI4+
         /o+vzMCoARKo0OgsfuHiiWMEq6T+weERRum6Ebe6NB5UZ5EJbNyoT+TvthRQt6LGWcEE
         BFWtNT7rLZjyIdv2IRwtZUXf9b5LBL5p2zfssVCcN9uzNNgA9FBWtlWhm/5qyZRV0zp4
         nSj2OKI2b+izqDeAvuxjV3mDhyFEfK0dT1dXxtdRz0JUiNsDQLLnmt9FY2E2Iwnarxuu
         S8RA==
X-Gm-Message-State: ACrzQf0ZuTSwKKAw9QdMEPSDHL7fc6GmQL1OvEBHYxZitXYp6kb/WKOa
        Kz36LXTGOyb8P8t+5ibi1ks55g==
X-Google-Smtp-Source: AMsMyM5WrqJrUBZvoiyGl7X5vrqH2Gvxvuf/HFdM4HS1waH9xSJs0zJko5ghWa1hAJLAG7Vgf6Zz5w==
X-Received: by 2002:aa7:c78e:0:b0:456:c524:90ec with SMTP id n14-20020aa7c78e000000b00456c52490ecmr34291821eds.192.1667546266383;
        Fri, 04 Nov 2022 00:17:46 -0700 (PDT)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b0077a8fa8ba55sm1384836ejf.210.2022.11.04.00.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 00:17:45 -0700 (PDT)
Message-ID: <893c83e7-8b11-0439-6f38-d522f4a1a368@rasmusvillemoes.dk>
Date:   Fri, 4 Nov 2022 08:17:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: define ti,ledX-active-low
 properties
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
 <20221103143118.2199316-2-linux@rasmusvillemoes.dk>
 <Y2Q9+qqwRqEu5btz@lunn.ch>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <Y2Q9+qqwRqEu5btz@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11/2022 23.17, Andrew Lunn wrote:
> On Thu, Nov 03, 2022 at 03:31:17PM +0100, Rasmus Villemoes wrote:
>> The dp83867 has three LED_X pins that can be used to drive LEDs. They
>> are by default driven active high, but on some boards the reverse is
>> needed. Add bindings to allow a board to specify that they should be
>> active low.
> 
> Somebody really does need to finish the PHY LEDs via /sys/class/leds.
> It looks like this would then be a reasonable standard property:
> active-low, not a vendor property.
> 
> Please help out with the PHY LEDs patches.

So how do you imagine this to work in DT? Should the dp83867 phy node
grow a subnode like this?

  leds {
    #address-cells = <1>;
    #size-cells = <0>;

    led@0 {
      reg = <0>;
      active-low;
    };
    led@2 {
      reg = <2>;
      active-low;
    };
  };

Since the phy drives the leds automatically based on (by default)
link/activity, there's not really any need for a separate LED driver nor
do I see what would be gained by somehow listing the LEDs in
/sys/class/leds. Please expand.

Rasmus

