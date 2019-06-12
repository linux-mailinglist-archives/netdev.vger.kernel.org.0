Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159CC424F8
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437089AbfFLMEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:04:48 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33411 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405097AbfFLMEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:04:48 -0400
Received: by mail-vs1-f68.google.com with SMTP id m8so10065788vsj.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=RyXefo1AKgFRL46CmUUBxzimpNeLSzhWVHAVIaZQWcQ=;
        b=QKHZ0a0VFZIbQYkz80wtcUjlGiYzmkj/efESGdEsCgn8jGvJCS59LRLHDndYYUFTok
         kexnFfUcAyz2qW/4exMGh4+3esU0f1tBnRsdYM3eAJfSOVXHR2pMnqoj0sQ0C+tPNUeR
         qInSoTeVxyFuwqFstyf//Vuj0FZFmsU46h0HAkAUvUx0NttqYYIz1mW8tROitAAft3eK
         eGrxbHXQ3QTn4ElEU23PcGgCAGRUlrYYD56T/UVutMVsvYkONv1XOebJStBRVv74hl45
         REt20N5N31kEOP560G4d1VWRuCdfnVb2LqZRzFNglJTSh1VMwJZ158Dq7vDKoF0gFgYw
         cO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=RyXefo1AKgFRL46CmUUBxzimpNeLSzhWVHAVIaZQWcQ=;
        b=cqp14Ny12LCYzNWkaeFUBnfKULUAhN3H7MMziZb1/4xr0ZEX13pNTNcxrL5GsZbaY8
         xrWIoRPA8VRPqXgm9CvTI1sW2g9TIxhiwewCuohYq6n3EA2q6mDZ3VaNg10KbSWD2EMN
         DbLw4XlJLTIizBcG8lsyKkQX28vFIQvtY6ypbSoeJzQZK5Sdt+Tt4JH3jPNRq/F5Ew+5
         EMn78yo4m1D2iOphQG4w74BhyhEFFs78Qk2F2aiVIRiYjRZz6bOYndI9zPU7xUe2a71b
         d7wn4Y41xyF9FWwWNSs1EY3DmIjNeOoHn9FhVvZqLsc73FW+sgnEmSFbuGPpshvTSIz7
         w9mQ==
X-Gm-Message-State: APjAAAU9vUJOQpYPHj3Wd5+Wbcvs39Hvps1ff03WYNTaSVt8XpnSR+LS
        bnpH3iPuHWfzZIwqBpVzMbgAz86KuPnO1shQF/KTuQ==
X-Google-Smtp-Source: APXvYqxUEUXmcG23tBr9TrEMfAwLafTiQeNT3e/jtvSSdK7jaW4xqh1IWvXwtFNw8Gh+lEOPlFbi0IitP6QYDdBtBhU=
X-Received: by 2002:a67:e446:: with SMTP id n6mr3890090vsm.142.1560341087097;
 Wed, 12 Jun 2019 05:04:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:108a:0:0:0:0:0 with HTTP; Wed, 12 Jun 2019 05:04:46
 -0700 (PDT)
X-Originating-IP: [5.35.24.158]
In-Reply-To: <20190612120216.GH31797@unicorn.suse.cz>
References: <20190612113348.59858-1-dkirjanov@suse.com> <20190612113348.59858-4-dkirjanov@suse.com>
 <20190612120216.GH31797@unicorn.suse.cz>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 12 Jun 2019 15:04:46 +0300
Message-ID: <CAOJe8K1T-LXA-v+JBm7uc48=R8SZLEtoH9+bMbxmKVv9SsQaPA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] ipoib: show VF broadcast address
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Wed, Jun 12, 2019 at 01:33:48PM +0200, Denis Kirjanov wrote:
>> in IPoIB case we can't see a VF broadcast address for but
>> can see for PF
>>
>> Before:
>> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 256
>>     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>>     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
>> trust off, query_rss off
>> ...
>>
>> After:
>> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 256
>>     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>>     vf 0     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
>> checking off, link-state disable, trust off, query_rss off
>> ...
>>
>> Signed-off-by: Denis Kirjanov <dkirjanov@suse.com>
>> ---
>>  net/core/rtnetlink.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 2e1b9ffbe602..f70902b57a40 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1248,6 +1248,7 @@ static noinline_for_stack int
>> rtnl_fill_vfinfo(struct sk_buff *skb,
>>  	if (!vf)
>>  		goto nla_put_vfinfo_failure;
>>  	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
>> +	    nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast) ||
>>  	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
>>  	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
>>  		    &vf_rate) ||
>
> This doesn't seem right, IFLA_BROADCAST is 2 which is the same as
> IFLA_VF_VLAN. You should add a new constant in the same enum as other
> IFLA_VF_* attribute types expected in this context. You should then also
> add an entry to ifla_vf_policy and account for the new attribute size in
> rtnl_vfinfo_size().

Ah, ok,

Thanks

>
> Michal
>
