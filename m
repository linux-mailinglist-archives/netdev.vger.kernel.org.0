Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C724FB6D4
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbiDKJDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344108AbiDKJDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:03:25 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F283ED2B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:01:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 21so4296006edv.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jn4SqyWw/i6faMX5gsX4G9jEopRFnFBc1MpDaJc7Ea0=;
        b=tUY4n4qUyS9VLDtuylArl7/NfR4Vh5lgD7Fvo15/sYUQN7GsHdUmeDoltmyIQZFxPz
         N9igXBL2d8BTDkZFc13ny2LfrVoehCv18NjQo2nX7/gsI0RLC4KcUq3hUX9RDYXrx1vE
         6tgmqO5FG2ucDjm7ToO/nFSHRtsb+nfBLKYwBSa1GloGgfYDFVflyQoq1rhbunBDCF0g
         VMZOuRiN0L9/YyHdcAf3zfoGGNtUDTZ/xfEfUyKLHjX6syWbtxMwzxKjKZVtVW1LF2VY
         ZgX6m3frM0bZw0P+pJI3Fc+dajXyqulV/7/cAP7d/zjRZ5tVzXiAncXhkhLsj400ntd1
         SHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jn4SqyWw/i6faMX5gsX4G9jEopRFnFBc1MpDaJc7Ea0=;
        b=SEbmOoiAgPcjbTdz6lYlPy+JxmDb2UtVSRvoAB4f/wCA3+5HAtojge/p41HX97WFzJ
         pS9zJNoBUGijoCjkEt2vl3SJQmmVdf164n8wmx4ncSA6crVZ0UTjOeLhspfmaBppm7YU
         oWupBc9GSIKNTkFTn+8IjtXR28sSDVyKdB2KyXrfH6iGIo0vsefFz9xZJt1zhBdgZeDv
         5GhgZ75NERjpJo+9FdYfoskjqYTv1B4iSNEZNGqCKKojREY1V1D9De71C/JskDz3I9NP
         sm8rqrLcuIdXkAHtpOCat1XCLV7Hly9ciou03r2DdfSy0uQ6LffgtTF16dUwYF2tVKl7
         d3/g==
X-Gm-Message-State: AOAM5322fReRygR7W/HsPyqDvKOrrBxGY4RAV9jvnMjjfrraZFrL9tNY
        7+PSr8GVzE+k80A4ascA47D+HQ==
X-Google-Smtp-Source: ABdhPJycynHi1TylrBL4aSaMEK9t3vrXpLztHCdwH48QW+FcPBx4d8GyfV/CwHH5768KI8kGd6H/Qw==
X-Received: by 2002:a05:6402:370b:b0:41d:8508:20af with SMTP id ek11-20020a056402370b00b0041d850820afmr893060edb.16.1649667669109;
        Mon, 11 Apr 2022 02:01:09 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm3521943eji.94.2022.04.11.02.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 02:01:08 -0700 (PDT)
Message-ID: <1d7c8d9b-1691-08c9-f7ae-5bc9d8d8b046@blackwall.org>
Date:   Mon, 11 Apr 2022 12:01:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 3/6] net: bridge: fdb: add new nl attribute-based
 flush call
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-4-razor@blackwall.org> <YlPnznOq3k8KZg2n@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YlPnznOq3k8KZg2n@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 11:33, Ido Schimmel wrote:
> On Sat, Apr 09, 2022 at 01:58:54PM +0300, Nikolay Aleksandrov wrote:
>> Add a new fdb flush call which parses the embedded attributes in
>> BRIDGE_FLUSH_FDB and fills in the fdb flush descriptor to delete only
>> matching entries. Currently it's a complete flush, support for more
>> fine-grained filtering will be added in the following patches.
>>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  include/uapi/linux/if_bridge.h |  8 ++++++++
>>  net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
>>  net/bridge/br_netlink.c        |  8 ++++++++
>>  net/bridge/br_private.h        |  2 ++
>>  4 files changed, 42 insertions(+)
>>
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 221a4256808f..2f3799cf14b2 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -807,7 +807,15 @@ enum {
>>  /* embedded in IFLA_BRIDGE_FLUSH */
>>  enum {
>>  	BRIDGE_FLUSH_UNSPEC,
>> +	BRIDGE_FLUSH_FDB,
>>  	__BRIDGE_FLUSH_MAX
>>  };
>>  #define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
>> +
>> +/* embedded in BRIDGE_FLUSH_FDB */
>> +enum {
>> +	FDB_FLUSH_UNSPEC,
>> +	__FDB_FLUSH_MAX
>> +};
>> +#define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
>>  #endif /* _UAPI_LINUX_IF_BRIDGE_H */
>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>> index 4b0bf88c4121..62f694a739e1 100644
>> --- a/net/bridge/br_fdb.c
>> +++ b/net/bridge/br_fdb.c
>> @@ -594,6 +594,30 @@ void br_fdb_flush(struct net_bridge *br,
>>  	rcu_read_unlock();
>>  }
>>  
>> +static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
>> +	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
>> +};
>> +
>> +int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>> +			struct netlink_ext_ack *extack)
>> +{
>> +	struct nlattr *fdb_flush_tb[FDB_FLUSH_MAX + 1];
>> +	struct net_bridge_fdb_flush_desc desc = {};
>> +	int err;
>> +
>> +	err = nla_parse_nested(fdb_flush_tb, FDB_FLUSH_MAX, fdb_flush_attr,
>> +			       br_fdb_flush_policy, extack);
>> +	if (err)
>> +		return err;
>> +
>> +	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
>> +		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
>> +
>> +	br_fdb_flush(br, &desc);
>> +
>> +	return 0;
>> +}
>> +
>>  /* Flush all entries referring to a specific port.
>>   * if do_all is set also flush static entries
>>   * if vid is set delete all entries that match the vlan_id
>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>> index 6e6dce6880c9..bd2c91e5723d 100644
>> --- a/net/bridge/br_netlink.c
>> +++ b/net/bridge/br_netlink.c
>> @@ -781,6 +781,7 @@ int br_process_vlan_info(struct net_bridge *br,
>>  
>>  static const struct nla_policy br_flush_policy[BRIDGE_FLUSH_MAX + 1] = {
>>  	[BRIDGE_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
>> +	[BRIDGE_FLUSH_FDB]	= { .type = NLA_NESTED },
> 
> In a previous submission [1] Jakub suggested using NLA_POLICY_NESTED()
> 
> [1] https://lore.kernel.org/netdev/20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> 

I didn't use it because I'll have to export the private object (fdb/mdb)
policy structs, it will also require some ifdefs due to conditional mdb.
They use nla_parse_nested internally, so they get validated properly.

>>  };
>>  
>>  static int br_flush(struct net_bridge *br, int cmd,
>> @@ -804,6 +805,13 @@ static int br_flush(struct net_bridge *br, int cmd,
>>  	if (err)
>>  		return err;
>>  
>> +	if (flush_tb[BRIDGE_FLUSH_FDB]) {
>> +		err = br_fdb_flush_nlattr(br, flush_tb[BRIDGE_FLUSH_FDB],
>> +					  extack);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index e6930e9ee69d..c7ea531d30ef 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -768,6 +768,8 @@ int br_fdb_hash_init(struct net_bridge *br);
>>  void br_fdb_hash_fini(struct net_bridge *br);
>>  void br_fdb_flush(struct net_bridge *br,
>>  		  const struct net_bridge_fdb_flush_desc *desc);
>> +int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
>> +			struct netlink_ext_ack *extack);
>>  void br_fdb_find_delete_local(struct net_bridge *br,
>>  			      const struct net_bridge_port *p,
>>  			      const unsigned char *addr, u16 vid);
>> -- 
>> 2.35.1
>>

