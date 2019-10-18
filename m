Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E2DD555
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbfJRX2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:28:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40893 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:28:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id e13so4156225pga.7;
        Fri, 18 Oct 2019 16:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o0R3SyRraCYFgVgsB5u2m67oRVRURyDN4oM3OQMhLd8=;
        b=bGMPOosORfDuftN5n0wtfJCp5crEfKFpnJYZ82SyZuvJqJ2g+x4NHfp6DkIhJQOnkc
         +hwj6myIZ6VOq27otny1g3tseHmRgkASYlk/bND7N8tVEaIaak6adGWC728OlmNcmpak
         2HVilYdRLCEzD4GDT+TugdUWxld1vt9qB8z0bZ9XsTsxi+Dgn4AsOkQA+YYjU1bczafx
         RMF3TK8nLUM/e01Rs1cMjHerWREsPMU/TVFVrGbxvQ2aweQ7yO41tiJErR24O/xu+og5
         D5lVT2S7NyHwz2eIJgp1eHvZwS9G4iwMZBbwJ9uG4cd/bEDrflfrSArs9aMcTEpC2Dkr
         FCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o0R3SyRraCYFgVgsB5u2m67oRVRURyDN4oM3OQMhLd8=;
        b=Eu1xGY/nrvaPRlIl0Kw5T0nGVQhiRUItPYNnfLjMgq2LxdbMPIaR/gYox1LovUdwVY
         ZQeSeLSK4JMmWMTXeMVkeOnVNiZT+0Xca35AWkwbWkQ+kon4w/GFRh9YNbOFGVbRiBqF
         +J/6xTYE9lsnVHG4nmIKAChNbEaLcz9lhnL633V5tK8sJLZpm2Mdv+DXwZ4h+xePkJMF
         ge8qt0CjgJbFEVJcZSLkiCX72StBbhsptM8f/M8BFZtK8PevGkXQr6EZBb5OkDLfGQ5P
         nzcVcLQboq2EXcbhDIv047Ey36j0QAf8Tn5u0cxU0ucLMyt3avk9fbKJfrRvZlF1UOIY
         RuJw==
X-Gm-Message-State: APjAAAVlVFD95gwK5+q15WxG2T1fNJlHxayD+13PkftkEm2xNhsVBlZr
        QVTP+iDjwI++LjluJcEeANQ=
X-Google-Smtp-Source: APXvYqxW38q5b5LG4zDiowueOjD4jrk+ucC9DSBK1BYWfFUNsvDPbUsQfBa7/hNxK/thEb0mxws1gw==
X-Received: by 2002:a62:2643:: with SMTP id m64mr9228282pfm.232.1571441281466;
        Fri, 18 Oct 2019 16:28:01 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::6038])
        by smtp.gmail.com with ESMTPSA id w12sm9211275pfq.138.2019.10.18.16.27.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 16:28:00 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:27:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        linux-doc@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2] xsk: improve documentation for AF_XDP
Message-ID: <20191018232756.akn4yvyxmi63dl5b@ast-mbp>
References: <1571391220-22835-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571391220-22835-1-git-send-email-magnus.karlsson@intel.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 11:33:40AM +0200, Magnus Karlsson wrote:
> +
> +   #include <linux/bpf.h>
> +   #include "bpf_helpers.h"
> +
> +   #define MAX_SOCKS 16
> +
> +   struct {
> +        __uint(type, BPF_MAP_TYPE_XSKMAP);
> +        __uint(max_entries, MAX_SOCKS);
> +        __uint(key_size, sizeof(int));
> +        __uint(value_size, sizeof(int));
> +   } xsks_map SEC(".maps");
> +
> +   struct {
> +        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +        __uint(max_entries, 1);
> +        __type(key, int);
> +        __type(value, unsigned int);
> +   } rr_map SEC(".maps");

hmm. does xsks_map compile?

> +
> +   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> +   {
> +	int key = 0, idx;
> +	unsigned int *rr;
> +
> +	rr = bpf_map_lookup_elem(&rr_map, &key);
> +	if (!rr)
> +	   return XDP_ABORTED;

could you please use global data and avoid lookup?
The run-time will be much faster.

