Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5895037F1
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiDPTdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiDPTdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:33:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1170C6E4DC;
        Sat, 16 Apr 2022 12:30:50 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u2so11971789pgq.10;
        Sat, 16 Apr 2022 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=o1j46ljk0KokorCRHc4W5bGHgYOZI3rnTKQfHyykL6g=;
        b=C2so+dMmtvDtHxM/ILjbA3IuDMxRpTaQaMWMJMfKIb2kVgFgDUAtw2Im6sRhPRnIzV
         H+SVzp2v5cWkIXuFnPnEwUiGHpBKSyN5HcKfSr9WUbUjUWO9aWzfFUp3n90HTNoakvR+
         IzNAmh2MmFUwupWEhMUd8M0KkWmG7X0diyk/BQ46Mfq1+77sXqhwhg5Pnh0RBe6ZefYx
         DQSZfmEddBX5vB9mZrSYHahQ6QTudOlJoe4PUbrwCRg/ypn1FZuIYrc2qorgF6DlM+SJ
         CvAWkQCRcJdx0m0O4wo82XquehQ0VSR7DDb7Corm3zmZNmo5vgZ+oxATrrcAVJo2aoA0
         9PrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o1j46ljk0KokorCRHc4W5bGHgYOZI3rnTKQfHyykL6g=;
        b=ztw/fA+EsSuUSr1u1QXg/L3GTsY+eQv80CFon30TtM6jxzQbOaKReS0XafmSGDQOqu
         xrwGU1XkPbGXLn4ttGFtd5mM2/MKHhTwjyqipKJ3cE+bzUebJk4BNOobQW8F0faMRPDF
         Mkp/+YTE8j9Sc3lJV78Dbc9cV6MOZ2oPoXWQlJt6t6lrys5JmRcm2lIfjcLh8rd9thcL
         KZjmdsyuG7QSg46H5yKSIcOlqFcyv1iYxawvNpqbem6jw0bWM2hUzCq6Saktdw6vagEj
         ibmmvnyzFX/e8DpzOpj18ps36yl8F/WN8NoQ9p3mU8Lzl5yKsazvTVk1/4WOTAzZABno
         NVlw==
X-Gm-Message-State: AOAM532upwyz5YU/uVjcjgqs/R1ktr5MVLelsY1wcdkkfg2OGh06R4Iy
        mRn2CIiq3P0Cwpe34az2dII=
X-Google-Smtp-Source: ABdhPJyu2KFwtEFEDnC1XdJwqxIbO8zWWosdQH6/dXzUcrd5Oq4lDPUbimOEhYi7/1RDLgHENYqtzw==
X-Received: by 2002:a63:db4c:0:b0:39d:18bf:7857 with SMTP id x12-20020a63db4c000000b0039d18bf7857mr3971625pgi.413.1650137449541;
        Sat, 16 Apr 2022 12:30:49 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a67-20020a621a46000000b005060c73ef43sm6661780pfa.195.2022.04.16.12.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:30:48 -0700 (PDT)
Message-ID: <7454cdf9-cb8a-9329-83ad-48bce3e2bfdd@gmail.com>
Date:   Sat, 16 Apr 2022 12:30:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [net-next PATCH v2 2/4] drivers: net: dsa: qca8k: drop port_sts
 from qca8k_priv
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412173019.4189-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2022 10:30 AM, Ansuel Smith wrote:
> Port_sts is a thing of the past for this driver. It was something
> present on the initial implementation of this driver and parts of the
> original struct were dropped over time. Using an array of int to store if
> a port is enabled or not to handle PM operation seems overkill. Switch
> and use a simple u8 to store the port status where each bit correspond
> to a port. (bit is set port is enabled, bit is not set, port is disabled)
> Also add some comments to better describe why we need to track port
> status.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
