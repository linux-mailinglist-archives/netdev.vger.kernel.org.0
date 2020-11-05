Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113BD2A8784
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgKETrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:47:41 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D2CC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 11:47:41 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i7so2056556pgh.6
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 11:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1LOTo8UUi+aPq+8VNE9d8RB8luDDjM4KCS3eWO+QWDo=;
        b=uFjtqE5zriykFejhpQWNJbOvAtxj7TD908/c4l4VN8f4TEW9CBhkH9EF1qgrs2i4FO
         Dtf9eqdWQcdJEP6k9Zij9cH1OjQfgyoFpUpr182hxIVBFc3Z0FTPX3vzy6RcFj7vVj7D
         oMGNguH1r2S85OtUPNQVD47e4GtOOSUQqoIfIE+UrQvP4vKPQ6goxLQK90Ulb9IZ8Z5U
         b8Ug9W6OntT0vFu3lSxhdbAjZuWeS+OIsIOxDoa9ahGbya2I4rkIv1Y15KDYerrIxfuJ
         +RMuslHvl667105wNV8HZdMRL+cbAw7rzfN0j0+3qKJ84m4dSFVhOjpmcjG9U0PBQ1TW
         +ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LOTo8UUi+aPq+8VNE9d8RB8luDDjM4KCS3eWO+QWDo=;
        b=D9FsGF1N1YfbjFHbO7yZDL/CWyB0NopMTxEuqmy5P5B2oOm0YbZKhds24MlBjEzXbI
         QxC6UF7mVmsh+eNaZEXELdtrPAVnLlEf3X5qyWCbG1IsS9aKJ0rNv/WK92zJ0i1EgNCH
         jejw036YBAbZWaG1ugppuyDhoLgRD+8L98VHZkk64crT21hizLQl2tlIOsrfN4/ipik4
         prszFXTsjjqQXRYdccWJH0w5dE7/kl48tljTzKamxNwt3LB6MUh5KSh7YB4yAvqL2Exy
         wTVJcTdoE8S1HF2/veRz+Azx2IcVJSOH3Th+lWrFRIOag7HMmmpE+y9mqkGg9s1z6+3d
         4rPw==
X-Gm-Message-State: AOAM53181xBLGLeYqITrNIJlaAskIJoMMG3QDlUWhy2+IzZ4IVUwjFGg
        7w2VU/AsYwKKT6wUHXp41L+y3tyGZKzUhQ==
X-Google-Smtp-Source: ABdhPJzOvDm/KwbAzBaHzKjYXwVb6b46Bqumk3SDyWr3pTJmBHczXLlHHiTFMTGp+E9mH2wP7vnydg==
X-Received: by 2002:a17:90b:4a10:: with SMTP id kk16mr3988183pjb.77.1604605660193;
        Thu, 05 Nov 2020 11:47:40 -0800 (PST)
Received: from [192.168.0.16] (97-115-80-55.ptld.qwest.net. [97.115.80.55])
        by smtp.gmail.com with ESMTPSA id x18sm3116218pgj.49.2020.11.05.11.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 11:47:39 -0800 (PST)
Subject: Re: [PATCH net] openvswitch: Fix upcall
 OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS
To:     Yi-Hung Wei <yihung.wei@gmail.com>, netdev@vger.kernel.org
References: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <32f58804-4f52-9893-2666-7e1b71acb55e@gmail.com>
Date:   Thu, 5 Nov 2020 11:47:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/3/2020 4:11 PM, Yi-Hung Wei wrote:
> TUNNEL_GENEVE_OPT is set on tun_flags in struct sw_flow_key when
> a packet is coming from a geneve tunnel no matter the size of geneve
> option is zero or not.  On the other hand, TUNNEL_VXLAN_OPT or
> TUNNEL_ERSPAN_OPT is set when the VXLAN or ERSPAN option is available.
> Currently, ovs kernel module only generates
> OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS when the tun_opts_len is non-zero.
> As a result, for a geneve packet without tun_metadata, when the packet
> is reinserted from userspace after upcall, we miss the TUNNEL_GENEVE_OPT
> in the tun_flags on struct sw_flow_key, and that will further cause
> megaflow matching issue.
> 
> This patch changes the way that we deal with the upcall netlink message
> generation to make sure the geneve tun_flags is set consistently
> as the packet is firstly received from the geneve tunnel in order to
> avoid megaflow matching issue demonstrated by the following flows.
> This issue is only observed on ovs kernel datapath.
> 
> Consider the following two flows, and the two cases.
> * flow1: icmp traffic from gnv0 to gnv1, without any tun_metadata
> * flow2: icmp traffic form gnv0 to gnv1 with tun_metadata0
> 
> Case 1)
> Send flow2 first, and then send flow1.  When both flows are running,
> both the following two flows are hit, which is expected.
> 
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> 
> Case 2)
> Send flow1 first, then send flow2.  When both flows are running,
> only the following flow is hit.
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> 
> Example flows)
> 
> table=0, arp, actions=NORMAL
> table=0, in_port=gnv1, icmp, action=ct(table=1)
> table=0, in_port=gnv0, icmp  action=move:NXM_NX_TUN_METADATA0[0..7]->NXM_NX_REG9[0..7], resubmit(,1)
> table=1, in_port=gnv1, icmp, action=output:gnv0
> table=1, in_port=gnv0, icmp  action=ct(table=2)
> table=2, priority=300, in_port=gnv0, icmp, ct_state=+trk+new, action=ct(commit),output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> 
> Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> ---
>   net/openvswitch/flow_netlink.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 9d3e50c4d29f..b03ec6a1a1fa 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -912,13 +912,13 @@ static int __ip_tun_to_nlattr(struct sk_buff *skb,
>   	if ((output->tun_flags & TUNNEL_OAM) &&
>   	    nla_put_flag(skb, OVS_TUNNEL_KEY_ATTR_OAM))
>   		return -EMSGSIZE;
> -	if (swkey_tun_opts_len) {
> -		if (output->tun_flags & TUNNEL_GENEVE_OPT &&
> -		    nla_put(skb, OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS,
> +	if (output->tun_flags & TUNNEL_GENEVE_OPT) {
> +		if (nla_put(skb, OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS,
>   			    swkey_tun_opts_len, tun_opts))
>   			return -EMSGSIZE;
> -		else if (output->tun_flags & TUNNEL_VXLAN_OPT &&
> -			 vxlan_opt_to_nlattr(skb, tun_opts, swkey_tun_opts_len))
> +	} else if (swkey_tun_opts_len) {
> +		if (output->tun_flags & TUNNEL_VXLAN_OPT &&
> +		    vxlan_opt_to_nlattr(skb, tun_opts, swkey_tun_opts_len))
>   			return -EMSGSIZE;
>   		else if (output->tun_flags & TUNNEL_ERSPAN_OPT &&
>   			 nla_put(skb, OVS_TUNNEL_KEY_ATTR_ERSPAN_OPTS,
> 

Applies and builds cleanly.

Passes OVS kernel test suite geneve tunnel tests.

  17: datapath - ping over geneve tunnel              ok
  18: datapath - flow resume with geneve tun_metadata ok
  19: datapath - ping over geneve6 tunnel             ok

Code looks good to me.

Acked-by: Greg Rose <gvrose8192@gmail.com>
