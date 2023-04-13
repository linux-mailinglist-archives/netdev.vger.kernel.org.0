Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9817E6E0F59
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjDMN4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDMN4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:56:47 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7761B93F4;
        Thu, 13 Apr 2023 06:56:45 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id lz6so10391311qvb.6;
        Thu, 13 Apr 2023 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394204; x=1683986204;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tK1JRA5N6KDGdmKaslynfavZpPSvQlIvSyOFEkZ8StA=;
        b=d2vTH4A6bm3nTjMKPsnGKj8KAsZHCIjwLDo+bkY9ewgyZkk3czORlo5ccGpehOKLtb
         RFcuKW8sIGe16l0jZBODyM9j71MG7UnH8hGAdolwULWSjSFRlQtpAsgpIC78ngCu9J3g
         pjOmF/F2IdXdXsaaH85YonXQ1GWKmdqCquJCNisX1GO+ZyD1+xLR2XS35EcfCrfxKiQw
         liZCLKiKj+/BYsb5Af4/1LltDYwd1e6FcqlyDCNSyT/VH95kxHeeNnZ1n/sf/5tmt+B/
         AArlt5X/DwHDycaXlZMIB63t5WK8rRNtGIpKF8NZrPlePS1JrYEcSMnuoCCku+/OR1Z0
         pigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394204; x=1683986204;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tK1JRA5N6KDGdmKaslynfavZpPSvQlIvSyOFEkZ8StA=;
        b=Nvt9VeqzpFiiHampZIHxKYsb35cLR1NJeMKx64qU+MZqM4byFi8gjYCCCs6sjVufPf
         fVaOHaCy/lQ1cVWSi4NAxz11ZS69idULSyA0vlIh/MAcMXzhU5VIb/TfWAP6cGtFCUCS
         uJ5SGe9eSLVQA5OByJZVxWFqVt4tvyDiNlmSMKyw5PsVa+QHHDO4iPKhqs/XuKq47ZGA
         2bBn494svZpWUsAI3saa1oToYGHATqwolr/RwvTrCdi9KzarYiMe8yGQBqVP1X9Spnxm
         Ic4ixKmanF8fvx6q3Rqu2Xsyu1JBp+k6xflezuVMGmMMPf2+hWazjeSqSipovcsNtePm
         W1sw==
X-Gm-Message-State: AAQBX9f4wuErc+cIjhj9YTtZD65J9ssCwEO8lXdmqQlTbUsUGOvwx2X1
        XeizLDGckByoa0fBo6xM05I=
X-Google-Smtp-Source: AKy350Z7k7077eA/05w22f4qwXj1FQW+51rNDtlaDQwTzGWeJ6IrWyGNRtJLL2tMZEpQE/h3UuP3+A==
X-Received: by 2002:a05:6214:2683:b0:5a9:ed32:1765 with SMTP id gm3-20020a056214268300b005a9ed321765mr3550609qvb.23.1681394204522;
        Thu, 13 Apr 2023 06:56:44 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id n15-20020a0cbe8f000000b005dd8b9345cbsm438530qvi.99.2023.04.13.06.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:56:43 -0700 (PDT)
Message-ID: <540630ed-f60a-b3f9-f30a-547573270ca4@gmail.com>
Date:   Thu, 13 Apr 2023 06:56:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 08/16] net: phy: phy_device: Call into the PHY
 driver to set LED blinking
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
Cc:     Michal Kubiak <michal.kubiak@intel.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-9-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-9-ansuelsmth@gmail.com>
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
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Linux LEDs can be requested to perform hardware accelerated
> blinking. Pass this to the PHY driver, if it implements the op.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
