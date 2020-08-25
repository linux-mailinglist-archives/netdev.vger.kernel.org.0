Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF1252324
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 23:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHYVvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 17:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgHYVvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 17:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598392304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PBUDt3MLFSsbvUi94397oyZLEz11vDjTLsYjmK81Sac=;
        b=IhRRy7Tb33k+8qfU8EmzAGKriGVrD1fp9PTWfn329hlcJuxioahoNEW2g3Sr1ZGssxdKwq
        hAPZKuEjz1RvZabgG7G0Gmbd9dEaL9No7IF0pSYJmBjV8HUt/ukOIBmAbMIOxMAgHzNb6+
        MlmpoeW6nyuIoPn+Kdk6PHgIt4jBAmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-kIL0rb0nM5e-PLHSuTeJtA-1; Tue, 25 Aug 2020 17:51:37 -0400
X-MC-Unique: kIL0rb0nM5e-PLHSuTeJtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 564E6189E60D;
        Tue, 25 Aug 2020 21:51:36 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D90F19C58;
        Tue, 25 Aug 2020 21:51:33 +0000 (UTC)
Date:   Tue, 25 Aug 2020 23:51:21 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     xiangxia.m.yue@gmail.com
Cc:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com,
        dev@openvswitch.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: openvswitch: improve coding style
Message-ID: <20200825235121.0d8bd3d0@elisabeth>
In-Reply-To: <20200825050636.14153-2-xiangxia.m.yue@gmail.com>
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
        <20200825050636.14153-2-xiangxia.m.yue@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 13:06:34 +0800
xiangxia.m.yue@gmail.com wrote:

> +++ b/net/openvswitch/datapath.c
>
> [...]
>
> @@ -2095,7 +2099,7 @@ static void ovs_update_headroom(struct datapath *dp, unsigned int new_headroom)
>  	dp->max_headroom = new_headroom;
>  	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)

While at it, you could also add curly brackets here.

> +++ b/net/openvswitch/flow_table.c
>
> [...]
>
> @@ -111,9 +111,11 @@ static void flow_free(struct sw_flow *flow)
>  	if (ovs_identifier_is_key(&flow->id))
>  		kfree(flow->id.unmasked_key);
>  	if (flow->sf_acts)
> -		ovs_nla_free_flow_actions((struct sw_flow_actions __force *)flow->sf_acts);
> +		ovs_nla_free_flow_actions((struct sw_flow_actions __force *)
> +					  flow->sf_acts);
>  	/* We open code this to make sure cpu 0 is always considered */
> -	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask))
> +	for (cpu = 0; cpu < nr_cpu_ids;
> +	     cpu = cpumask_next(cpu, &flow->cpu_used_mask))

...and here.

> @@ -273,7 +275,7 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
>  
>  	if (ma_count >= ma->max) {
>  		err = tbl_mask_array_realloc(tbl, ma->max +
> -					      MASK_ARRAY_SIZE_MIN);
> +					     MASK_ARRAY_SIZE_MIN);

This is not aligned properly either, MASK_ARRAY_SIZE_MIN is added to
ma->max and should be aligned to it.

> @@ -448,16 +450,17 @@ int ovs_flow_tbl_init(struct flow_table *table)
>  
>  static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
>  {
> -	struct table_instance *ti = container_of(rcu, struct table_instance, rcu);
> +	struct table_instance *ti =
> +		container_of(rcu, struct table_instance, rcu);

The assignment could very well go on a separate line.

-- 
Stefano

