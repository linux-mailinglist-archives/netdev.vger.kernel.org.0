Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC4078A3A
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbfG2LOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:14:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56203 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbfG2LOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:14:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so53455770wmj.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 04:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F9xze7EuNMlpdeu9j58pHlZMhDPD1uyveURptxNoH+8=;
        b=cltdXSpv+Y3RYPa9c2LmSINGUOfQECFL6P3Yg4ahPXZpb1N2kmTmc/XwlMWmsojZW3
         iSEvbAxMPKUNh8c4VKd3FzMgng/EoTMXMAsYT0k1IwdqOSyAd/14XqCzfpjm+uQHMkfv
         KzIzHHjS+fy5t3DNnlGQZVKsmPXdG/cW4uRdnN53wnvc8hfdmacUP5oZFYfceqWYpKJk
         6ouwG0HrhL3xdjrGH41m5Ni961uyr6dMj66Vj6ntc2fG9vLpEcQ3orf1UFHs9U9mMubK
         BwysgJlWGz+er6LpyLOB9H0f/fp0AP9FSo4AKTPR4kYW0bRwdjo9z/EaAdABUDlDcUIW
         3Skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F9xze7EuNMlpdeu9j58pHlZMhDPD1uyveURptxNoH+8=;
        b=bAbYUNT4uduEVfnGbBe3fK2VCRcMTXevux5KUmFiQP7qR3XCSmMfWAa4veazIiVwHf
         LyLeD4ZpTC5szjwJZK/gLRpF9EGeO5OMmyRMg3/ln0GY9TjGN4nFgxoC8YSjmAHY3Mcu
         T/R63MObXVSzYjcVr1+4OeNgME/U6ZMAIHDBMI3U/TNJ12Vtl4fDQHBGDSvi0vz0UNuV
         U7oVj4qRg5/rjDYcy9jUfh1dMW1xJXCQpxcUYc6sMQQ3A2//CSJmjVe10UV4VOuoqPeA
         zNH2xhk0lCVk1/rxJN86AYC5zYf3el6xyooYftjAtQKLzLhHjWmtBUNc5cApEq05p0vk
         Q3pQ==
X-Gm-Message-State: APjAAAUvbOergs9CoeEt5l6HDldPbBoBdVLYJ45Ftb3R7pD4QIUy8JrR
        e3wGDuX56vhCL087g5VR8aS+l93J
X-Google-Smtp-Source: APXvYqwklRKQJ3VWRDpw54uKC3FxI/tMgS6PG0oY9PpFfv0m+0tCIairiymXdOgaj5+SPzcala1hrA==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr96685428wmj.94.1564398837236;
        Mon, 29 Jul 2019 04:13:57 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id z19sm44618105wmi.7.2019.07.29.04.13.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 04:13:56 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:13:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190729111350.GE2211@nanopsycho>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 28, 2019 at 08:52:47AM CEST, wenxu@ucloud.cn wrote:
>From: wenxu <wenxu@ucloud.cn>
>
>move tc indirect block to flow_offload and rename
>it to flow indirect block.The nf_tables can use the
>indr block architecture.
>
>Signed-off-by: wenxu <wenxu@ucloud.cn>
>---
>v3: subsys_initcall for init_flow_indr_rhashtable
>v4: no change
>

[...]


>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index 00b9aab..66f89bc 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -4,6 +4,7 @@
> #include <linux/kernel.h>
> #include <linux/list.h>
> #include <net/flow_dissector.h>
>+#include <linux/rhashtable.h>
> 
> struct flow_match {
> 	struct flow_dissector	*dissector;
>@@ -366,4 +367,42 @@ static inline void flow_block_init(struct flow_block *flow_block)
> 	INIT_LIST_HEAD(&flow_block->cb_list);
> }
> 
>+typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
>+				      enum tc_setup_type type, void *type_data);
>+
>+struct flow_indr_block_cb {
>+	struct list_head list;
>+	void *cb_priv;
>+	flow_indr_block_bind_cb_t *cb;
>+	void *cb_ident;
>+};

I don't understand why are you pushing this struct out of the c file to
the header. Please don't.


>+
>+typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
>+				       struct flow_block *flow_block,
>+				       struct flow_indr_block_cb *indr_block_cb,
>+				       enum flow_block_command command);
>+
>+struct flow_indr_block_dev {
>+	struct rhash_head ht_node;
>+	struct net_device *dev;
>+	unsigned int refcnt;
>+	struct list_head cb_list;
>+	flow_indr_block_ing_cmd_t *ing_cmd_cb;
>+	struct flow_block *flow_block;

I don't understand why are you pushing this struct out of the c file to
the header. Please don't.


>+};
>+
>+struct flow_indr_block_dev *flow_indr_block_dev_lookup(struct net_device *dev);
>+
>+int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>+				  flow_indr_block_bind_cb_t *cb, void *cb_ident);
>+
>+void __flow_indr_block_cb_unregister(struct net_device *dev,
>+				     flow_indr_block_bind_cb_t *cb, void *cb_ident);
>+
>+int flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>+				flow_indr_block_bind_cb_t *cb, void *cb_ident);
>+
>+void flow_indr_block_cb_unregister(struct net_device *dev,
>+				   flow_indr_block_bind_cb_t *cb, void *cb_ident);
>+
	
[...]

	
>+
>+int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>+				  flow_indr_block_bind_cb_t *cb,
>+				  void *cb_ident)
>+{
>+	struct flow_indr_block_cb *indr_block_cb;
>+	struct flow_indr_block_dev *indr_dev;
>+	int err;
>+
>+	indr_dev = flow_indr_block_dev_get(dev);
>+	if (!indr_dev)
>+		return -ENOMEM;
>+
>+	indr_block_cb = flow_indr_block_cb_add(indr_dev, cb_priv, cb, cb_ident);
>+	err = PTR_ERR_OR_ZERO(indr_block_cb);
>+	if (err)
>+		goto err_dev_put;
>+
>+	if (indr_dev->ing_cmd_cb)
>+		indr_dev->ing_cmd_cb(indr_dev->dev, indr_dev->flow_block, indr_block_cb,

This line is over 80cols. Please run checkpatch script for your patch
and obey the warnings.


>+				     FLOW_BLOCK_BIND);
>+
>+	return 0;
>+
>+err_dev_put:
>+	flow_indr_block_dev_put(indr_dev);
>+	return err;
>+}
>+EXPORT_SYMBOL_GPL(__flow_indr_block_cb_register);

[...]


> 
>-static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
>-				  struct tc_indr_block_cb *indr_block_cb,
>+static void tc_indr_block_ing_cmd(struct net_device *dev,

I don't understand why you change struct tc_indr_block_dev * to
struct net_device * here. If you want to do that, please do that in a
separate patch, not it this one where only "the move" should happen.


>+				  struct flow_block *flow_block,
>+				  struct flow_indr_block_cb *indr_block_cb,
> 				  enum flow_block_command command)
> {
>+	struct tcf_block *block = flow_block ?
>+				  container_of(flow_block,
>+					       struct tcf_block,
>+					       flow_block) : NULL;
> 	struct flow_block_offload bo = {
> 		.command	= command,
> 		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
>-		.net		= dev_net(indr_dev->dev),
>-		.block_shared	= tcf_block_non_null_shared(indr_dev->block),
>+		.net		= dev_net(dev),
>+		.block_shared	= tcf_block_non_null_shared(block),
> 	};
> 	INIT_LIST_HEAD(&bo.cb_list);
> 

[...]
