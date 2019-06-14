Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E56545E5B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfFNNhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:37:04 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:37508 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbfFNNhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:37:04 -0400
Received: by mail-ua1-f66.google.com with SMTP id z13so952261uaa.4
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 06:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eRd9R9cpIJoDNBfuQLMcVDh9lR+PWfBAW4x11YLASUc=;
        b=RFIshYp4GA3LjNXiFoQFGRJZOrAnZiLFP2q9WlZAgJX4+Z8bJtf7xZVWe+OakjnHoc
         BSt6YRPdQk5W7Z2w3iOBwaWpZpbvvN3D4NhDfoBswvPizPJZwGVMnpKVbkw1l5dDFHLb
         oFlNfrtppItGriM4g3JBwruu24cFetuS+Bs9UBHwICX0wbel0dsDfTfX8QY/8iEQimW/
         yw2pGLs9zAGVoZKqBR9gyU2he3ESbG3SThYUw+7Srz+fz8Mw0iXde9vqLTsoxJIPREpE
         mgqMCDPKswqhFW78MnoQrIN3jLh3YOQNrhcE2rVStr+k5U4YnjTUChpNB1zi2AL2uRNk
         yHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=eRd9R9cpIJoDNBfuQLMcVDh9lR+PWfBAW4x11YLASUc=;
        b=mmGhfEcRZ6ugO3TXK+F4rSqD2sW3yidnyS+4y4epQtM3N3fUK/PX7YHN0DIwHcIj8x
         /kh/YBBtWMxa4vzvdtIRea1wxB0DMZRYCBk9fw3GIgKsz9CtgiNRZHwvimmQKZNdswZP
         nJFq4c8GzE6oUUw/pT6xOYgqPYbYD1MmTysiA779z6PpUD5XJl+O1dookGGzyGA3OM6P
         TpnyaPldd0B1WeXn8QD9d3PRsDSpxIAPOaJ5j/LoMijRocrvO3R4rvcTFZDqosAHL6v6
         ASeCSpRkUyiGRj7fEd9+VLXiquwx7kjyzviIXlbpqu3K4CypfvT3YQwUdkgVKdVssD9b
         fbKw==
X-Gm-Message-State: APjAAAXcdHYooMTNhS7B6ZgkHP8uvMAg06qIjuXzygvtaOJv/QUk0wmo
        BtTGmxghCz8dr1TJYOgFDUJB6I9U1CkdXP29xpDJXA==
X-Google-Smtp-Source: APXvYqzgdXfuhFCaKvvqbastHdT47w295gm70NKdBCPvWF6U6mhEGhT7OtLpkCvbXtA7A0aHbeU68QfzaZ5aBF0450E=
X-Received: by 2002:ab0:55c4:: with SMTP id w4mr5361241uaa.35.1560519423078;
 Fri, 14 Jun 2019 06:37:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:108a:0:0:0:0:0 with HTTP; Fri, 14 Jun 2019 06:37:02
 -0700 (PDT)
X-Originating-IP: [5.35.24.158]
In-Reply-To: <20190613163941.GK31797@unicorn.suse.cz>
References: <20190613142003.129391-1-dkirjanov@suse.com> <20190613142003.129391-4-dkirjanov@suse.com>
 <20190613163941.GK31797@unicorn.suse.cz>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 14 Jun 2019 16:37:02 +0300
Message-ID: <CAOJe8K1OycscWUKfYKP73bK_eJdmG3=-_yK6ajSUpXpfGEEgwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] ipoib: show VF broadcast address
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/19, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Thu, Jun 13, 2019 at 04:20:03PM +0200, Denis Kirjanov wrote:
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
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>  include/uapi/linux/if_link.h | 5 +++++
>>  net/core/rtnetlink.c         | 6 ++++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 5b225ff63b48..1f36dd3a45d6 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -681,6 +681,7 @@ enum {
>>  enum {
>>  	IFLA_VF_UNSPEC,
>>  	IFLA_VF_MAC,		/* Hardware queue specific attributes */
>> +	IFLA_VF_BROADCAST,
>>  	IFLA_VF_VLAN,		/* VLAN ID and QoS */
>>  	IFLA_VF_TX_RATE,	/* Max TX Bandwidth Allocation */
>>  	IFLA_VF_SPOOFCHK,	/* Spoof Checking on/off switch */
>
> Oops, I forgot to mention one important point when reviewing v1: the new
> attribute type must be added at the end (just before __IFLA_VF_MAX) so
> that you do not change value of existing IFLA_VF_* constants (this would
> break compatibility).

Right, I've also missed that that the change breaks KABI.

>
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
>
> My first idea was that to question the need of a wrapping structure as
> we couldn't modify that structure in the future anyway so that there
> does not seem to be any gain against simply passing the address as a
> binary with attribute length equal to address length (like we do with
> IFLA_ADDRESS and IFLA_BROADCAST).
>
> But then I checked other IFLA_VF_* attributes and I'm confused. The
> structure seems to be
>
>     IFLA_VF_INFO_LIST
>         IFLA_VF_INFO
>             IFLA_VF_MAC
>             IFLA_VF_VLAN
>             ...
>         IFLA_VF_INFO
>             IFLA_VF_MAC
>             IFLA_VF_VLAN
>             ...
>         ...
>
> Each IFLA_VF_INFO corresponds to one virtual function but its number is
> not determined by an attribute within this nest. Instead, each of the
> neste IFLA_VF_* attributes is a structure containing "__u32 vf" and it's
> only matter of convention that within one IFLA_VF_INFO nest, all data
> belongs to the same VF, neither do_setlink() nor do_setvfinfo() check
> it.
>
> I guess you should either follow this weird pattern or introduce proper
> IFLA_VF_ID to be used for IFLA_VF_BROADCAST and all future IFLA_VF_*
> attributes. However, each new attribute makes IFLA_VF_INFO bigger and
> lowers the number of VFs that can be stored in an IFLA_VF_INFO_LIST nest
> without exceeding the hard limit of 65535 bytes so that we cannot afford
> to add too many.

I've just put it as other attrs for now.

>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index cec60583931f..88304212f127 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
> ...
>> @@ -1753,6 +1758,7 @@ static const struct nla_policy
>> ifla_info_policy[IFLA_INFO_MAX+1] = {
>>
>>  static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
>>  	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
>> +	[IFLA_VF_BROADCAST]	= {. len = sizeof(struct ifla_vf_broadcast) },
>>  	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
>>  	[IFLA_VF_VLAN_LIST]     = { .type = NLA_NESTED },
>>  	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },
>
> As you do not implement setting the broadcast address (is that possible
> at all?),

According to rfc4391 it's formed from the components like p_key,
q_key, mtu and other.

 NLA_REJECT would be more appropriate so that the request isn't
> silently ignored.

Anyway, I've sent v3.

Thanks!

>
> Michal
>
