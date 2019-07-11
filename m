Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A48657DA
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfGKNXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 09:23:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35418 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfGKNXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 09:23:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so5707100wmg.0
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 06:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tU6jXndUgskegjYLfj+99Z6a7a9Nh+gO67K7C1rHa5E=;
        b=rg94vvNbMugWLQ59CZ5EqE6whR658vUJTeBK4gEP/9jd8VqKXFkrf73ysktkZUuUYI
         sY1l26I9LDIj/tWl8A07AXKwVCOKGC+ZH02tu4WQ8PhjEermvB/ErlyS4jUwR/gq9nSp
         Kc8F391ozUfFafHeo8By4MY5H8Xkb2CODjd+6D9O0tKhxSePejNAqDLkXOQ0DdHxijeG
         73P92PbMVNXVIua3pEEGHVQ797lXRL63h2r2f62M+zNED8I77BeTzd2UeS0gomlH/2WX
         PFxlsaD92vzo4WSaA77Hg0QqCUN7rZR9KtVjdnQpizMXju3eOtc5DZJh5T3k8oJtcWEy
         T1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tU6jXndUgskegjYLfj+99Z6a7a9Nh+gO67K7C1rHa5E=;
        b=kTzJ9wjJ4/KXJ1ddj7V54ZzylSwfouzysUtNb7ydGA5m1GtPv1Vw7zCzSXQzb+c0WY
         TLBj8SzNbIYY1g0zXaCH0JRpJffIb8QMLqP9G8HwweHN29rjIBHHFYpvxoXEv/tJXVMh
         p2wuv4zNG7m/mRA+xRfexZnMOmSm3xZ1qtc7C5LbZkW4jtI3vPDncttcL/25ZFsXK2dD
         wV1hXnYqD+85XK6m1AdqX/HYHP4ioo9a4va2Z28BJAkD43hUYK0rLVReJMbDMDEgj/D7
         RgQuCZXwFUJVszQcge56nIpEeYpPgPoNtL77mdAD6iFnxP8huUZniwsTTgepZaXgZ2p7
         HYxw==
X-Gm-Message-State: APjAAAWM0PSFHWMmxbXAQjgdf6W1jsq4CQRf4Ivfnsr2ijj0E6RHKiy1
        SEUFv/6k0UJFUdWo8S99UBPkoVyl
X-Google-Smtp-Source: APXvYqyOZOjC18zEQbNxNlIeuZ/7FkYtPBhxjCdenHmcRzJujWs3oLOFKCFwzWdhggjpFBkzr8VHbQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr4289611wmg.135.1562851415991;
        Thu, 11 Jul 2019 06:23:35 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id x16sm3542032wmj.4.2019.07.11.06.23.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:23:35 -0700 (PDT)
Date:   Thu, 11 Jul 2019 15:23:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next,v2 3/3] net: flow_offload: add flow_block
 structure and use it
Message-ID: <20190711132334.GM2291@nanopsycho>
References: <20190711130923.2483-1-pablo@netfilter.org>
 <20190711130923.2483-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711130923.2483-3-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 11, 2019 at 03:09:23PM CEST, pablo@netfilter.org wrote:
>This object stores the flow block callbacks that are attached to this
>block. This patch restores block sharing.
>
>Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>v3: add flow_block_init() - Jiri Pirko.

and rename flow/flow_block/

[...]


>@@ -951,7 +952,7 @@ struct nft_stats {
>  *	@stats: per-cpu chain stats
>  *	@chain: the chain
>  *	@dev_name: device name that this base chain is attached to (if any)
>- *	@cb_list: list of flow block callbacks (for hardware offload)
>+ *	@flow: flow block (for hardware offload)

You missed rename here: s/flow:/flow_block:/


>  */
> struct nft_base_chain {
> 	struct nf_hook_ops		ops;
>@@ -961,7 +962,7 @@ struct nft_base_chain {
> 	struct nft_stats __percpu	*stats;
> 	struct nft_chain		chain;
> 	char 				dev_name[IFNAMSIZ];
>-	struct list_head		cb_list;
>+	struct flow_block		flow_block;
> };
> 
> static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
>diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>index 9482e060483b..6b6b01234dd9 100644
>--- a/include/net/sch_generic.h
>+++ b/include/net/sch_generic.h
>@@ -399,7 +399,7 @@ struct tcf_block {
> 	refcount_t refcnt;
> 	struct net *net;
> 	struct Qdisc *q;
>-	struct list_head cb_list;
>+	struct flow_block flow_block;
> 	struct list_head owner_list;
> 	bool keep_dst;
> 	unsigned int offloadcnt; /* Number of oddloaded filters */
>diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>index a800fa78d96c..935c7f81a9ef 100644
>--- a/net/core/flow_offload.c
>+++ b/net/core/flow_offload.c
>@@ -198,7 +198,7 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,

Reminding the block arg here.


> {
> 	struct flow_block_cb *block_cb;
> 
>-	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
>+	list_for_each_entry(block_cb, &f->block->cb_list, list) {
> 		if (block_cb->cb == cb &&
> 		    block_cb->cb_ident == cb_ident)
> 			return block_cb;

[...]

