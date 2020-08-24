Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76ED2501CD
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHXQOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHXQOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:14:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81753C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:14:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b11so4451459pld.7
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BOM0RHlYd5dDzGd7ECE+wX7LcX4C42YYm/QRbNMgH58=;
        b=Ey1iUgfrFartc6QZb38yFtxgb1kJ7ockeUToywmhjXirLKVmkQN6iKXRscIbOibHs7
         BY6c3jI0EnAnmyF7nyjelX5lpfZu1QR/jKm7uqc0e5BJgrUfiFFoUX/y1VfyIXWBIkWa
         RiMBgwtxGNE8hbCFIxb4sd/ys2+8BP+JVVKblOikybhVbT7uWJQtHyNKGyV7DdXBrP79
         0QMrJwE94AVkCwaDaPuQAAvVhDjdYqgPTxqDo+fbpScSLT3dNiU187sEA/SM1Fvowfe3
         JOyHPfZGtAV3bzcRLCn5KpHa8dlAGnRqCiHwyFRRxPbtO46CZBapVX4z0R8GQq5d5m84
         Z+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BOM0RHlYd5dDzGd7ECE+wX7LcX4C42YYm/QRbNMgH58=;
        b=V4lYaviNhqdVddCwYK5y1w/SHeYmrQVYiYBrdHr40DuMPFphG7UaFyBmO5Sf1+V7US
         76caOn/8J8Vl9WdBopDG5uvmWUIk0bnymRodUN2ey8ykWE8e0h+q+6JG/G9zP58V5qBs
         Xzt3pPS834S66+D2Ay7U286lzkd2i1QhueYT8ljOh8fsWG9TXWLqqAMLHEfH2h86Uld8
         uwB1oGmDClY50SZw/C+32Me+nVmu2/IDb7cwpi2UqNjAFIR+db7b5/TJJfQ3LWPTYUlA
         d8KCUk+dotOAjcQrvxWiIehHTnFc2ieoFDCYHHVzYCPZa/AKvX2JKNsUHWItC16JD7Kz
         8lDg==
X-Gm-Message-State: AOAM531j44muzZCsy1RcyjYM6BgQSE3iAI/oDiOjEkZpqveQl4nIbkX+
        flTgERwkdZxK528LsqpOGGE=
X-Google-Smtp-Source: ABdhPJx3iGo/jBm6v1tP2iefuZpLv5VQhWkwXStZn2cI618DbGIYz6owUtW7/YR6/i35WTqr57ON0A==
X-Received: by 2002:a17:90a:448e:: with SMTP id t14mr53688pjg.59.1598285642445;
        Mon, 24 Aug 2020 09:14:02 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x20sm21787pjp.24.2020.08.24.09.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 09:14:00 -0700 (PDT)
Subject: Re: Request for backport of 78dc70ebaa38aa303274e333be6c98eef87619e2
 to 4.19.y
To:     =?UTF-8?Q?Robert_Bengtsson-=c3=96lund?= 
        <robert.bengtsson-olund@intinor.se>, netdev@vger.kernel.org,
        Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
References: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6be0e30c-e9ec-17ea-968b-6ec5a9559dac@gmail.com>
Date:   Mon, 24 Aug 2020 09:13:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAM7CaVQf-xymnx8y-nn7E3N6P5=-HF2i_1XhFgp1MZB1==WZiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/20 7:35 AM, Robert Bengtsson-Ölund wrote:
> Hi everyone
> 
> We stumbled upon a TCP BBR throughput issue that the following change fixes.
> git: 78dc70ebaa38aa303274e333be6c98eef87619e2
> 
> Our issue:
> We have a transmission that is application limited to 20Mbps on an
> ethernet connection that has ~1Gbps capacity.
> Without this change our transmission seems to settle at ~3.5Mbps.
> 
> We have seen the issue on a slightly different network setup as well
> between two fiber internet connections.
> 
> Due to what the mentioned commit changes we suspect some middlebox
> plays with the ACK frequency in both of our cases.
> 
> Our transmission is basically an RTMP feed through ffmpeg to MistServer.
> 
> Best regards
> /Robert
> 

Please always CC patch authors in this kind of requests.

Thanks.

Patch was :

commit 78dc70ebaa38aa303274e333be6c98eef87619e2
Author: Priyaranjan Jha <priyarjha@google.com>
Date:   Wed Jan 23 12:04:54 2019 -0800

    tcp_bbr: adapt cwnd based on ack aggregation estimation
    
    Aggregation effects are extremely common with wifi, cellular, and cable
    modem link technologies, ACK decimation in middleboxes, and LRO and GRO
    in receiving hosts. The aggregation can happen in either direction,
    data or ACKs, but in either case the aggregation effect is visible
    to the sender in the ACK stream.
    
    Previously BBR's sending was often limited by cwnd under severe ACK
    aggregation/decimation because BBR sized the cwnd at 2*BDP. If packets
    were acked in bursts after long delays (e.g. one ACK acking 5*BDP after
    5*RTT), BBR's sending was halted after sending 2*BDP over 2*RTT, leaving
    the bottleneck idle for potentially long periods. Note that loss-based
    congestion control does not have this issue because when facing
    aggregation it continues increasing cwnd after bursts of ACKs, growing
    cwnd until the buffer is full.
    
    To achieve good throughput in the presence of aggregation effects, this
    algorithm allows the BBR sender to put extra data in flight to keep the
    bottleneck utilized during silences in the ACK stream that it has evidence
    to suggest were caused by aggregation.
    
    A summary of the algorithm: when a burst of packets are acked by a
    stretched ACK or a burst of ACKs or both, BBR first estimates the expected
    amount of data that should have been acked, based on its estimated
    bandwidth. Then the surplus ("extra_acked") is recorded in a windowed-max
    filter to estimate the recent level of observed ACK aggregation. Then cwnd
    is increased by the ACK aggregation estimate. The larger cwnd avoids BBR
    being cwnd-limited in the face of ACK silences that recent history suggests
    were caused by aggregation. As a sanity check, the ACK aggregation degree
    is upper-bounded by the cwnd (at the time of measurement) and a global max
    of BW * 100ms. The algorithm is further described by the following
    presentation:
    https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg-an-update-on-bbr-work-at-google-00
    
    In our internal testing, we observed a significant increase in BBR
    throughput (measured using netperf), in a basic wifi setup.
    - Host1 (sender on ethernet) -> AP -> Host2 (receiver on wifi)
    - 2.4 GHz -> BBR before: ~73 Mbps; BBR after: ~102 Mbps; CUBIC: ~100 Mbps
    - 5.0 GHz -> BBR before: ~362 Mbps; BBR after: ~593 Mbps; CUBIC: ~601 Mbps
    
    Also, this code is running globally on YouTube TCP connections and produced
    significant bandwidth increases for YouTube traffic.
    
    This is based on Ian Swett's max_ack_height_ algorithm from the
    QUIC BBR implementation.
    
    Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
    Signed-off-by: Neal Cardwell <ncardwell@google.com>
    Signed-off-by: Yuchung Cheng <ycheng@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

