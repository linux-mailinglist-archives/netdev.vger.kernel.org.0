Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B707854AD00
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353572AbiFNJKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 05:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353412AbiFNJKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 05:10:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52CA42A38
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 02:10:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c2so10679466edf.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vbE6VRJ6L2Qi7wHf9J/y7BjGn5acIfx2cDitHSWZN8U=;
        b=AWbngWo4Lf9j8+7rwhn9DK43YZsPYbm2fMnv5NmSdw+pvHmAzGWBJKaZX22g8de88t
         ppjc5RbJE79kcZct9aj1DYUQ4xVvmi2lX40qgADykUAMZCAJ3d94iUfDIAdx74CwuIA8
         I+VrcGSbiyhF1gP8YDr3lh9qgyu31KwzBfIOMOU5igLTc0SyCQDULFfPtSTEW9lw0LMy
         RkLJYn2rWkIeqXG/JPO50KmMnw66ua3CjDkAMFsDTW9ybKDwnmexyz/5+1k9NmSmGXQ/
         PpBd9XzxHxdUTuzSkjRIP39Nb5vjWng//GfAjg5FxULE1YtAdLQPwM8UKHPxw/uDdA1Z
         cfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vbE6VRJ6L2Qi7wHf9J/y7BjGn5acIfx2cDitHSWZN8U=;
        b=fEKkURJX2hFXQkruTjSLCS75Ia7InNSv47IJ+lpA3K0ticXV8jDTNNEJLcpRAGtyQH
         ZbwEa/mbFkTQK8dp2gNRYQAdwhscwbtjEA7yB6N+t8bo472aF+afyAEz5O2OXAz/OfQH
         s8NSpNc3ju6N8FUb+rKaNIbUJzzT+Syz6MaPFzTG6quTYKQvxT1uShddskhVif3I/NHV
         +snK1LOm0nOTC0Rt9rgjVgMdI2SYmQg3XdEfw3Hj7WJ00TdALRqAlkaznw+jzWXdI0/D
         CfTzsLjI8p35CI0ayT7q82BG/BRBA04PkOX87iO1V6y9jkyJGZOhQ1vBHOAWo2r4dBIi
         wAaA==
X-Gm-Message-State: AJIora9vEYkDrhCXGZGSz2+hFArRdxl9myJhkaYm25FsGYHsvxIvpi1l
        qcMy+/uLHLpIxqf4sXHEuLEk/A==
X-Google-Smtp-Source: ABdhPJyLh3JBR4LBO2uISaXXF74hKbzCrMWKiKHkfD/0hz6aeTBNIlftywrU5AU+hhMj5adPyOLWCw==
X-Received: by 2002:a05:6402:350f:b0:42f:68f9:ae5 with SMTP id b15-20020a056402350f00b0042f68f90ae5mr4804452edd.36.1655197834871;
        Tue, 14 Jun 2022 02:10:34 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id x24-20020aa7dad8000000b0042dd482d0c4sm6657138eds.80.2022.06.14.02.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 02:10:34 -0700 (PDT)
Message-ID: <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
Date:   Tue, 14 Jun 2022 12:10:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time
 for periodic probe
Content-Language: en-US
To:     Yuwei Wang <wangyuweihx@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
 <20220609105725.2367426-3-wangyuweihx@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220609105725.2367426-3-wangyuweihx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06/2022 13:57, Yuwei Wang wrote:
> commit ed6cd6a17896 ("net, neigh: Set lower cap for neigh_managed_work rearming")
> fixed a case when DELAY_PROBE_TIME is configured to 0, the processing of the
> system work queue hog CPU to 100%, and further more we should introduce
> a new option used by periodic probe
> 
> Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
> ---
> v3:
> - add limitation to prevent `INTERVAL_PROBE_TIME` to 0
> - remove `NETEVENT_INTERVAL_PROBE_TIME_UPDATE`
> - add .min to NDTPA_INTERVAL_PROBE_TIME
> 
>  include/net/neighbour.h        |  1 +
>  include/uapi/linux/neighbour.h |  1 +
>  include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
>  net/core/neighbour.c           | 33 ++++++++++++++++++++++++++++--
>  net/decnet/dn_neigh.c          |  1 +
>  net/ipv4/arp.c                 |  1 +
>  net/ipv6/ndisc.c               |  1 +
>  7 files changed, 55 insertions(+), 20 deletions(-)
> 
[snip]
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index 39c565e460c7..8713c3ea81b2 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -154,6 +154,7 @@ enum {
>  	NDTPA_QUEUE_LENBYTES,		/* u32 */
>  	NDTPA_MCAST_REPROBES,		/* u32 */
>  	NDTPA_PAD,
> +	NDTPA_INTERVAL_PROBE_TIME,	/* u64, msecs */
>  	__NDTPA_MAX
>  };
>  #define NDTPA_MAX (__NDTPA_MAX - 1)
[snip]
>  /* /proc/sys/net/dccp */
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 54625287ee5b..845fad952ce2 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
>  	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>  		neigh_event_send_probe(neigh, NULL, false);
>  	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> -			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
> +			   NEIGH_VAR(&tbl->parms, INTERVAL_PROBE_TIME));
>  	write_unlock_bh(&tbl->lock);
>  }
>  
> @@ -2100,7 +2100,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
>  	    nla_put_msecs(skb, NDTPA_PROXY_DELAY,
>  			  NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
>  	    nla_put_msecs(skb, NDTPA_LOCKTIME,
> -			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
> +			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
> +	    nla_put_msecs(skb, NDTPA_INTERVAL_PROBE_TIME,
> +			  NEIGH_VAR(parms, INTERVAL_PROBE_TIME), NDTPA_PAD))
>  		goto nla_put_failure;
>  	return nla_nest_end(skb, nest);
>  
> @@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
>  	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
>  	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
> +	[NDTPA_INTERVAL_PROBE_TIME]	= { .type = NLA_U64, .min = 1 },

shouldn't the min be MSEC_PER_SEC (1 sec minimum) ?

>  };
>  
>  static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
> @@ -2373,6 +2376,10 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
>  					      nla_get_msecs(tbp[i]));
>  				call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
>  				break;
> +			case NDTPA_INTERVAL_PROBE_TIME:
> +				NEIGH_VAR_SET(p, INTERVAL_PROBE_TIME,
> +					      nla_get_msecs(tbp[i]));
> +				break;
>  			case NDTPA_RETRANS_TIME:
>  				NEIGH_VAR_SET(p, RETRANS_TIME,
>  					      nla_get_msecs(tbp[i]));
> @@ -3562,6 +3569,24 @@ static int neigh_proc_dointvec_zero_intmax(struct ctl_table *ctl, int write,
>  	return ret;
>  }
>  
> +static int neigh_proc_dointvec_jiffies_positive(struct ctl_table *ctl, int write,
> +						void *buffer, size_t *lenp,
> +						loff_t *ppos)

Do we need the proc entry to be in jiffies when the netlink option is in ms?
Why not make it directly in ms (with _ms similar to other neigh _ms time options) ?

IMO, it would be better to be consistent with the netlink option which sets it in ms.

It seems the _ms options were added later and usually people want a more understandable
value, I haven't seen anyone wanting a jiffies version of a ms interval variable. :)

> +{
> +	struct ctl_table tmp = *ctl;
> +	int ret;
> +
> +	int min = HZ;
> +	int max = INT_MAX;
> +
> +	tmp.extra1 = &min;
> +	tmp.extra2 = &max;

hmm, I don't think these min/max match the netlink attribute's min/max.

> +
> +	ret = proc_dointvec_jiffies_minmax(&tmp, write, buffer, lenp, ppos);
> +	neigh_proc_update(ctl, write);
> +	return ret;
> +}
> +
>  int neigh_proc_dointvec(struct ctl_table *ctl, int write, void *buffer,
>  			size_t *lenp, loff_t *ppos)
>  {
> @@ -3658,6 +3683,9 @@ static int neigh_proc_base_reachable_time(struct ctl_table *ctl, int write,
>  #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
>  	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_userhz_jiffies)
>  
[snip]
Cheers,
 Nik
