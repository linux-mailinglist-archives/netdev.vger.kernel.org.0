Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C7B50A72F
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390635AbiDURgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390618AbiDURfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:35:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C45F4990E
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 10:33:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id iq10so1822632pjb.0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 10:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tNVhvJ/Zn4Qjp/Wh4qlL0sHAvit4aP8pftBdQEwpj8Q=;
        b=KnluVB8n7ICCuvzH9qC7Xk0TpgDgtkXsKGCfoy76e8uyeCuLE4dAwwe5W6N0bx1dOZ
         TD4IjMp5KazqmS4MP8cv2U0SwDEPvJvybzT2hJqtfiRhlckdAPDt2p6Ov1uPv8B4VusG
         udFGhTwQ1XG5O2z9llUB60saBQNP3CywkYquSTONKk8KV+n3iOgqsXu8oGi7HMFkIDyc
         iQuSjR+Usym/D8VPZ8rlPpaAJHsYu2bBnQcR223vz8HMoXXWruE6knSK9fEMR1ZBh+bH
         vu+q7XHJJOAGSm1rwFAqdamdwFr9yW8937f1kXu01ziCP3YggKaAEgScimJse+Dj0mAP
         56Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tNVhvJ/Zn4Qjp/Wh4qlL0sHAvit4aP8pftBdQEwpj8Q=;
        b=2jCfB3gxzMHpSoF6frgpPdb7U9o9gwJJ6sR2oxIkqkzMzKf90l/lykalBeHmN1wsHt
         3QI28abLhjg48PxGTrmTV6iyYbrpvvoeP1GHY703f2/8sdBGWpx9yjb11vvYnm4JACME
         CsckkNa4UL8ez1WoE2x7e+9eyEs/PKg2ewq8FIiKH9QjX8D8uHYhKZC888loMpYxHK+3
         Sb9QJpqBDIc6JMtHbmTRyTUiha8S7j5cGz00dBBbjn36WmdltCfsQfamy6ZFtUuoz9uZ
         Wdebet+Kd2rpdDGeZVt00JgsE9R0PVsQDT0vzrOAIjSN1xDSgqYi3Dw3iI9EgXVq1gF0
         AT/Q==
X-Gm-Message-State: AOAM53084bld1bJK5KewG3yTjLj08E1edwdOrytmmJqsI0sx38xyA30L
        CWztjPfesx1T74PpNmOeeq1wPv5zHX8=
X-Google-Smtp-Source: ABdhPJzI3SO/sdca5yCpuixtibhuTC2i1F87faFDgcU2b5Wj8kTwIIwUpP7O8ejevOPJHsdypqyUYA==
X-Received: by 2002:a17:902:e541:b0:159:db95:9d30 with SMTP id n1-20020a170902e54100b00159db959d30mr556073plf.91.1650562382727;
        Thu, 21 Apr 2022 10:33:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y190-20020a62cec7000000b0050adbfee09asm3288186pfg.187.2022.04.21.10.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 10:33:01 -0700 (PDT)
Message-ID: <32e384b0-53ab-c813-fe70-2588d46ed7b2@gmail.com>
Date:   Thu, 21 Apr 2022 10:32:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Support for IEEE1588 timestamping in the BCM54210PE PHY using the
 kernel mii_timestamper interface
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YmBc2E2eCPHMA7lR@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/22 12:19, Andrew Lunn wrote:
> On Wed, Apr 20, 2022 at 03:03:26PM +0100, Lasse Johnsen wrote:
>> Hello,
>>
>>
>> The attached set of patches adds support for the IEEE1588 functionality on the BCM54210PE PHY using the Linux Kernel mii_timestamper interface. The BCM54210PE PHY can be found in the Raspberry PI Compute Module 4 and the work has been undertaken by Timebeat.app on behalf of Raspberry PI with help and support from the nice engineers at Broadcom.

Lasse, can you copy the maintainers listed for 
drivers/net/phy/broadcom.c in the future? Thank you.
-- 
Florian
