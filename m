Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADA5777ED
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiGQTW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGQTW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:22:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AC295A8
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:22:26 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 5so7331165plk.9
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BKEzhL5AZuWctYZnWxySx9DzRR9Z5lmAXfjaNn/Fttg=;
        b=bwdNkDT+bK+HIvPkViduXeq6X0rb0qa/B4gLaYB8ERoJVOJqjgsoZWu0/o/i8veMkg
         WQb1918hTN9W3Hqs4ZC1lYn+vjTdrcTkF8QRizN13DIl2b9r87McSu1I3htZqgQw+3y4
         xevVta6YcsCwwASo6tBc0L0/su8BZQd1Efu5runlSQSO3cB9mmKtfuIZPUdJF5xjxNpT
         ITPl9fikA35n4hKKWo0ibKNoSlxi6gMfB75Uuxu3ohE4er1oORCMUXXjyCtIfpgn2ogJ
         Bovq+qIkJowFC5XX5NQJ3UNvEdsKfsmFxIZyML2JJE2vSAY7keWaBckyyg0O9pxJRBg1
         aWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BKEzhL5AZuWctYZnWxySx9DzRR9Z5lmAXfjaNn/Fttg=;
        b=MZP73PanttX+9B9g1dBR9Wy6l0dZUoH+RGH6bEY/W3EB9RlcRzdDr+fFPYqTDpwPEz
         YqMrsdhWfgEYwmyvrSbfahwgfeE517JjgYzcgC51W/J6/VoxHBocoiW+zZ+wzpjxhigC
         kljpcGLe0iUMvKZ2Cylk4ByKRINJRLrQe9UPT6UBzzB76HW+wBiJZncTRVBFRMj4kFue
         N6HDZ9u4h3tO3b3gCXbVknBE3ZGzPC/oy8IhS9AIUqx2CpuF3naKdiXIeObJKwJWNjM5
         8HzGC6UBV/ZTuXLHFvInKi1r62ZAp5mjWWUiqYyqSDc8N3MDtPU3xMwgWOzV3mQ6xQv5
         tUqA==
X-Gm-Message-State: AJIora8nWaHcuBF81SlvN1lucw3BFnfA/GkOOkDmD9mUJQpi5FE/uFE4
        QMRF4YbgT6xrNoNFrW3k49baJI5Ft6E=
X-Google-Smtp-Source: AGRyM1vrZXkSi6s8CvAO0sqFsNz49CxpJz41Z4cFM1XO+FgnDODT5834QuhuhrmEp8cuw8IbDrCjyA==
X-Received: by 2002:a17:903:189:b0:16c:39b2:c217 with SMTP id z9-20020a170903018900b0016c39b2c217mr25533644plg.113.1658085745992;
        Sun, 17 Jul 2022 12:22:25 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id h20-20020a17090aa89400b001f04479017fsm7551224pjq.29.2022.07.17.12.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:22:25 -0700 (PDT)
Message-ID: <53a6125e-611a-ac17-399b-a5624c0e15a8@gmail.com>
Date:   Sun, 17 Jul 2022 12:22:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 10/15] docs: net: dsa: remove port_vlan_dump
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-11-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-11-vladimir.oltean@nxp.com>
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



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> This was deleted in 2017, delete the obsolete documentation.
> 
> Fixes: c069fcd82c57 ("net: dsa: Remove support for bypass bridge port attributes/vlan set")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
