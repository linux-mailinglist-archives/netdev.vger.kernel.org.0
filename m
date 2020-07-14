Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BEB21F289
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGNNaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgGNNaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:30:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A98C061794
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:30:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so21621640wrs.0
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aTJ3Rcwa/grjzVIqzKxKgdaenS1CE6YbOTpZIMshk7Q=;
        b=MtRuyZA8wAUOQH0SLfWm2UNNYnjptVw+pJPfiXxotJo3wrtwQRLpbEMxQQTuF8raxF
         WJuJjCmNl4kWnJzBoUNhuKk+AC3ZK/f4GS+Mj00uVX1r+SdtAp5EgcVN11d+gOPUBZw9
         ZJlhE9j2mHJI8UXLBmLsdePeGc7Mp4LXa3RNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aTJ3Rcwa/grjzVIqzKxKgdaenS1CE6YbOTpZIMshk7Q=;
        b=d1oqlMkUVnHf6p4gx5OZpcSAw8jXVvzwicIgU/6UO2hwPXAhwl1IrHr0krRUtgqCB6
         dwxURlxQhy9QRk8GAr579ApQBnRaebrx24AD58m+nxlYksISk+kcXIuvwcQNCuUoHdF9
         tKciM50OKmGUEV4tYutmbF9d4kVjKyl4tYyoybi4tQvuEKIHKxXTzZ05fHaWPB/GSZIV
         pUAONOs4+DvH5xMFQZ+ykK/m7+BIO1IhsfEwyeVEfBdVFXbFyO2OGc4t+S+5CnTGZRzv
         4ig42YznehnmkUl89GLqsnGdH+j1sYPpPn8DZOWnLdi/eI0NQc6bAFqpDn8lPV439gGZ
         6T/A==
X-Gm-Message-State: AOAM531k9xCQv5IVsodBjyBE5nrjocLHuH2f8oa4JwtCudesr3yi2JUM
        d/flFL0Zl3Lf3xQ0oBHJZJfOaQ==
X-Google-Smtp-Source: ABdhPJwx92NGJ6juyq9L3CkGoI/9dISLiqb98fnDN5Dz2vU/bXwlxekp7ivCpc2klxVg1F0urn9YNA==
X-Received: by 2002:a5d:518a:: with SMTP id k10mr5371438wrv.316.1594733402366;
        Tue, 14 Jul 2020 06:30:02 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 92sm31481023wrr.96.2020.07.14.06.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:30:01 -0700 (PDT)
Subject: Re: [PATCH net-next v4 01/12] switchdev: mrp: Extend switchdev API
 for MRP Interconnect
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@resnulli.us, ivecera@redhat.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200714073458.1939574-1-horatiu.vultur@microchip.com>
 <20200714073458.1939574-2-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a90c8980-fb9f-2bf2-16d2-c9878ce55cf3@cumulusnetworks.com>
Date:   Tue, 14 Jul 2020 16:30:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714073458.1939574-2-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2020 10:34, Horatiu Vultur wrote:
> Extend switchdev API to add support for MRP interconnect. The HW is
> notified in the following cases:
> 
> SWITCHDEV_OBJ_ID_IN_ROLE_MRP: This is used when the interconnect role
>   of the node changes. The supported roles are MIM and MIC.
> 
> SWITCHDEV_OBJ_ID_IN_STATE_MRP: This is used when the interconnect ring
>   changes it states to open or closed.
> 
> SWITCHDEV_OBJ_ID_IN_TEST_MRP: This is used to start/stop sending
>   MRP_InTest frames on all MRP ports. This is called only on nodes that
>   have the interconnect role MIM.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/net/switchdev.h | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index b8c059b4e06d9..ff22469143013 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -76,6 +76,10 @@ enum switchdev_obj_id {
>  	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
>  	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
>  	SWITCHDEV_OBJ_ID_RING_STATE_MRP,
> +	SWITCHDEV_OBJ_ID_IN_TEST_MRP,
> +	SWITCHDEV_OBJ_ID_IN_ROLE_MRP,
> +	SWITCHDEV_OBJ_ID_IN_STATE_MRP,
> +
>  #endif
>  };
>  
> @@ -155,6 +159,40 @@ struct switchdev_obj_ring_state_mrp {
>  #define SWITCHDEV_OBJ_RING_STATE_MRP(OBJ) \
>  	container_of((OBJ), struct switchdev_obj_ring_state_mrp, obj)
>  
> +/* SWITCHDEV_OBJ_ID_IN_TEST_MRP */
> +struct switchdev_obj_in_test_mrp {
> +	struct switchdev_obj obj;
> +	/* The value is in us and a value of 0 represents to stop */
> +	u32 interval;
> +	u32 in_id;
> +	u32 period;
> +	u8 max_miss;
> +};
> +
> +#define SWITCHDEV_OBJ_IN_TEST_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_in_test_mrp, obj)
> +
> +/* SWICHDEV_OBJ_ID_IN_ROLE_MRP */
> +struct switchdev_obj_in_role_mrp {
> +	struct switchdev_obj obj;
> +	struct net_device *i_port;
> +	u32 ring_id;
> +	u16 in_id;
> +	u8 in_role;
> +};
> +
> +#define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_in_role_mrp, obj)
> +
> +struct switchdev_obj_in_state_mrp {
> +	struct switchdev_obj obj;
> +	u32 in_id;
> +	u8 in_state;
> +};
> +
> +#define SWITCHDEV_OBJ_IN_STATE_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_in_state_mrp, obj)
> +
>  #endif
>  
>  typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
> 

