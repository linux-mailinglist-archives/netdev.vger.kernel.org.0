Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C364A5F322D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiJCOu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJCOuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:50:51 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010B12F64A
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:50:51 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id p202so8253185iod.6
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=G8/dG2pwP3l/t62JOi712l2CQbMvZ7QykaPrtYsgir8=;
        b=ElRUVyhUVIOUle4X7HQls5G/YPUpa4/+j1rx+wtByIf/iDYNICPup9gzc0YA0U8EJL
         zUOL3JwKyRTRUiJz43H6+64lrZIgkY2nLP1X0ZGFeNsWoaDs6JCcpx0HA/nE4tFCFh8g
         4OD54LFy4TOBPwwGljhfCtp6cpyYkc3WoayLJcWwPIfFPw63zRHE1w82p95xwmPuYeoS
         1J1wcZ3QiVUJTtEPG0XSaNn5X3lPgAE6ArW/zMgsNI4UfMaZzJRwL/U+OPh1qmBayMCa
         2nvpfFucZeQJ0T/kEjHgv8iKmVLuHg43nHGrl/Vz37RplnzcCjSvSv7lzDUpc/vbRG7d
         ffog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=G8/dG2pwP3l/t62JOi712l2CQbMvZ7QykaPrtYsgir8=;
        b=WkbtMOFOjAejFVmRljQIXAWka3t+rgIbMXTlVUw/LbHJtVdTwhXWw++CehHNaFRFBs
         ZB9B2WIZtHTUyFZrsycXT7VhwEOraJ+WWAxHqmxVqOAbMRMtEdAcqBdswzc2jA8p5Ww+
         lguUrHTUydwTsus7o7BPg/bNCAn9IYefiuPBk6gd5lBU9Jt1flmcY12mZWBxd7Nvm7U0
         rxYC/14/Spa+J95rzlPcykUM897jXufcVQx/FwunYgO5ULPKIufnxjfnTQpdS0ghm0G6
         WZK3rYYBqyVpzb2h3MaMPRFWA8Wj3zjpeXjigZ93D34IyD025jgMVluumBVkaiIAIfGg
         zuyA==
X-Gm-Message-State: ACrzQf3K0Nc4+1i5XZO/TGNoMJ/XNjGn43O9ZjoN0tc1ONmX1xh2DmlP
        scQxf1zAiWCpzN9K/B0Ob6I=
X-Google-Smtp-Source: AMsMyM7cw0k+u980mqsKY0XO0mCpmOz+A9dbKr/sTxbknG8OmlVQUBPFqhd7YiRFT5bOoP5pY5H9pg==
X-Received: by 2002:a05:6638:22d1:b0:358:3ee7:70b8 with SMTP id j17-20020a05663822d100b003583ee770b8mr10080765jat.80.1664808650407;
        Mon, 03 Oct 2022 07:50:50 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:38e6:13c8:49a3:2476? ([2601:282:800:dc80:38e6:13c8:49a3:2476])
        by smtp.googlemail.com with ESMTPSA id g2-20020a05660203c200b006a19152b3f0sm4674673iov.5.2022.10.03.07.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 07:50:49 -0700 (PDT)
Message-ID: <7c74c1c1-5bce-76d3-113b-fb56321e31b4@gmail.com>
Date:   Mon, 3 Oct 2022 08:50:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next 0/2] ip: xfrm: support "external" mode for
 xfrm interfaces
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, steffen.klassert@secunet.com,
        nicolas.dichtel@6wind.com, razor@blackwall.org
References: <20221003091212.4017603-1-eyal.birger@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221003091212.4017603-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/22 3:12 AM, Eyal Birger wrote:
> This series adds support for configuring XFRM interfaces in "external"
> mode as recently merged.
> 
> Eyal Birger (2):
>   ip: xfrm: support "external" (`collect_md`) mode in xfrm interfaces
>   ip: xfrm: support adding xfrm metadata as lwtunnel info in routes
> 
>  include/uapi/linux/if_link.h  |  1 +
>  include/uapi/linux/lwtunnel.h | 10 +++++
>  ip/iproute.c                  |  5 ++-
>  ip/iproute_lwtunnel.c         | 83 +++++++++++++++++++++++++++++++++++
>  ip/link_xfrm.c                | 18 ++++++++
>  man/man8/ip-link.8.in         |  7 +++
>  man/man8/ip-route.8.in        | 11 +++++
>  7 files changed, 133 insertions(+), 2 deletions(-)
> 

always put all uapi changes in a separate patch. headers are synched via
a script and a separate patch is easier to drop then editing patches.

Removed the use of matches() in patch 1 and applied to iproute2-next.
