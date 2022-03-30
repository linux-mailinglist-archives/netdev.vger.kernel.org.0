Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9F64EB8EA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbiC3Dgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242328AbiC3Dgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:36:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D46D3BFA6;
        Tue, 29 Mar 2022 20:34:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p8so17632771pfh.8;
        Tue, 29 Mar 2022 20:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vTugT/4Ia9cHp1UAxBJ5NKpmizvA1ucyAF8czBK7kvg=;
        b=UwUhmdlz1NSkqDJef/8AB4ijupYQIvdbyICFGkkx8ZZTqG60rJdPD+bdVZRTAKF9kZ
         c+lJWscod14KrmablhlS8v6euyHTz+9fXid/Dw1883VhmGi3j3CUcXXxKK+rTJTwkws8
         U3q6LGsaFU8PgB6iN4J/JooIxnjytJX2Xca+hL9uGnf9GrJow0xttE1Z1+lBYfp6PjDe
         gJkKDI/szKDaJv8pehKCzj2P8lDrJiW8Lod5+EqQhtZjGUgCAskDPSsFm1dlrfR5TesN
         Zek8TVhg6jIv8aHAWhRSE53yPW+Tv308pRhgo3A1fnjg/CBOY0pPtk2oQb00TqeWULIO
         xtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vTugT/4Ia9cHp1UAxBJ5NKpmizvA1ucyAF8czBK7kvg=;
        b=5Wshn153UN7pEPCEf8rtwbDC7xjo0+kt7Z8HWFIgRyEXkxQOGkk4TpDSlvxprsok0G
         pCoHozB16HfaF3oTkgyy9nBnrEasxtwgSaLl4OVuQTxXqv4f2UUJLKpC9OIRB8KVvDvx
         cgRsyNu+qpf6M2BMVJD9jkyd9TRvER3ewg652leWf6x8l82AGo2NpCE0wZIq1kk44K6X
         YJF9rtBHQjSCt9halVFH1GMBRrtrJb0wDsJ6yrpFivoewRu6WWnoJITiCGf8V1wHxvWk
         VaUWaZ8XA4Vd2b81bQVuc6pImq8RqWrfhd9/YPEiX4VgAiEuK48X6yt2QFAyxz1tCu+A
         oAAA==
X-Gm-Message-State: AOAM533YMhiNjWsyGS0nKqlXuxKLEym0v3B9RTYNdVUiYBv3CeUMCUkq
        myFhzAahAvgwNLDks4XXVuM=
X-Google-Smtp-Source: ABdhPJyvskztTPglUS0kD4YTfESHyz8JJbzlFwH0iXPTWtIuOgwsfY8TQ0M6g8gMo70p60TuB3ajFw==
X-Received: by 2002:a63:1566:0:b0:382:a08b:1ce0 with SMTP id 38-20020a631566000000b00382a08b1ce0mr4554914pgv.89.1648611294665;
        Tue, 29 Mar 2022 20:34:54 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm16150389pfi.75.2022.03.29.20.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:34:53 -0700 (PDT)
Message-ID: <79826172-9aed-7bae-bb0e-9c6ce0c912f4@gmail.com>
Date:   Tue, 29 Mar 2022 20:34:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 13/14] docs: netdev: broaden the new vs old code
 formatting guidelines
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-14-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-14-kuba@kernel.org>
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



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> Convert the "should I use new or old comment formatting" to cover
> all formatting. This makes the question itself shorter.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
