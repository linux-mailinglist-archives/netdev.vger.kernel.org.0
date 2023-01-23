Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9884678558
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjAWSxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjAWSxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:53:25 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556EE32E6B;
        Mon, 23 Jan 2023 10:53:14 -0800 (PST)
Message-ID: <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674499992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9r8HNuiL5kCXCflLv3H0u4cF6+EvDEa21DtFDXkmT94=;
        b=coBxZVNdTQksXS1xVfoqhRhNqEdh/GCxcmQkN74+81Bi191qhrIUfxQUV3WeyCw6h0tW9L
        0+a0JWhkbVJHGiP4IrUV5fGpGEVLhNSURIFFaipYEEcUgARPhHm9dOEu4rCnnQwXJD6oRR
        sV7HTh4b3wjU2qTy2IZmp6bZq9ZB6j8=
Date:   Mon, 23 Jan 2023 10:53:06 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20230119221536.3349901-1-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
> Please see the first patch in the series for the overall
> design and use-cases.
> 
> See the following email from Toke for the per-packet metadata overhead:
> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
> 
> Recent changes:
> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)
> 
> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
> 
> - Clarify xdp_buff vs 'XDP frame' (Jesper)
> 
> - Explicitly mention that AF_XDP RX descriptor lacks metadata size (Jesper)
> 
> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
>    of ifname (due to recent xsk.h refactoring)

Applied with the minor changes in the selftests discussed in patch 11 and 17. 
Thanks!

