Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F714BF0AE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbiBVDoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:44:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiBVDoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:44:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F05240BE
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:43:43 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d187so10640523pfa.10
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/7sXqiOUAdXt4KOfRvpynVYqEr87Q+e8T7DHXvfIMMI=;
        b=qY821bnFr/uUbfGdBNby2G6CJbKYWYG1jsQ0pcqC/Ui9TmYs38YfppoL0H+ppdOcd4
         H+Gv63UoalVNBDGmVxECvor2kfDyKrCJ2TU0mLe0WMRKSkWQ+Nvjmyo5+nRCG1AvLkb5
         VbVDQqVMCQaIukaPtRV5saDhmWYm3hCiex9r40c/DIBV0Zp1ZxnlBt1UTqs7PsqskYOr
         18vU1nDcmsrklkhmtWC1RQibsHnY1wC/kfgNzXcnPawATQULynTS95ebuBEeL+F0oZur
         CECMWZHTfFKM1LJRYm/5K3mjXF+xyT/d/5/Vn8jd2zdbJx2OlAp9lN0F6tIpNf2YP6p2
         J3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/7sXqiOUAdXt4KOfRvpynVYqEr87Q+e8T7DHXvfIMMI=;
        b=wq8Fct1exJKZ6YaIZdy/oG5KPJtfEcvsnB4qaQvoIhW+ZiYc/yTZJb4annGJZOodeA
         pBUA/vRDYYTaQQNMnSvPfKbMwGMfNOxe7W/NAPaHHdprT1VxuwZAdyoLadWoglOKQk5V
         dfhmJOlEJ+2MXLl5SKYBZtcXFfu/GP4977BYXq+JCw5lzECScLDCs7m0QFRYDCLS8o25
         8m3YwGQMJpgT9b2YRoSWpPBHIeD0gZfKuk8ww09Xr/jKJ75p1c6HqVtNhmrgHuDj+wff
         FGF0bvzrNOu3vfBUMJLpYatJSbA2h8N5jbNOiE51YdhzIhxfpqs+3O1li+P/y0s8XqQq
         CyyA==
X-Gm-Message-State: AOAM533ABgidZtfQK31C3D9GV2mSj4e4HTPVEIIZg6I1uI7ChD/ynyTD
        zm1Rd6T9vxDWe1rrrO3aGu0=
X-Google-Smtp-Source: ABdhPJw1SCiIvwxpnC5Rf42lvuC/f7Lm6WYr1UYBuwIvBwlLoqYekZZwPoh2e4HvD0pPxp5VrU2Asg==
X-Received: by 2002:a63:fe01:0:b0:372:b258:a8c9 with SMTP id p1-20020a63fe01000000b00372b258a8c9mr18341629pgh.376.1645501422889;
        Mon, 21 Feb 2022 19:43:42 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm720133pjh.19.2022.02.21.19.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:43:42 -0800 (PST)
Message-ID: <e4891c23-b456-4433-1ee2-5a4e4e5d9a4f@gmail.com>
Date:   Mon, 21 Feb 2022 19:43:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 04/11] net: dsa: make LAG IDs one-based
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
 <20220221212337.2034956-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-5-vladimir.oltean@nxp.com>
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
> The DSA LAG API will be changed to become more similar with the bridge
> data structures, where struct dsa_bridge holds an unsigned int num,
> which is generated by DSA and is one-based. We have a similar thing
> going with the DSA LAG, except that isn't stored anywhere, it is
> calculated dynamically by dsa_lag_id() by iterating through dst->lags.
> 
> The idea of encoding an invalid (or not requested) LAG ID as zero for
> the purpose of simplifying checks in drivers means that the LAG IDs
> passed by DSA to drivers need to be one-based too. So back-and-forth
> conversion is needed when indexing the dst->lags array, as well as in
> drivers which assume a zero-based index.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
