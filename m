Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BD8123847
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfLQVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:04:12 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53056 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbfLQVEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:04:11 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so477692pjd.2;
        Tue, 17 Dec 2019 13:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tI+0rfyZxMpqi1+x5A6g2dbkPTkzQJsbaVymsCKWZsI=;
        b=ll/7lxuGzMpNF/z6jBXIkCBBP/l8evsRppMFDJI7bAjaSmZSf2uwNip9DKmXsrTrVS
         6aUPShhdWyoC09fv+0TJY/HZsDrecyx1Kq8wTRKrpyByMfqV6dwqKtXH25eJav1GHi+M
         Yn1c+H918a9f4xSTBM4YtOdO2Nts2LB3GoHJGFH9OkbHqa9OawcFulYji8y+STna7aXn
         qDZFGeWjw31MDdX+yhkFMWKn+8GYva3o4NtDWBeN/Z5jk5vyJJVTkiBn1yyN4L7QWQw+
         c3zIj6HvyKSaeMU6oFr7vronHK8uPxIX9khjEOCDxMDNEF+kcodZXhrn1zwZaU6p8p7t
         icrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tI+0rfyZxMpqi1+x5A6g2dbkPTkzQJsbaVymsCKWZsI=;
        b=QMmzx0UgcI6wFJnfk5p19Fu2dywtAtBVH+vLILFiqf2VtBanQoAjXi8BHdZkpjzyZ1
         RiucLsiuB2sp3EniMUrL2bmkudACZpAsRY92DTbFZQbVrTzDtrlk2yydb+63GXlotZtm
         HpG41/eNR2YJqb8ImZn3hall+Reft1wi84RtUvi1n9wg9vckRPH2cy6Lq1DmGFWJPfft
         UnSKcVwSOUXc6MvT8u7b8cy2IzAXZ/mMiGeeVl/rWz0KNDqAmUYprdprgKLC+SKr17G7
         T/LgbWdLvPfbKpPMLeJehEkeXC3tRVE2VezRUohTkWtie9DKGBZ0H8hPOJQFC3LhbWD0
         Q7hg==
X-Gm-Message-State: APjAAAWwdHOYqgm3MWmpYQ/g9b74qNjT2sSH2pJRnjAi3NwxzezHEaJD
        lARqBAHrjCHlYfFNyNKTOhdluh+p
X-Google-Smtp-Source: APXvYqxhKrc6X9ZO/n4xOcapDrldWR+J2OZB5k9YIrw+ZyfsmoFhJvumLAaz0rxyv+shDW/S446xqQ==
X-Received: by 2002:a17:902:d88f:: with SMTP id b15mr25332312plz.172.1576616650014;
        Tue, 17 Dec 2019 13:04:10 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 12sm1914571pfn.177.2019.12.17.13.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 13:04:09 -0800 (PST)
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
To:     Martin Lau <kafai@fb.com>, Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
 <87o8w7fjd4.fsf@cloudflare.com>
 <20191217182228.icbttiozdcmveutq@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <48fa41ef-c777-360a-279d-c71d0a5b6c47@gmail.com>
Date:   Tue, 17 Dec 2019 13:04:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217182228.icbttiozdcmveutq@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Andrii's extern variable work (already landed) allows a bpf_prog
> to read CONFIG_HZ as a global variable.  It is the path that I am
> pursuing now for jiffies/nsecs conversion without relying on
> a helper.

I am traveling today, but plan sending a patch series for cubic,
switching to usec resolution to solve its inability to properly
detect ack trains in the datacenter.

But still it will use jiffies32 in some spots,
as you mentioned already because of tp->lsndtime.

This means bpf could also stick to tp->tcp_mstamp 

extract :

-static inline u32 bictcp_clock(void)
+static inline u32 bictcp_clock_us(const struct sock *sk)
 {
-#if HZ < 1000
-       return ktime_to_ms(ktime_get_real());
-#else
-       return jiffies_to_msecs(jiffies);
-#endif
+       return tcp_sk(sk)->tcp_mstamp;
 }

 
