Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778984F6AFD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiDFUOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiDFUNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:13:17 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C775956214
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 10:40:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r66so2805197pgr.3
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6uLsJJChYBLCOOPgLZAHSdkxLxZlaUCQFBTEagQjLcU=;
        b=hs4ZBiL7o4DuRB8x6TVGa2c/jVr3l4PqzmAKqASkRXmSPjxTkMd7c/AdExaoE/+LaY
         AN08ZF9z4+yDGu6/fI+0qEFY1kdYX4gO0njfZu+rh1afUYM+icA/JC+cGva/2dDDywUc
         bsnfHVraxYdv8m3YCW4odmA2fd8K5k6GtCEK48Y7c7TVCphZ4bU6Lp4arhBSwm6VTqzN
         sP2L/xwEcxJUIGgrdrnGTL5M2gJWXH45sjL3BJYI5hW03PFD2GvZHNPsrh1t4MhKT0rB
         Ftzvh3iWpnmEiX4hgKlLmkO9yL15jgZS/vOePakTkvSvQpZHCVThacBb3DLp60MlGALE
         995Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6uLsJJChYBLCOOPgLZAHSdkxLxZlaUCQFBTEagQjLcU=;
        b=lmi3NxpXI9Mj/kdNC1+lO7TizSksBFPxRbcRXTU/9PpfgMGqCFpqxmjqfcXg26Estf
         JBZ73H2P5S5x4DWsahIEVmZWA6R+uHbi4Tjf7R0jh9OPPseikjOcQTugMgS//tFnVW+B
         6IocKJ90o9SFl74G8BkWRXdXWvtUrqAdDDadBC12VWQLB/IlyPBc+wCqXgz+Km/FLNos
         90U/yyI6NHYoaUYbAPn6fOoAWnehHk7kdxWgYCbbE+wHsBJBm6Nl/Hoplq9c1z5LLZSA
         q4+y4fgf8nva5bUepzmElqvcpgoOUFv8Z3j5xvgKXyXmt3zfLqkvH3F/uGWxIQJljdZK
         O1gw==
X-Gm-Message-State: AOAM531rCBDgV6ju+QV+/4jkLxE4mn//VJt6SF13lh8EeI/JD77QbvYH
        aP0yWerUJm7vxvWG+we3us2H9y1GFQSFDQ==
X-Google-Smtp-Source: ABdhPJxStpN09WqE79cSbe79B4h0oIN/tHd+0SUffyFdF8Tl4o7tmqCYmi4miDxQNcdrn0oHfRXfCA==
X-Received: by 2002:a63:4642:0:b0:398:b6b9:5f45 with SMTP id v2-20020a634642000000b00398b6b95f45mr8153534pgk.518.1649266820260;
        Wed, 06 Apr 2022 10:40:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:be1c:593c:43fb:d0a8? ([2620:15c:2c1:200:be1c:593c:43fb:d0a8])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm21014511pfc.41.2022.04.06.10.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 10:40:19 -0700 (PDT)
Message-ID: <18cd7e48-d719-bc82-9dbc-67cbb42eed83@gmail.com>
Date:   Wed, 6 Apr 2022 10:40:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: =?UTF-8?Q?Re=3a_TCP_stack_gets_into_state_of_continually_advertisin?=
 =?UTF-8?B?ZyDigJxzaWxseSB3aW5kb3figJ0gc2l6ZSBvZiAx?=
Content-Language: en-US
To:     Erin MacNeil <emacneil@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BY3PR05MB8002750FAB3DC34F3B18AD9AD0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
 <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/6/22 07:19, Erin MacNeil wrote:
> This issue has been observed with the  4.8.28 kernel, I am wondering if it may be a known issue with an available fix?
>
> Description:
> Device A hosting IP address <Device A i/f addr>  is running Linux version: 4.8.28, and device B hosting IP address <Device B i/f addr>  is non-Linux based.
> Both devices are configured with an interface MTU of 9114 bytes.
>
> The TCP connection gets  established via frames 1418-1419, where a window size + MSS of 9060 is agreed upon; SACK is disabled as device B does not support it + window scaling is not in play.
>
> No.     Time                          Source                Destination           Protocol Length Info
>    *1418 2022-03-15 06:52:49.693168    <Device A i/f addr>   <Device B i/f addr>   TCP      122    57486 -> 179 [SYN] Seq=0 Win=9060 Len=0 MSS=9060 SACK_PERM=1 TSval=3368771415 TSecr=0 WS=1
>    *1419 2022-03-15 06:52:49.709325    <Device B i/f addr>   <Device A i/f addr>   TCP      132    179 -> 57486 [SYN, ACK] Seq=0 Ack=1 Win=16384 Len=0 MSS=9060 WS=1
> ...
>     4661 2022-03-15 06:53:52.437668    <Device B i/f addr>   <Device A i/f addr>   BGP      9184
>     4662 2022-03-15 06:53:52.437747    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9658065 Win=9060 Len=0
>     4663 2022-03-15 06:53:52.454599    <Device B i/f addr>   <Device A i/f addr>   BGP      9184
>     4664 2022-03-15 06:53:52.454661    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9667125 Win=9060 Len=0
>     4665 2022-03-15 06:53:52.471377    <Device B i/f addr>   <Device A i/f addr>   BGP      9184
>     4666 2022-03-15 06:53:52.512396    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9676185 Win=0 Len=0
>     4667 2022-03-15 06:53:52.828918    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9676185 Win=9060 Len=0
>     4668 2022-03-15 06:53:52.829001    <Device B i/f addr>   <Device A i/f addr>   BGP      125
>     4669 2022-03-15 06:53:52.829032    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9676186 Win=9060 Len=0
>     4670 2022-03-15 06:53:52.845494    <Device B i/f addr>   <Device A i/f addr>   BGP      9184
>    *4671 2022-03-15 06:53:52.845532    <Device A i/f addr>   <Device B i/f addr>   TCP      102    57486 -> 179 [ACK] Seq=3177223 Ack=9685245 Win=1 Len=0
>     4672 2022-03-15 06:53:52.861968    <Device B i/f addr>   <Device A i/f addr>   TCP      125    179 -> 57486 [ACK] Seq=9685245 Ack=3177223 Win=27803 Len=1
> ...
> At frame 4671, some 63 seconds after the connection has been established, device A advertises a window size of 1, and the connection never recovers from this; a window size of 1 is continually advertised. The issue seems to be triggered by device B sending a TCP window probe conveying a single byte of data (the next byte in its send window) in frame 4668; when this is ACKed by device A, device A also re-advertises its receive window as 9060. The next packet from device B, frame 4670, conveys 9060 bytes of data, the first byte of which is the same byte that it sent in frame 4668 which device A has already ACKed, but which device B may not yet have seen.
>
> On device A, the TCP socket was configured with setsockopt() SO_RCVBUF & SO_SNDBUF values of 16k.

Presumably 16k buffers while MTU is 9000 is not correct.

Kernel has some logic to ensure a minimal value, based on standard MTU 
sizes.


Have you tried not using setsockopt() SO_RCVBUF & SO_SNDBUF ?


>
> Here is the sequence detail:
>
> |2022-03-15 06:53:52.437668|         ACK - Len: 9060               |Seq = 4236355144 Ack = 502383504 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.437747|         ACK       |                   |Seq = 502383551 Ack = 4236364204 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.454599|         ACK - Len: 9060               |Seq = 4236364204 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.454661|         ACK       |                   |Seq = 502383551 Ack = 4236373264 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.471377|         ACK - Len: 9060               |Seq = 4236373264 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.512396|         ACK       |                   |Seq = 502383551 Ack = 4236382324 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.828918|         ACK       |                   |Seq = 502383551 Ack = 4236382324 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.829001|         ACK - Len: 1                  |Seq = 4236382324 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.829032|         ACK       |                   |Seq = 502383551 Ack = 4236382325 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.845494|         ACK - Len: 9060               |Seq = 4236382324 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.845532|         ACK       |                   |Seq = 502383551 Ack = 4236391384 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.861968|         ACK - Len: 1                  |Seq = 4236391384 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.862022|         ACK       |                   |Seq = 502383551 Ack = 4236391385 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.878445|         ACK - Len: 1                  |Seq = 4236391385 Ack = 502383551 |         |(57486)  <------------------  (179)    |
> |2022-03-15 06:53:52.878529|         ACK       |                   |Seq = 502383551 Ack = 4236391386 |         |(57486)  ------------------>  (179)    |
> |2022-03-15 06:53:52.895212|         ACK - Len: 1                  |Seq = 4236391386 Ack = 502383551 |         |(57486)  <------------------  (179)    |
>
>
> There is no data in the recv-q or send-q at this point, yet the window stays at size 1:
>
> $ ss -o state established -ntepi '( dport = 179 or sport = 179 )' dst <Device B i/f addr>
> Recv-Q Send-Q                 Local Address:Port                                Peer Address:Port
> 0     0                  <Device A i/f addr>:57486                               <Device B i/f addr>:179                ino:1170981660 sk:d9d <->
>
>
> Thanks
> -Erin
>
> --
>
> Juniper Business Use Only
