Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDABD6C3C17
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCUUni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCUUnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:43:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DBD4FF0F;
        Tue, 21 Mar 2023 13:43:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w9so64781396edc.3;
        Tue, 21 Mar 2023 13:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431415;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PeP3HcyTjPxxNOqAcC7pbi/56qhRwp+1YhUNPsmy6fU=;
        b=j3ciKxYJHhH/chjp36YI2YdFfcO5EpzvHTNralvW9CnX77P6Jonyz7QY5h/wkINJBa
         g2znG/xBD/L8ZHRPq3qdsF1NWqh2NrU3f9xlJ5Q6o24heWlflql8zTpFK3L3UaeDjnBR
         WK7AdWhLYsoe3Jp2TSeoJX063CN58apF9qgvMFRFEGfnPgX7CL0fDRMWC4HWNAxyaQW6
         i8U6e5fGpo2MOJ57vzCeaiksd7K6TAsyP3PbKocWcJ+ZuOP+/pZ6+QDR7JOL2QAG8rVF
         IHEAbbVesSc+skK6Ur0vetytJ7htfrZHlAICj4hvpBHNED2L+NQcw+wcshHZZLfwXgUb
         9TNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431415;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeP3HcyTjPxxNOqAcC7pbi/56qhRwp+1YhUNPsmy6fU=;
        b=W50AqMp9/1ycDpmAXihreKo08HZnZMMCs+WBGiJZmpsCAmSMtLbnwRK/EO8j6+xP1T
         /4Q05i4ZDUPscK14+L/QPp/rM6Oj+s3XHYcdYtYYGKqQQDrLRGy+gq8QY6xUGY4F5oWi
         41DY/mwnAg+MGk0fcIIe4EAl7GZ7MloPvX5nUsPbPVGP3GBebbIy3IdDYAkQ16vzTH+1
         6t+gluC4zXldeVn3fvPSj+T2CLyG3az0yhoVznLkzoRP1vX9xv5I/YqVh/NTjYizQ61P
         BFKRwi1M68vqPtpksRoAy5AlRtKEwXZO3aduMz2Q52/5g2kQXNbkn9VtcHgamyiOn/ZD
         5gKg==
X-Gm-Message-State: AO0yUKXmBSIxN8Qm1QZ30AYD81jY0FaGSmeAXnshbOevPMgHgrT871fo
        75g73QeBiXDE4BN/05NbJr4=
X-Google-Smtp-Source: AK7set/c7W6993tvLP5KS1XL2pRd+/p9dzzTr79//sn5QJyfVm4aGb4clNy4ztzxUFKKbpdXZjji4w==
X-Received: by 2002:a17:906:b0c3:b0:930:d0f1:9d8 with SMTP id bk3-20020a170906b0c300b00930d0f109d8mr4649981ejb.27.1679431415126;
        Tue, 21 Mar 2023 13:43:35 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709067c8b00b009231714b3d4sm6120435ejo.151.2023.03.21.13.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:43:34 -0700 (PDT)
Message-ID: <682a413b-4f84-cc06-d378-3b44d721c64e@gmail.com>
Date:   Tue, 21 Mar 2023 22:43:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH bpf V2] xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver
 support
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
References: <167940675120.2718408.8176058626864184420.stgit@firesoul>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <167940675120.2718408.8176058626864184420.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/03/2023 15:52, Jesper Dangaard Brouer wrote:
> When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
> implementation returns EOPNOTSUPP, which indicate device driver doesn't
> implement this kfunc.
> 
> Currently many drivers also return EOPNOTSUPP when the hint isn't
> available, which is ambiguous from an API point of view. Instead
> change drivers to return ENODATA in these cases.
> 
> There can be natural cases why a driver doesn't provide any hardware
> info for a specific hint, even on a frame to frame basis (e.g. PTP).
> Lets keep these cases as separate return codes.
> 
> When describing the return values, adjust the function kernel-doc layout
> to get proper rendering for the return values.
> 
> Fixes: ab46182d0dcb ("net/mlx4_en: Support RX XDP metadata")
> Fixes: bc8d405b1ba9 ("net/mlx5e: Support RX XDP metadata")
> Fixes: 306531f0249f ("veth: Support RX XDP metadata")
> Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

For the mlx4/5 parts:
Acked-by: Tariq Toukan <tariqt@nvidia.com>

Thanks!
