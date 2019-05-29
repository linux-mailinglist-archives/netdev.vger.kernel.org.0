Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291842D98C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfE2JyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:54:08 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34513 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2JyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:54:08 -0400
Received: by mail-lj1-f193.google.com with SMTP id j24so1820324ljg.1
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 02:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lNs/p+JI3D1zMvTvnIvX3YzQkmwKplKfx1eyegHlUGs=;
        b=b7fhwy9KHyUHN1+JlY54Izh0UyO3XPFFISf05d3A09WpwVuLvrThPkOQMuiPkXAHd2
         av6G2ajatkgXHfRYOzoCM73Yl7wigIk/GrANkMIGKS0APqqPU8ml399Qb+v4pbmh3kd6
         8y9/xQ49KErSRP5pPjn1hWTvlBpTrg8GTFRC8fdrGE++BIime5+AGff2+5UUnMDQfXFk
         Vvh7BeWG2cAK2O6qE/SzBVHqhgh019YeN0H0NM71HAyAE0UoVUa5bk1oPzWvK9d3Fo2o
         tImwEqaC5PM0ibTBMRTPr956imoYfWybaalHs2WbQ4RmAaj5VaZ3Zwvh9WBR09VmmcFc
         Ap+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lNs/p+JI3D1zMvTvnIvX3YzQkmwKplKfx1eyegHlUGs=;
        b=nwXl+8bgWgaju2z6uArlKThQtwsyQ1BVT+ClEYzIzu+TINZHAWjNF463ftdtWzzaFD
         2rhqJrEVM4Zf0tML+b3E21XN7kI4nUSFrAFXnGBlneZQCZ57PkPVKH08cgUJrxObUnZ2
         MqpCs1dNLeNFQCyZW810wdJumhxq3/JbMWklcJWKUFZNTFZ5LQUZXvo8sGggQMe3JNZz
         utpht+bwWAxUSxTTms3CtK76L2bLCVhRTfWE5Z1xR7egAiA1Wevz6YKPPRlA6wBb2bVA
         T3L/BdHDcNKXssNahNk5P7mq41i3+LK1uQKk6LoYbp/40jinY+Qm4MnXJ8nnfzh5l5A8
         UpRg==
X-Gm-Message-State: APjAAAUZ5yPKV0Z75Z2zDMg+ceqE/u7nkWZjgPHlrSLZ3qxtAPC+RSrR
        spslVkG3QmkmUgCT+C4a06K/zw==
X-Google-Smtp-Source: APXvYqy3vMRQTqltRLbu1to0t8Uw2L6vp3NNLrEAEyPljntAyQr8TzYLsDyYWbDU7gEOUTVGvhAhRg==
X-Received: by 2002:a2e:9193:: with SMTP id f19mr26590199ljg.111.1559123646154;
        Wed, 29 May 2019 02:54:06 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.1])
        by smtp.gmail.com with ESMTPSA id g81sm3390192lfg.22.2019.05.29.02.54.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 02:54:05 -0700 (PDT)
Subject: Re: [PATCH bpf] libbpf: Return btf_fd in libbpf__probe_raw_btf
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190529082941.9440-1-mrostecki@opensuse.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e28170e1-cf06-87ef-812b-9b9e6185d925@cogentembedded.com>
Date:   Wed, 29 May 2019 12:53:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529082941.9440-1-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 29.05.2019 11:29, Michal Rostecki wrote:

> Function load_sk_storage_btf expects that libbpf__probe_raw_btf is
> returning a btf descriptor, but before this change it was returning
> an information about whether the probe was successful (0 or 1).
> load_sk_storage_btf was using that value as an argument to the close
> function, which was resulting in closing stdout and thus terminating the
> process which used that dunction.

    Function? :-)

> That bug was visible in bpftool. `bpftool feature` subcommand was always
> exiting too early (because of closed stdout) and it didn't display all
> requested probes. `bpftool -j feature` or `bpftool -p feature` were not
> returning a valid json object.
> 
> Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
[...]

MBR, Sergei
