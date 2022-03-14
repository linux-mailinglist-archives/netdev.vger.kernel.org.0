Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5284D8A23
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiCNQuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbiCNQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:50:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0428820F5C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:49:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bu29so28401070lfb.0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F9ILzHWkvkyh+gia0dF1ILImDL/fEekmMr3Uov1MXcE=;
        b=QnGXLSD3jzJFREQ+Ji7gzJL8J6H4xQsmmHsoRgoe05KeQClo92KR5djjaibyRshbUC
         6LrCTjZzV7oJnxFUQzJeG6qM1qKThe+XdJY4clHHC+Lmu1IQPXi6C8MGXYLztcgygx7z
         4mHsDq+Duym7C7NZ/9cUWou8zydiI9jR8823Q/1A4kam5/cubSBDhvIK5u74LQTDfwZc
         Ju1mrqz4NNeBXFWQWKNvSSPGmO4Y9FLu3+hNBMahR2IMJmv3nfZI/k3/0Hv2vVSSWOwk
         q/CxcCfuS1obHPLAzxeBGkuE7AAxTUNwR6Hhkoz+4R1EMQ2oir9BbmEBz3Tz+mfiuEa0
         DXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F9ILzHWkvkyh+gia0dF1ILImDL/fEekmMr3Uov1MXcE=;
        b=r8xZGO1FmTq9gOCcwkOQXZxbGqvMEI51t3x9WRng4MAKHqV8H/zZK1ST3pnGcA6O6E
         bzumdAoLOOKU/teomM0gAW609tIz3zhtSYMMdi7ZOPt98snyzSfrz1oL0tzdjIr0g0mJ
         9oxMWA1cFSbBjQlLrraSUrJi8MQZI0V4GhXVVkIi5rYmO8pYpdghp2g0Ezqd5TqdwWK8
         X8J/4n/ydlFPpsTXir3FrERP76lLTTPXLVCQqQUjfrDRR80KUNVFByN9jnZhwusdYOZs
         aeDZVFNppHpmr5dDNdJrT/PQNYHDnr+JLyaF8mwH+pWggopd7Ltdpd3ck8uLDAQe8Fxl
         UaHQ==
X-Gm-Message-State: AOAM5312fiHxayHb4RGSLRQOLsRLwoWhT1F0Ip81zhbF7ZHOQRRHaQju
        KVn40KDJaLxaUBEOVhF27hg=
X-Google-Smtp-Source: ABdhPJyuZgoxmaop3RO6KPEJDYmmlf4TVUxONkXsdh/WBh2TrSmuMB/xmDDButV64izJQyieeRZt6Q==
X-Received: by 2002:ac2:4ec3:0:b0:443:6504:ee19 with SMTP id p3-20020ac24ec3000000b004436504ee19mr14243848lfr.260.1647276540029;
        Mon, 14 Mar 2022 09:49:00 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id w15-20020ac25d4f000000b0044846901eaesm3347690lfd.247.2022.03.14.09.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 09:48:59 -0700 (PDT)
Message-ID: <603ed7af-8b5e-f5f3-ed9c-8d287095efbf@gmail.com>
Date:   Mon, 14 Mar 2022 17:48:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: mattias.forsblad+netdev@gmail.com
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, mattias.forsblad+netdev@gmail.com
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <Yh5NL1SY7+3rLW5O@shredder>
 <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
 <96845833-8c17-04ab-2586-5005d27e1077@gmail.com> <Yi9tgOQ32q2l2TxD@shredder>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <Yi9tgOQ32q2l2TxD@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-14 17:29, Ido Schimmel wrote:
> On Wed, Mar 02, 2022 at 07:27:25AM +0100, Mattias Forsblad wrote:
>> On 2022-03-01 23:36, Nikolay Aleksandrov wrote:
>>> On 1 March 2022 17:43:27 CET, Ido Schimmel <idosch@idosch.org> wrote:
>>>> On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
>>>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>>>> index e0c13fcc50ed..5864b61157d3 100644
>>>>> --- a/net/bridge/br_input.c
>>>>> +++ b/net/bridge/br_input.c
>>>>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>>  		break;
>>>>>  	}
>>>>>  
>>>>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
>>>>> +		local_rcv = false;
>>>>> +
>>>>
>>>> I don't think the description in the commit message is accurate:
>>>> "packets received on bridge ports will not be forwarded up". From the
>>>> code it seems that if packets hit a local FDB entry, then they will be
>>>> "forwarded up". Instead, it seems that packets will not be flooded
>>>> towards the bridge. In which case, why not maintain the same granularity
>>>> we have for the rest of the ports and split this into unicast /
>>>> multicast / broadcast?
>>>>
>>>
>>> Exactly my first thought - why not implement the same control for the bridge?
>>> Also try to minimize the fast-path hit, you can keep the needed changes 
>>> localized only to the cases where they are needed.
>>> I'll send a few more comments in a reply to the patch.
>>>
>>
>> Soo, if I understand you correctly, you want to have three different options?
>> local_receive_unicast
>> local_receive_multicast
>> local_receive_broadcast
> 
> My understanding of the feature is that you want to prevent flooding
> towards the bridge. In which case, it makes sense to keep the same
> granularity as for regular bridge ports and also name the options
> similarly. We already have several options that are applicable to both
> the bridge and bridge ports (e.g., 'mcast_router').
> 
> I suggest:
> 
> $ ip link help bridge
> Usage: ... bridge [ fdb_flush ]
>                   ...
>                   [ flood {on | off} ]
>                   [ mcast_flood {on | off} ]
>                   [ bcast_flood {on | off} ]
> 
> This is consistent with "bridge_slave".

Many thanks for your input. I'll have a go at a V2.

BR
Mattias Forsblad
