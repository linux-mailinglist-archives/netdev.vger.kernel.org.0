Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034E36E0FA0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjDMOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjDMOG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:06:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AC2A24C;
        Thu, 13 Apr 2023 07:06:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id hg12so682600pjb.2;
        Thu, 13 Apr 2023 07:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394785; x=1683986785;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=755nBU1zulNOs2YutsXsGDDt+M4BYyX1RbQ3zgyAT3Y=;
        b=OxxLy6Q07oG9e72IePpFrTffePb9O3gLGcm9T9fchwwDsWRJ/MfGvUBxnwUFOea3pt
         iT62h2nYzP6yJgGUh3EBJvssdPzYSyB/vdMQ1PN7zdzC/fva40jJXszVOqnrJjqIlwfc
         Ar0bx+/gaJXxyDRH3Sxcr8jTampvQ4ZzKqQn8abD1UwHM8HP58llMPVC0ELmFaklwjoc
         GrlaaphUPi7VAd4Je0N8Y8+zE4ctOFTTxZf1TpXwUc9rADRy8UQtC7JAOGB5CRziNG2v
         5i2d5mxsrTL7F1GlPAWArE0GVP1Xi2CBRV8bVMphUjtaNekA58NuBDNFdPFV0uOMW/jd
         F6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394785; x=1683986785;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=755nBU1zulNOs2YutsXsGDDt+M4BYyX1RbQ3zgyAT3Y=;
        b=IyzvwrmYpI49BWgeIwG/j5En0y0qhDD0HV7Wgo7FTnQUkppgTD9nFevi5OYCxYmsvO
         dSoFvQ//hbnyGuE4BOwWI3V8KUB0YbgjE1QSOQ3rOoNFai5xOHjzM7cR3Uk1l2DHZxKt
         qx9as9n8/+h+q4yL++Bw4MSOlh/tEYclm9T3PUPq1kWki6ecSiqRVeQmelEZsinnSIc8
         ItXhBk4U0y5cqxOTLjx5QbU2XUvV3fN8gzf5RylOFuIRvvBHz3dlJm0TzsMeJ2abW7zF
         Jsu7qfi5RCptTDxGktARZYjTAIQJR1zVNUMzOAmy+wQilp3iEMNPMsAXZa8BWYRj3uEf
         v51g==
X-Gm-Message-State: AAQBX9caMfMHhkVl5VwGzT+T1G38klkrM1KrOhkzuwOCzedwHIl2zKMb
        i731q7pGBRsXzGmDPp09Dww=
X-Google-Smtp-Source: AKy350aL+J+mLJIp6DjsQh+ajlKOV9a1yYr9yYRxZBl/Ovd1jckknKTC+goTD7oQNzTiivAFykjXMA==
X-Received: by 2002:a05:6a21:8688:b0:da:897b:ae40 with SMTP id ox8-20020a056a21868800b000da897bae40mr2003234pzb.37.1681394785601;
        Thu, 13 Apr 2023 07:06:25 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a18-20020aa78652000000b00627f2f23624sm1442132pfo.159.2023.04.13.07.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 07:06:25 -0700 (PDT)
Message-ID: <ec5b01c4-1482-548b-acbe-ea3ab51db1c5@gmail.com>
Date:   Thu, 13 Apr 2023 07:06:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 03/16] net: dsa: qca8k: add LEDs blink_set()
 support
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-4-ansuelsmth@gmail.com>
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



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> Add LEDs blink_set() support to qca8k Switch Family.
> These LEDs support hw accellerated blinking at a fixed rate
> of 4Hz.
> 
> Reject any other value since not supported by the LEDs switch.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
