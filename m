Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB80132907
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 15:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgAGOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 09:36:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45016 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgAGOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 09:36:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so15250234wrm.11
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 06:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73LjBmiEkGIYm4Th768t00zd9pN6SU7FcL2GNuvIly4=;
        b=hbOsyfYA8mfDEbvNDDbXegn+/ld528lPjXtjdqGd41D4mcJ0gkwLBBw5hvfLRrhsgo
         8ZzZWm1f+RV0eZ8M6Q2mCxJHlBC0cq6NX/3LrqHTV4FT+n34tC7O8mPhsHllnz6SdCtx
         /Mrc7W+LTHNhr8/oEznNXCrGRfpaK2da5HTfWVFURHiPUP/vP7WOLy5LlXy6Q4JluxXK
         6C1P53AeTBTKy33pwuREr9wbuh3n+s8WioevHzeIxkW1TzqTceTTxpiKVXASPOYXDVPo
         wXuhR27QqTxmWTknQ04V3dMPgrOT/k//ok/pCcpyXaGpFyLMrmg6drtDba63rviX4T3Y
         Qg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=73LjBmiEkGIYm4Th768t00zd9pN6SU7FcL2GNuvIly4=;
        b=GPffDhsHKo5H7BvXRRoozNscI3U65NCBYXXSffozn8F8sNPlybyQHEzKyySuHY14cl
         vTD2v/jf9B+S063h0r17vsjLRxrGQvHwjNagNW6UQUOKXEWJLAI/6/P+YxswXtHaWRDN
         +BjsKYj/p8v+xUsouKSOt+ygv/LZ01WwAMP9beJ7ic2UQt2MD+4MxvBliUO0e+RcG58C
         IQyBVEO1WsarOTLEN0vDiB1N+w7mNqsrrzzgvB8Er+V5S1A0g19b3CVnxXjDT6mcwtZS
         YF4aHIIZTsWWaYSnmnjhShy+ycrCGFibaUMvU44a2WdyMzlIIb5I2HgHKVgkrV2qayir
         rphQ==
X-Gm-Message-State: APjAAAWcqRVZ99dSQB8YBlT8m8WYI1dyMZ5dCWYeFHxo22PboCm8gTFG
        6oyMleqNYm0gtfjH7cGP8m6dcQ==
X-Google-Smtp-Source: APXvYqx8EK4r2U+w5EdthGweQWs26preoOTiuOyCt7mCGziquf9Axoe9nbyDgelNKewOnUQ75OdmaQ==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr110415159wrw.289.1578407776410;
        Tue, 07 Jan 2020 06:36:16 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a5sm27168885wmb.37.2020.01.07.06.36.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jan 2020 06:36:15 -0800 (PST)
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200107130308.20242-1-mrostecki@opensuse.org>
 <20200107130308.20242-3-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next v2 2/2] bpftool: Add misc secion and probe for
 large INSN limit
Message-ID: <70565317-89af-358f-313c-c4b327cdca4a@netronome.com>
Date:   Tue, 7 Jan 2020 14:36:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200107130308.20242-3-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nit: typo in subject ("secion").

2020-01-07 14:03 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Introduce a new probe section (misc) for probes not related to concrete
> map types, program types, functions or kernel configuration. Introduce a
> probe for large INSN limit as the first one in that section.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>  tools/bpf/bpftool/feature.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 03bdc5b3ac49..d8ce93092c45 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -572,6 +572,18 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
>  		printf("\n");
>  }
>  
> +static void
> +probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
> +{
> +	bool res;
> +
> +	res = bpf_probe_large_insn_limit(ifindex);
> +	print_bool_feature("have_large_insn_limit",
> +			   "Large complexity and program size limit",

I am not sure we should mention "complexity" here. Although it is
related to program size in the kernel commit you describe, the probe
that is run is only on instruction number. This can make a difference
for offloaded programs: When you probe a device, if kernel has commit
c04c0d2b968a and supports up to 1M instructions, but hardware supports
no more than 4k instructions, you may still benefit from the new value
for BPF_COMPLEXITY_LIMIT_INSNS for complexity, but not for the total
number of available instructions. In that case the probe will fail, and
the message on complexity would not be accurate.

Looks good otherwise, thanks Michal!

Quentin
