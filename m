Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06557C2BC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiGUDdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUDdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:33:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3F7757C;
        Wed, 20 Jul 2022 20:33:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y24so613355plh.7;
        Wed, 20 Jul 2022 20:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=9LvvtodZE4lnsgetaSvcmgRimwxuWALnezRS08pYm0k=;
        b=TmVs+1guzNg30xg3VprA99agrAp38CB+N1VaRhKq1i8qMFROXoTVk1DwtdB106MEU7
         tsyjL4fxs05MTr1LUJAg0PorfBrsszb4zJnP0I+urfRzymxp0Tk/E33okda82Fdk+ua3
         7qxSL+5R6eVHAOXcxsYb4xFH3UNUlTcS1BN+CyQxLzU/BAspVKxsPYeWi7KJuvlj1X9h
         AaGqY7t1dEo5kuLkqm3/TlZwipOoU4m28b3Bj8JP66iw/EKERRYd1lSN0X35BqTLh7aB
         RyZPGq3KwgUnnoTE/qQn+IVg4O+69OkLItKJEgfLP9dc4fht5MiEN/hUeGaqs00WcWAR
         KJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=9LvvtodZE4lnsgetaSvcmgRimwxuWALnezRS08pYm0k=;
        b=tA0gQ3d3Z9trvNA418yd4Ht8hETT7S5Jxf6qPmdoMnt/xQijG80m+Tbz8Ts6VBbow1
         84QrhezHHx5f5ukUJzV0dtfVAw5b+n6w6VZwFCq+xVQWy2rXPNjNriLHRX2Q+uUDlZQY
         /LMYRUHvXAv8keNqiBDr0A8tc6lAAMalhUlco+Fb/vlz4pG/JN8LrLh8ROYu+NHv0gUu
         BTQN9s8hPZnN3hOYxl5q5xRLaBjVbDBk4c576nZPHOGRQEBTWOvILs97w5yjqykqKGDC
         qNkhTvWm5U4YpEuBLVJutQ1ZjByGtCL+fDeu7THbYWTsXgzVzjd07QwR1aLiIDBcnVnG
         PlPA==
X-Gm-Message-State: AJIora+FCt28s6P0jPjzfXTdupmKYwsXHEC/mJGBtmq/WpOATOD2OeUg
        egVUEM2ah/bztROiUL5dR5A=
X-Google-Smtp-Source: AGRyM1vCo1UIUGLQA7xTplZMs5jbkpZuKvy7nkBmZlb5W6wFr3tbtgJkLURE8BVLbTSfLc2SJRn1sQ==
X-Received: by 2002:a17:90b:1b0c:b0:1f0:1c:1f8a with SMTP id nu12-20020a17090b1b0c00b001f0001c1f8amr9030659pjb.77.1658374390425;
        Wed, 20 Jul 2022 20:33:10 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f26-20020a631f1a000000b00415320bc31dsm266836pgf.32.2022.07.20.20.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 20:33:09 -0700 (PDT)
Message-ID: <2492407a-49a8-4672-b117-4e027db09400@gmail.com>
Date:   Wed, 20 Jul 2022 20:33:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     joel.peshkin@broadcom.com, dan.beygelman@broadcom.com,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20220721000626.29497-1-william.zhang@broadcom.com>
 <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
In-Reply-To: <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/2022 8:32 PM, Florian Fainelli wrote:
> 
> 
> On 7/20/2022 5:06 PM, William Zhang wrote:
>> RESEND to include linux arm kernel mailing list.
>>
>> Now that Broadcom Broadband arch ARCH_BCMBCA is in the kernel, this 
>> change
>> set migrates the existing broadband chip BCM4908 support to ARCH_BCMBCA.
> 
> Looks like only 1, 2 4 and 5 made it to bcm-kernel-feedback-list meaning 
> that our patchwork instance did not pick them all up.
> 
> Did you use patman to send these patches? If so, you might still need to 
> make sure that the final CC list includes the now (ex) BCM4908 
> maintainer and the ARM SoC maintainer for Broadcom changes.

And the threading was broken because the patches 1-9 were not in 
response to your cover letter.
-- 
Florian
