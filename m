Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01F1518263
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 12:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiECKfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 06:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiECKfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 06:35:36 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98DF1FA67
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 03:32:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id w3so5407730qkb.3
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 03:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KvIqS3VrNxII9itwuWe5KiVa3YBLtLiVQQrHINB8FAw=;
        b=nlbFngc3POrli51uooWb5RVp4s+tKKXsEGXGiEbfIw4xZS23Xik1FLPzFcPcRMuCQY
         DCCdsxz8zI+ywuwgT4U2OksMo/aB9iXiXntotSlCnm35NNIBIbpJbydmWPwDMl5AtyoI
         guH0cECfh8cJJEpWFHzjj1IWDGGo8z5pOUwkLR6RkDE1aXda0qpVJbruXrzlCutgXSU+
         Zk+UGTOGX8Qo2JwTdpAPsMfFDkblO0vbh1hFj6uN53BxX6/zRdLmDaAEQ4tZjewCVLpg
         3yr75F0f2242JHFndTBqm13w1UPvoT/p+ZFhrjic1fWMgEBWttb3VdD6FDoUvbLSGy5o
         8rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KvIqS3VrNxII9itwuWe5KiVa3YBLtLiVQQrHINB8FAw=;
        b=CmNVUGN2k4GQdjg4PLqUPFIawBCxBuZjkkwoBbBPN+Wh6uLL2mnxSKy6nQUqbnDdqX
         oflLT6zvn/pl/qbtgNoUVx9b4jErU12ItNn3OcwSRcVpTqSEfnKbO/wgh4xO5BFVjL2S
         C2wLS4hEJN1nVbDyTXUKsyp5h0AHzNDv7aUXPjsiwFpxQ1hwSnZqeo13FjHM3FT8lYmP
         EzpgiU71lEhQEGf+o5nx2qbjWNGVUD61ZPn8Uw7tpuRi6ApELev35hgybWePGmV5q+Oj
         Ad6ykU729yW5ny62+bHOSECNEbxm4sqbv6INWiuPLdwWiq2tcm6r2RudtXMdVHEScBZX
         jwBA==
X-Gm-Message-State: AOAM530RRLSCZPb9Q6gkGpyx1YqGwMK9nK9QA/ZfPw5h0D4kO4YfUakX
        r9XnI4+RafdrzKbl3at9ZemNUw==
X-Google-Smtp-Source: ABdhPJydi9iWK0MOwuaSkIPIK3BCXexPrP7k4AStfd0BGiqSDGZ09+ya5M8NEdp5jy3aVyFNqqcKGQ==
X-Received: by 2002:a05:620a:1087:b0:6a0:151:658 with SMTP id g7-20020a05620a108700b006a001510658mr1626585qkk.108.1651573923858;
        Tue, 03 May 2022 03:32:03 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id w17-20020a05620a095100b0069fcf0da629sm4378323qkw.134.2022.05.03.03.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 03:32:02 -0700 (PDT)
Message-ID: <d3935370-b12c-e9db-1e59-52c8cceacf9a@mojatatu.com>
Date:   Tue, 3 May 2022 06:32:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
 <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
 <20220428160414.28990a0c@kernel.org>
 <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220429171717.5b0b2a81@kernel.org>
 <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220429194207.3f17bf96@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220429194207.3f17bf96@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 22:42, Jakub Kicinski wrote:
> On Sat, 30 Apr 2022 02:00:05 +0000 Nambiar, Amritha wrote:
>> IIUC, currently the action skbedit queue_mapping is for transmit queue selection,
>> and the bound checking is w.r.to dev->real_num_tx_queues. Also, based on my
>> discussion with Alex (https://www.spinics.net/lists/netdev/msg761581.html), it
>> looks like this currently applies at the qdisc enqueue stage and not at the
>> classifier level.
> 
> They both apply at enqueue stage, AFAIU. Setting classid on ingress
> does exactly nothing, no? :)
> 
> Neither is perfect, at least skbedit seems more straightforward.
> I suspect modern DC operator may have little familiarity with classful
> qdiscs and what classid is. Plus, again, you're assuming mqprio's
> interpretation like it's a TC-wide thing.
> 
> skbedit OTOH is used with a clsact qdisc.
> 
> Also it would be good if what we did had some applicability to SW.
> Maybe extend skbedit with a way of calling skb_record_rx_queue()?

I am on the fence of "six of one, half a dozen of the other" ;->

TC classids have *always been used to identify queues* (or hierarchy of
but always leading to a single queue). Essentially a classid identity
is equivalent to a built-in action which says which queue to pick.
The data structure is very much engrained in the tc psyche.

When TX side HW queues(IIRC, mqprio) showed up there was ambiguity to
distinguish between a s/w queue vs a h/w queue hence queue_mapping
which allows us to override the *HW TX queue* selection - or at least
that was the intended goal.
Note: There are other ways to tell the h/w what queues to use on TX
(eg skb->priority) i.e there's no monopoly by queue_mapping.

Given lack of s/w queues on RX (hence lack of ambiguity) it seemed
natural that the classid could be used to describe the RX queue
identity for offload, it's just there.
I thought it was brilliant when Amritha first posted.

I think we should pick the simpler of "half-dozen or six".
The posted patch seems driver-only change i.e no core code
changes required (which other vendors could follow).
But i am not sure if that defines "simpler".

BTW:
Didnt follow the skb_record_rx_queue() thought - isnt that
always set by the driver based on which h/w queue the packet
arrived at? Whereas the semantics of this is to tell the h/w
what queue to use.

cheers,
jamal
