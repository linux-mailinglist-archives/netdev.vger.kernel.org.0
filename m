Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBBF46CDD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfFNXXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:23:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40064 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNXXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:23:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so2270321pfp.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MrxBFEydxmEiNsed0LhOkDYUwxCasZZoIH+0VgjMG2g=;
        b=SE9UDesSXU05vG3IpSsbaUtSeh9qjDSbaeZjP1pzFdIXGDmnmLaw0dpPfsL+t2Vndq
         WnrEu7YEsuj6iNHA6qPhPVOSCzc4W7hOejE04OxXCSGLo8S5OEB7xWc6p5EKpxaxBS60
         D1ripAfCRXCy/QPk4bGUBQbOHSeJ5YqYACBsvfrKfTQDNd/oo1KmEAuG93HNtTCa9fbF
         U3BKEYsmoV6gd/iIQ79Kuq2bR8Q6+1qSR3AjY9pC2XfwkGotSWxXP5x8MqfewN8crEkn
         8q8sQlmPfV7mweX7FAO+iIXjKXzo2mLNvRGSsO+SMoxoa2VUiSQimN4h8K+DzRNdYO6t
         WqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MrxBFEydxmEiNsed0LhOkDYUwxCasZZoIH+0VgjMG2g=;
        b=IOC48IoopE+FKptE5XX8iZCWbT2+sAvMAhukShDg0pBle/yItW7XaU7tBwpuL9jfZ1
         ye37yqx4VSHwBFKfujx1A7MRWYVZsKT7RYUMUIKrX53OHTZnFgXHkVSMUxv8hF3zppzH
         B35zt+1rYvA6LhRvNyVy5nwgBiQix9hQQevHTmYaCPsb2N1BEIGl+k62i8RRvM4/xlNn
         snL0qW4s2Q956v20//ocuTCKIO9ZWWybrLlRa2M0ZVhPkck+xeHDCn48nzIOrKrbTsBu
         g4wIj0Ic1cicgsqvkTxN1gDbEWvjJ3zK4g0KQq9UIXzNhq/Ub6Ixf6MQ9nDfNDedHJUX
         Q2Gg==
X-Gm-Message-State: APjAAAUkbAEAi61dNyZHqNe/GRUPa0ch+ZqN8oUJbZ3uwP3rcRsnesbu
        G4IvZr7aktnZWzxUYYQ9pAgnCaEarvs=
X-Google-Smtp-Source: APXvYqwUbaTxTdLLvrVoonMVZ3bMKwnojiogriztok6OU2itvgU5cAF+KqYRHn3KXdCGcDQIyo+zdQ==
X-Received: by 2002:a62:6:: with SMTP id 6mr37301672pfa.159.1560554611050;
        Fri, 14 Jun 2019 16:23:31 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f88sm9781198pjg.5.2019.06.14.16.23.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 16:23:30 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:23:29 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: switch tests to BTF-defined
 map definitions
Message-ID: <20190614232329.GF9636@mini-arch>
References: <20190611044747.44839-1-andriin@fb.com>
 <20190611044747.44839-9-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611044747.44839-9-andriin@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10, Andrii Nakryiko wrote:
> Switch test map definition to new BTF-defined format.
Reiterating my concerns on non-RFC version:

Pretty please, let's not convert everything at once. Let's start
with stuff that explicitly depends on BTF (spinlocks?).

One good argument (aside from the one that we'd like to be able to
run tests internally without BTF for a while): libbpf doesn't
have any tests as far as I'm aware. If we don't have 'legacy' maps in the
selftests, libbpf may bit rot.

(Andrii, feel free to ignore, since we've already discussed that)

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/progs/bpf_flow.c  | 18 +++--
>  .../selftests/bpf/progs/get_cgroup_id_kern.c  | 18 +++--
>  .../testing/selftests/bpf/progs/netcnt_prog.c | 22 +++---
>  .../selftests/bpf/progs/sample_map_ret0.c     | 18 +++--
>  .../selftests/bpf/progs/socket_cookie_prog.c  |  9 ++-
>  .../bpf/progs/sockmap_verdict_prog.c          | 36 +++++++---
>  .../bpf/progs/test_get_stack_rawtp.c          | 27 ++++---
>  .../selftests/bpf/progs/test_global_data.c    | 27 ++++---
>  tools/testing/selftests/bpf/progs/test_l4lb.c | 45 ++++++++----
>  .../selftests/bpf/progs/test_l4lb_noinline.c  | 45 ++++++++----
>  .../selftests/bpf/progs/test_map_in_map.c     | 20 ++++--
>  .../selftests/bpf/progs/test_map_lock.c       | 22 +++---
>  .../testing/selftests/bpf/progs/test_obj_id.c |  9 ++-
>  .../bpf/progs/test_select_reuseport_kern.c    | 45 ++++++++----
>  .../bpf/progs/test_send_signal_kern.c         | 22 +++---
>  .../bpf/progs/test_skb_cgroup_id_kern.c       |  9 ++-
>  .../bpf/progs/test_sock_fields_kern.c         | 60 +++++++++-------
>  .../selftests/bpf/progs/test_spin_lock.c      | 33 ++++-----
>  .../bpf/progs/test_stacktrace_build_id.c      | 44 ++++++++----
>  .../selftests/bpf/progs/test_stacktrace_map.c | 40 +++++++----
>  .../testing/selftests/bpf/progs/test_tc_edt.c |  9 ++-
>  .../bpf/progs/test_tcp_check_syncookie_kern.c |  9 ++-
>  .../selftests/bpf/progs/test_tcp_estats.c     |  9 ++-
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    | 18 +++--
>  .../selftests/bpf/progs/test_tcpnotify_kern.c | 18 +++--
>  tools/testing/selftests/bpf/progs/test_xdp.c  | 18 +++--
>  .../selftests/bpf/progs/test_xdp_noinline.c   | 60 ++++++++++------
>  .../selftests/bpf/test_queue_stack_map.h      | 20 ++++--
>  .../testing/selftests/bpf/test_sockmap_kern.h | 72 +++++++++++++------
>  29 files changed, 526 insertions(+), 276 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 81ad9a0b29d0..849f42e548b5 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -57,17 +57,25 @@ struct frag_hdr {
>  	__be32 identification;
>  };
>  
> -struct bpf_map_def SEC("maps") jmp_table = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} jmp_table SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PROG_ARRAY,
> +	.max_entries = 8,
>  	.key_size = sizeof(__u32),
>  	.value_size = sizeof(__u32),
> -	.max_entries = 8
>  };
>  
> -struct bpf_map_def SEC("maps") last_dissection = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct bpf_flow_keys *value;
> +} last_dissection SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct bpf_flow_keys),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c b/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
> index 014dba10b8a5..87b202381088 100644
> --- a/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
> +++ b/tools/testing/selftests/bpf/progs/get_cgroup_id_kern.c
> @@ -4,17 +4,23 @@
>  #include <linux/bpf.h>
>  #include "bpf_helpers.h"
>  
> -struct bpf_map_def SEC("maps") cg_ids = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} cg_ids SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") pidmap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} pidmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
> index 9f741e69cebe..a25c82a5b7c8 100644
> --- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
> +++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
> @@ -10,24 +10,22 @@
>  #define REFRESH_TIME_NS	100000000
>  #define NS_PER_SEC	1000000000
>  
> -struct bpf_map_def SEC("maps") percpu_netcnt = {
> +struct {
> +	__u32 type;
> +	struct bpf_cgroup_storage_key *key;
> +	struct percpu_net_cnt *value;
> +} percpu_netcnt SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE,
> -	.key_size = sizeof(struct bpf_cgroup_storage_key),
> -	.value_size = sizeof(struct percpu_net_cnt),
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(percpu_netcnt, struct bpf_cgroup_storage_key,
> -		     struct percpu_net_cnt);
> -
> -struct bpf_map_def SEC("maps") netcnt = {
> +struct {
> +	__u32 type;
> +	struct bpf_cgroup_storage_key *key;
> +	struct net_cnt *value;
> +} netcnt SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
> -	.key_size = sizeof(struct bpf_cgroup_storage_key),
> -	.value_size = sizeof(struct net_cnt),
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(netcnt, struct bpf_cgroup_storage_key,
> -		     struct net_cnt);
> -
>  SEC("cgroup/skb")
>  int bpf_nextcnt(struct __sk_buff *skb)
>  {
> diff --git a/tools/testing/selftests/bpf/progs/sample_map_ret0.c b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
> index 0756303676ac..0f4d47cecd4d 100644
> --- a/tools/testing/selftests/bpf/progs/sample_map_ret0.c
> +++ b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
> @@ -2,17 +2,23 @@
>  #include <linux/bpf.h>
>  #include "bpf_helpers.h"
>  
> -struct bpf_map_def SEC("maps") htab = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	long *value;
> +} htab SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(long),
>  	.max_entries = 2,
>  };
>  
> -struct bpf_map_def SEC("maps") array = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	long *value;
> +} array SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(long),
>  	.max_entries = 2,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
> index 9ff8ac4b0bf6..5158bd8c342a 100644
> --- a/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
> +++ b/tools/testing/selftests/bpf/progs/socket_cookie_prog.c
> @@ -7,10 +7,13 @@
>  #include "bpf_helpers.h"
>  #include "bpf_endian.h"
>  
> -struct bpf_map_def SEC("maps") socket_cookies = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u64 *key;
> +	__u32 *value;
> +} socket_cookies SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(__u64),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 1 << 8,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
> index bdc22be46f2e..7b2146300489 100644
> --- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
> +++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
> @@ -5,31 +5,49 @@
>  
>  int _version SEC("version") = 1;
>  
> -struct bpf_map_def SEC("maps") sock_map_rx = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map_rx SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_SOCKMAP,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_map_tx = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map_tx SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_SOCKMAP,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_map_msg = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map_msg SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_SOCKMAP,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_map_break = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_map_break SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 20,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> index f6d9f238e00a..aaa6ec250e15 100644
> --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> @@ -15,17 +15,25 @@ struct stack_trace_t {
>  	struct bpf_stack_build_id user_stack_buildid[MAX_STACK_RAWTP];
>  };
>  
> -struct bpf_map_def SEC("maps") perfmap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} perfmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +	.max_entries = 2,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(__u32),
> -	.max_entries = 2,
>  };
>  
> -struct bpf_map_def SEC("maps") stackdata_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct stack_trace_t *value;
> +} stackdata_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct stack_trace_t),
>  	.max_entries = 1,
>  };
>  
> @@ -47,10 +55,13 @@ struct bpf_map_def SEC("maps") stackdata_map = {
>   * issue and avoid complicated C programming massaging.
>   * This is an acceptable workaround since there is one entry here.
>   */
> -struct bpf_map_def SEC("maps") rawdata_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 (*value)[2 * MAX_STACK_RAWTP];
> +} rawdata_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = MAX_STACK_RAWTP * sizeof(__u64) * 2,
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_global_data.c b/tools/testing/selftests/bpf/progs/test_global_data.c
> index 5ab14e941980..866cc7ddbe43 100644
> --- a/tools/testing/selftests/bpf/progs/test_global_data.c
> +++ b/tools/testing/selftests/bpf/progs/test_global_data.c
> @@ -7,17 +7,23 @@
>  
>  #include "bpf_helpers.h"
>  
> -struct bpf_map_def SEC("maps") result_number = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} result_number SEC(".maps") = {
>  	.type		= BPF_MAP_TYPE_ARRAY,
> -	.key_size	= sizeof(__u32),
> -	.value_size	= sizeof(__u64),
>  	.max_entries	= 11,
>  };
>  
> -struct bpf_map_def SEC("maps") result_string = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	const char (*value)[32];
> +} result_string SEC(".maps") = {
>  	.type		= BPF_MAP_TYPE_ARRAY,
> -	.key_size	= sizeof(__u32),
> -	.value_size	= 32,
>  	.max_entries	= 5,
>  };
>  
> @@ -27,10 +33,13 @@ struct foo {
>  	__u64 c;
>  };
>  
> -struct bpf_map_def SEC("maps") result_struct = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct foo *value;
> +} result_struct SEC(".maps") = {
>  	.type		= BPF_MAP_TYPE_ARRAY,
> -	.key_size	= sizeof(__u32),
> -	.value_size	= sizeof(struct foo),
>  	.max_entries	= 5,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_l4lb.c b/tools/testing/selftests/bpf/progs/test_l4lb.c
> index 1e10c9590991..848cbb90f581 100644
> --- a/tools/testing/selftests/bpf/progs/test_l4lb.c
> +++ b/tools/testing/selftests/bpf/progs/test_l4lb.c
> @@ -169,38 +169,53 @@ struct eth_hdr {
>  	unsigned short eth_proto;
>  };
>  
> -struct bpf_map_def SEC("maps") vip_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	struct vip *key;
> +	struct vip_meta *value;
> +} vip_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(struct vip),
> -	.value_size = sizeof(struct vip_meta),
>  	.max_entries = MAX_VIPS,
>  };
>  
> -struct bpf_map_def SEC("maps") ch_rings = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} ch_rings SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = CH_RINGS_SIZE,
>  };
>  
> -struct bpf_map_def SEC("maps") reals = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct real_definition *value;
> +} reals SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct real_definition),
>  	.max_entries = MAX_REALS,
>  };
>  
> -struct bpf_map_def SEC("maps") stats = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct vip_stats *value;
> +} stats SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct vip_stats),
>  	.max_entries = MAX_VIPS,
>  };
>  
> -struct bpf_map_def SEC("maps") ctl_array = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct ctl_value *value;
> +} ctl_array SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct ctl_value),
>  	.max_entries = CTL_MAP_SIZE,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
> index ba44a14e6dc4..c63ecf3ca573 100644
> --- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
> +++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
> @@ -165,38 +165,53 @@ struct eth_hdr {
>  	unsigned short eth_proto;
>  };
>  
> -struct bpf_map_def SEC("maps") vip_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	struct vip *key;
> +	struct vip_meta *value;
> +} vip_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(struct vip),
> -	.value_size = sizeof(struct vip_meta),
>  	.max_entries = MAX_VIPS,
>  };
>  
> -struct bpf_map_def SEC("maps") ch_rings = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} ch_rings SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = CH_RINGS_SIZE,
>  };
>  
> -struct bpf_map_def SEC("maps") reals = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct real_definition *value;
> +} reals SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct real_definition),
>  	.max_entries = MAX_REALS,
>  };
>  
> -struct bpf_map_def SEC("maps") stats = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct vip_stats *value;
> +} stats SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct vip_stats),
>  	.max_entries = MAX_VIPS,
>  };
>  
> -struct bpf_map_def SEC("maps") ctl_array = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct ctl_value *value;
> +} ctl_array SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct ctl_value),
>  	.max_entries = CTL_MAP_SIZE,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_map_in_map.c b/tools/testing/selftests/bpf/progs/test_map_in_map.c
> index 2985f262846e..7404bee7c26e 100644
> --- a/tools/testing/selftests/bpf/progs/test_map_in_map.c
> +++ b/tools/testing/selftests/bpf/progs/test_map_in_map.c
> @@ -5,22 +5,30 @@
>  #include <linux/types.h>
>  #include "bpf_helpers.h"
>  
> -struct bpf_map_def SEC("maps") mim_array = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} mim_array SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
> +	.max_entries = 1,
>  	.key_size = sizeof(int),
>  	/* must be sizeof(__u32) for map in map */
>  	.value_size = sizeof(__u32),
> -	.max_entries = 1,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def SEC("maps") mim_hash = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} mim_hash SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
> +	.max_entries = 1,
>  	.key_size = sizeof(int),
>  	/* must be sizeof(__u32) for map in map */
>  	.value_size = sizeof(__u32),
> -	.max_entries = 1,
> -	.map_flags = 0,
>  };
>  
>  SEC("xdp_mimtest")
> diff --git a/tools/testing/selftests/bpf/progs/test_map_lock.c b/tools/testing/selftests/bpf/progs/test_map_lock.c
> index af8cc68ed2f9..40d9c2853393 100644
> --- a/tools/testing/selftests/bpf/progs/test_map_lock.c
> +++ b/tools/testing/selftests/bpf/progs/test_map_lock.c
> @@ -11,29 +11,31 @@ struct hmap_elem {
>  	int var[VAR_NUM];
>  };
>  
> -struct bpf_map_def SEC("maps") hash_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct hmap_elem *value;
> +} hash_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct hmap_elem),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(hash_map, int, struct hmap_elem);
> -
>  struct array_elem {
>  	struct bpf_spin_lock lock;
>  	int var[VAR_NUM];
>  };
>  
> -struct bpf_map_def SEC("maps") array_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	struct array_elem *value;
> +} array_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct array_elem),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(array_map, int, struct array_elem);
> -
>  SEC("map_lock_demo")
>  int bpf_map_lock_test(struct __sk_buff *skb)
>  {
> diff --git a/tools/testing/selftests/bpf/progs/test_obj_id.c b/tools/testing/selftests/bpf/progs/test_obj_id.c
> index 880d2963b472..2b1c2efdeed4 100644
> --- a/tools/testing/selftests/bpf/progs/test_obj_id.c
> +++ b/tools/testing/selftests/bpf/progs/test_obj_id.c
> @@ -16,10 +16,13 @@
>  
>  int _version SEC("version") = 1;
>  
> -struct bpf_map_def SEC("maps") test_map_id = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} test_map_id SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> index 5b54ec637ada..435a9527733e 100644
> --- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> @@ -21,38 +21,55 @@ int _version SEC("version") = 1;
>  #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
>  #endif
>  
> -struct bpf_map_def SEC("maps") outer_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} outer_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
> +	.max_entries = 1,
>  	.key_size = sizeof(__u32),
>  	.value_size = sizeof(__u32),
> -	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") result_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} result_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = NR_RESULTS,
>  };
>  
> -struct bpf_map_def SEC("maps") tmp_index_ovr_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	int *value;
> +} tmp_index_ovr_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(int),
>  	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") linum_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} linum_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") data_check_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct data_check *value;
> +} data_check_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct data_check),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> index 45a1a1a2c345..6ac68be5d68b 100644
> --- a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> @@ -4,24 +4,26 @@
>  #include <linux/version.h>
>  #include "bpf_helpers.h"
>  
> -struct bpf_map_def SEC("maps") info_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} info_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
> -
> -struct bpf_map_def SEC("maps") status_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} status_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
> -
>  SEC("send_signal_demo")
>  int bpf_send_signal_test(void *ctx)
>  {
> diff --git a/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c b/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
> index 68cf9829f5a7..af296b876156 100644
> --- a/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_skb_cgroup_id_kern.c
> @@ -10,10 +10,13 @@
>  
>  #define NUM_CGROUP_LEVELS	4
>  
> -struct bpf_map_def SEC("maps") cgroup_ids = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} cgroup_ids SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = NUM_CGROUP_LEVELS,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
> index 1c39e4ccb7f1..c3d383d650cb 100644
> --- a/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_sock_fields_kern.c
> @@ -27,31 +27,43 @@ enum bpf_linum_array_idx {
>  	__NR_BPF_LINUM_ARRAY_IDX,
>  };
>  
> -struct bpf_map_def SEC("maps") addr_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct sockaddr_in6 *value;
> +} addr_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct sockaddr_in6),
>  	.max_entries = __NR_BPF_ADDR_ARRAY_IDX,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_result_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct bpf_sock *value;
> +} sock_result_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct bpf_sock),
>  	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
>  };
>  
> -struct bpf_map_def SEC("maps") tcp_sock_result_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct bpf_tcp_sock *value;
> +} tcp_sock_result_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct bpf_tcp_sock),
>  	.max_entries = __NR_BPF_RESULT_ARRAY_IDX,
>  };
>  
> -struct bpf_map_def SEC("maps") linum_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} linum_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = __NR_BPF_LINUM_ARRAY_IDX,
>  };
>  
> @@ -60,26 +72,26 @@ struct bpf_spinlock_cnt {
>  	__u32 cnt;
>  };
>  
> -struct bpf_map_def SEC("maps") sk_pkt_out_cnt = {
> +struct {
> +	__u32 type;
> +	__u32 map_flags;
> +	int *key;
> +	struct bpf_spinlock_cnt *value;
> +} sk_pkt_out_cnt SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_SK_STORAGE,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct bpf_spinlock_cnt),
> -	.max_entries = 0,
>  	.map_flags = BPF_F_NO_PREALLOC,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(sk_pkt_out_cnt, int, struct bpf_spinlock_cnt);
> -
> -struct bpf_map_def SEC("maps") sk_pkt_out_cnt10 = {
> +struct {
> +	__u32 type;
> +	__u32 map_flags;
> +	int *key;
> +	struct bpf_spinlock_cnt *value;
> +} sk_pkt_out_cnt10 SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_SK_STORAGE,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct bpf_spinlock_cnt),
> -	.max_entries = 0,
>  	.map_flags = BPF_F_NO_PREALLOC,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(sk_pkt_out_cnt10, int, struct bpf_spinlock_cnt);
> -
>  static bool is_loopback6(__u32 *a6)
>  {
>  	return !a6[0] && !a6[1] && !a6[2] && a6[3] == bpf_htonl(1);
> diff --git a/tools/testing/selftests/bpf/progs/test_spin_lock.c b/tools/testing/selftests/bpf/progs/test_spin_lock.c
> index 40f904312090..0a77ae36d981 100644
> --- a/tools/testing/selftests/bpf/progs/test_spin_lock.c
> +++ b/tools/testing/selftests/bpf/progs/test_spin_lock.c
> @@ -10,30 +10,29 @@ struct hmap_elem {
>  	int test_padding;
>  };
>  
> -struct bpf_map_def SEC("maps") hmap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	struct hmap_elem *value;
> +} hmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct hmap_elem),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(hmap, int, struct hmap_elem);
> -
> -
>  struct cls_elem {
>  	struct bpf_spin_lock lock;
>  	volatile int cnt;
>  };
>  
> -struct bpf_map_def SEC("maps") cls_map = {
> +struct {
> +	__u32 type;
> +	struct bpf_cgroup_storage_key *key;
> +	struct cls_elem *value;
> +} cls_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_CGROUP_STORAGE,
> -	.key_size = sizeof(struct bpf_cgroup_storage_key),
> -	.value_size = sizeof(struct cls_elem),
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(cls_map, struct bpf_cgroup_storage_key,
> -		     struct cls_elem);
> -
>  struct bpf_vqueue {
>  	struct bpf_spin_lock lock;
>  	/* 4 byte hole */
> @@ -42,14 +41,16 @@ struct bpf_vqueue {
>  	unsigned int rate;
>  };
>  
> -struct bpf_map_def SEC("maps") vqueue = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	struct bpf_vqueue *value;
> +} vqueue SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(struct bpf_vqueue),
>  	.max_entries = 1,
>  };
>  
> -BPF_ANNOTATE_KV_PAIR(vqueue, int, struct bpf_vqueue);
>  #define CREDIT_PER_NS(delta, rate) (((delta) * rate) >> 20)
>  
>  SEC("spin_lock_demo")
> diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> index d86c281e957f..fcf2280bb60c 100644
> --- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
> @@ -8,34 +8,50 @@
>  #define PERF_MAX_STACK_DEPTH         127
>  #endif
>  
> -struct bpf_map_def SEC("maps") control_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} control_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") stackid_hmap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} stackid_hmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 16384,
>  };
>  
> -struct bpf_map_def SEC("maps") stackmap = {
> +typedef struct bpf_stack_build_id stack_trace_t[PERF_MAX_STACK_DEPTH];
> +
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 map_flags;
> +	__u32 key_size;
> +	__u32 value_size;
> +} stackmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_STACK_TRACE,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct bpf_stack_build_id)
> -		* PERF_MAX_STACK_DEPTH,
>  	.max_entries = 128,
>  	.map_flags = BPF_F_STACK_BUILD_ID,
> +	.key_size = sizeof(__u32),
> +	.value_size = sizeof(stack_trace_t),
>  };
>  
> -struct bpf_map_def SEC("maps") stack_amap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	/* there seems to be a bug in kernel not handling typedef properly */
> +	struct bpf_stack_build_id (*value)[PERF_MAX_STACK_DEPTH];
> +} stack_amap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct bpf_stack_build_id)
> -		* PERF_MAX_STACK_DEPTH,
>  	.max_entries = 128,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> index af111af7ca1a..7ad09adbf648 100644
> --- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> @@ -8,31 +8,47 @@
>  #define PERF_MAX_STACK_DEPTH         127
>  #endif
>  
> -struct bpf_map_def SEC("maps") control_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} control_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 1,
>  };
>  
> -struct bpf_map_def SEC("maps") stackid_hmap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} stackid_hmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 16384,
>  };
>  
> -struct bpf_map_def SEC("maps") stackmap = {
> +typedef __u64 stack_trace_t[PERF_MAX_STACK_DEPTH];
> +
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} stackmap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_STACK_TRACE,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64) * PERF_MAX_STACK_DEPTH,
>  	.max_entries = 16384,
> +	.key_size = sizeof(__u32),
> +	.value_size = sizeof(stack_trace_t),
>  };
>  
> -struct bpf_map_def SEC("maps") stack_amap = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 (*value)[PERF_MAX_STACK_DEPTH];
> +} stack_amap SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64) * PERF_MAX_STACK_DEPTH,
>  	.max_entries = 16384,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_edt.c b/tools/testing/selftests/bpf/progs/test_tc_edt.c
> index 3af64c470d64..c2781dd78617 100644
> --- a/tools/testing/selftests/bpf/progs/test_tc_edt.c
> +++ b/tools/testing/selftests/bpf/progs/test_tc_edt.c
> @@ -16,10 +16,13 @@
>  #define THROTTLE_RATE_BPS (5 * 1000 * 1000)
>  
>  /* flow_key => last_tstamp timestamp used */
> -struct bpf_map_def SEC("maps") flow_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	uint32_t *key;
> +	uint64_t *value;
> +} flow_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(uint32_t),
> -	.value_size = sizeof(uint64_t),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
> index 1ab095bcacd8..0f1725e25c44 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
> @@ -16,10 +16,13 @@
>  #include "bpf_helpers.h"
>  #include "bpf_endian.h"
>  
> -struct bpf_map_def SEC("maps") results = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} results SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 1,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_tcp_estats.c b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
> index bee3bbecc0c4..df98f7e32832 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcp_estats.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcp_estats.c
> @@ -148,10 +148,13 @@ struct tcp_estats_basic_event {
>  	struct tcp_estats_conn_id conn_id;
>  };
>  
> -struct bpf_map_def SEC("maps") ev_record_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct tcp_estats_basic_event *value;
> +} ev_record_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct tcp_estats_basic_event),
>  	.max_entries = 1024,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> index c7c3240e0dd4..38e10c9fd996 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> @@ -14,17 +14,23 @@
>  #include "bpf_endian.h"
>  #include "test_tcpbpf.h"
>  
> -struct bpf_map_def SEC("maps") global_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct tcpbpf_globals *value;
> +} global_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct tcpbpf_globals),
>  	.max_entries = 4,
>  };
>  
> -struct bpf_map_def SEC("maps") sockopt_results = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	int *value;
> +} sockopt_results SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(int),
>  	.max_entries = 2,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
> index ec6db6e64c41..d073d37d4e27 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcpnotify_kern.c
> @@ -14,18 +14,26 @@
>  #include "bpf_endian.h"
>  #include "test_tcpnotify.h"
>  
> -struct bpf_map_def SEC("maps") global_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct tcpnotify_globals *value;
> +} global_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct tcpnotify_globals),
>  	.max_entries = 4,
>  };
>  
> -struct bpf_map_def SEC("maps") perf_event_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} perf_event_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +	.max_entries = 2,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(__u32),
> -	.max_entries = 2,
>  };
>  
>  int _version SEC("version") = 1;
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp.c b/tools/testing/selftests/bpf/progs/test_xdp.c
> index 5e7df8bb5b5d..ec3d2c1c8cf9 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp.c
> @@ -22,17 +22,23 @@
>  
>  int _version SEC("version") = 1;
>  
> -struct bpf_map_def SEC("maps") rxcnt = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u64 *value;
> +} rxcnt SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u64),
>  	.max_entries = 256,
>  };
>  
> -struct bpf_map_def SEC("maps") vip2tnl = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	struct vip *key;
> +	struct iptnl_info *value;
> +} vip2tnl SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(struct vip),
> -	.value_size = sizeof(struct iptnl_info),
>  	.max_entries = MAX_IPTNL_ENTRIES,
>  };
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> index 4fe6aaad22a4..d2eddb5553d1 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> @@ -163,52 +163,66 @@ struct lb_stats {
>  	__u64 v1;
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) vip_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	struct vip_definition *key;
> +	struct vip_meta *value;
> +} vip_map SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_HASH,
> -	.key_size = sizeof(struct vip_definition),
> -	.value_size = sizeof(struct vip_meta),
>  	.max_entries = 512,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) lru_cache = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 map_flags;
> +	struct flow_key *key;
> +	struct real_pos_lru *value;
> +} lru_cache SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_LRU_HASH,
> -	.key_size = sizeof(struct flow_key),
> -	.value_size = sizeof(struct real_pos_lru),
>  	.max_entries = 300,
>  	.map_flags = 1U << 1,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) ch_rings = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	__u32 *value;
> +} ch_rings SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(__u32),
>  	.max_entries = 12 * 655,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) reals = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct real_definition *value;
> +} reals SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct real_definition),
>  	.max_entries = 40,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) stats = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct lb_stats *value;
> +} stats SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct lb_stats),
>  	.max_entries = 515,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) ctl_array = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 *key;
> +	struct ctl_value *value;
> +} ctl_array SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(__u32),
> -	.value_size = sizeof(struct ctl_value),
>  	.max_entries = 16,
> -	.map_flags = 0,
>  };
>  
>  struct eth_hdr {
> diff --git a/tools/testing/selftests/bpf/test_queue_stack_map.h b/tools/testing/selftests/bpf/test_queue_stack_map.h
> index 295b9b3bc5c7..f284137a36c4 100644
> --- a/tools/testing/selftests/bpf/test_queue_stack_map.h
> +++ b/tools/testing/selftests/bpf/test_queue_stack_map.h
> @@ -10,20 +10,28 @@
>  
>  int _version SEC("version") = 1;
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) map_in = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} map_in SEC(".maps") = {
>  	.type = MAP_TYPE,
> +	.max_entries = 32,
>  	.key_size = 0,
>  	.value_size = sizeof(__u32),
> -	.max_entries = 32,
> -	.map_flags = 0,
>  };
>  
> -struct bpf_map_def __attribute__ ((section("maps"), used)) map_out = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} map_out SEC(".maps") = {
>  	.type = MAP_TYPE,
> +	.max_entries = 32,
>  	.key_size = 0,
>  	.value_size = sizeof(__u32),
> -	.max_entries = 32,
> -	.map_flags = 0,
>  };
>  
>  SEC("test")
> diff --git a/tools/testing/selftests/bpf/test_sockmap_kern.h b/tools/testing/selftests/bpf/test_sockmap_kern.h
> index 4e7d3da21357..70b9236cedb0 100644
> --- a/tools/testing/selftests/bpf/test_sockmap_kern.h
> +++ b/tools/testing/selftests/bpf/test_sockmap_kern.h
> @@ -28,59 +28,89 @@
>   * are established and verdicts are decided.
>   */
>  
> -struct bpf_map_def SEC("maps") sock_map = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map SEC(".maps") = {
>  	.type = TEST_MAP_TYPE,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_map_txmsg = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map_txmsg SEC(".maps") = {
>  	.type = TEST_MAP_TYPE,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_map_redir = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	__u32 key_size;
> +	__u32 value_size;
> +} sock_map_redir SEC(".maps") = {
>  	.type = TEST_MAP_TYPE,
> +	.max_entries = 20,
>  	.key_size = sizeof(int),
>  	.value_size = sizeof(int),
> -	.max_entries = 20,
>  };
>  
> -struct bpf_map_def SEC("maps") sock_apply_bytes = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_apply_bytes SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 1
>  };
>  
> -struct bpf_map_def SEC("maps") sock_cork_bytes = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_cork_bytes SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 1
>  };
>  
> -struct bpf_map_def SEC("maps") sock_bytes = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_bytes SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 6
>  };
>  
> -struct bpf_map_def SEC("maps") sock_redir_flags = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_redir_flags SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 1
>  };
>  
> -struct bpf_map_def SEC("maps") sock_skb_opts = {
> +struct {
> +	__u32 type;
> +	__u32 max_entries;
> +	int *key;
> +	int *value;
> +} sock_skb_opts SEC(".maps") = {
>  	.type = BPF_MAP_TYPE_ARRAY,
> -	.key_size = sizeof(int),
> -	.value_size = sizeof(int),
>  	.max_entries = 1
>  };
>  
> -- 
> 2.17.1
> 
