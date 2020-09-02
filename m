Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6925A2E5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgIBCJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 22:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIBCJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 22:09:39 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D30C061244;
        Tue,  1 Sep 2020 19:09:39 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q6so3624550ild.12;
        Tue, 01 Sep 2020 19:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RvQ64wf9Wh48WwQaP0R20+deCJqQguDL1Pk8BjaeB6k=;
        b=rqVZsP1zNJwZge4J3LP/4FGgzBO6lS/rO8tsBJDUetULTiPbGk/4n64Rx2x5JIJ8Rp
         56R+bbvq3hZ6PU2P8bnZRrrhTKHek2i8ddAkYBzZTXjDtEs+V1LHGhpQVhLZr4oxwoPl
         4hLuWeChldiGFPtP3ZcwHaxMIDmlhD9WXfWemEoalUqAFrfHy39JLVL+Ed6L2n82YmOb
         gt27PHd5kIMgoIVsEaz7rRlFYLzx5mRBFa+GsGSX9TI8rGnH2OHG3auChxEnYiMd2HKi
         MSDm2N5KLRq5vR//qRpIX7u7YbguY6Hoa4RXGc2xpNxaaspPknin7chzU9G9zX24+I7t
         SMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RvQ64wf9Wh48WwQaP0R20+deCJqQguDL1Pk8BjaeB6k=;
        b=OvayyAoLRBe5NYAYsH42xNMitPKGEdSuV58fWNbgp+qExwr5dINMPuFV7cIYT9Ljbt
         4C4g3bNpfts3qQimDkCQ5dupFfbQhu8+muLRRy2wJeWReSBxZAxPeUU26d+6Z5/uZKBz
         t96X6LceSx4UjIuiTqV3KMxrCfS2piTRE9FbqhAHgUIuuokFh0zalomRg+Xa0ked/zQo
         Equg8QObhY1Xz7QgbT6FCapKmtAANjuJG0kuG9+Z8S6WEdHrBE8MFin0MLYPR5OA0tGt
         P7BvtJwttQh9vZGQDCYYkuxmopaXiqgepSgFOBlD/dNBQxeqX8OX4DBBJT4boArwxZ0R
         HWsQ==
X-Gm-Message-State: AOAM530Bs44QvJBa+D7czLYNh7PXDSyjjVdNdLZSfKioheffc4u1NFU4
        Y4Hvaa6L/jJKfftFKIPTiQc=
X-Google-Smtp-Source: ABdhPJxhDXZmvtt9rkjrKrsYRiB+nEvoM99FzH6pQ2xKBFG1M9226fII1Uu5ADK0A308ODrJldCMNA==
X-Received: by 2002:a92:bad9:: with SMTP id t86mr1749383ill.308.1599012578388;
        Tue, 01 Sep 2020 19:09:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id o17sm1453888ila.35.2020.09.01.19.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 19:09:37 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
To:     "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
 <04856bca-0952-4dd7-3313-a13be6b2e95a@gmail.com>
 <MW3PR11MB45220F94F1E303CEC0F6C19C852F0@MW3PR11MB4522.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f3fbdb56-6e7e-7b18-e160-3f402bee8083@gmail.com>
Date:   Tue, 1 Sep 2020 20:09:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <MW3PR11MB45220F94F1E303CEC0F6C19C852F0@MW3PR11MB4522.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 6:52 PM, Ramamurthy, Harshitha wrote:
>> On 8/31/20 1:25 PM, Harshitha Ramamurthy wrote:
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h index
>>> a613750d5515..bffe93b526e7 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3576,6 +3576,14 @@ union bpf_attr {
>>>   * 		the data in *dst*. This is a wrapper of copy_from_user().
>>>   * 	Return
>>>   * 		0 on success, or a negative error in case of failure.
>>> + *
>>> + * u32 bpf_get_xdp_hash(struct xdp_buff *xdp_md)
>>
>> I thought there was a change recently making the uapi reference xdp_md;
>> xdp_buff is not exported as part of the uapi.
> 
> Not sure what you mean - other xdp related helper functions still use xdp_buff as an argument. Could you point me to an example of what you are referring to?

a patch from Jakub that is apparently not committed yet.


>>
>>> +	memset(&keys, 0, sizeof(keys));
>>> +	__skb_flow_dissect(dev_net(xdp->rxq->dev), NULL,
>> &flow_keys_dissector,
>>> +			   &keys, data, eth->h_proto, sizeof(*eth), len,
>>> +			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
>>
>> By STOP_AT_FLOW_LABEL I take it you want this to be an L3 hash. Why not
>> add a flags argument to the helper and let the hash be L3 or L4?
> 
> I wrote this exactly how skb_get_hash calls skb_flow_dissect - with the same flag STOP_AT_FLOW_LABEL.  So it should already cover L3 and L4 hash, right? From what I understand STOP_AT_FLOW_LABEL flag is used to only stop parsing when a flow label is seen in ipv6 packets. 

right; missed that. That means this new helper will always do an L4 hash
for tcp/udp. Adding a flags argument now for the uapi allows a later
change to make it an L3 hash.
