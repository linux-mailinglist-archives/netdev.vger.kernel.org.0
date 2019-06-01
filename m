Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF32320D9
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 00:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfFAWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 18:05:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41454 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFAWFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 18:05:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id s24so5295143plr.8;
        Sat, 01 Jun 2019 15:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/4V2UooyuT/xkSgDxYFCbZIPQVYE9qANQONtUStbi0I=;
        b=aEiIIh6j5gaLu/uiZsVxflyGB2psU3ACsQYja8COPyf/sGEsPia+zJxZNoD5tRkohA
         g9RV5ceEJlQFAzKNPGKe9mXBRs4ZWaHZ/ykZOXdmK/wsC4X/pZk5ph1ByGBeC2VzyNRZ
         O8yGDJHbGv6Vy23coroNP8rSiSlp0M9GBuLhOT6/rN6tqdYEKPQg9TLYjxNZ/5VUaPf6
         5Qk97JOBOmNB8B9TzI1J8UsEzsUGf99HKRtbZ34XYB/ZzAlpWiIpjFEpBpm+MFutG6om
         hebDvdHhAY/Ih8rd03POUsAeMllDh1EtKmFFh5UEMr8tP7v6OsTOY0nl5hoqMf5lb7mR
         COPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/4V2UooyuT/xkSgDxYFCbZIPQVYE9qANQONtUStbi0I=;
        b=mxn9fpVu4v6PczwtaajB8ugK0YYiScBmc0eencKcMuO9QJSBiBMOLH+WURh6vC4Uck
         mTRX/PK1HPnw4GO/Ib3aBVmPn+L4bBto1QDrznYeUbvOg7wwVqpnBqsVcpYSZdmdHZKo
         YpsqWG7soa3u4+IPe9/ZmLI+csTVT6juLJluVeUi7RHvM7nQVmQ9/vzNv0swGdLz7r02
         JnPZLL+fi4VhikyyxFwxWl7X2uCeaJJvewhnrQll+Y5CfRdfeq3zDT8X+eNAjjSYhAZ3
         4yMSojDbMAB0UtJ1Xu52/8GKvaX0/a+Gd2h+RvLCKt8+SJhinTnzAz7T2zqoQ++E0b3z
         hhZA==
X-Gm-Message-State: APjAAAUyRHW/OPKobDes4z7ojt21HgEcptUcr7YK0bFcHxH91KcqOeF2
        L8Il7eHIj61XRf3hi7pEEZM=
X-Google-Smtp-Source: APXvYqwphbTFBcDNn046SvWLFg37yH4vLdMAbWqhRuMWdSG0CO0So6w07nR8xMOHP9MX59I3A8TMoA==
X-Received: by 2002:a17:902:9f8b:: with SMTP id g11mr19481783plq.199.1559426707771;
        Sat, 01 Jun 2019 15:05:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::92b7])
        by smtp.gmail.com with ESMTPSA id p7sm10562075pgb.92.2019.06.01.15.05.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 15:05:07 -0700 (PDT)
Date:   Sat, 1 Jun 2019 15:05:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: add real-world BPF verifier
 scale test program
Message-ID: <20190601220503.7dabs472ixfbtjsf@ast-mbp.dhcp.thefacebook.com>
References: <20190601063952.2176919-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601063952.2176919-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:39:52PM -0700, Andrii Nakryiko wrote:
> This patch adds a new test program, based on real-world production
> application, for testing BPF verifier scalability w/ realistic
> complexity.

Thanks!

> -	const char *pyperf[] = {
> +	const char *tp_progs[] = {

I had very similar change in my repo :)

> +struct strobemeta_payload {
> +	/* req_id has valid request ID, if req_meta_valid == 1 */
> +	int64_t req_id;
> +	uint8_t req_meta_valid;
> +	/*
> +	 * mask has Nth bit set to 1, if Nth metavar was present and
> +	 * successfully read
> +	 */
> +	uint64_t int_vals_set_mask;
> +	int64_t int_vals[STROBE_MAX_INTS];
> +	/* len is >0 for present values */
> +	uint16_t str_lens[STROBE_MAX_STRS];
> +	/* if map_descrs[i].cnt == -1, metavar is not present/set */
> +	struct strobe_map_descr map_descrs[STROBE_MAX_MAPS];
> +	/*
> +	 * payload has compactly packed values of str and map variables in the
> +	 * form: strval1\0strval2\0map1key1\0map1val1\0map2key1\0map2val1\0
> +	 * (and so on); str_lens[i], key_lens[i] and val_lens[i] determines
> +	 * value length
> +	 */
> +	char payload[STROBE_MAX_PAYLOAD];
> +};
> +
> +struct strobelight_bpf_sample {
> +	uint64_t ktime;
> +	char comm[TASK_COMM_LEN];
> +	pid_t pid;
> +	int user_stack_id;
> +	int kernel_stack_id;
> +	int has_meta;
> +	struct strobemeta_payload metadata;
> +	/*
> +	 * makes it possible to pass (<real payload size> + 1) as data size to
> +	 * perf_submit() to avoid perf_submit's paranoia about passing zero as
> +	 * size, as it deduces that <real payload size> might be
> +	 * **theoretically** zero
> +	 */
> +	char dummy_safeguard;
> +};

> +struct bpf_map_def SEC("maps") sample_heap = {
> +	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +	.key_size = sizeof(uint32_t),
> +	.value_size = sizeof(struct strobelight_bpf_sample),
> +	.max_entries = 1,
> +};

due to this design the stressfulness of the test is
limited by bpf max map value limitation which comes from
alloc_percpu limit.
That makes it not as stressful as I was hoping for :)

> +#define STROBE_MAX_INTS 25
> +#define STROBE_MAX_STRS 25
> +#define STROBE_MAX_MAPS 5
> +#define STROBE_MAX_MAP_ENTRIES 20

so I could bump STROBE_MAX_INTS to 300 and got:
verification time 302401 usec // with kasan
stack depth 464
processed 40388 insns (limit 1000000) max_states_per_insn 6 total_states 8863 peak_states 8796 mark_read 4110
test_scale:./strobemeta25.o:OK

which is not that stressful comparing to some of the tests :)

Without unroll:
verification time 435963 usec // with kasan
stack depth 488
processed 52812 insns (limit 1000000) max_states_per_insn 26 total_states 6786 peak_states 1405 mark_read 777
test_scale:./strobemeta25.o:OK

So things are looking pretty good.

I'll roll your test into my set with few tweaks. Thanks a lot!

btw I consistently see better code and less insn_processed in alu32 mode.
It's probably time to make it llvm default.

