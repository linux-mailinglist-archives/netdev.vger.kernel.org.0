Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67485037EF
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiDPTdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDPTdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:33:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686C96AA76;
        Sat, 16 Apr 2022 12:30:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y13so76077plg.2;
        Sat, 16 Apr 2022 12:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=GXpYsibJgbwzrsoKdFVKjWbsXs5GVGrlAx1EyLFiLTw=;
        b=lrMCOU7PNkVpRq9cSaewuD16OZ0XI83/COfEOAPN/fq98jhfnfcDd6VHfRZp4d0o40
         c+pp+iVA7JgBxb+4KHi+D/HyrxEN4qFgyxib12so8j/VOk2joq/OXSN1dyYwXtrg2aO8
         gbNMqDT0kBdp36qd6XgGKRRvH9bYsX3oQ6uTZgUSp+3Ez9NAewa9q6zpfPWnjZ/yYuP+
         xCf0SMTRZPEHisqEv5fDMrSfW+SfoH0iiN5bAJcIEinXg1bxRvyN8WaT2T879hCnu4eO
         /Qr/LmiRQlqUg5/O6w3jEs4HNH5tdTcPIJgNAbDLN28X/t2OBexlBMCWwuD6KDGbfrmh
         BKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GXpYsibJgbwzrsoKdFVKjWbsXs5GVGrlAx1EyLFiLTw=;
        b=HTG/n5FMKvTIqf7YyPNzhsAOCtOYn6uA63Z0qFClKm5KYoNKhbgAuWnGxHPFf9Joie
         1vAw2/5xDnv3dCVOCpcbrUHEJzZI/1C+bB/ZkJlhNhThChF2Ev6pKcJxPycStTfsR8Fd
         hRDxsP5ceWn88t/Yi4F9PWQ+hHIWIauPid7t6vyhwljcvpwru6RKkk2kywq6K5DP583j
         G5g6RTSTHJRAvG921KrGlN+ZvkC24msMHjFRewAh8o0dSB/ALhuAJ+kUPQHfSXGXEoU4
         bkuB1J2E6X5IO41Mwp1hl7frWZsbn8+KFajIRDijPe4A5HbLfocp2u9OWVVDDJ1EVbz8
         E1OQ==
X-Gm-Message-State: AOAM533uG5gYGZRsOe/hi77FTxoxgka1Rx2qu/170RTDEHGeKZ8YY3eW
        epsTicEziDOGP4k12QF+3Q0=
X-Google-Smtp-Source: ABdhPJyOMBLHdNqrDWONKsaljU0WWFCfWY6TastEgVZnYLoVdtoCTVXmX8uwsHnk7sDfnd9tQGOr3A==
X-Received: by 2002:a17:902:d717:b0:156:20a9:d388 with SMTP id w23-20020a170902d71700b0015620a9d388mr4560170ply.19.1650137434896;
        Sat, 16 Apr 2022 12:30:34 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bu10-20020a056a00410a00b0050a641fc685sm213172pfb.115.2022.04.16.12.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:30:34 -0700 (PDT)
Message-ID: <fa334dea-b823-f658-0215-1e66e36fa30e@gmail.com>
Date:   Sat, 16 Apr 2022 12:30:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [net-next PATCH v2 1/4] drivers: net: dsa: qca8k: drop MTU
 tracking from qca8k_priv
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-2-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220412173019.4189-2-ansuelsmth@gmail.com>
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
> DSA set the CPU port based on the largest MTU of all the slave ports.
> Based on this we can drop the MTU array from qca8k_priv and set the
> port_change_mtu logic on DSA changing MTU of the CPU port as the switch
> have a global MTU settingfor each port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
