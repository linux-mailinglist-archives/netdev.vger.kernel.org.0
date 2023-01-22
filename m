Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF06676B61
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 08:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAVHBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 02:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVHBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 02:01:17 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F88F21A0B;
        Sat, 21 Jan 2023 23:01:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so8529007wmb.2;
        Sat, 21 Jan 2023 23:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8o/DgIT4qxcGcdpV8eRhdtBixnNAVvJj/hKETs635UQ=;
        b=ZKbmThDhumQMB9AhhYRjv7LQAgI+vjA3bHhWxsFTWHy7UjtZpuPeIAdKqg4lBQaUne
         gEuUn9Cv8LDLyF/yyaqzB4h0CTqBdM6qyv1BdYX2FxaEbrcDowB8K7AnVwl89259chvO
         tb5fg+WkZo9t1UXoDDHdooGSeq2dWM2joCeYNcepIRBsbYX7rdbLLdB0lsZbdQRgegyW
         Jp0P2dBMQ8Cxugkt2g/GJvS/x2DK5jNqIQguYjmWFNGUF7QvDnhDGb4atqS5c3Bf54EQ
         +FA/oTFFVqFEu08UtiaM9zSzzlSsg6rW+TQqM926zeeLn35X6SDEcqGNFpCKF52uBFJN
         zzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8o/DgIT4qxcGcdpV8eRhdtBixnNAVvJj/hKETs635UQ=;
        b=zQyhd5SKjLbuhCtANL1PYbNrGR5FXaJ6INU0d6RP/8kzO2XXVncvat7Qh0teKyL3eo
         0tt7qu36NKArFBwmAxjyPrFEW9hzI2YvN3/2/M8UOxEGkQa5MZT7ojswWPOtDY0/RANO
         BvNu7/kFsIEMphm09rglbYKbOb0ip8Xd1L6n/WwgWwN7MjWin5E+PArz3fwFKYgB0JHH
         kw0hxDW/3HxFhnX2T99GCyptAOAcwAXV6EOE/Vzpl3u9PJq3ktrLdeCMOvZhMh3Xysee
         0WYZTEQMAd7IgO+ABhBmeD5ZWqH/BEcyLmR/83myfglQ3grgLMT/wosJTyHWkEv1amFS
         LPWw==
X-Gm-Message-State: AFqh2krDhsbdBHNO2XYowYy1E9lEVmZfUznksfYSNaYAH+XtwmlIRuei
        1/3yIYc02wn8fW57bcmuzDQ=
X-Google-Smtp-Source: AMrXdXtX7J5uMc0/FikfYssKe2+stVNXQ+HoAqAUzi6wv0Uslehf/2xvLICmKVNSQf9tR+JdE8tF9A==
X-Received: by 2002:a05:600c:1712:b0:3d9:a145:91a with SMTP id c18-20020a05600c171200b003d9a145091amr19660813wmn.28.1674370874666;
        Sat, 21 Jan 2023 23:01:14 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id d5-20020adfa345000000b002be546f947asm5346722wrb.61.2023.01.21.23.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 23:01:13 -0800 (PST)
Message-ID: <1a2339ca-41fe-12f9-e7d8-9aa1d989d6bb@gmail.com>
Date:   Sun, 22 Jan 2023 09:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v8 15/17] net/mlx5e: Introduce wrapper for
 xdp_buff
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20230119221536.3349901-1-sdf@google.com>
 <20230119221536.3349901-16-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230119221536.3349901-16-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/01/2023 0:15, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Preparation for implementing HW metadata kfuncs. No functional change.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 33 +++++++----
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----------
>   4 files changed, 57 insertions(+), 43 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
