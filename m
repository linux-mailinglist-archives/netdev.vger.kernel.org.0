Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0632646F1B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 10:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFOItt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 04:49:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43194 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfFOItt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 04:49:49 -0400
Received: by mail-qt1-f196.google.com with SMTP id z24so5261561qtj.10;
        Sat, 15 Jun 2019 01:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aFUSLiGja/89o8eCWaye9MJNTTxuZVwKuy6ekDrgdXg=;
        b=N7Bgd/9+45MmrIAQVgZf7iF0dJl6TWko9lFOqz7OMUC4Tmf38esLBcLFKBJGcXhTpl
         F1gB7vxJ/5YVlRYKUm19z5fbtpR3AahXp9xZbTb2+/wsZYyIYjoRZ75dQRmsz/Q/deUj
         myTXslLuQ91jWB996zod+NNdDazTAPYvnTkWQxM5kdQMf/aXTXudHbuIJYCTk2mI4HPO
         6ddyx0denseswsxodFL3xp6ovOBaXItfOeuVEOIKemLnjej8wNGanZhgsSBaRvti4vmt
         CbumgNhwX7Vs8aRj4g1KB7tGh12MNzsCvYTmkl3FkGmX/Heq/s6F2SZ6CUhFSILNyYPA
         9ybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aFUSLiGja/89o8eCWaye9MJNTTxuZVwKuy6ekDrgdXg=;
        b=qjUzptsNHNqqRaGNMe+eU0ojJVCe1BCXKLRu2iuE7zmInHqYWup7wl6dTb0U6VW0UB
         fq7KCDBrfNwbaf7vOu7oel8AbBqFhstQziLAqVoRIkroZvYkgHNq2aDqD5EpZ8RG7Ky6
         qnXZMHU1PsJgYEqY71DsrUHNrFtZBZtoueDXPexA5EomkgfSvYcmbQqvki1O0fLxGzri
         7SuEc9sOaVkWwPiKox9YhwBYmn4UJFpVZB2CGS+blvxa/Ine1dmUKzhob8dBgXXgQnd5
         zSBlGuyePFP0fmLvj2ebBB0RnxNpy1WzUD0yHHv5L9ZdlIBFOuEkocz5ljDGfc9rRm8+
         jcgA==
X-Gm-Message-State: APjAAAXY0BJAxThaMgHh6ezx+SWWJ91dtpN0q+1gqCcUcmJAqmp8ARuw
        cOCiQ8a3W2VTnnpIEM4mudNONCW4wuBt69IhJbc=
X-Google-Smtp-Source: APXvYqwE0eTo3XktygOGLLTL9Y8ieNe855zMjhi1X1lesJQ3xcHhDalT5ovz/cIbNMS7cOLF44XguMVzGH04BkkzZLs=
X-Received: by 2002:a0c:e712:: with SMTP id d18mr11845392qvn.152.1560588587428;
 Sat, 15 Jun 2019 01:49:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:5184:0:0:0:0:0 with HTTP; Sat, 15 Jun 2019 01:49:46
 -0700 (PDT)
In-Reply-To: <f91615fe4a883ccb6490aec11ef4ae64cdd9e494.camel@redhat.com>
References: <20190614133249.18308-1-dkirjanov@suse.com> <20190614133249.18308-2-dkirjanov@suse.com>
 <f91615fe4a883ccb6490aec11ef4ae64cdd9e494.camel@redhat.com>
From:   Denis Kirjanov <kirjanov@gmail.com>
Date:   Sat, 15 Jun 2019 11:49:46 +0300
Message-ID: <CAHj3AVny9PijUD7_bWM2-fDNF9n4YZ5xgnG-_O9rZhr1cNVicw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ipoib: show VF broadcast address
To:     Doug Ledford <dledford@redhat.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19, Doug Ledford <dledford@redhat.com> wrote:
> On Fri, 2019-06-14 at 15:32 +0200, Denis Kirjanov wrote:
>> in IPoIB case we can't see a VF broadcast address for but
>> can see for PF
>>
>> Before:
>> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 256
>>     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>>     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state
>> disable,
>> trust off, query_rss off
>> ...
>
> The above Before: output should be used as the After: portion of the
> previous commit message.  The previos commit does not fully resolve the
> problem, but yet the commit message acts as though it does.
>
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
>
> Ok, I get why the After: should have a valid broadcast.  What I don't
> get is why the Before: shows a MAC and the After: shows a
> link/infiniband?  What change in this patch is responsible for that
> difference?  I honestly expect, by reading this patch, that you would
> have a MAC and Broadcast that look like Ethernet, not that the full
> issue would be resolved.

Hi Doug,
it's the patch for iproute2 that I'm going to send

>
>> v1->v2: add the IFLA_VF_BROADCAST constant
>> v2->v3: put IFLA_VF_BROADCAST at the end
>> to avoid KABI breakage and set NLA_REJECT
>> dev_setlink
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>  include/uapi/linux/if_link.h | 5 +++++
>>  net/core/rtnetlink.c         | 5 +++++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/include/uapi/linux/if_link.h
>> b/include/uapi/linux/if_link.h
>> index 5b225ff63b48..6f75bda2c2d7 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -694,6 +694,7 @@ enum {
>>  	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
>>  	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
>>  	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for
>> QinQ */
>> +	IFLA_VF_BROADCAST,	/* VF broadcast */
>>  	__IFLA_VF_MAX,
>>  };
>>
>> @@ -704,6 +705,10 @@ struct ifla_vf_mac {
>>  	__u8 mac[32]; /* MAX_ADDR_LEN */
>>  };
>>
>> +struct ifla_vf_broadcast {
>> +	__u8 broadcast[32];
>> +};
>> +
>>  struct ifla_vf_vlan {
>>  	__u32 vf;
>>  	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index cec60583931f..8ac81630ab5c 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -908,6 +908,7 @@ static inline int rtnl_vfinfo_size(const struct
>> net_device *dev,
>>  		size +=3D num_vfs *
>>  			(nla_total_size(0) +
>>  			 nla_total_size(sizeof(struct ifla_vf_mac)) +
>> +			 nla_total_size(sizeof(struct
>> ifla_vf_broadcast)) +
>>  			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
>>  			 nla_total_size(0) + /* nest IFLA_VF_VLAN_LIST
>> */
>>  			 nla_total_size(MAX_VLAN_LIST_LEN *
>> @@ -1197,6 +1198,7 @@ static noinline_for_stack int
>> rtnl_fill_vfinfo(struct sk_buff *skb,
>>  	struct ifla_vf_vlan vf_vlan;
>>  	struct ifla_vf_rate vf_rate;
>>  	struct ifla_vf_mac vf_mac;
>> +	struct ifla_vf_broadcast vf_broadcast;
>>  	struct ifla_vf_info ivi;
>>
>>  	memset(&ivi, 0, sizeof(ivi));
>> @@ -1231,6 +1233,7 @@ static noinline_for_stack int
>> rtnl_fill_vfinfo(struct sk_buff *skb,
>>  		vf_trust.vf =3D ivi.vf;
>>
>>  	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
>> +	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
>>  	vf_vlan.vlan =3D ivi.vlan;
>>  	vf_vlan.qos =3D ivi.qos;
>>  	vf_vlan_info.vlan =3D ivi.vlan;
>> @@ -1247,6 +1250,7 @@ static noinline_for_stack int
>> rtnl_fill_vfinfo(struct sk_buff *skb,
>>  	if (!vf)
>>  		goto nla_put_vfinfo_failure;
>>  	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
>> +	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast),
>> &vf_broadcast) ||
>>  	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
>>  	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
>>  		    &vf_rate) ||
>> @@ -1753,6 +1757,7 @@ static const struct nla_policy
>> ifla_info_policy[IFLA_INFO_MAX+1] =3D {
>>
>>  static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] =3D {
>>  	[IFLA_VF_MAC]		=3D { .len =3D sizeof(struct ifla_vf_mac)
>> },
>> +	[IFLA_VF_BROADCAST]	=3D { .type =3D NLA_REJECT },
>>  	[IFLA_VF_VLAN]		=3D { .len =3D sizeof(struct
>> ifla_vf_vlan) },
>>  	[IFLA_VF_VLAN_LIST]     =3D { .type =3D NLA_NESTED },
>>  	[IFLA_VF_TX_RATE]	=3D { .len =3D sizeof(struct ifla_vf_tx_rate) },
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> 2FDD
>


--=20
Regards / Mit besten Gr=C3=BC=C3=9Fen,
Denis
