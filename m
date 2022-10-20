Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DFE605573
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJTCXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJTCXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:23:31 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030001D5E25;
        Wed, 19 Oct 2022 19:23:31 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id a24so12914207qto.10;
        Wed, 19 Oct 2022 19:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9lB5arQHffZuEw1/gufkq+xRyVa+H5y2gBqdt079YS8=;
        b=afmDpeKvZHQ8ZP3dazfMRPJO3k3uVwvPrd5HuNSMdSZLdpYlO+rzSoIT+287dLPkLw
         LrOSTJ5Z0Z9121Z59cekYYH4DVkmBjnt7XLTQzFQbbH3tgZLzss8+NTGZ3/varM+dQLC
         X2+ih+J4npIh2mug1ZjWx4xwgX3fpn2kwcXJpiCRWVzPmKANoXe+PdFtjIkWD8Zo5cpa
         2YydRcOD67QKodCKRHcK9KDQfgLAJjFiq2FpUVdzURO4JemsOWlAFZCXYufXrabN7NOy
         Uc7Rx2O4Hyj4795RBjDVxqsDKZLngG6YzukMBuFCjTWQ2TZijCZkHW798NYoKOc0UIBX
         kOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9lB5arQHffZuEw1/gufkq+xRyVa+H5y2gBqdt079YS8=;
        b=AsMCOkrophgKIam7Q3pWmilIwq+EQQ/iYCD/GNoWReA7bAWj9XR+Z+NDFoSYqOX5Yw
         ofR1y823D8S3u9dGVrbUp0dzvpxdRsNeL299Q7RRNAHRRJkJnVYwNN7sx6+FpgwEHJlj
         t96mWy6vKvOAjsELbYpts/EmHr7GmrlDOv/beHfnvnji/mqWYqyoSYKzaDM9zeWIK4nF
         ihkUSlzLtfv+T88DbGzxmHtsfNis0fSwiZk9A3AKofFQZ1DlycZnhQkYeeWZH2vuNNBF
         scKPHzwK6dmF6yHCn3qUd+bI2BBiQb70gnTA0NAXjsB/EGrXjrKwHdwvcvYA3IJyzYAW
         6KRg==
X-Gm-Message-State: ACrzQf26sjgm0t1Z4wZBKwDVp/dyjCLJYRWFxIO9zAUOCO7cmu4rrw0q
        3af5TUyjgffzVrVRlSaA3FwdoaidHss=
X-Google-Smtp-Source: AMsMyM61M+FGhHV7uc+pRXMllfs3Dnt+txsGR4IMmW8EKQCIRiu3qgotTtLMcIdpC6YTRnh1HywOPA==
X-Received: by 2002:ac8:7d81:0:b0:39c:d6ad:cce9 with SMTP id c1-20020ac87d81000000b0039cd6adcce9mr9414490qtd.81.1666232610039;
        Wed, 19 Oct 2022 19:23:30 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r8-20020a05620a298800b006be8713f742sm6568745qkp.38.2022.10.19.19.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 19:23:29 -0700 (PDT)
Message-ID: <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com>
Date:   Wed, 19 Oct 2022 19:23:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
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



On 10/19/2022 1:35 AM, Yoshihiro Shimoda wrote:
> Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
> ethernet controller.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

How can this be a switch driver when it does not include any switchdev 
header files nor does it attempt to be using the DSA framework? You are 
certainly duplicating a lot of things that DSA would do for you like 
managing PHYs and registering per-port nework devices. Why?
-- 
Florian
