Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A0D6AB6DB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCFHTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:19:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF2CC15E
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 23:19:09 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id a25so34679690edb.0
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 23:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678087147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=znIlFcnwE2/NQIRfEz5JKkqyLpI8MP4wJ/kYSi/TDQI=;
        b=RqQXDbyqoJicHw2jnG/2ffmP9/I7nDpxXNle2XT3ve9bqiqoqOEd3iaNpS5m6qcF7u
         PRjCpH82y+a8W1ACbpx/ZPvhY5y5Ehdi5w1aCJnMLnmEZo053lkdviVLomEFSXWWYRG0
         +aGIAb9FqtL+ePWCa/kLop9Wy6/JCguP7U6cZ13riZS7KjtWuduNiMwXZ1Ukh1una+/f
         LOla5Jo68exDq7JpgyvhbHDi4DXB1TviEBFlSbUBVJ5/YMGLM1PWNyhvol7jWTFt+CBa
         pUN7LYjuxS+gEzlasXa811BCikBiM7AIp+6wE52fjnhvvuVc5pxUSsD9+SjGNo6Qcj6a
         13zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678087147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=znIlFcnwE2/NQIRfEz5JKkqyLpI8MP4wJ/kYSi/TDQI=;
        b=z9NiIRvJuRuAzuARGzZHHBR4KNurODGNugJbIAxcdaJ7DzV2pXMmohHNjIjVhUCn+k
         9IQ6zefajjuE7TX0MsVx9dRUqOArVcUSmc/cnpCGMrqNRjFUHQKxnCz6XMaAH/zWeQwT
         Hd/71JeEOkERCYBNBOC4neViZwv5N/60x57t+NgWLlDh1//WF0l0pUPMfe8JMQNZY2H+
         lKHr7Z0CWjbEhzgRUe60Zxusm9sucrN/2KwcJ4R0lXiEI8wWjhiqA7pKe6JSho+Gk3Cv
         wsqD3wu/kxDoBxsCpuygsDGJQ8Xpi8vQCNNR5PYiKd3xqWM0vJscLzNdSWQeyx04R67g
         t8QA==
X-Gm-Message-State: AO0yUKV8pCKet3+J4zMM5uuxldwuCvmzDzgvDQS69mc1cGYHc/iA3KUW
        jOs54rNjVZ2Xko8DZa+oreGIJaObP74=
X-Google-Smtp-Source: AK7set/lwh6et08nQVLgM9F4fH3XWtBcsrBYujdtCzTa1yMyttGInU0rCymUsJf+9V2Vz24AMhd1lA==
X-Received: by 2002:aa7:d60b:0:b0:4bd:94b9:b8a8 with SMTP id c11-20020aa7d60b000000b004bd94b9b8a8mr8443192edr.26.1678087147457;
        Sun, 05 Mar 2023 23:19:07 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id d27-20020a50f69b000000b004acb696a0f6sm4655767edn.91.2023.03.05.23.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 23:19:06 -0800 (PST)
Message-ID: <3f4933b8-e98f-3572-745a-6dbb47fa4cf1@gmail.com>
Date:   Mon, 6 Mar 2023 09:19:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] net: tls: fix device-offloaded sendpage straddling
 records
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Adrien Moulin <amoulin@corp.free.fr>, borisp@nvidia.com,
        john.fastabend@gmail.com, tariqt@nvidia.com, maximmi@nvidia.com,
        maxtram95@gmail.com
References: <20230304192610.3818098-1-kuba@kernel.org>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230304192610.3818098-1-kuba@kernel.org>
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



On 04/03/2023 21:26, Jakub Kicinski wrote:
> Adrien reports that incorrect data is transmitted when a single
> page straddles multiple records. We would transmit the same
> data in all iterations of the loop.
> 
> Reported-by: Adrien Moulin <amoulin@corp.free.fr>
> Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
> Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> CC: tariqt@nvidia.com
> CC: maximmi@nvidia.com
> CC: maxtram95@gmail.com
> 

Thanks for handling this.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

