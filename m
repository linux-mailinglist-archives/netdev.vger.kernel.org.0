Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD33852882D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244177AbiEPPND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbiEPPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:13:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C23B55A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 08:12:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z7-20020a17090abd8700b001df78c7c209so705177pjr.1
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=onSVhbbDe90AAo5iHD51K9cw5Q4qIT/DS9813GRTJfw=;
        b=ayamzRNxvVJ98iiOV7qVFWPIVFuf70nvikuzN2W6Yx3sGDmAYbVpO4bt2VPx/Xro4p
         7tV3+4hmq8Wj1qtamIHKk0vWZ71f+fcX2+wFwlcJgSHTBYTyaaESLMj0vNmbsz0uePN/
         nzxyEfqy8N7aKGvzRPjz/Gj0Jr9p556x5wYE1E3YfNy0QqTqsKSGuyLZYe2465+V63Y7
         tpjzKzUHASMKaLwMhnNdT7EZGKOM+Wfa/GHIbMPuwdYBjAIFF+x6BxAbjd7r2aEMUVyy
         LFi46/E0i5Bwi0fivyg0qp45STkn/TmHkl8XCqOnbCkTYQ704zYjs3xu32jd8q97vCBL
         eS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=onSVhbbDe90AAo5iHD51K9cw5Q4qIT/DS9813GRTJfw=;
        b=0GSHwT5Nle2taozYBvfuA1rcVjTYBq4jtw3ZUPnC6cfmrI62x04e4XSJvL4rSzFWdY
         VlG9c1joD01UgoVGcy401HB6db1Ypa/BXPTK9IkozoCHbWHcjfiqApXWa6Cx8z/tLb+c
         PDxqkAiXDDgXO7oS7lflzhzwYg1X2Q+yCwofakRFVzYedL2lPttBTrLOb7dAvrpWsMTc
         337As1kTdWodCzUEOk8DxHIObi0IN8EO53O0HtiqMdCs3rZm/wsPNrJogKfk7M2Edr+D
         hz3hTbw3RrfH10Fmg9x1g1KzOQSpfQypP+oGTph3d/v67AAOJC+PxdWHtVYLwjY+YvBW
         60+g==
X-Gm-Message-State: AOAM531FXFOOtUMtqcv9OlMdyPOOWSZAQuXF8dJjOkJDZQGs4/+zhLzD
        0zfWyLBEB9zlkU9R5YmIeNw=
X-Google-Smtp-Source: ABdhPJzU3v2R+uWnvuDUPmrKHbK0nbW5mKJCvk96Wlud92X/dfz/+vUVrjoVqKqI0ci2ZSFT5QZyog==
X-Received: by 2002:a17:90b:17d0:b0:1dc:ddce:9c25 with SMTP id me16-20020a17090b17d000b001dcddce9c25mr31205693pjb.232.1652713979061;
        Mon, 16 May 2022 08:12:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o9-20020a62cd09000000b0050dc762812asm7022708pfg.4.2022.05.16.08.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 08:12:58 -0700 (PDT)
Message-ID: <ba65f579-4e69-ae0d-4770-bc6234beb428@gmail.com>
Date:   Mon, 16 May 2022 08:12:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: sockets staying in FIN-WAIT-1, CLOSING, or LAST-ACK state till
 reboot
Content-Language: en-US
To:     Sami Farin <hvtaifwkbgefbaei@gmail.com>,
        Linux Networking Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220515140001.cws3pgz4iaaanpjo@m.mifar.in>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220515140001.cws3pgz4iaaanpjo@m.mifar.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/15/22 07:04, Sami Farin wrote:
> Hello,
>
> with 5.15.37, ss -K -t does not properly kill the TCP sockets.
> [ Disclaimer: this is my guess of the culprit.  I also use wireguard. ]
>
> tcp          FIN-WAIT-1        0 1 80.220.8.55:22384                   
> 91.198.174.208:443 ino:0 sk:510b cgroup:unreachable:6c46 ---
>      skmem:(r0,rb87380,t0,tb130560,f0,w0,o0,bl0,d0) ts sack ecn 
> ecnseen bbr wscale:9,10 rto:3744 rtt:33.364/18.714 ato:40 mss:36 
> pmtu:68 rcvmss:536 advmss:1448 cwnd:1 bytes_sent:701 bytes_acked:702 
> bytes_received:254 segs_out:6 segs_in:3 data_segs_out:2 data_segs_in:1 
> bbr:(bw:10176bps,mrtt:27.924,pacing_gain:2.88672,cwnd_gain:2.88672) 
> send 8632bps lastsnd:601107881 lastrcv:601107884 lastack:601107810 
> pacing_rate 11658680bps delivery_rate 10192bps delivered:3 app_limited 
> busy:23371222ms lost:1 rcv_space:14480 rcv_ssthresh:42242 minrtt:27.924
>
> $ nc -l -p 22384
> Ncat: bind to 0.0.0.0:22384: Address already in use. QUITTING.
> $ nc -l 127.0.0.1 22384
> ^C
> $
>
> These zombie sockets all have Send-Q > 0.


That is right.

tcp_abort() currently supports established and SYN_RECV sockets only.

Adding support for TIMEWAIT should not be difficult.


