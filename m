Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4984BF075
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiBVDZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:25:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiBVDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:25:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843AC1AF1D
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:24:41 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 195so15900366pgc.6
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rfZjg17t1Hbnqgz25mZ6nlL2MydsmqMGMMbOYemdKYE=;
        b=SZUS8dgrEvlZSykiZ9exD3jrkwUrj5DopepTJPDoguDPza3unTs+iLOxpjh+2jqXbv
         L8WbZT5nYZSvLrN5wwyBGmQZwHTxK8SQOZjM45JVmyJCd0W0qyGj93aC7hGL3lNEz0OA
         J3sOKXv7dE+gyheyc1eLGpA8fGQ6S7j0rqLpvMC52Y5fjkzX+0q41s5spLrjZAszLcWD
         46roU0G3Qx8isX4olIs3QODHbWQoatOw+EEQo4I97MRtD//2PeeQYFSLiEDiGimcbtGh
         n7snGlzRwWzgyTkcaDnA2ufCLKXoeDO/iw9DS4sxDAlcDQ9OLX/+M/+aoDM4YTh1kAlP
         8VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rfZjg17t1Hbnqgz25mZ6nlL2MydsmqMGMMbOYemdKYE=;
        b=fGCAeAll+3XWStdjRPGuFVaqqIGdDAfsUSiOy2T/UtwrzTi6eIGP5jqONL2xXbOipt
         Kn6BTX/ahukoQmdB7WEc8NHaOh+u+1zBx4eEmtoFiMZXehnjXhVSBRTUzzxH+WpDGk8f
         DK34xv8ujBlqVnfNfnTHZyUn3gjFOT6W9tuLhlV1MONk+WYO6fGY8liRaEfR0ZoMbWC3
         2zyza7ohbHjqlAeG/cDK0IJdC9vGfkv1xpDQg/N182k4oPbpZbAXwlI6N+FzGK6+64N6
         T+kfbccis8cSfs5fir3vvO4oyl32y0i2zLiRhiqIHBzPXkR47OazBd0tGkR4jlEql3Lv
         L/rA==
X-Gm-Message-State: AOAM531uWYQ4VNFcjD7csqJGB4g3YWUWO5S+LF1+OkY5tvnOABJqSPS8
        GNwR8wsShNVthBF1I3IIA9A=
X-Google-Smtp-Source: ABdhPJxwHAsdZDPDjovJ/mPm1B1jIUkQw3uyo72CVTtlU0yDv/BGjIAgvizgj3COLcDcb979XDcnMA==
X-Received: by 2002:a05:6a00:c90:b0:4bd:22a:bb1d with SMTP id a16-20020a056a000c9000b004bd022abb1dmr22721384pfv.32.1645500281044;
        Mon, 21 Feb 2022 19:24:41 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q13sm14902964pfj.44.2022.02.21.19.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:24:40 -0800 (PST)
Message-ID: <0ed938f9-a415-0b32-4a12-7241bc00d11a@gmail.com>
Date:   Mon, 21 Feb 2022 19:24:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 01/11] net: dsa: rename references to "lag" as
 "lag_dev"
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
 <20220221212337.2034956-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-2-vladimir.oltean@nxp.com>
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
> all occurrences of the "lag" variable in the DSA core to "lag_dev".
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
