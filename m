Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8030946D00
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFNXpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:45:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44375 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNXpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:45:10 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so2359407pgp.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qAPQX1PoQDph8jKavq3m/dLChG0ZwdxBZ7PACqvU/Go=;
        b=BFVm67hrVReyZHNE/pvvmGxBq7mTrhzRSt22NU0A4UwcSHxBCsH6M6ATnMnHVbESSj
         OyAjUA1QxSBbhCM+qEBwWIXp+W5xCBUqK6fbf24lauXypeAGCCQ6KdaQA3u5lW1vW3tA
         JPAMKtSHR1sgc8XXJ3zy+fCOUSDlDzJnqVM04XmiQKzktlrNsAp5QdCZez1QaWWgULUk
         YRq7EEUV5FdC70vnr+w9uoUNwhcfpbnDCHkpAaI1CEfCzPNgC0G/FjUhz5vwAPOssJSW
         oQ9rJlUMBpP0NS6a/eQqqstwm5JG/m/GiqCcPn58UohDlI+u0QiIhJlqg6B4lErCTluc
         qK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qAPQX1PoQDph8jKavq3m/dLChG0ZwdxBZ7PACqvU/Go=;
        b=S5Bf2wXrxFtb61WQXDMDDeGiSxuLEFT7SnnSDQg4BQsuAaxoXhwvDyiRcgBjn70UxG
         n+3DuR1CmxC4cJIyKmV60O5SlRh+ssPrrEOtR7M/qOWbX/THXS+18oL1PaM3gmNIRokf
         Y23SMiIrVfj7SyTjC0iYZAs4PfW/dkwvTpbHDftfXBDckWXNQxG+gOkGvApjZ1gGMoyO
         lv3beZfMC0HJ2UiLIgev5lvv7t5HnIQ4x3OoIU60rMOmMdi6u7zw5/zL/GsH0QgvkW93
         B+Fa9eGT6JNnM/n47VS0ARoCwtbTXhXcQ9x188Y9SiAaJiR6cuHQI7Sa1sMW/ZbQSTO+
         32zw==
X-Gm-Message-State: APjAAAU0H3+Sfll0QqMecTztHxDWvVQJa6hutM33L3dJNjCDQlnaSAoW
        tffTkrx3UsAhOyhyOfh3qFM=
X-Google-Smtp-Source: APXvYqzzaBgYjBNBwT2/DI5vGgGnb1g3bcIWNaQwIqVDRJdO0TxV1dArdv8GtJLZJUiOBI/Ks1Nrtw==
X-Received: by 2002:a17:90a:3585:: with SMTP id r5mr11655090pjb.15.1560555909593;
        Fri, 14 Jun 2019 16:45:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:6345])
        by smtp.gmail.com with ESMTPSA id t18sm5321475pgm.69.2019.06.14.16.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 16:45:08 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:45:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net 1/4] sysctl: define proc_do_static_key()
Message-ID: <20190614234506.n3kuojutoaqxhyox@ast-mbp.dhcp.thefacebook.com>
References: <20190614232221.248392-1-edumazet@google.com>
 <20190614232221.248392-2-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614232221.248392-2-edumazet@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:22:18PM -0700, Eric Dumazet wrote:
> Convert proc_dointvec_minmax_bpf_stats() into a more generic
> helper, since we are going to use jump labels more often.
> 
> Note that sysctl_bpf_stats_enabled is removed, since
> it is no longer needed/used.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/bpf.h    |  1 -
>  include/linux/sysctl.h |  3 +++
>  kernel/bpf/core.c      |  1 -
>  kernel/sysctl.c        | 44 ++++++++++++++++++++++--------------------
>  4 files changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5df8e9e2a3933949af17dda1d77a4daccd5df611..b92ef9f73e42f1bcf0141aa21d0e9c17c5c7f05b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -600,7 +600,6 @@ void bpf_map_area_free(void *base);
>  void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
>  
>  extern int sysctl_unprivileged_bpf_disabled;
> -extern int sysctl_bpf_stats_enabled;
>  
>  int bpf_map_new_fd(struct bpf_map *map, int flags);
>  int bpf_prog_new_fd(struct bpf_prog *prog);
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index b769ecfcc3bd41aad6fd339ba824c6bb622ac24d..aadd310769d080f1d45db14b2a72fc8ad36f1196 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -63,6 +63,9 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
>  				      void __user *, size_t *, loff_t *);
>  extern int proc_do_large_bitmap(struct ctl_table *, int,
>  				void __user *, size_t *, loff_t *);
> +extern int proc_do_static_key(struct ctl_table *table, int write,
> +			      void __user *buffer, size_t *lenp,
> +			      loff_t *ppos);
>  
>  /*
>   * Register a set of sysctl names by calling register_sysctl_table
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 7c473f208a1058de97434a57a2d47e2360ae80a8..080e2bb644ccd761b3d54fbad9b58a881086231e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2097,7 +2097,6 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
>  
>  DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>  EXPORT_SYMBOL(bpf_stats_enabled_key);
> -int sysctl_bpf_stats_enabled __read_mostly;
>  
>  /* All definitions of tracepoints related to BPF. */
>  #define CREATE_TRACE_POINTS
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 7d1008be6173313c807b2abb23f3171ef05cddc8..1beca96fb6252ddc4af07b6292f9dd95c4f53afd 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -230,11 +230,6 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
>  #endif
>  static int proc_dopipe_max_size(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp, loff_t *ppos);
> -#ifdef CONFIG_BPF_SYSCALL
> -static int proc_dointvec_minmax_bpf_stats(struct ctl_table *table, int write,
> -					  void __user *buffer, size_t *lenp,
> -					  loff_t *ppos);
> -#endif
>  
>  #ifdef CONFIG_MAGIC_SYSRQ
>  /* Note: sysrq code uses its own private copy */
> @@ -1253,12 +1248,10 @@ static struct ctl_table kern_table[] = {
>  	},
>  	{
>  		.procname	= "bpf_stats_enabled",
> -		.data		= &sysctl_bpf_stats_enabled,
> -		.maxlen		= sizeof(sysctl_bpf_stats_enabled),
> +		.data		= &bpf_stats_enabled_key.key,
> +		.maxlen		= sizeof(bpf_stats_enabled_key),

maxlen is ignored by proc_do_static_key(), right?

Great idea, btw. I like the series.

