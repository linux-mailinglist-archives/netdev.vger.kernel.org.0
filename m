Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E33B148ED5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403897AbgAXTpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:45:35 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33349 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391381AbgAXTpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:45:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so1582275pfn.0;
        Fri, 24 Jan 2020 11:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=uAtf8UFoE+PN3UiSFGJxqL2LItMWe3zK1JG/WM0xK54=;
        b=U5MIHpAYiYl1tN/v3wBtlCpWWQexc2PBHipYhnlZY01BU1nYEXQcem3ktSO8CCb+WL
         3TyytFB9d6FN7CCayl/+jR9ywTrykenI1ObFjcmwvX2G8+5TiPFtBE5VqaWogzcezRG1
         xd83kKQH/yoFyC5twgYIAozwljhO4ujvci1eDn/6P2Wzv4G8QyoOegB/ZOFmhQuh7NDj
         L9PEu6s6QeuVUrhPJhR1bNCsODFJWMX/5kTtkF6Yj//lvXHmSrHV4BZVM7Zmx5lIm2TL
         OkdhRFXMHkx3sZVPG1u2ekg1OXTwB5m47H/8fhGGuFZfSq7DL1T/5xlby2E3oMNcAsRv
         e8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=uAtf8UFoE+PN3UiSFGJxqL2LItMWe3zK1JG/WM0xK54=;
        b=RcmoA+p36Ir2uLEy6UqRRvYX6pSqHrDsBBoujz2rtEiFHbfUp+Fv60sd3KA75IEe/r
         XsK4kJg0Bb0ZZVfjeBVZ+ThuDioj3lKd1wYsKuy7BaIx0+YAUCLuF16Nd25EygdED/3m
         QqWG2yst6cn9WUvwEmJGMlj7vQDgs91VzZXqLY6Hj8N1Cckuj/GeG/wxQhNrFaCjxqF/
         SsH/C5hyENL6YyTcM2XlFYWC7ZUtsE3m5YLLi1IwxvOwSEJX/OxigxS8eDdPHAzy+di4
         x0jBvKiEk8g8QuyG8SisjqN6VY8+edA3WfJ+sp7ZjLmxHc2q91pNfy66mNPwKADLZTlg
         rNVA==
X-Gm-Message-State: APjAAAV/eqOeFjiP7BD4p6Gw3q0HakWC8SnQxaXipDz9xdFbrXMv2rO8
        MfMhDmsJXKiITpnn/rDxbw49C11F
X-Google-Smtp-Source: APXvYqx/gD/MSaVKp9vFpCooVWOq+vZEktSonTpjCqs1EQsClDOZoYp4KvvGpzmHryLBmoNbVaG/ow==
X-Received: by 2002:a63:b50a:: with SMTP id y10mr5898440pge.104.1579895131757;
        Fri, 24 Jan 2020 11:45:31 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u127sm7268053pfc.95.2020.01.24.11.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 11:45:31 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:45:24 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5e2b495476333_551b2aaf5fbda5b85d@john-XPS-13-9370.notmuch>
In-Reply-To: <20200123165934.9584-3-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-3-lmb@cloudflare.com>
Subject: RE: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> The reuseport tests currently suffer from a race condition: RST
> packets count towards DROP_ERR_SKB_DATA, since they don't contain
> a valid struct cmd. Tests will spuriously fail depending on whether
> check_results is called before or after the RST is processed.
> 
> Exit the BPF program early if FIN is set.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../selftests/bpf/progs/test_select_reuseport_kern.c        | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> index d69a1f2bbbfd..26e77dcc7e91 100644
> --- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
> @@ -113,6 +113,12 @@ int _select_by_skb_data(struct sk_reuseport_md *reuse_md)
>  		data_check.skb_ports[0] = th->source;
>  		data_check.skb_ports[1] = th->dest;
>  
> +		if (th->fin)
> +			/* The connection is being torn down at the end of a
> +			 * test. It can't contain a cmd, so return early.
> +			 */
> +			return SK_PASS;
> +
>  		if ((th->doff << 2) + sizeof(*cmd) > data_check.len)
>  			GOTO_DONE(DROP_ERR_SKB_DATA);
>  		if (bpf_skb_load_bytes(reuse_md, th->doff << 2, &cmd_copy,
> -- 
> 2.20.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
