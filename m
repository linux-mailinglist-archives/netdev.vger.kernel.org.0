Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B67A7FFE8
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436672AbfHBRwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:52:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41748 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405555AbfHBRv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:51:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so26076546pgg.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=2NF118ohkpMSq+LddurSp4t7mX6YWZVIC7WvM4KdDTs=;
        b=jIl9vJlgWgd+Q1n/izxSZ0zsUHcnvrrGLqoOxCSr8AHnBMBxhXYH0gS6yWnGhkCQb3
         FQ/ajBMeSDRaiEkS5IxrWVrWm6r1e6OydVPW+GTpb0jRa5ygYX9m8C7DWL3iusXjxNof
         t9w3c3sMtup1s4Mv1uR+TvsZHKXHXdh8ngPmJMMRb5OpjM+a51BzvCriiaOMReDiGUYk
         /Ok+l6T2CZft94MU+el/UKUTN/JLf4x8Fyh6Fh/qTaWESoLhSL2uA1c8wb7x6u0CyFwE
         DspHhRYH28bYKDrETtnuvoZiXE21uc/Ma5QdAcoShjfv+AM7eFTzYbt8tswvluGaC04o
         QcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2NF118ohkpMSq+LddurSp4t7mX6YWZVIC7WvM4KdDTs=;
        b=SpoyEa6KwDm+J2/mmQ8v5Anloc/MHZi2vLw8EsIXYu7bDMhmR0SUJqjs2YGwtZX+Fq
         6FZwZY8UhvoQSY8VmGke5B+RQcN15Xkg3LPPqQ3Gm5v4kTC18IaD1s+EUiMFIgU5mRAL
         IEJl1dVAy2m+Y8XjSWO9SDJV4LLDaitJzj58lf75hfGNI7x7GadPGuPfuF5ybDmZAYBj
         J4QDfi7zF4FCkvkU8whiOvS/nQ0+rnwnvPwVITcb9B4Vi+DcBBNpc+I5ipeepcD2R27d
         nxD9r9LMfTAC+nxJR0yvi/UybRBFKe1EXbat1BRDprQeKNIBKLvbcZuQLVHeQB7mYZ1E
         IFEg==
X-Gm-Message-State: APjAAAXI3s3iNCfiskBPOq1nvGjJ6vcjzuq3IlVl+Xt1JgVJfYxj4S/d
        byX9xp6Gr15979qCBF7xGJ8=
X-Google-Smtp-Source: APXvYqzCeBr2eMTzekEXSN1HLSOl0sJDG9pP2mbCfvZb4jB9g6HWlU1z27pb+1ZqO9HtwzKB0xz7Ow==
X-Received: by 2002:a63:1046:: with SMTP id 6mr128575817pgq.111.1564768318998;
        Fri, 02 Aug 2019 10:51:58 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.142.179])
        by smtp.gmail.com with ESMTPSA id t7sm7129336pjq.15.2019.08.02.10.51.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 10:51:58 -0700 (PDT)
Subject: Re: [PATCH net-next] openvswitch: Print error when
 ovs_execute_actions() fails
To:     Yifeng Sun <pkusunyifeng@gmail.com>, netdev@vger.kernel.org,
        pshelar@ovn.org
References: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <91335f0c-95dc-bbb6-f815-8e90d6f18874@gmail.com>
Date:   Fri, 2 Aug 2019 10:51:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/2019 2:14 PM, Yifeng Sun wrote:
> Currently in function ovs_dp_process_packet(), return values of
> ovs_execute_actions() are silently discarded. This patch prints out
> an error message when error happens so as to provide helpful hints
> for debugging.
>
> Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>
> ---
>   net/openvswitch/datapath.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 892287d..603c533 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -222,6 +222,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>   	struct dp_stats_percpu *stats;
>   	u64 *stats_counter;
>   	u32 n_mask_hit;
> +	int error;
>   
>   	stats = this_cpu_ptr(dp->stats_percpu);
>   
> @@ -229,7 +230,6 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>   	flow = ovs_flow_tbl_lookup_stats(&dp->table, key, &n_mask_hit);
>   	if (unlikely(!flow)) {
>   		struct dp_upcall_info upcall;
> -		int error;
>   
>   		memset(&upcall, 0, sizeof(upcall));
>   		upcall.cmd = OVS_PACKET_CMD_MISS;
> @@ -246,7 +246,10 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>   
>   	ovs_flow_stats_update(flow, key->tp.flags, skb);
>   	sf_acts = rcu_dereference(flow->sf_acts);
> -	ovs_execute_actions(dp, skb, sf_acts, key);
> +	error = ovs_execute_actions(dp, skb, sf_acts, key);
> +	if (unlikely(error))
> +		net_err_ratelimited("ovs: action execution error on datapath %s: %d\n",
> +							ovs_dp_name(dp), error);
>   
>   	stats_counter = &stats->n_hit;
>   

Thanks Yifeng.

Reviewed-by: Greg Rose <gvrose8192@gmail.com>

