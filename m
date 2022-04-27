Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2EE511D54
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242930AbiD0Qf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243288AbiD0Qfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:35:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A1A5838D
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:32:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bg9so1848140pgb.9
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZQ0rQ6V66zQlseO16krWvzK16QAOswh2ipJZGC58CgQ=;
        b=V0+sqm49uiyIrYTaYUrXDxUszE7CnDjhth2SJ6bq1MZbi3N3K9d5zpkWJS2LypSOhW
         ABKU8n7kF3x4D7z0wT1hcfyquCXGXtfZKTzyJFDhrGehmmoqMKWE6RoiwMg6FkvWAChH
         5a+u2mDcluCsPdY8wtcKbNsVvIEYXa4HyeLHsuFhmFLMsUVFTFVcuVQr3a/7gdQLkmY/
         jZuon1gZlNvvcOfXcSPZ4RU8eTBNUUSGL2/YVHsL9fePb2cufqqTEKAfv1jP6mZEkkDF
         IpvGjgP3TRmpTLa/5ChmTx+9faE2jRLNKbtHpY7HMGnX5yQamvknRRY3qSx7hTGHc7jp
         jgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZQ0rQ6V66zQlseO16krWvzK16QAOswh2ipJZGC58CgQ=;
        b=PO1RL+xGfT2bjub8BsqXHBUfSh9taJh+nit2Qx/PV3EyF7Bm7ACkEWR3Y54rhTEZZ0
         RAqp30rpLXE6mcbJZZ5goDUl8T93kdWJSa+o8mWn1+UTZDq9JpLQpKy35w5JWdLZavut
         8ZKaMgdCrrNy9bwvwo7EjzITr3jozHmlCm9PAMP052DI2+Q7yYKF8QJHmzNRDKwdLweg
         z/z4fnSanHCi0ZuVyqtkOFEPZiXs8vrePr8nTZbaG15s8mmm9BMcivO75H3kvuyNQvgw
         020iGQn93BiZOPdRP+7RjjGXL0fIS/zx7b+tqM02Y2T5AayM+q8b2dfRJMMWIBViZJI0
         ULUQ==
X-Gm-Message-State: AOAM530g7RUDyj6adwISt2PjX5fzJWT5bg8DamHSeQ6BB+xTTvYHaifc
        RAznvMiXf5VbafIaPUm7WwU=
X-Google-Smtp-Source: ABdhPJzsaH28MMablpzbGAcEtXCs5tzDZDr7i2mc9oNq2tj42tKQGnQUlBa3Bh5EhqXqJSdQPFsHJQ==
X-Received: by 2002:a63:4e59:0:b0:39d:69fe:eaa with SMTP id o25-20020a634e59000000b0039d69fe0eaamr25022200pgl.340.1651077158828;
        Wed, 27 Apr 2022 09:32:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z14-20020a17090a8b8e00b001d95cdb62d4sm7614249pjn.33.2022.04.27.09.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:32:38 -0700 (PDT)
Message-ID: <5fa9f853-962e-784f-772c-7cbe61f38eec@gmail.com>
Date:   Wed, 27 Apr 2022 09:32:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] MAINTAINERS: Update BNXT entry with firmware files
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        andy@kernel.org
References: <20220427162145.121370-1-f.fainelli@gmail.com>
 <CACKFLi=Zg54Uaewkrn9J9wBT3-ucCCJbPu=yXc61PTs=SDkTkQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CACKFLi=Zg54Uaewkrn9J9wBT3-ucCCJbPu=yXc61PTs=SDkTkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 09:29, Michael Chan wrote:
> On Wed, Apr 27, 2022 at 9:21 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> There appears to be a maintainer gap for BNXT TEE firmware files which
>> causes some patches to be missed. Update the entry for the BNXT Ethernet
>> controller with its companion firmware files.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   MAINTAINERS | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index f585242da63d..0316d0c9a908 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3927,7 +3927,9 @@ BROADCOM BNXT_EN 50 GIGABIT ETHERNET DRIVER
>>   M:     Michael Chan <michael.chan@broadcom.com>
>>   L:     netdev@vger.kernel.org
>>   S:     Supported
>> +F:     drivers/firmware/broadcom/tee_bnxt_fw.c
>>   F:     drivers/net/ethernet/broadcom/bnxt/
>> +F:     linux/firmware/broadcom/tee_bnxt_fw.h
> 
> should be include/linux/firmware/...

Meh, I copy/pasted without adding it, thanks Michael, does that mean you 
are ok with being copied on those file changes?
-- 
Florian
