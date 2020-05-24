Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7E1E00FD
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 19:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbgEXRWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 13:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXRWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 13:22:17 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4ACC061A0E;
        Sun, 24 May 2020 10:22:17 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id w3so10146455qkb.6;
        Sun, 24 May 2020 10:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HOB7DJtAt7OqMWSSFuPavE57wAs0HI6Y2mvqKtQhO2o=;
        b=L8nUBEW8rI6wvT5v+4R9yh7ArGoy4wCtp0hVoHJ0jBZ5zRYtHvOcQHGHdlyih4ETUl
         NRP19hbkKRIpOvDXvLd9T6tSbfLtf+gytEBnHNFOYYeY3O8pu3XirRv4LdzrPxOr+e1S
         x+jYmF7cTduPzo5BvgvHDOcoSHWy/D7cPuEA0jJzH1kci9X9tsopPlH1yoacSUk0qC8G
         nSQmjzoH8C2qKBwSuq3TP7mtS733vT1F04SnIco1DORyQnvjH2JSM5KihPku+FcnfW33
         XSDc/VVsIRjkoogkCkDKQQqezBTv+leKBfO4IbzWFBpSjvgxHTvPOmRXiSvkDWMZ7m9Z
         rA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HOB7DJtAt7OqMWSSFuPavE57wAs0HI6Y2mvqKtQhO2o=;
        b=JRRdbho3SW6XB6qPqSbIz5+UCEYY8EmoOd6DWZVPoaDu/d2mIyazXfft3S7SwNjzUI
         tytOCgomEcilZpMAUax5okYDnbwe3nrU9ptRVyx5NgufSl6c+RaH3DHI0PtDULVulhlX
         n4Y+QpuVVn37h4qs6nJUPjoHoF5s7HLkcmvAK6j001BGTJcxRnYWIyLitDy5kWPfcDfO
         x8U2OUfKXCG8HNCUeOi/uX4j2DiiwIh8pt8sOxjQVk64RSXVNXP/DLPPe1daceA0MYKa
         4ECb/vViI1yYFqoEkrVIDewiEdKrK6ytpd/XC58skkD8/uv5Or1VPG5mE9kWPyNvCGn9
         ypYQ==
X-Gm-Message-State: AOAM530CV6zA+gYWtketEUMNp8ucWkg1c+aUS9nvvUvNEqKJmTggoRTT
        mtZlOSTC0ysHz/fUwnmxl5c=
X-Google-Smtp-Source: ABdhPJyCqsYV8xitKRx7CmfAA0xR3jd+1bNWsLQLi3NTcFMKvjZ8ntVkXYqbv6MwGaTlb2Wu8WSM6Q==
X-Received: by 2002:a37:9f0c:: with SMTP id i12mr24245409qke.264.1590340936835;
        Sun, 24 May 2020 10:22:16 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:dde6:2665:8a05:87c9? ([2601:284:8202:10b0:dde6:2665:8a05:87c9])
        by smtp.googlemail.com with ESMTPSA id b17sm6016596qkl.95.2020.05.24.10.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2020 10:22:16 -0700 (PDT)
Subject: Re: [RFC bpf-next 1/2] bpf: cpumap: add the possibility to attach a
 eBPF program to cpumap
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
References: <cover.1590162098.git.lorenzo@kernel.org>
 <6685dc56730e109758bd3affb1680114c3064da1.1590162098.git.lorenzo@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <21c30a1c-cebc-b2f2-be94-9db430610578@gmail.com>
Date:   Sun, 24 May 2020 11:22:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6685dc56730e109758bd3affb1680114c3064da1.1590162098.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 10:11 AM, Lorenzo Bianconi wrote:
> @@ -307,8 +354,23 @@ static int cpu_map_kthread_run(void *data)
>  	return 0;
>  }
>  
> -static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
> -						       int map_id)
> +static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu,
> +				      u32 prog_id)
> +{
> +	struct bpf_prog *prog;
> +
> +	/* TODO attach type */
> +	prog = bpf_prog_by_id(prog_id);
> +	if (IS_ERR(prog) || prog->type != BPF_PROG_TYPE_XDP)
> +		return -EINVAL;

Add check that expected_attach_type is NOT set since it uses existing
xdp programs which should not have it set.

