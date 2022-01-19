Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A784933BE
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351097AbiASDqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiASDqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:46:51 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C2C061574;
        Tue, 18 Jan 2022 19:46:51 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h30so1030107ila.12;
        Tue, 18 Jan 2022 19:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VhFWqtfS53NlaIXZZHHH2I/cw34K8M2uEVfmGSHsbrM=;
        b=iXjWcTZ2020uJS0SoWqbVrSDTcAcWxkxIjGOtjHnRsSbpE+1KHIAs5+I/088r43x7H
         eKpbcqTJIRY5P5GEvdLUWfzrWKwnkN95Xd34FO36p/eKFo/i8kquLxUGQqu7AlQGKADN
         rLsX5koZKCc/PXYVlJEU8omIQwvAVMxuTH/CEnDH5GkonjyWhTgBm42zJSHE8bzP8kjG
         z8oFZ2fnWfhImzibX/xPDhgDprXYMBKtJ2gpVj6rk436UYK6Osiok2KPH2o04xjac017
         HBhpeOjCH78xf9BA4smzLd/NncDqYb1T4+h+p/Fmr7oFgEmF/+xPDbpcI5JSMBcokrda
         9psQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VhFWqtfS53NlaIXZZHHH2I/cw34K8M2uEVfmGSHsbrM=;
        b=8NAAc+JbqU5qH2NnwmAIdslAslRuflPj8YAhW553HugWXNvOnnxU5M4j7vHfPpAdnC
         cCgq6BR9yqJCfDVDOGSL4XNPI3/brL3nAkY6Pg1prfINlH/bpAh+rtP2U6K8onlkZW6s
         fSIbRAXa0IrXRvtPSGQOVj/HaqU+qxWT5saArVhmG7SNbQKlBop/QYSU2Yoq4coMiYv6
         ivtvOVblNLX7kQwRXYzx32nPVF/Xq9YBbZVqTwwZi1K21W4MOoTbUQIqBC5Z9bUkxvpo
         t+tAo2Mwrfj+37mmEGZBTcUCTT6wIhc5qwPbz8N/qYHe83Ad64ZfvMzL3aTdhB0iSfIX
         bm+g==
X-Gm-Message-State: AOAM532eV0h//XXvZ6V7tLAlrFzxPdxfdn1lb+yigW27fLmBXUMXJahw
        da+UIqTRFXynl4pWJH9vHzs=
X-Google-Smtp-Source: ABdhPJxBLoeP/4doJy/1PHCQNJDMuvivRCbJ+y/Qmq6cU7/BKPmImOjXRPsVGvLSgX3FIHNVmgaoOw==
X-Received: by 2002:a92:c142:: with SMTP id b2mr14036323ilh.214.1642564011217;
        Tue, 18 Jan 2022 19:46:51 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id x16sm8196231iol.33.2022.01.18.19.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 19:46:50 -0800 (PST)
Message-ID: <04a436b8-3120-4671-a1e4-cf690ce8ec60@gmail.com>
Date:   Tue, 18 Jan 2022 20:46:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 118/217] net: Enable neighbor sysctls that is
 save for userns root
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joanne Koong <joannekoong@fb.com>,
        "David S . Miller" <davem@davemloft.net>, daniel@iogearbox.net,
        dsahern@kernel.org, roopa@nvidia.com, edumazet@google.com,
        chinagar@codeaurora.org, yajun.deng@linux.dev,
        netdev@vger.kernel.org
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-118-sashal@kernel.org>
 <20220118085940.6d7b4a88@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220118085940.6d7b4a88@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 9:59 AM, Jakub Kicinski wrote:
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>> Acked-by: Joanne Koong <joannekoong@fb.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Not a fix, IDK how the "Zeal Robot" "reported" that a sysctl is not
> exposed under uesr ns, that's probably what throws off matchers :/
> Anyway - it's a feature.

A lot of these Reported-by from robots should be "Suggested-by".
