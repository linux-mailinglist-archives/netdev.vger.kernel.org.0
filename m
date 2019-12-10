Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20236119103
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLJTuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:50:15 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39457 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfLJTuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:50:14 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so3401600lfb.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 11:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mh1MDhoccZ8LcGj7No6Pp5Z8k1gtAci1d0+A5gGxl1E=;
        b=eXFdChDloDkEyFWlQ+kb/rD3xmn4wMBfccyqSQplXrWA9vQHvu59MGI5/jck3JYQms
         hlnBt7+yDu3vS2w3tH9wqyAEvXEUG9uDyW0lwjzbmdynzznqx5UaflGPOhWygHzAApMI
         7QnlL2qtXQNxiVoy2xtO6Rma2PeITxY3tGsdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mh1MDhoccZ8LcGj7No6Pp5Z8k1gtAci1d0+A5gGxl1E=;
        b=Q56sCcDiX9l2aVGVljIOsS2jE65g4rNOLH7+kIQKPBn2WjHdlFVT409eisuILIbL58
         wyO/ojYHNRyh6VvS5GUlgU8EgRGmuzOf9leAFBIEtIJdO8igMdUUzaf5Yi0UieQZOhqV
         QbrO1cLUWysSrf/gR3qVJFTVe4UcmRV6Vo77kp0OIH8mnPOTO5/aDdvaYXfKtjsfUUJ1
         t/gos0w0ti1iUhgyvmvTszzKZIb0baUZEi27FxEBack5mUEmqFqSJva0zlXU+sXis6vw
         wYF3t2A04b2HEQ8J4f43OT2yGRKyPWLsLYQ4cZpr6Cx6RM8pYljXd+v9t63RkPgG13+V
         DEEA==
X-Gm-Message-State: APjAAAXDyXJTwMgz4k1EYn3vktEA3VItDT1grecbU5wjZFb9pR6GeZPr
        zz494c8fE1EwhstKDyl/7LyRuA==
X-Google-Smtp-Source: APXvYqyl+VfdSDo5UzwybpIatTMhunT7staLyyawXzmvuMq1T/sqIAa8/kbxGXWyzXN5Gxgu7+l9rQ==
X-Received: by 2002:a19:f00d:: with SMTP id p13mr20761511lfc.37.1576007412928;
        Tue, 10 Dec 2019 11:50:12 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w17sm2129532lfn.22.2019.12.10.11.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 11:50:12 -0800 (PST)
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
Date:   Tue, 10 Dec 2019 21:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210143931.GF1344570@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2019 21:39, Vivien Didelot wrote:
> Hi Nikolay,
> 
> On Tue, 10 Dec 2019 09:49:59 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> 
>> Why did you send the bridge patch again ? Does it have any changes ?
> 
> The second iproute2 patch does not include the include guards update, but
> I kept the bridge_stp_stats structure and the BRIDGE_XSTATS_STP definition
> otherwise iproute2 wouldn't compile.
> >>
>> Why do you need percpu ? All of these seem to be incremented with the
>> bridge lock held. A few more comments below.
> 
> All other xstats are incremented percpu, I simply followed the pattern.
> 

We have already a lock, we can use it and avoid the whole per-cpu memory handling.
It seems to be acquired in all cases where these counters need to be changed.

>>>  	struct net_bridge_port *p
>>>  		= container_of(kobj, struct net_bridge_port, kobj);
>>> +	free_percpu(p->stp_stats);
>>
>> Please leave a new line between local var declaration and the code. I know
>> it was missing, but you can add it now. :)
> 
> OK.
> 
>>> +	if (p) {
>>> +		struct bridge_stp_xstats xstats;
>>
>> Please rename the local var here, using just xstats is misleading.
>> Maybe stp_xstats ?
> 
> This isn't misleading to me since its scope is limited to the current block
> and not the entire function. The block above dumping the VLAN xstats is
> using a local "struct br_vlan_stats stats" variable for example.
> 

Yep, as I answered to myself earlier, with the below change this goes away.

>>
>>> +
>>> +		br_stp_get_xstats(p, &xstats);
>>> +
>>> +		if (nla_put(skb, BRIDGE_XSTATS_STP, sizeof(xstats), &xstats))
>>> +			goto nla_put_failure;
>>
>> Could you please follow how mcast xstats are dumped and do something similar ?
>> It'd be nice to have similar code to audit.
> 
> Sure. I would also love to have easily auditable code in net/bridge. For
> the bridge STP xstats I followed the VLAN xstats code above, which does:
> 
>     if (nla_put(skb, BRIDGE_XSTATS_VLAN, sizeof(vxi), &vxi))
>         goto nla_put_failure;
> 

Yeah, we can move that to a vlan-specific helper too, but that is an unrelated change.

> But I can change the STP xstats code to the following:
> 
>     if (p) {
>         nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
>                                 sizeof(struct bridge_stp_xstats),
>                                 BRIDGE_XSTATS_PAD);
>         if (!nla)
>             goto nla_put_failure;
> 
>         br_stp_get_xstats(p, nla_data(nla));
>     }
> 
> Would that be preferred?
> 
> 

Perfect, thanks!

> Thanks,
> 
> 	Vivien
> 

