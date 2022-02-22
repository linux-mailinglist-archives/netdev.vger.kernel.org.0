Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABF34BF068
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiBVD0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:26:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBVD0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:26:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25F81D0F4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:26:29 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so727224pjb.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BAiEmxvKSPYCHUS1zgETLzfZLZ9clkVm6pgYpgXO8F0=;
        b=hc+lLzZkkgZKb43rpxYQMhAwGYjeEE4aOmb0RPJEIGPUFmuybqoEbChJIUpPenPVmk
         hXACAGPpX3KaB+Gj1gN8UquWGYT8t0F1+feMnhlZFazwIDowjTVSZ/Jd8hPzqXVctoez
         4lzCUp2mtRUgXwjQeuRlJpZLvlIpDpw7rJTbOqTEZyWnFFtHsZLAEB9RDomoDxHVnLZa
         J6MLOnZE03ONqRgIZHTDKndjTScBbRsa60Kkl/KtlXRqGpwm+e+FiLOGGSVBxPqjHj/N
         t2y3mJP0RNmmV2hbU/r2i/MzI1St9iUqKdf6WojGIhFxHK+z2K7yvbTyg2g+QH1lGwTJ
         LHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BAiEmxvKSPYCHUS1zgETLzfZLZ9clkVm6pgYpgXO8F0=;
        b=xF65i0Hx4gdpf1FpZcVO66FMBlqnqRAf+Wwh+JB0A7HMDsj72eo6aUxkm43iV8Pm94
         77DBXM3QBfxTwRFSFGn8LY50DyQpzSAodiNdi5mPthrNAN43MAoiuggsDIJPKUCxpTV3
         8JmjUymsKfI7J7bdotC2Rdrcujv+1sjJva6CDuSCTO+fTjaFOewhzBI3OvzTMizuExdH
         Idrre+aG51A+7ju6Qtc3yN2eBw1tTab1WD02YcCk3TmiLGiBaNcJfhhUElp0YpBS/e5g
         BYsBrp95JlaRVdiiUTKsYF19qfl+hjdILX9uQKi6+Tr7SZ90VFXHSVOsqfXBHQTNiLn/
         C+Cw==
X-Gm-Message-State: AOAM532Byk9uT7nEuJHoTVKvvR2pCLapuklT+QFC4eBN2Uu//Q2SHeqQ
        1sEv+cFYmpAzmiE4b1U2B7U=
X-Google-Smtp-Source: ABdhPJx5ATnP4tHaKQEezptKVrpYpNpgC8jBvlUJAHEPgw1uV/On80Hgj5VRZhk8nbL2bPsHHu0Kvg==
X-Received: by 2002:a17:90a:420f:b0:1b9:58b:966d with SMTP id o15-20020a17090a420f00b001b9058b966dmr2021916pjg.28.1645500389425;
        Mon, 21 Feb 2022 19:26:29 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c9sm14902189pfv.70.2022.02.21.19.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:26:28 -0800 (PST)
Message-ID: <aae39467-7618-436b-953b-11172ccda0f5@gmail.com>
Date:   Mon, 21 Feb 2022 19:26:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 03/11] net: dsa: qca8k: rename references to
 "lag" as "lag_dev"
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> In preparation of converting struct net_device *dp->lag_dev into a
> struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
> all occurrences of the "lag" variable in qca8k to "lag_dev".
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
