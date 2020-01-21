Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368A31445E5
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAUU0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:26:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33689 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgAUU0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 15:26:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so1837350plb.0;
        Tue, 21 Jan 2020 12:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y4HqdTARh6qInX9ivewXq2HuMoZktb2ZhhXo0h3rDfM=;
        b=hms1Wljnns+Dzujf4rTCZHcIkAgzokPVroKARWRREpX9cBSI8J64xvvMBigPSV0bvj
         E6uy1etXONSgLkuK4QdGs/YR7gn/FmvIkO1JbW5TU+lhqsqhtH9DlVys6IzLiKiLD/Fw
         Q17N8yeDNuo2lsrFP8LoXtvXAkeCcIYCGXsWalZ5W9/WyZUmUhibr26pzoAw5PnBgwP+
         5VeqrWpcZsGiV75vkt7mMFqofNTKXPn2LID7chFCbpJ+761rkdjQ6b4yfZWMai1vglUY
         DU3VAx00tjYwXWcPgLBdJg4KvO8ikA52iuxEbSEoE6R+7oLdaKZ8Ac7CCkkpVPZ2gVhe
         Ueew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4HqdTARh6qInX9ivewXq2HuMoZktb2ZhhXo0h3rDfM=;
        b=Uxp7XqOOvY2Pe87IenTviahNODM26EwX3/nBk9vbMRZtcaiBahP0793Zp010wNmqtw
         C10/ndGZM8/Ov7Silhl4vdpmsXjbHmDM0e091wupQFEUgGMf1VQKH5ctrftvMkqC1QUz
         DcdCJhK9uOEieffCps11kOEWWfADRDCkt7AhiFUABFNJ7Hc4AEtWEuT+/30F0AoWdPVf
         P7JcupaKmSGovSUHeCnT+iU2tkOh2PX/NyHqKpKbvktp6OIIT+DIUZE6/qpGGVGp/QUf
         ZmhnT0V/rnil0+qgd6/KUTQMKAshaLLCnZWBAjYVgPVLHbNn+uwaISsOAAwMyRAfQ+OU
         cl8A==
X-Gm-Message-State: APjAAAUobY9c6tsxjF5nzfcBX+Sv66tCyFuLoHNyMacmw6AY/JOcBaX/
        rmZZylakMllzY6fuvcCXk7/+Ze34
X-Google-Smtp-Source: APXvYqyWqZmSlAxFKJVAZDHF3rf2PgKN4EWBJH035w+s2HfAzaJ6vTLu0Zy7jQrhiQXS+ue9TroaIg==
X-Received: by 2002:a17:90a:c697:: with SMTP id n23mr204487pjt.37.1579638369699;
        Tue, 21 Jan 2020 12:26:09 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e19sm293082pjr.10.2020.01.21.12.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 12:26:09 -0800 (PST)
Subject: Re: [PATCH bpf-next 3/3] bpf: tcp: Add bpf_cubic example
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200121195408.3756734-1-kafai@fb.com>
 <20200121195427.3758504-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b8770e1-6cac-2e67-fb79-2feb2a35a0e5@gmail.com>
Date:   Tue, 21 Jan 2020 12:26:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200121195427.3758504-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/20 11:54 AM, Martin KaFai Lau wrote:
> This patch adds a bpf_cubic example.  Some highlights:
> 1. CONFIG_HZ kconfig is used.  For example, CONFIG_HZ is used in the usecs
>    to jiffies conversion in usecs_to_jiffies().
> 2. In bitctcp_update() [under tcp_friendliness], the original
>    "while (ca->ack_cnt > delta)" loop is changed to the equivalent
>    "ca->ack_cnt / delta" operation


...

> +	/* cubic function - calc*/
> +	/* calculate c * time^3 / rtt,
> +	 *  while considering overflow in calculation of time^3
> +	 * (so time^3 is done by using 64 bit)
> +	 * and without the support of division of 64bit numbers
> +	 * (so all divisions are done by using 32 bit)
> +	 *  also NOTE the unit of those veriables
> +	 *	  time  = (t - K) / 2^bictcp_HZ
> +	 *	  c = bic_scale >> 10
> +	 * rtt  = (srtt >> 3) / HZ
> +	 * !!! The following code does not have overflow problems,
> +	 * if the cwnd < 1 million packets !!!
> +	 */
> +
> +	t = (__s32)(tcp_jiffies32 - ca->epoch_start);
> +	t += usecs_to_jiffies(ca->delay_min);
> +	/* change the unit from HZ to bictcp_HZ */
> +	t <<= BICTCP_HZ;
> +	t /= HZ;
>

Note that this part could use usec resolution instead of jiffies
to avoid all these inlines for {u|n}secs_to_jiffies() 

	t = (__s32)(tcp_jiffies32 - ca->epoch_start) * (USEC_PER_JIFFY);
	t += ca->delay_min;
	/* change the unit from usec to bictcp_HZ */
	t <<= BICTCP_HZ;
	t /= USEC_PER_SEC;

ie :

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 8f8eefd3a3ce116aa8fa2b7ef85c7eb503fa8da7..9ba58e95dbe6b15098bcfd045e1d0bb8874d713f 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -271,11 +271,11 @@ static inline void bictcp_update(struct bictcp *ca, u32 cwnd, u32 acked)
         * if the cwnd < 1 million packets !!!
         */
 
-       t = (s32)(tcp_jiffies32 - ca->epoch_start);
-       t += usecs_to_jiffies(ca->delay_min);
-       /* change the unit from HZ to bictcp_HZ */
+       t = (s32)(tcp_jiffies32 - ca->epoch_start) * (USEC_PER_SEC / HZ);
+       t += ca->delay_min;
+       /* change the unit from usec to bictcp_HZ */
        t <<= BICTCP_HZ;
-       do_div(t, HZ);
+       do_div(t, USEC_PER_SEC);
 
        if (t < ca->bic_K)              /* t - K */
                offs = ca->bic_K - t;


But this is a minor detail.

