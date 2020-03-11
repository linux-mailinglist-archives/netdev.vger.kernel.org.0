Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC8180D5E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCKBPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:15:18 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38600 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKBPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:15:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so243896pgh.5;
        Tue, 10 Mar 2020 18:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A15QzXUJHdqLavarexM8lDiWIzTL32zBjxHi4bfoIu8=;
        b=HHPHEWnasrSuhZ8msIcJIPDRSICT44TWWhYK8cJGNTRWWBf94u/wtX38qcyBqutfS5
         WOdog+lPUs1WJDgz0SmMdX3AQEH4RLcwgw/NUq01wuxZ4TOrP49hHqeL9cPp4/958eKP
         i4whc2JJiXiUve3HK2luPZqgs4l7tuuvXYljmQaB60rrBaRgp8o6MkaB44mQUzCZXPLa
         JXJFtd7FLhSnBjqqfaRtp2KKO/LW8NwHr3me7RDfa9fw71KE90sNXE93P22GiMTq03Re
         9FHDvboOofWP8NCTVJ+1ypUcfyNpO33eLQwz7GVtHNBhhFo7ytBibyoG6XppN6z4Atsc
         IJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A15QzXUJHdqLavarexM8lDiWIzTL32zBjxHi4bfoIu8=;
        b=eCl7aAi4TRsTIeMIIbeGbUe0scYWYN/IamT/QyeTSqF4pq2hD2XvMZvctDPNjTj5b4
         muYYu5vZ2nZFXyWadclD/J1gGd4bl9o65EWtyZwFqob5SWLZDSEBDNZjv4Mu8XdCvzUI
         /gblZMLnrbULdyslxt5n3GBHKYnAhSK4kVdTEehfGshBhThNMEsM/t575cD/S7cJ0+NQ
         1+GJ2khSjyH+WOv0Ki/DA9XI0mSfuniQ2oOz9BvL+4jngYaoYcMX2VsewRw3NL3Lwwxl
         9V+HRdOonx92uf05UTAZo50wDRHPEjSEorLkV5P5sOm5OZGNtX36kGmWEyZ4scJgL0ym
         YHTA==
X-Gm-Message-State: ANhLgQ1xPXzwoYKFo+WiO4qalfACYQh81dTv4CdbeR5Y/UHfmOsV7mA8
        UPc8QfgJS8cemfRz7EKRtAs=
X-Google-Smtp-Source: ADFU+vvTiR+oyqn7Ggieg9DuI8wHNgO3nLYJEnq5YcGX1uIe8op9GCGagh/UxDFE4jYVmUoXH/8ozQ==
X-Received: by 2002:aa7:87ca:: with SMTP id i10mr315625pfo.169.1583889315740;
        Tue, 10 Mar 2020 18:15:15 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k24sm46896103pgf.59.2020.03.10.18.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 18:15:14 -0700 (PDT)
Subject: Re: [PATCH 2/8] raw: Add missing annotations to raw_seq_start() and
 raw_seq_stop()
To:     Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <0/8> <20200311010908.42366-1-jbi.octave@gmail.com>
 <20200311010908.42366-3-jbi.octave@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <af9016d1-c224-ea61-3290-330ed0fe8d60@gmail.com>
Date:   Tue, 10 Mar 2020 18:15:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311010908.42366-3-jbi.octave@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 6:09 PM, Jules Irenge wrote:
> Sparse reports warnings at raw_seq_start() and raw_seq_stop()
> 
> warning: context imbalance in raw_seq_start() - wrong count at exit
> warning: context imbalance in raw_seq_stop() - unexpected unlock
> 
> The root cause is the missing annotations at raw_seq_start()
> 	and raw_seq_stop()
> Add the missing __acquires(&h->lock) annotation
> Add the missing __releases(&h->lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  net/ipv4/raw.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 3183413ebc6c..47665919048f 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -1034,6 +1034,7 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
>  }
>  
>  void *raw_seq_start(struct seq_file *seq, loff_t *pos)
> +	__acquires(&h->lock)

I dunno, h variable is not yet defined/declared at this point,
this looks weird.

>  {
>  	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
>  
> @@ -1056,6 +1057,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  EXPORT_SYMBOL_GPL(raw_seq_next);
>  
>  void raw_seq_stop(struct seq_file *seq, void *v)
> +	__releases(&h->lock)
>  {
>  	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
>  
> 
