Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0B967EE82
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjA0Tm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjA0Tmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:42:53 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEA679F00;
        Fri, 27 Jan 2023 11:42:25 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id d3so4962566qte.8;
        Fri, 27 Jan 2023 11:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bYJb+R9vHDmzhpB4/9JC2gXbOeP6gitvyXNDmhbdviY=;
        b=JCDFff+5/UB0qymX3IqjVnnjFCmw2jVOT6qrNfiIRlS+p1W3gvU7K9hCsBv1LWK+JF
         IjN6vksOAdelZWUgK/9aO+sohEjc1gBaIlHKSDUgLkNQ24kbtseMmn/kYXOfrMP8rFSp
         INCiOdySDT6nJnVuJtxCOtJecyoXkUJoPCWYAq/7jB7oadkSitxXx+HjvuOIRvpOBAl2
         sN1ZwRk1ab7oLr+2lGZsIHTI5CIhDu5UAFRdhmDjZZOe9bspt8ReaUad5g5VTrFW8bfv
         Ba33rg1zfvWMw0Yk0maYKPAmoFszJrFgodmlvHXgh7/JONtCiyLu+Q3ksg651phh9Uqk
         /xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYJb+R9vHDmzhpB4/9JC2gXbOeP6gitvyXNDmhbdviY=;
        b=prUxB/UT9GhiHw8zuH+TFGYnz5c2R+Iv2Eb710f6zcij39/EQ1XSOjlQxZS+NdmAQP
         Og8QF6DgmnHiWxyfuVI/ZdGp4RimL3w+UnKbikIW5WYwE7xpa3x/VWTg6gctOcdyfvp/
         0B5DWT8Ymlrvyber7DaNKJE8fzT4ykJyqxTPW/Nuu5Jzl/z6EqOxS8RpSsqwAlyFZ1lb
         8JFwagukoaOWvyu5WkavZmAN+/GfKCm1XptMB0fpL+RzTtJ3uiycvoI+O1EnWwest6kC
         HiPxU/IqfFLbaaxSD1vHLtf2OW+TLlK4bsrlRnkUb1t2DtzxzQKxXFwsLRPem878qfk5
         Kh7w==
X-Gm-Message-State: AFqh2krxz/ymHrh28BBEEw2L8uZv6i/jHkn2Q9Xr1LnUuQBUCaRzFvnW
        KJl7FefxJw5iHade+c5gxYM=
X-Google-Smtp-Source: AMrXdXuqRhbEfvetrr5JTYy8DhK7hL13DxkS2rtMJrI7+DiuUgnLFfjE6EaVA9VZ03wkij1eeyPyhg==
X-Received: by 2002:ac8:53d3:0:b0:3b6:88c2:2ac6 with SMTP id c19-20020ac853d3000000b003b688c22ac6mr49252749qtq.27.1674848482144;
        Fri, 27 Jan 2023 11:41:22 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f23-20020ac84717000000b003a81eef14efsm3206933qtp.45.2023.01.27.11.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:41:21 -0800 (PST)
Message-ID: <651da1df-2abf-7b44-44db-cb77d0b65d20@gmail.com>
Date:   Fri, 27 Jan 2023 11:41:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 09/13] mfd: ocelot: prepend resource size
 macros to be 32-bit
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-10-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-10-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> The *_RES_SIZE macros are initally <= 0x100. Future resource sizes will be
> upwards of 0x200000 in size.
> 
> To keep things clean, fully align the RES_SIZE macros to 32-bit to do
> nothing more than make the code more consistent.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Acked-for-MFD-by: Lee Jones <lee@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
