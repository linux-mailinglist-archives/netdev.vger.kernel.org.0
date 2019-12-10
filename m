Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460F911818F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfLJHyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:54:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41423 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLJHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:54:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so18710861ljc.8
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qsqd9AhQRa9hpfqkhwfNfWPl8RmlEkObLmWrw1kINII=;
        b=OqngQHNHaO353lzZWpAk0HRzC3O/em2CcW87cQh0dU3Ey712Iqvge8hFyxEePGfoFt
         Q3eiH4OUMllIF1E3BKJe3dFOHNsdlr//N9sD8L0hyTXV07uTHisY1I6+N4mcN/z1VddG
         mdCJhMzLIjtgu7KKhatbmuddVKXYzULywZT9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qsqd9AhQRa9hpfqkhwfNfWPl8RmlEkObLmWrw1kINII=;
        b=g7oFFxnILBNPagnQr0neXtr6/9TGaqiuE+W0iPJbmMhJHMj3Ru7zUgMTiQiuolNWuu
         gnvPyUn5TyxaMCJWjsSWi24hgxJETeGkuISm3iibIucb7ztM6bYYdqvVmfDnKWQdl+7Y
         B2bJfcQbIFbFejXzj1YPWag0SsjRnYt7/zaIEO7NJhRzn7Vb7D3jylsUYK4zcCbxLSsj
         JFEB2vKyhCeZFRUCm11HXk/n3VxhveG7tJ3Vo2knY5vc1SyoefgZWqgcik4zDmShzOdS
         PSsRwvXG//aNZ36xUeZbGHWJbQD3CtFdw1HXMWUs7PTgWQj4gUapKmU5oCCbJea2CzIF
         oooA==
X-Gm-Message-State: APjAAAXjCNT8xyHnOHhFGVtEAuysHd8IMWb84raydQMp9iUgIDzAIFCr
        gHeKRkZaetpTuYZAg7r85pwVxA==
X-Google-Smtp-Source: APXvYqy+1yM3G+PzAz8mRHJoQdCUhG5ZBR6GwFkbSmY4gopq6f6zIqppjCzN6G5H72+63evS7EsbtA==
X-Received: by 2002:a2e:8606:: with SMTP id a6mr19426093lji.119.1575964447970;
        Mon, 09 Dec 2019 23:54:07 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t9sm1004685lfl.51.2019.12.09.23.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:54:07 -0800 (PST)
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
Message-ID: <1a32ac69-a802-e039-215a-feec740e682c@cumulusnetworks.com>
Date:   Tue, 10 Dec 2019 09:54:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2019 09:49, Nikolay Aleksandrov wrote:
> On 10/12/2019 01:05, Vivien Didelot wrote:
>> This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
>> transition_fwd xstats counters to the bridge ports copied over via
>> netlink, providing useful information for STP.
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
>> ---
>>  include/uapi/linux/if_bridge.h | 10 ++++++++++
>>  net/bridge/br_if.c             |  8 ++++++++
>>  net/bridge/br_netlink.c        |  9 +++++++++
>>  net/bridge/br_private.h        |  9 +++++++++
>>  net/bridge/br_stp.c            | 25 +++++++++++++++++++++++++
>>  net/bridge/br_stp_bpdu.c       | 12 ++++++++++++
>>  net/bridge/br_stp_if.c         | 27 +++++++++++++++++++++++++++
>>  7 files changed, 100 insertions(+)
>>
[snip]
>>  }
>>  
>> @@ -419,6 +420,12 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
>>  	if (p == NULL)
>>  		return ERR_PTR(-ENOMEM);
>>  
>> +	p->stp_stats = netdev_alloc_pcpu_stats(struct br_stp_stats);
>> +	if (!p->stp_stats) {
>> +		kfree(p);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>>  	p->br = br;
>>  	dev_hold(dev);
>>  	p->dev = dev;
>> @@ -432,6 +439,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
>>  	err = br_multicast_add_port(p);
>>  	if (err) {
>>  		dev_put(dev);
>> +		free_percpu(p->stp_stats);
>>  		kfree(p);
>>  		p = ERR_PTR(err);
>>  	}
>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>> index a0a54482aabc..03aced1f862b 100644
>> --- a/net/bridge/br_netlink.c
>> +++ b/net/bridge/br_netlink.c
>> @@ -1597,6 +1597,15 @@ static int br_fill_linkxstats(struct sk_buff *skb,
>>  		}
>>  	}
>>  
>> +	if (p) {
>> +		struct bridge_stp_xstats xstats;
> 
> Please rename the local var here, using just xstats is misleading.
> Maybe stp_xstats ?
> 

Actually if this gets re-written to follow the mcast dump the local var
would disappear altogether.


