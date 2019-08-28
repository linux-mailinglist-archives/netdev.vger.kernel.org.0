Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A3FA0C46
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfH1VTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:19:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33052 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1VTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:19:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id v38so1301085qtb.0;
        Wed, 28 Aug 2019 14:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q+bSnufMMSFAODoq3/Ev2TbR4aO+KDVdFDkEKdK/0bU=;
        b=IoDMT2RdcJ1YeBO9uC+RbeSTb4qg2esJfM3QoK2NpLSWreOyNGs1A61oRRkNbnA9Th
         vq5RblmFhWFroC0ZXCXTGtilPCjVx9unFhhlKgm0LEPgJLLzW+tCid8Kjz8XzsOP9yCR
         6ZzNgZuWYQ6zaEPelKHttusivG/QClkEfXqTYCwM9vcvt/4x6Z6g43XH92DP6YjZ0MhV
         5g6300DwobiiJGbxxRUx2fJz3L6nyQAOWUzn8sMbblsnbbkyhPvl2GDCsWWyTU679p84
         /GL+ZvFTQcYZKIJqQ9nHZ/nvN+hRcB29hk2Nh8zJ9M+EEqTmQMRn+2IGXGfBctVnc8e+
         ymrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q+bSnufMMSFAODoq3/Ev2TbR4aO+KDVdFDkEKdK/0bU=;
        b=dIKqgDSV9HP5wf9zNZ44VqSV4J3qfe8IQUPwTuIqdcYCRKxXKkfSj00cVKywIoPqt3
         KTTO5s/FBzJ8nkj39eYy3w/nItn0Uxi8U4TuICyNKHe+BrSh9+4h6xJHdo9uOuvMwX09
         4AzEih1BAKDnVRxCGMRH7OKqzcecuQx20OBJ/VpICF26xHtdAUod0XALMZddTr1SNPJR
         yw+k5tcBcVISVEZWdqQCbPcH2jbRAFzEIO34B4fmNYC3SwpQKu55OnYYOiQTA1s3b/Du
         q8tibyARgZ8/HFEsbw6vUX1n0NDM5ENmtc+ghic5bVpLAXSJtpV1DkrDCjLutALDuJGh
         USgg==
X-Gm-Message-State: APjAAAU6H02DBvKJnbbfhCSHdv/yrvABiu2ZVs6hzvvXchTjnFBm1AfR
        UHuAZ6ZaBHjxsOKZyUsK4h09Thj1
X-Google-Smtp-Source: APXvYqwO5mxKViKsfViHqdNiTk/Dza2zVIjeURGbk4BSGoEVpsLVDJV3PdyjmWWN9odp2q5jjsGkmw==
X-Received: by 2002:a05:6214:1447:: with SMTP id b7mr4436628qvy.89.1567027160329;
        Wed, 28 Aug 2019 14:19:20 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.162.135.198])
        by smtp.gmail.com with ESMTPSA id t13sm161466qkm.117.2019.08.28.14.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 14:19:19 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9D8FC41146; Wed, 28 Aug 2019 18:19:16 -0300 (-03)
Date:   Wed, 28 Aug 2019 18:19:16 -0300
To:     Julia Kartseva <hex@fb.com>
Cc:     rdna@fb.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 03/10] tools/bpf: handle
 __MAX_BPF_(PROG|MAP)_TYPE in switch statements
Message-ID: <20190828211916.GA28011@kernel.org>
References: <cover.1567024943.git.hex@fb.com>
 <1895f7dfe2a8067f6397ff565edf20130a28aa91.1567024943.git.hex@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1895f7dfe2a8067f6397ff565edf20130a28aa91.1567024943.git.hex@fb.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Aug 28, 2019 at 02:03:06PM -0700, Julia Kartseva escreveu:
> Add cases to switch statements in probe_load, bpf_prog_type__needs_kver
> bpf_probe_map_type to fix enumeration value not handled in switch
> compilation error.
> prog_type_name array in bpftool/main.h doesn't have __MAX_BPF_PROG_TYPE
> entity, same for map, so probe won't be called.

Shouldn't this be added when adding that __MAX_BPF_PROG_TYPE value to
the enum? Otherwise the build will fail when __MAX_BPF_PROG_TYPE is
added but not handled in the switches.

I.e. the tree should build patch by patch, not just at the end of patch
series.

- Arnaldo
 
> Signed-off-by: Julia Kartseva <hex@fb.com>
> ---
>  tools/lib/bpf/libbpf.c        | 1 +
>  tools/lib/bpf/libbpf_probes.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2233f919dd88..72e6e5eb397f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3580,6 +3580,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
>  	case BPF_PROG_TYPE_PERF_EVENT:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +	case __MAX_BPF_PROG_TYPE:
>  		return false;
>  	case BPF_PROG_TYPE_KPROBE:
>  	default:
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index 4b0b0364f5fc..8f2ba6a457ac 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -102,6 +102,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>  	case BPF_PROG_TYPE_FLOW_DISSECTOR:
>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +	case __MAX_BPF_PROG_TYPE:
>  	default:
>  		break;
>  	}
> @@ -250,6 +251,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
>  	case BPF_MAP_TYPE_XSKMAP:
>  	case BPF_MAP_TYPE_SOCKHASH:
>  	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
> +	case __MAX_BPF_MAP_TYPE:
>  	default:
>  		break;
>  	}
> -- 
> 2.17.1

-- 

- Arnaldo
