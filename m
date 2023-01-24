Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46E567A6DC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 00:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjAXX2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 18:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjAXX2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 18:28:40 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6615D3B0F7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 15:28:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d3so16282289plr.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 15:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=COR9vr/WzuWdRWPj83SY+1mJ8lvbBlEE6fKF0uCvzoI=;
        b=HDaSt/0VBWwEezJZ1tj9PN7BT7k+fnWRcEG97ayKwg6N2g7/je3JnYPd7awNzs5leV
         Ob5em5jqNmoqV46I7fy0MHkVKOwBrzAUm7NalKnac4wGLS6K4r+sKcx1RXdJNX5tiggq
         eEy9XZU/xmC0Kp+LhWTSQ2woSP3X0JmZIRIoYRUIYDG7tboJfJkvULVMp9lnbpfC9X4d
         Kgh7VE4ngM9WVp2qgc1LnlwRyn8XM4fKvbjtoxyHrdjspDpDr8L4JT8uNCQ9s85jMJMc
         DvZSm39YOolfAzHJ9qnziZZB2wVRloc92uM+EIJCHDdjxW4dpgUwPJognA9r0x30cBc2
         XySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COR9vr/WzuWdRWPj83SY+1mJ8lvbBlEE6fKF0uCvzoI=;
        b=g3r6Kga1kxtPbaa+djooPSgU41NpOlZaQFRQjdzdW3CVI1WpofxxPXUrs9naJOIDLn
         ZpzSquyr6BhDGHM9S5E220DMyXGVPGF8OIOSJeQl9SzManXbg+BCzRSIWsmtKGM3GcL3
         slcAgSAuBcxKKRg87WMQESycNReO9WA53ua1l5DSz9tiEszg8/RGRxupfZQvo93G+kuv
         ibuh7Klf3OCL9gansZAF8yaMMPg3Ty5kSVEIddrnyktkwfdBcbEALuOlGwIFTrAptIU9
         IkgR90kW1AawHv6WjnzB7+80udOjWPjibAF5kv1o6rDEyUlPDUkKwhE1OvxhwyZwuHiX
         gUAw==
X-Gm-Message-State: AFqh2kqFmCQnYSKehCAhcNkqOoq0fLsnLggbKu2XEOOd3ZfKI0G3W0tv
        pjfQJprzESI6IW2YZeptJ+JxUsbUfiBYxg==
X-Google-Smtp-Source: AMrXdXtlDfK7QOFrTXwfsd9Ytevy+d/BbCRwspCqzlwm87FFEX/vMVlNkJB48yfzGYJhfvtRjnWjbg==
X-Received: by 2002:a17:902:820f:b0:194:8e5b:5f55 with SMTP id x15-20020a170902820f00b001948e5b5f55mr29212449pln.2.1674602919869;
        Tue, 24 Jan 2023 15:28:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bb3-20020a170902bc8300b00192d9258532sm2204527plb.150.2023.01.24.15.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 15:28:39 -0800 (PST)
Message-ID: <77b6a4f9-be34-c1c6-9140-a39633fe4692@gmail.com>
Date:   Tue, 24 Jan 2023 15:28:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: ethtool: introducing "-D_POSIX_C_SOURCE=200809L" breaks
 compilation with OpenWrt
Content-Language: en-US
To:     Nick <vincent@systemli.org>, netdev@vger.kernel.org
References: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/22 07:23, Nick wrote:
> Commit 1fa60003a8b8 ("misc: header includes cleanup") [0] introduces 
> "-D_POSIX_C_SOURCE=200809L".
> However, this breaks compilation with OpenWrt resulting in following error:
> 
>> marvell.c: In function 'dump_queue':
>> marvell.c:34:17: error: unknown type name 'u_int32_t'
>>    34 |                 u_int32_t               ctl;
>>       |                 ^~~~~~~~~
> Not sure, why the code uses u_int32_t.

Should be fixed with:

https://lore.kernel.org/netdev/20230114163411.3290201-1-f.fainelli@gmail.com/T/
-- 
Florian

