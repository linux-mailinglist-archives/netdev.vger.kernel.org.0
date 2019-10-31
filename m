Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B527EB99F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbfJaWSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:18:07 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43749 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387465AbfJaWSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:18:07 -0400
Received: by mail-il1-f193.google.com with SMTP id j2so4758756ilc.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 15:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f9H8vPZS0pICHykw0vOk9fhaqrb+Y2WMpkToPe5Em5Q=;
        b=eDNBQtuOmLLvi/C3OQzDfxr+pmNZgFDA1Rlo2bt8QduLNF4TWEmLxpr2iOOMzTDNOI
         wWqaI0Y3k6vThpRRyRlhbJxIGyjOwIiv2EhV41+g1Zr3eRbyPMgKSNV57cG0AUP6pb3M
         M1yW0XjGu7+TrBANF6z6lKe3qvLxbk7K8AecNVS1OxMaAYobKijwOXfjNDV1fKkcib1D
         ZA/Z57AFvD8eSRIpQ0ebWnmlEolJ5IsnHJRYvHNCtlpj/wGHDoOcvFSpfeD7u1l3ZB0n
         HKjz+DL/hO+MUPoZviMAnFHnKI4STmOo0/O8Hp9IOXZCiYZar0pn1rRHqYtAzB+TGBHL
         HdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f9H8vPZS0pICHykw0vOk9fhaqrb+Y2WMpkToPe5Em5Q=;
        b=eoLjaMrJ8PRcUj05VLxs4i1Ta5ib7y32c2AxAY50ciOF6Oed6tOF1UE4WjySMvDJcb
         VISNRYB6baCG7GOHQUwXXfuEomO6fU5WyEolbwoIXIF5QPBjJt/enp89KCN5kGR7tP6+
         ebUyP2sipMKLp/Z9QnmknGd7H2g+3ttJ6W4Dhte+Kcgfzo7s/zbi5uLjUIz9ynmEfpzq
         SsGYRl2nhOGQI2607MicCAOAeppXIPLjb0tMj45znQC9geMM1OWx2kKpsT7YmHvIUZMv
         V8u+M+u+Jqfk23dUod8tAo7i8dYSF9/RduopM9aif/pyq6sBBblxf1V+ZIxZwQdZCQUY
         C1Yg==
X-Gm-Message-State: APjAAAVqPbCPU44HS66kIKF5o4AkaJHlZf3IQimc6Aa+H3Oyxir2QqyY
        DW55LN2zc+l2Ey85/OsWu28=
X-Google-Smtp-Source: APXvYqydkT1Ss4mAV4FeK6/oJoZaGsAlTEVgW1HA9lxG+QlMEvPhUufL5et/7sFew7qdf4qGP+y90A==
X-Received: by 2002:a92:8fc6:: with SMTP id r67mr8456373ilk.5.1572560286262;
        Thu, 31 Oct 2019 15:18:06 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0f1:25db:d02a:8fc2])
        by smtp.googlemail.com with ESMTPSA id z22sm467989iol.75.2019.10.31.15.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 15:18:05 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/6] sfc: Add XDP support
To:     Charles McLachlan <cmclachlan@solarflare.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        brouer@redhat.com
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b971b219-5aab-722d-72b7-545a7c2b609e@gmail.com>
Date:   Thu, 31 Oct 2019 16:18:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 4:21 AM, Charles McLachlan wrote:
> Supply the XDP callbacks in netdevice ops that enable lower level processing
> of XDP frames.
> 
> Changes in v4:
> - Handle the failure to send some frames in efx_xdp_tx_buffers() properly.
> 
> Changes in v3:
> - Fix a BUG_ON when trying to allocate piobufs to xdp queues.
> - Add a missed trace_xdp_exception.
> 
> Changes in v2:
> - Use of xdp_return_frame_rx_napi() in tx.c
> - Addition of xdp_rxq_info_valid and xdp_rxq_info_failed to track when
>   xdp_rxq_info failures occur.
> - Renaming of rc to err and more use of unlikely().
> - Cut some duplicated code and fix an array overrun.
> - Actually increment n_rx_xdp_tx when packets are transmitted.
> 

Something is up with this version versus v2. I am seeing a huge
performance drop with my L2 forwarding program - something I was not
seeing with v2 and I do not see with the experimental version of XDP in
the out of tree sfc driver.

Without XDP:

$ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.39.16.7 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    30.00    9386.73


With XDP

$ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.39.16.7 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    30.01     384.11


Prior versions was showing throughput of at least 4000 (depends on the
test and VM setup).
