Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6D13DC8
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfEEGTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:19:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34278 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfEEGTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:19:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so4835763pgt.1;
        Sat, 04 May 2019 23:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/O0+bcvBE2OoO/gEJJYwRuRI/RoGqtMYiiZRYQc0t4I=;
        b=sVUer8yo9OhUMSJX6hMcLyZ+WUt9ijpiwKTXdDxyiNFPrWmlSF1bSzGIxcU9MQZDl/
         VX9Pm4+viIfiVlcPLEUCKpLOhERG3PfBuMA/Abvbktj0/MF9jGMMRl5toJJli4UQOBDW
         52BqRPznwSDs3vjHfnh8JJqbQVUofVXrjYcCBEUF207yGPlEL7QHvg/TB6wkNClRRwNJ
         OULDI6PqWV3ffyHQpv5pJHc2J9nQyGa8sbRmqkpGKM1UNFxB9dvYkfvtalkxJq95upI8
         r+3lAKrPCMLAndOZWsPtHMO6N9QUT4vBxyj+ROXQtHHN72eKkF8NPeq1CK2a+kWPmzq6
         7iZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/O0+bcvBE2OoO/gEJJYwRuRI/RoGqtMYiiZRYQc0t4I=;
        b=ok+TQIDWQ6+zjS9zdrEZG5sO+1IggXwuoKnVy1Bhaq7f90x6zH+K8jEcMx6TAIEG3b
         UsJbwLPAt3zVcKifL57uJIygkmMvZCXrUbZ0VEzkP/Qhzlhhzm55ozJXH+ToV1OfHAvm
         MOTqbECJScPNLxVO7wW8cYAPKd1ujasxvE5fIKRpL1oKHj1bybWWvEPOcE6aw35Lr6Ns
         PGK2KOKUWMOi6Jr5yv//V/OPxshuXsuID3j5cCxiULQ+ljraObEdHAwk7ddBt06PrHFx
         kVMP4U2GVxrnVzmMxlL8TdAtaMGBLAZMB+V8kBfTAQy5omxSulaqVJW5T9sMb6wOYRTS
         Lv2w==
X-Gm-Message-State: APjAAAVTS5roZt0S1KTVTYsOIhESQ6jfzS3obOmNwHB6LGl3s9B+i295
        mHDJqz6zxKy/XbOjob12FzOk4Ic9
X-Google-Smtp-Source: APXvYqzvyiCxAFPvRtwFJEnXIdbqPspm5dip3VA/y6atEk9Tt9bRxCDrDN4ROhC0K5EZZ7NbSWeOsg==
X-Received: by 2002:a63:ed12:: with SMTP id d18mr23581304pgi.248.1557037156347;
        Sat, 04 May 2019 23:19:16 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::2e11])
        by smtp.gmail.com with ESMTPSA id k7sm8649674pfi.67.2019.05.04.23.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 23:19:15 -0700 (PDT)
Date:   Sat, 4 May 2019 23:19:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH bpf-next 4/6] bpf: make BPF_LOG_* flags available in UAPI
 header
Message-ID: <20190505061913.mgazaivmg62auirx@ast-mbp>
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
 <20190429095227.9745-5-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429095227.9745-5-quentin.monnet@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:52:25AM +0100, Quentin Monnet wrote:
> The kernel verifier combines several flags to select what kind of logs
> to print to the log buffer provided by users.
> 
> In order to make it easier to provide the relevant flags, move the
> related #define-s to the UAPI header, so that applications can set for
> example: attr->log_level = BPF_LOG_LEVEL1 | BPF_LOG_STATS.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  include/linux/bpf_verifier.h | 3 ---
>  include/uapi/linux/bpf.h     | 5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 1305ccbd8fe6..8160a4bb7ad9 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -253,9 +253,6 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
>  	return log->len_used >= log->len_total - 1;
>  }
>  
> -#define BPF_LOG_LEVEL1	1
> -#define BPF_LOG_LEVEL2	2
> -#define BPF_LOG_STATS	4
>  #define BPF_LOG_LEVEL	(BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
>  #define BPF_LOG_MASK	(BPF_LOG_LEVEL | BPF_LOG_STATS)
>  
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 72336bac7573..f8e3e764aff4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -335,6 +335,11 @@ struct bpf_stack_build_id {
>  	};
>  };
>  
> +/* verifier log_level values for loading programs, can be combined */
> +#define BPF_LOG_LEVEL1	1
> +#define BPF_LOG_LEVEL2	2
> +#define BPF_LOG_STATS	4

The verifier log levels are kernel implementation details.
They were not exposed before and shouldn't be exposed in the future.
I know that some folks already know about existence of level2 and use it
when the verifier rejects the program, but this is not uapi.
What is being output at level1 and 2 can change.
It's ok for libbpf to use this knowledge of kernel internals,
but it shouldn't be in uapi header.
That was the reason I didn't expose stats=4 in uapi in the first place
when I added that commit.

