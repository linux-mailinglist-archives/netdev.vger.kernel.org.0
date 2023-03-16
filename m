Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237D36BD719
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCPRag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjCPRa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:30:28 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AE23D0A6;
        Thu, 16 Mar 2023 10:30:07 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id f1so1706889qvx.13;
        Thu, 16 Mar 2023 10:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678987806;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1ckKKfCdS6iR6CHpn4A1885U18s9IIj5WK45VdNbc=;
        b=Y2S88pw6EmpWjpdYCTxzNJq0Qwog9knPdu4mCJl3Pnx3XzAj3G8jH7V8GsXiZUH/H9
         H3M4bvSK0Bve9H+BGUw4GpaDTQMoJryhh23uBqa+XIOHc9wvUVvL2Abgp3IE35sEkr7X
         Yw9X7Yk8mKxsQAO0cMDzWMNfXMSNfAZd+Q3cEOmG7vkJvp/R+94p+wedwTksw2oJW9Bm
         iTmDoW8eAvx8JCH2rvPD8IjrRCW/Wqs87ZMTXHu6Nm/QrN+Q84LpEnWQsVjAX3BERle3
         jmhWb1KZP5W6tvX3ljV0KR1n2iIRks4PDBkzimx2ylthgwGzZECjbMz0plhTfmPrLkhz
         eBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678987806;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1ckKKfCdS6iR6CHpn4A1885U18s9IIj5WK45VdNbc=;
        b=ISKJvqv8OzPMPqQAw3MT9hbzLXWrllSH5Z5Uh5M55Lk/tqywoVlMzQoG5xoHwTtTOQ
         VX3NvUSDqG20598py4qOqIguNBpRPZJLQSoicec9PEVj4jKqqt/nbpFxSEt9mJvKwzL9
         5i6czABL5RAks9LPtCYtA0QPeVnh6Zllkmq2qsibKojcWXQK6BQSfUsRLN7cwO29UnZg
         lO/xOR/09Ik6w5IWj2XwLHwOPJ1ZsfZK+Hc2TlAOlZwbRPYiZ9OvIyXV/zZTXrxVzKWP
         TSkmPBisOH/cwGAPHQLHhJ37pgvJm6RZCD/48SemliJNiMrCokpy847PtGPsL7riQKqN
         +0OQ==
X-Gm-Message-State: AO0yUKV4y/ZtZVrkTuTtSaZqEE1M/HOUf9i+1BgDq3LQ8NpUEd83j6K4
        YDv+QpeESkbEl7PX9MfZba8=
X-Google-Smtp-Source: AK7set8VCghTK9sdZPFmL02S15AWQqH6WSVurO9amXjiXfU3aiOoqR1JXJswhVYF2+ggPEHsylzxtQ==
X-Received: by 2002:a05:6214:2622:b0:5b8:1f61:a20 with SMTP id gv2-20020a056214262200b005b81f610a20mr3173479qvb.35.1678987806299;
        Thu, 16 Mar 2023 10:30:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d78-20020a376851000000b0074571b64f0fsm6235131qkc.53.2023.03.16.10.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:30:05 -0700 (PDT)
Message-ID: <89808c78-2f78-6f17-883d-1bcaa52806fb@gmail.com>
Date:   Thu, 16 Mar 2023 10:30:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] net: dsa: b53: mmap: fix device tree support
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230310121059.4498-1-noltari@gmail.com>
 <20230316172807.460146-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316172807.460146-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/23 10:28, Álvaro Fernández Rojas wrote:
> CPU port should also be enabled in order to get a working switch.
> 
> Fixes: a5538a777b73 ("net: dsa: b53: mmap: Add device tree support")
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

