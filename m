Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933EF6276EE
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiKNIA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiKNIAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:00:51 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E744335;
        Mon, 14 Nov 2022 00:00:51 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y203so10294123pfb.4;
        Mon, 14 Nov 2022 00:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rl7XVfCURtX7IREOejYVHcuTKEa5Stt/cs0k6IIAT8s=;
        b=g7j6iKS8QzPekE/NsHsf99xS2YkZMkU0ht/LBWHE94c6k1y0oKp+/lsAXPGSLr0eIx
         LTIPOEdZ122h9c4+sfRLvAasLdawZd+ZzHsUepncaKIXkQhuaDA5tQ+cFo6WFMKD6ctU
         ZzC11qUWrAWWKMDnPi2YcBnTTbs9bFYftV0swBsFpMDmH4JoJ7c44X6tz5Xyv6J2995W
         7Fbhwsk+nsxZZcFi33+eZTaJ05i+nGBPhWKaBaIAnRsgy7hkrjtSSQYTfpWKL4SyJqtx
         0QeQxcph9hfeU0ERm/NsxxYwzfwnOSI5y5aYoEuEKWxMGKAVsoZ/t+BC1U+z0tAV1Q1o
         zzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rl7XVfCURtX7IREOejYVHcuTKEa5Stt/cs0k6IIAT8s=;
        b=IlNxdkX9FhE9EplfXBQNptbyc8ob6kXV62cgyoekvqK1AP1pIjCgd54xLp+lNDAjcj
         UG0pHGxRPtVnVxznINCht2DRYdOrjwiaaU/nq7SontW+PxTTyoYAb1SbpHIeXnClKt1F
         qWaa2P1cw7j56ETWt3FF8zoaMgdziIBzY1Wr57kxkHWyt5ky7A2f+LOm2e1R184P3nCY
         uzRYiysHLwaYNjj0ztM333cwCLpwhSHv24BqWM5AXwd8Wxp/FcufLfvya8oMhdOHMXDG
         yalmLSMh+3mRyR0Fcc7UvFCxGO5rqu1KXQ+7XV6Ksjq5MVPPipGvrdraNrv+G06RW/GT
         IkEQ==
X-Gm-Message-State: ANoB5pk2A/ZDFp1sRhh5a2nBoioldJ1rD97k3RzCbfFF3I9C45P7VtKD
        C7BEky5z6mkHb1X/l7BJTUVx6O9/QYE=
X-Google-Smtp-Source: AA0mqf43vZ2eUvFWOndO4XEoWcD7PQqdMC0LWR4PbveSwpL+5qefS8YkG9HEgNTQ7tnQP1GWZeA8lg==
X-Received: by 2002:a62:648a:0:b0:561:ada0:69d7 with SMTP id y132-20020a62648a000000b00561ada069d7mr13044989pfb.9.1668412850574;
        Mon, 14 Nov 2022 00:00:50 -0800 (PST)
Received: from [192.168.11.9] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090311d000b00182a9c27acfsm783254plh.227.2022.11.14.00.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 00:00:49 -0800 (PST)
Message-ID: <6a7f6bb3-bbd4-9b71-b069-b543de067079@gmail.com>
Date:   Mon, 14 Nov 2022 17:00:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     andrii@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        lorenzo@kernel.org, mtahhan@redhat.com, netdev@vger.kernel.org,
        Akira Yokosawa <akiyks@gmail.com>
References: <20221114183131.3c68e1b5@canb.auug.org.au>
Subject: Re: linux-next: build warnings after merge of the net-next tree
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <20221114183131.3c68e1b5@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
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

On Mon, 14 Nov 2022 18:31:31 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced these warnings:
> 
> Documentation/bpf/map_cpumap.rst:50: WARNING: Error in declarator or parameters
> Invalid C declaration: Expected identifier in nested name. [error at 67]
>   int bpf_map_update_elem(int fd, const void *key, const void *value,
>   -------------------------------------------------------------------^
> Documentation/bpf/map_cpumap.rst:50: WARNING: Error in declarator or parameters
> Invalid C declaration: Expecting "(" in parameters. [error at 11]
>   __u64 flags);
>   -----------^
> Documentation/bpf/map_cpumap.rst:73: WARNING: Duplicate C declaration, also defined at bpf/map_array:35.
> Declaration is '.. c:function:: int bpf_map_lookup_elem(int fd, const void *key, void *value);'.
> 
> Introduced by commit
> 
>   161939abc80b ("docs/bpf: Document BPF_MAP_TYPE_CPUMAP map")

Hi Stephen,

Maryam has posted a patch at:

    https://lore.kernel.org/r/20221113103327.3287482-1-mtahhan@redhat.com/

        Thanks, Akira

> 
> -- 
> Cheers,
> Stephen Rothwell
