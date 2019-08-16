Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736E390916
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfHPT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:58:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46460 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbfHPT6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:58:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id j15so7328626qtl.13
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cPTikdBvKEsu5fBF9SHgC8BRCguXqLmj/Y5cbTsPbbY=;
        b=G/Dr26bi25FJ+7o0zBZj78DE/ZK5P/0cVntkxH5lhF7qDUstlvc2565nrO64i8cLIo
         Shb5J3iwf+wICyb2ObKRz6iJSr54M4zjtD1rOGqc3CGw/2vJAfVWJeoAc0Uyc3Vh2C5G
         IBo0XwaYRoeUv+TOPcKOyKkQAQDavl71aSdI+ckTMGzvj9pxQyf7LFkGRQEopxlQer2k
         7y77YM+MR69uQRJSrY8QnZlsHMBg+NLqlMTNfhIC8rpQ7mTvx4YCep/5+R357CpnVDz3
         4iAnWsDa27XOLWX4/MehEXg1qoIwZ/06gmOb9MUOisTrmW4bEakCBtrsNd75kyq8/By5
         CSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cPTikdBvKEsu5fBF9SHgC8BRCguXqLmj/Y5cbTsPbbY=;
        b=l+4BDdO/kWJdfXgPiEckiHoPrqx/JhzR7AQMow9/Kz7GjA0yoL+68PIQI1DbnNlkRe
         g/QaxFR+Q6X1GZxpP55LBG5JvqlqSwIJuTpvb+i5rOpMz71kt63HH85hpub94bTAV9gW
         sG+D/UGArm7MylXdJCT+sQBH9gXBhMpctgv4x730uHSroYTKI80SQ9EkbcBZ7x5oxvN3
         sTKY1X84yx1I5IwEoSfMywWTDhX/zvHfAi5Ul69wJSCMs83KEUOJqhmC66e3rY7E6pB1
         Tzp+sZNr51r5Zl0M2v5kwyxQJA2r8ol9TceTScFSgr6xuwNQ1Pmc4BSLqJrQnBzcS542
         Zgjw==
X-Gm-Message-State: APjAAAUoTgSoL/UHuuZZo5cjrhKwpHaMHBI0RrbfIPCoCT1xZx7TrJfp
        k12BqaWq0X1Va+6R8BcpN7IpVA==
X-Google-Smtp-Source: APXvYqz2plHU9kFS9ecV9Dndef+BfdlJFIIc5WflEBcYfhhdN6mD8dKupHSwolNVrlNLEK92K96Ylw==
X-Received: by 2002:ac8:34aa:: with SMTP id w39mr10435554qtb.118.1565985499257;
        Fri, 16 Aug 2019 12:58:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q42sm4017774qtc.52.2019.08.16.12.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 12:58:19 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:58:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, wenxu@ucloud.cn,
        pablo@netfilter.org
Subject: Re: [PATCH net-next] net: flow_offload: convert block_ing_cb_list
 to regular list type
Message-ID: <20190816125801.095bfd23@cakuba.netronome.com>
In-Reply-To: <20190816150654.22106-1-vladbu@mellanox.com>
References: <20190816150654.22106-1-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 18:06:54 +0300, Vlad Buslov wrote:
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 64c3d4d72b9c..cf52d9c422fa 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -391,6 +391,8 @@ static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
>  	kfree(indr_block_cb);
>  }
>  
> +static DEFINE_MUTEX(flow_indr_block_ing_cb_lock);

I'd be tempted to place this definition next to:

static LIST_HEAD(block_ing_cb_list);

as it seems this is the list it protects. The reason for the name
discrepancy between the two is not immediately obvious to me :S 
but you're not changing that.

Otherwise makes sense, so FWIW:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

>  static void flow_block_ing_cmd(struct net_device *dev,
>  			       flow_indr_block_bind_cb_t *cb,
>  			       void *cb_priv,
> @@ -398,11 +400,11 @@ static void flow_block_ing_cmd(struct net_device *dev,
>  {
>  	struct flow_indr_block_ing_entry *entry;
>  
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
> +	mutex_lock(&flow_indr_block_ing_cb_lock);
> +	list_for_each_entry(entry, &block_ing_cb_list, list) {
>  		entry->cb(dev, cb, cb_priv, command);
>  	}
> -	rcu_read_unlock();
> +	mutex_unlock(&flow_indr_block_ing_cb_lock);
>  }
