Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA07B134A87
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgAHShb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:37:31 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44073 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgAHSha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:37:30 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so4247529iof.11
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 10:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hk1Kq6Dpojomo9iAYHQJvWF5j1qQEv1wXmovGYH98vA=;
        b=n0QuYAFn9iDVlvnB3kN/zuJf29g0REEci/dBdS81ddEfWS9DCKoj1vvUSr1uGAWpS+
         2DRtViZ0YQI4gMteFMfpvmW1kAc4oORjZZdLOtAj5p7ILAipDnahM3Xi2gb59hcMOcZ+
         3T/syq5SAM28JgAkSHkcFU0+REEASrpfo2HFcuSXkr8t3ID2XqV7CuMtggO1ZuwPay+R
         gsx7L2SlAzSiVoE3nLpyIdAOqNbirpPo5wP3b5y6AHmhEdYe4k1Sth8gKIeghEQi4aWM
         7ZVHT8Z5/ocOFstbCAZbqKZYst8MpFykp7ljDK51zEac28CcEP0BzvnufmOI7fNjrm73
         Qdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hk1Kq6Dpojomo9iAYHQJvWF5j1qQEv1wXmovGYH98vA=;
        b=JsDWefgmii9xvGDUiv5pT6NmxkRQL/dhtldq6MiKpQBSZPD11J4D9EzPK3HmdAB0hZ
         UGDPLaRzPmJAwHzCz6C51XU1VzNqApe3ArTJG4wee1xk7YW4quG/xuxsSV+pZu9YyCWW
         dwmAc8Vq3c5YMYJoECFFulG+ZMz+IIa94s9j5MVGc2Yt0sseZf/sYopPLEquAcnFhB6Z
         NQm2d5hTzx4n35HjZ2/6QyeZt3jinDua0aY3oZfq7c0NTdyvobKveUt5k7j6VEo9WJfe
         Rkl5/tWQrG09ZgJmuItV+h2ArD3soxAaAfygdBDUBlQRoQSFG7DAI3FdZgcfa/iy0NC1
         z+Yw==
X-Gm-Message-State: APjAAAUftUH9GsDB0is9fsuXxBV/tc+lNs9d2ppVF/pZGwK8AUJenJgN
        CIjGcOZPQHT+B9LFzNe18DM=
X-Google-Smtp-Source: APXvYqw+ZK3je0gUQox1Lbd5NtLpY3MMmQRH7SWTT16io/ajdvDNzTFGVyVC3TY5vWTmKcXX2CAung==
X-Received: by 2002:a6b:8b01:: with SMTP id n1mr4441010iod.111.1578508650035;
        Wed, 08 Jan 2020 10:37:30 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:601d:4dc7:bf1b:dae9? ([2601:282:800:7a:601d:4dc7:bf1b:dae9])
        by smtp.googlemail.com with ESMTPSA id a9sm1191058ilk.14.2020.01.08.10.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 10:37:29 -0800 (PST)
Subject: Re: [PATCH net-next 02/10] ipv4: Encapsulate function arguments in a
 struct
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20200107154517.239665-1-idosch@idosch.org>
 <20200107154517.239665-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c35c97d7-d1dc-d0d6-6ea8-deaf33441c7c@gmail.com>
Date:   Wed, 8 Jan 2020 11:37:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107154517.239665-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 8:45 AM, Ido Schimmel wrote:
> diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
> index a68b5e21ec51..b34594a9965f 100644
> --- a/net/ipv4/fib_lookup.h
> +++ b/net/ipv4/fib_lookup.h
> @@ -21,6 +21,15 @@ struct fib_alias {
>  
>  #define FA_S_ACCESSED	0x01
>  
> +struct fib_rt_info {
> +	struct fib_info		*fi;
> +	u32			tb_id;
> +	__be32			dst;
> +	int			dst_len;
> +	u8			tos;
> +	u8			type;
> +};
> +
>  /* Dont write on fa_state unless needed, to keep it shared on all cpus */
>  static inline void fib_alias_accessed(struct fib_alias *fa)
>  {
> @@ -35,9 +44,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>  int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
>  		 struct netlink_ext_ack *extack);
>  bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
> -int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event, u32 tb_id,
> -		  u8 type, __be32 dst, int dst_len, u8 tos, struct fib_info *fi,
> -		  unsigned int);
> +int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
> +		  struct fib_rt_info *fri, unsigned int);

since you are modifying this, can you add a name for that last argument?


Otherwise, nice cleanup.

Reviewed-by: David Ahern <dsahern@gmail.com>
