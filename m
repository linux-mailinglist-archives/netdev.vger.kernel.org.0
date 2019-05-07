Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B54168BF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfEGRGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:06:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38904 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfEGRGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:06:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id f2so16155988wmj.3
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 10:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S2isTtwl9/Sczr9NarPps1ISQPmeyLMikzq7BTupCZs=;
        b=DorSGhH1lChx014VRAHQpgjQ+v2X73p5SrQmu+9qBClNlCpuv4bcFppPahEzhDJfN8
         mudJkOEOr5j0EUsBN2A9RswoncpWwqQTjZ9FkdJpLdjxGaTZvIh5f1pkClXcnEkgXbgE
         QLVWCZa3VBw8IU7gGxdjYfnd69KGaQooYczbGtNiCSFPDpaea6xhG5pBGcXm21LmNQDt
         0x8hU/hz83P+/WthM4YhB22RXyb2FL6QzO7jxL1wbGKEkWe5fMmTtbAXSyJaTPJtOGmR
         V2FkGwf21plgieh9aSFsc6Z2N/n0OTL46Y59wXqojZgvbe17xtiUeKm96uw5uoCmPMV4
         3f2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S2isTtwl9/Sczr9NarPps1ISQPmeyLMikzq7BTupCZs=;
        b=lHMjrNegtNKVkybC+La5pWA/0Dk24XhsFKfgJ5C0e1rTD6s9Za3bG9tKYjfutySFKf
         YrDFFEl2CMNf0id3iGAYmSXREgQe4gqC8WVVAN1V94TSExOkaXe1O2AzUyeP4b4t00jA
         xjvHNauklTypvDMLmAO6CcIuv4EpbCMM7TkY+7ucEAa/cRsRQ2CtjREbQ/2wW1rtSSmt
         DvVDP7XNx2W80cfQTaqI/50i46CHKwQNTiL0QYgMqmoUAtPVpEKAICvr/0KLm7fLYqrU
         ksZAwAMzTopc0FutSnh3tA5aI6hK2bTlONXOv/3pwVeQigTJVqaTU+JIDBO3gHRIkvbB
         8hrA==
X-Gm-Message-State: APjAAAXu3GjXRhGzo0Ud1SfoEutBxELiIc6bBhevg9Z8cuFa9BrabKsU
        IUVPkuuldY43dajjqRRdNPIczA==
X-Google-Smtp-Source: APXvYqyLSRrLL4D4gLkve2uTVU5Aq/4Z8ZCKqQkjQCDxFZTAPALp9k4fm8lz7SZzJYlFxyveZrCUog==
X-Received: by 2002:a1c:7e87:: with SMTP id z129mr17919334wmc.145.1557248794822;
        Tue, 07 May 2019 10:06:34 -0700 (PDT)
Received: from [172.20.1.148] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id 130sm16655203wmd.15.2019.05.07.10.06.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:06:33 -0700 (PDT)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yonghong Song <ys114321@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
 <20190429095227.9745-5-quentin.monnet@netronome.com>
 <20190505061913.mgazaivmg62auirx@ast-mbp>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 4/6] bpf: make BPF_LOG_* flags available in UAPI
 header
Message-ID: <7575af33-46e1-f438-77de-5d3a5e873537@netronome.com>
Date:   Tue, 7 May 2019 18:06:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505061913.mgazaivmg62auirx@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-04 23:19 UTC-0700 ~ Alexei Starovoitov
<alexei.starovoitov@gmail.com>
> On Mon, Apr 29, 2019 at 10:52:25AM +0100, Quentin Monnet wrote:
>> The kernel verifier combines several flags to select what kind of logs
>> to print to the log buffer provided by users.
>>
>> In order to make it easier to provide the relevant flags, move the
>> related #define-s to the UAPI header, so that applications can set for
>> example: attr->log_level = BPF_LOG_LEVEL1 | BPF_LOG_STATS.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> ---
>>  include/linux/bpf_verifier.h | 3 ---
>>  include/uapi/linux/bpf.h     | 5 +++++
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>> index 1305ccbd8fe6..8160a4bb7ad9 100644
>> --- a/include/linux/bpf_verifier.h
>> +++ b/include/linux/bpf_verifier.h
>> @@ -253,9 +253,6 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
>>  	return log->len_used >= log->len_total - 1;
>>  }
>>  
>> -#define BPF_LOG_LEVEL1	1
>> -#define BPF_LOG_LEVEL2	2
>> -#define BPF_LOG_STATS	4
>>  #define BPF_LOG_LEVEL	(BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
>>  #define BPF_LOG_MASK	(BPF_LOG_LEVEL | BPF_LOG_STATS)
>>  
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 72336bac7573..f8e3e764aff4 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -335,6 +335,11 @@ struct bpf_stack_build_id {
>>  	};
>>  };
>>  
>> +/* verifier log_level values for loading programs, can be combined */
>> +#define BPF_LOG_LEVEL1	1
>> +#define BPF_LOG_LEVEL2	2
>> +#define BPF_LOG_STATS	4
> 
> The verifier log levels are kernel implementation details.
> They were not exposed before and shouldn't be exposed in the future.
> I know that some folks already know about existence of level2 and use it
> when the verifier rejects the program, but this is not uapi.
> What is being output at level1 and 2 can change.
> It's ok for libbpf to use this knowledge of kernel internals,
> but it shouldn't be in uapi header.
> That was the reason I didn't expose stats=4 in uapi in the first place
> when I added that commit.
> 

Ok, in that case I will not move the macros. I take it there is also
little sense in offering different levels for the verifier through the
command line (the "--log-verifier level1,level2,stats" proposed in patch 6).

Since there was no real consensus on libbpf log level syntax either,
I'll resubmit the series (once bpf-next reopens) with just the shortcut
option, that sets all log levels to their maximum but without presenting
the different levels to the users. We can still add other options for
finer control over log levels after that, if they become desirable.

Thanks,
Quentin
