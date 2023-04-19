Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63F6E73AB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjDSHJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSHJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:09:29 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1632710;
        Wed, 19 Apr 2023 00:09:27 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f17eb6b10fso2456625e9.3;
        Wed, 19 Apr 2023 00:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681888166; x=1684480166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gncw5NSYKJdC+oXb5vIMmABpBB/w2kQIQqkwx1G7ip0=;
        b=jE/02GvCWwsIBkkZC7nqWL71z3VWDSjb0p+VqxANr0zdhwqFx3PMsodzHk6g1kS+sa
         u1dlw35nt3ABDoU5sCnbd1mF92h+XdLlAM1W+TzPi0OAnazAyN4Lg5l23Ga0Bn8JyCTH
         EqKuPdfswmFGbTvPYCGrp6MnFf70HKr2lXONtTEyO0c9rhEtYOWACU2vGaSkMg+gM6ML
         RV8sFwI6oe1E6q9Jh1ZyN4CbSeuABf5114iupLWs+UHvF1FOEixYyvqyIEuVwuEvkoKP
         JsA1fMr6BevonVOiJGG7hkXTjLC0nggIzQRKPsbHtpt+E7Lc0nzZS47wzFl4cI1+knFU
         ngKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888166; x=1684480166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gncw5NSYKJdC+oXb5vIMmABpBB/w2kQIQqkwx1G7ip0=;
        b=QLuo7NdP7sfB2vGnXUW1sgY7pJr8BjuMn9vg6XdotTtPI4ZmghECvMeuJuiQUYvywk
         VaJ7Yz2Lh9l4XUBqDAmgNX5ZdEPs8sH58JoZ0Z/jSCx3O7snyHfj3635na/SAmwkAMe0
         KA4bJFgmYjsSarx3j6c4RII8KsNWx9+2qSaKiIaFgXL9Txw6lKlqrI9KiaD9Y5Tb9t5r
         kGcbcd2jWMCSvAUA1DT/MlEgweNMCFKxoWMtX63p8W+prlGQbizv6SCjN8rF2rCBYptj
         KL4hCvFd9Pof6wzf2cJWDEvbKOmU418qfYWhqIwd6Cv1AkLF2qATZbDKPiciXkf6fKxE
         mS7Q==
X-Gm-Message-State: AAQBX9dn1fi5u0d4MEtwsb63wutF6fvsMBDGedndM1vv+ofcj01wtXIu
        bcXa+Fj/HQyJoDUXh1cfH40=
X-Google-Smtp-Source: AKy350YV8zET0vM4q6+vXD1E7cJckJiUb0/Ni6CnVlFipLUT0QudslX6e3wYbpWqftH/rcdvPj/pDQ==
X-Received: by 2002:adf:e58a:0:b0:2ef:1c8c:1113 with SMTP id l10-20020adfe58a000000b002ef1c8c1113mr4361586wrm.9.1681888166283;
        Wed, 19 Apr 2023 00:09:26 -0700 (PDT)
Received: from [192.168.0.103] ([77.124.103.108])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b002f3e1122c1asm14963527wrd.15.2023.04.19.00.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 00:09:25 -0700 (PDT)
Message-ID: <9975669b-27bf-6903-f908-184946960c25@gmail.com>
Date:   Wed, 19 Apr 2023 10:09:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/2] net/mlx4: avoid overloading user/kernel pointers
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>, Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230418114730.3674657-1-arnd@kernel.org>
 <20230418114730.3674657-2-arnd@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230418114730.3674657-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/04/2023 14:47, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The mlx4_ib_create_cq() and mlx4_init_user_cqes() functions cast
> between kernel pointers and user pointers, which is confusing
> and can easily hide bugs.
> 
> Change the code to use use the correct address spaces consistently
> and use separate pointer variables in mlx4_cq_alloc() to avoid
> mixing them.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I ran into this while fixing the link error in the first
> patch, and decided it would be useful to clean up.
> ---
>   drivers/infiniband/hw/mlx4/cq.c         | 11 +++++++----
>   drivers/net/ethernet/mellanox/mlx4/cq.c | 17 ++++++++---------
>   include/linux/mlx4/device.h             |  2 +-

missed the mlx4_cq_alloc usage in
drivers/net/ethernet/mellanox/mlx4/en_cq.c.

>   3 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
> index 4cd738aae53c..b12713fdde99 100644
> --- a/drivers/infiniband/hw/mlx4/cq.c
> +++ b/drivers/infiniband/hw/mlx4/cq.c
> @@ -180,7 +180,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>   	struct mlx4_ib_dev *dev = to_mdev(ibdev);
>   	struct mlx4_ib_cq *cq = to_mcq(ibcq);
>   	struct mlx4_uar *uar;
> -	void *buf_addr;
> +	void __user *ubuf_addr;
> +	void *kbuf_addr;
>   	int err;
>   	struct mlx4_ib_ucontext *context = rdma_udata_to_drv_context(
>   		udata, struct mlx4_ib_ucontext, ibucontext);
> @@ -209,7 +210,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>   			goto err_cq;
>   		}
>   
> -		buf_addr = (void *)(unsigned long)ucmd.buf_addr;
> +		ubuf_addr = u64_to_user_ptr(ucmd.buf_addr);
> +		kbuf_addr = NULL;
>   		err = mlx4_ib_get_cq_umem(dev, &cq->buf, &cq->umem,
>   					  ucmd.buf_addr, entries);
>   		if (err)
> @@ -235,7 +237,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>   		if (err)
>   			goto err_db;
>   
> -		buf_addr = &cq->buf.buf;
> +		ubuf_addr = NULL;
> +		kbuf_addr = &cq->buf.buf;

Now we should maintain the values of the two pointers before any call. 
I'm not sure this is less error-prune. One can mistakenly update 
kbuf_addr for example without nullifying ubuf_addr.

Also, I'm not a big fan of passing two pointers when exactly one of them 
is effectively used.
We can think maybe of passing a union of both types, and a boolean 
indicating which pointer type is to be used.

>   
>   		uar = &dev->priv_uar;
>   		cq->mcq.usage = MLX4_RES_USAGE_DRIVER;
> @@ -248,7 +251,7 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>   			    &cq->mcq, vector, 0,
>   			    !!(cq->create_flags &
>   			       IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION),
> -			    buf_addr, !!udata);
> +			    ubuf_addr, kbuf_addr);
>   	if (err)
>   		goto err_dbmap;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
> index 020cb8e2883f..22216f4e409b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
> @@ -287,7 +287,7 @@ static void mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn)
>   		__mlx4_cq_free_icm(dev, cqn);
>   }
>   
> -static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
> +static int mlx4_init_user_cqes(void __user *buf, int entries, int cqe_size)
>   {
>   	int entries_per_copy = PAGE_SIZE / cqe_size;
>   	size_t copy_size = array_size(entries, cqe_size);
> @@ -307,7 +307,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   
>   	if (copy_size > PAGE_SIZE) {
>   		for (i = 0; i < entries / entries_per_copy; i++) {
> -			err = copy_to_user((void __user *)buf, init_ents, PAGE_SIZE) ?
> +			err = copy_to_user(buf, init_ents, PAGE_SIZE) ?
>   				-EFAULT : 0;
>   			if (err)
>   				goto out;
> @@ -315,8 +315,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>   			buf += PAGE_SIZE;
>   		}
>   	} else {
> -		err = copy_to_user((void __user *)buf, init_ents,
> -				   copy_size) ?
> +		err = copy_to_user(buf, init_ents, copy_size) ?
>   			-EFAULT : 0;
>   	}
>   
> @@ -343,7 +342,7 @@ static void mlx4_init_kernel_cqes(struct mlx4_buf *buf,
>   int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
>   		  struct mlx4_mtt *mtt, struct mlx4_uar *uar, u64 db_rec,
>   		  struct mlx4_cq *cq, unsigned vector, int collapsed,
> -		  int timestamp_en, void *buf_addr, bool user_cq)
> +		  int timestamp_en, void __user *ubuf_addr, void *kbuf_addr)
>   {
>   	bool sw_cq_init = dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SW_CQ_INIT;
>   	struct mlx4_priv *priv = mlx4_priv(dev);
> @@ -391,13 +390,13 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
>   	cq_context->db_rec_addr     = cpu_to_be64(db_rec);
>   
>   	if (sw_cq_init) {
> -		if (user_cq) {
> -			err = mlx4_init_user_cqes(buf_addr, nent,
> +		if (ubuf_addr) {
> +			err = mlx4_init_user_cqes(ubuf_addr, nent,
>   						  dev->caps.cqe_size);
>   			if (err)
>   				sw_cq_init = false;
> -		} else {
> -			mlx4_init_kernel_cqes(buf_addr, nent,
> +		} else if (kbuf_addr) {
> +			mlx4_init_kernel_cqes(kbuf_addr, nent,
>   					      dev->caps.cqe_size);
>   		}
>   	}
> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index 6646634a0b9d..dd8f3396dcba 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -1126,7 +1126,7 @@ void mlx4_free_hwq_res(struct mlx4_dev *mdev, struct mlx4_hwq_resources *wqres,
>   int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
>   		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq,
>   		  unsigned int vector, int collapsed, int timestamp_en,
> -		  void *buf_addr, bool user_cq);
> +		  void __user *ubuf_addr, void *kbuf_addr);
>   void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq);
>   int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
>   			  int *base, u8 flags, u8 usage);

