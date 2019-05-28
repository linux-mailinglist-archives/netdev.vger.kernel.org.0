Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCCC2C7FF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfE1Nmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:42:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40055 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfE1Nmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:42:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so11017969pgm.7
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 06:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4oKpkHwXcgdHoU8txPQnuEGOd2FFUjYrPMjNGt8TJms=;
        b=gSqyVwahSjhSoYCW+K3Avoau35t0M+J9A3cdl3/iGqIjDjm5b7e0+DhAZT7UPnL3u2
         S84+vmTUVIPPFuZJbbeXmdOIKiD3jkwOaQmWHuHmN3+p2IQPOwYVa9YMmq/LsRBI+bPI
         qHKYhU74T9zKvJRDsw/B5jMwHKpQWL5Fpt4C0nbOaXn1p8KEEppgydhB1h99ldwlsjs5
         TvMu2mzCVaGbGB4pQEjkZMkuNpiCcAzX/SunOlArE/XCRhbtSzDPRpNIp3c01q5XSZqj
         ywH3IC/WqzS94VQA+sxuYwHQFgl4oCIcdseqPK9iCUsVrnHGBYUpZkV73uAwYsPBHvlr
         mT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oKpkHwXcgdHoU8txPQnuEGOd2FFUjYrPMjNGt8TJms=;
        b=MVM0tDrPCxVYYSzoREXj+5EFSaHunhfcaHvZrQ5gaCdOREYy8nv6TEUvt31wIcuMXc
         RNyRrBZ62oYn+Kxhs2EmqIneP5HuIC0D/kjQNjiztTG4mMWWiLfw3Kewz+vsUSErziv+
         tiNAYTIAi4besVW+gBZ0A1hHSOPzHJGp8lUc7lu10VJh+oslHL4viFB6bFoRoyBLVgwA
         2zwTt/lqRSkHdpy0q/1JNW57EznL19nvWE4Y/jXDXdGYER931jf+rOd5J052iu1tQtna
         h0O2PeVvDjD5nnG3T7jTNSisvnMxbfLN192PR+pFIC/g28mXz/ifevbx3o00zjHEnf3Q
         /3Mg==
X-Gm-Message-State: APjAAAVEKfDniTfisbujv3dzSekaFDCnIB+vLtySPKYTe12HZZ6MVuXX
        l7jLCqwU3eFo+3c3NgtXG6c=
X-Google-Smtp-Source: APXvYqxhEmp58fMT8gXqhjCPzgZVLzaNKlIDwcrMeG3Q7bI9EXP1TXbfPkPcEuv4u6NS/qkz0lNJ+g==
X-Received: by 2002:a63:1d1d:: with SMTP id d29mr134189112pgd.63.1559050973550;
        Tue, 28 May 2019 06:42:53 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id v39sm4866596pjb.3.2019.05.28.06.42.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 06:42:52 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 1/6] bpf: Create
 BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
To:     brakmo <brakmo@fb.com>, netdev <netdev@vger.kernel.org>
Cc:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20190528034907.1957536-1-brakmo@fb.com>
 <20190528034907.1957536-2-brakmo@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <75cd4d0a-7cf8-ee63-2662-1664aedcd468@gmail.com>
Date:   Tue, 28 May 2019 06:42:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528034907.1957536-2-brakmo@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/19 8:49 PM, brakmo wrote:
> Create new macro BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY() to be used by
> __cgroup_bpf_run_filter_skb for EGRESS BPF progs so BPF programs can
> request cwr for TCP packets.
> 

...

> +#define BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(array, ctx, func)		\
> +	({						\
> +		struct bpf_prog_array_item *_item;	\
> +		struct bpf_prog *_prog;			\
> +		struct bpf_prog_array *_array;		\
> +		u32 ret;				\
> +		u32 _ret = 1;				\
> +		u32 _cn = 0;				\
> +		preempt_disable();			\
> +		rcu_read_lock();			\
> +		_array = rcu_dereference(array);	\

Why _array can not be NULL here ?

> +		_item = &_array->items[0];		\
> +		while ((_prog = READ_ONCE(_item->prog))) {		\
> +			bpf_cgroup_storage_set(_item->cgroup_storage);	\
> +			ret = func(_prog, ctx);		\
> +			_ret &= (ret & 1);		\
> +			_cn |= (ret & 2);		\
> +			_item++;			\
> +		}					\
> +		rcu_read_unlock();			\
> +		preempt_enable_no_resched();	

Why are you using preempt_enable_no_resched() here ?

	\
> +		if (_ret)				\
> +			_ret = (_cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);	\
> +		else					\
> +			_ret = (_cn ? NET_XMIT_DROP : -EPERM);		\
> +		_ret;					\
> +	})
> +
>  #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
>  	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
>  
> 
