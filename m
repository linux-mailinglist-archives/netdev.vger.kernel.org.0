Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5ED99618F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfHTNsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:48:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50642 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbfHTNsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:48:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so2697868wml.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAT7SyBCLW4Yu4QrSneHAfmHCfaOcdPIhTOn63ZR9A4=;
        b=OLJ9oWSKBahvsUbwcKYm3EdKff/9kJI1ieDki1y8XUIY8Zk4vsQYeVxpF3pgeH03Dw
         NttuADIXxMTEU3UvpCF/w10V+3WRd+ZWkHzMUIuEE1LA0TaX8Jv15DeLqZHfQBT8gvE/
         bJq9+TvGN38Z4bT18oFxEdmPKM70Q1kBZGxomv3bcR0+wlANiFQ4lVBvlBjcEb8x1W4R
         NPQmdu4j+pFQCwCTHmpW+nOROMpHH/5oOcR3FM8HcuO69N52KwbNJSTV46thOdIEm8ov
         mwN3xw6nHN4VK4C9J5COc1+0xHloLdQmj/CTjU6VTHC7bmmNjTJehtaj56YHMut+9Zkr
         q93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wAT7SyBCLW4Yu4QrSneHAfmHCfaOcdPIhTOn63ZR9A4=;
        b=mjT6VRRcqC4ld3i0kTn3cHjj9TWX5CctPz4Ih3p+0nJJsV9F3DUjU2Gv8UKITCm1N2
         AlNoEIuyvYwiyddkcAGXerfaTb+MxJ30d1Skucl2TfHAzGr03LWZNsr0nN6myyG0pOe5
         zE/qTRx/MDxlyqOH4cWVr8jkTCkFwvsE+cPkH9dpYlUcIWddf2ZEaQFhKM5FkpBeek+3
         UkUidtPudn2LkVhJCd/yB6Yq3y8D7qzcNwxGTJL1xMYkz8ogSWDDcpPVTL5mxMNJ7eWb
         w5en3SqqFC1HdTS+dHIGMJJscY1h/ociEOyxa2Am47H2uko5tHmPFIs1YqpdecPt5KmA
         3Ncg==
X-Gm-Message-State: APjAAAUmoCZ5n9m1tPTq1p9kPvy+NPurdF6feVfduYAWv2kR72uBdd5n
        BjF1pPo1wrnT6BvI1MEAoZx9bA==
X-Google-Smtp-Source: APXvYqzw5VL2EY7tUEATyO7k1BRMQOVVWPMvfC2ycjU5JCZv2DMjS5gNqN9z6a4Erxg+kdhL7u+Kzg==
X-Received: by 2002:a7b:cd0f:: with SMTP id f15mr121947wmj.86.1566308912168;
        Tue, 20 Aug 2019 06:48:32 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id w5sm27954wmm.43.2019.08.20.06.48.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 06:48:31 -0700 (PDT)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190820095233.17097-1-quentin.monnet@netronome.com>
 <fcb2e528-6750-2192-befe-dd68ca36fc62@iogearbox.net>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [oss-drivers] Re: [PATCH bpf-next] bpf: add BTF ids in procfs for
 file descriptors to BTF objects
Message-ID: <534ce109-06e9-d8d5-9de6-240518286d11@netronome.com>
Date:   Tue, 20 Aug 2019 14:48:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fcb2e528-6750-2192-befe-dd68ca36fc62@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-20 15:36 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> On 8/20/19 11:52 AM, Quentin Monnet wrote:
>> Implement the show_fdinfo hook for BTF FDs file operations, and make it
>> print the id and the size of the BTF object. This allows for a quick
>> retrieval of the BTF id from its FD; or it can help understanding what
>> type of object (BTF) the file descriptor points to.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> ---
>>   kernel/bpf/btf.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index 5fcc7a17eb5a..39e184f1b27c 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -3376,6 +3376,19 @@ void btf_type_seq_show(const struct btf *btf,
>> u32 type_id, void *obj,
>>       btf_type_ops(t)->seq_show(btf, t, type_id, obj, 0, m);
>>   }
>>   +#ifdef CONFIG_PROC_FS
>> +static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
>> +{
>> +    const struct btf *btf = filp->private_data;
>> +
>> +    seq_printf(m,
>> +           "btf_id:\t%u\n"
>> +           "data_size:\t%u\n",
>> +           btf->id,
>> +           btf->data_size);
> 
> Looks good, exposing btf_id makes sense to me in order to correlate with
> applications.
> Do you have a concrete use case for data_size to expose it this way as
> opposed to fetch
> it via btf_get_info_by_fd()? If not, I'd say lets only add btf_id in there.

No, I don't have one for data_size to be honest. I'll respin with btf_id
only then.

Thanks,
Quentin
