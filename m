Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF59E150AD
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfEFPuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:50:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43566 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfEFPuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:50:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id c6so1786113pfa.10;
        Mon, 06 May 2019 08:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4h6c69krvoIOxEQP2kDxN5Xj3mPYUgRHclyDxLY3Sh0=;
        b=REiIGyWuoUTJpB1Pch98JUzAEk8ap6S1I36DikzGdR1pRS19cEyCPmpDC9NMFA/m0N
         YvG2ws+a+p149IMp9mhLaSYKS90QFxNdKwRMMSK11WrWhP4SuDOj70PPDwvg3+SYDdiL
         ejAZUjn449GQKHl+RxNrXkekjOdCSWTJlQk9ab6YRer3idb4mlzlYqlciJlMgvnKibON
         7MBk89RETAVSZ7kjvCdjdOvqcBAHqovlsipYI3qfGMDzKsiQc3R4pL/2U3SqqtK0X2lA
         8sOzPZ40oUrWlPyJTrqhDzcAjQkG4Myb7QSEiSPnsN/4yaMl0eclacE44gUdr84faXZW
         e3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4h6c69krvoIOxEQP2kDxN5Xj3mPYUgRHclyDxLY3Sh0=;
        b=Y9wxIdx0WEMDBzzP6xD/p8WBWLFD5rGtc8SNjAvLURpLxa9w2vIrdHVcDV/ReX+A1t
         W67I2rCmC+g2pAED8uULpEVauPYkPUJ4sndts8fgGofcfIyCX0HS4eJ8Va202O+bj2x1
         Xx9YnwyfZKSo7+QpARtmjvnQqbOGtxeflz/UVvG8RQqXxP3PGtFz4fWiDyUZx1Zf+RHH
         YfUkbMUlHkan2z8VTlq20N92BxexpG4f4bT6yQ39W46CRnCctte1fdZVR33/C7FgaTVe
         t0a7bKkZocRVAdYxkXYtMvXHT/Whb28M+Pg8EOTJG/sq0QfXPVNq1w3ohVF5ZbcXPETv
         WLrA==
X-Gm-Message-State: APjAAAXzb7eDmJNSLp6cVV/YYAwBte8ct2n8aQRR8cji0QtJP3KVuRS9
        cIhvQtLGQbPxfdaFy1j4XSdW76hU
X-Google-Smtp-Source: APXvYqxQcYyxsv2xNx3M2J5q2cX+Wsl5SsKNw6kdfWINz7PuxKpZUyNnb2cQihm3F7Qc2/rxnN8euQ==
X-Received: by 2002:aa7:8252:: with SMTP id e18mr34192136pfn.105.1557157844753;
        Mon, 06 May 2019 08:50:44 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:1919])
        by smtp.gmail.com with ESMTPSA id n184sm7202714pfn.21.2019.05.06.08.50.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 08:50:43 -0700 (PDT)
Date:   Mon, 6 May 2019 08:50:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate
 helper function arg and return type
Message-ID: <20190506155041.ofxsvozqza6xrjep@ast-mbp>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 11:42:28AM +0100, Jiong Wang wrote:
> BPF helper call transfers execution from eBPF insns to native functions
> while verifier insn walker only walks eBPF insns. So, verifier can only
> knows argument and return value types from explicit helper function
> prototype descriptions.
> 
> For 32-bit optimization, it is important to know whether argument (register
> use from eBPF insn) and return value (register define from external
> function) is 32-bit or 64-bit, so corresponding registers could be
> zero-extended correctly.
> 
> For arguments, they are register uses, we conservatively treat all of them
> as 64-bit at default, while the following new bpf_arg_type are added so we
> could start to mark those frequently used helper functions with more
> accurate argument type.
> 
>   ARG_CONST_SIZE32
>   ARG_CONST_SIZE32_OR_ZERO
>   ARG_ANYTHING32
> 
> A few helper functions shown up frequently inside Cilium bpf program are
> updated using these new types.
> 
> For return values, they are register defs, we need to know accurate width
> for correct zero extensions. Given most of the helper functions returning
> integers return 32-bit value, a new RET_INTEGER64 is added to make those
> functions return 64-bit value. All related helper functions are updated.
> 
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  include/linux/bpf.h      |  6 +++++-
>  kernel/bpf/core.c        |  2 +-
>  kernel/bpf/helpers.c     | 10 +++++-----
>  kernel/bpf/verifier.c    | 15 ++++++++++-----
>  kernel/trace/bpf_trace.c |  4 ++--
>  net/core/filter.c        | 38 +++++++++++++++++++-------------------
>  6 files changed, 42 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9a21848..11a5fb9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -198,9 +198,12 @@ enum bpf_arg_type {
>  
>  	ARG_CONST_SIZE,		/* number of bytes accessed from memory */
>  	ARG_CONST_SIZE_OR_ZERO,	/* number of bytes accessed from memory or 0 */
> +	ARG_CONST_SIZE32,	/* Likewise, but size fits into 32-bit */
> +	ARG_CONST_SIZE32_OR_ZERO,	/* Ditto */

these two should not be necessary. The program must pass constant into
the helper. The verifier is smart enough already to see it through.
Looks like patch 2 is using it as a band-aid.

>  	ARG_PTR_TO_CTX,		/* pointer to context */
>  	ARG_ANYTHING,		/* any (initialized) argument is ok */
> +	ARG_ANYTHING32,		/* Likewise, but it is a 32-bit argument */

Such annotation has subtle semantics that I don't think we've explored
in the past and I don't see from commit logs of this patch set that
the necessary analysis was done.
In particular 'int' in the helper argument does not mean that the verifier
will reject 64-bit values. It also doesn't mean that the helper
will reject them at run-time. In most cases it's a silent truncation.
Like bpf_tail_call will accept 64-bit value, and will cast it to u32
before doing max_entries bounds check.
In other cases it could be signed vs unsigned interpretation inside
the helper.
imo the code base is not ready for semi-automatic remarking of
helpers with ARG_ANYTHING32 when helper is accepting 32-bit value.
Definitely not something short term and not a prerequisite for this set.

Longer term... if we introduce ARG_ANYTHING32, what would that mean?
Would the verifier insert zext before calling the helper automatically
and we can drop truncation in the helper? May be useful?
What about passing negative value ?
ld_imm64 r2, -1
call foo
is a valid program.

>  	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
>  	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
>  	ARG_PTR_TO_INT,		/* pointer to int */
> @@ -210,7 +213,8 @@ enum bpf_arg_type {
>  
>  /* type of values returned from helper functions */
>  enum bpf_return_type {
> -	RET_INTEGER,			/* function returns integer */
> +	RET_INTEGER,			/* function returns 32-bit integer */
> +	RET_INTEGER64,			/* function returns 64-bit integer */

These type of annotations are dangerous too since they don't consider sign
of the return value. In BPF ISA all arguments and return values are 64-bit.
When it's full 64-bit we don't need to specify the sign, since sing-bit
will be interpreted by the program and the verifier doesn't need to worry.
If we say that helper returns 32-bit we need state whether it's signed or not
for the verifier to analyze it properly.

I think it's the best to drop this patch. I don't think the rest of the set
really needs it. It looks to me as a last minute optimization that I really
wish wasn't there, because the rest we've discussed in depth and the set
was practically ready to land, but now bpf-next is closed.
Please resubmit after it reopens.

