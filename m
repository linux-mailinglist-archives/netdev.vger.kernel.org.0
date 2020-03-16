Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3800C18766D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgCPX52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:57:28 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41658 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732932AbgCPX52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:57:28 -0400
Received: by mail-oi1-f193.google.com with SMTP id b17so4886958oic.8;
        Mon, 16 Mar 2020 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Oqo2JJRYgFPA7fT3MpISl0/etjwuAoyb95hkUCRCf0=;
        b=eBbV+4odYsHTHuC4yrDXu19x0MftuMXiRTSjCkWRt3jSaMXFGhhsNorofMj+SPb/sa
         J64dWOv5hKKYiuworQhW5MHEB5jN8UQ19BLhWdCicZWmQ/RmTUfSCRv8595swnbjnfBo
         9cexSEMvOL1KnRwwM6u6kDTz9BO1mFAP++f4fd3ltsZrCLZrkqKxeSSUavNSHRA6B9Rz
         8b/XJdvLt3wiV9JNXneN5bOXSaBmVrtz+YxGTAtOkydxA2bYxGHqLrbAUjrCFc8GmPVX
         FDxSmxvNkoYFvJIL98KVgaU7Ls5hB7oRxshc1WLI6WoC1Nx/ka7Cfs4k15clTHsVy8G2
         LPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3Oqo2JJRYgFPA7fT3MpISl0/etjwuAoyb95hkUCRCf0=;
        b=e0564FQTNWoQmJi+dyHwc1sQVC9nOgScGfm+nPgFWES+G+Y48ISE5f3LzQNhg/LL+Y
         I/hF7Z84Rg2fmh3/FrDGJYZx+EUCnuA2ZJ/HHCPmrVeFZqvj0dQc8y1mkVD4PHZv7D5v
         TLC4gLaqDPESVOdyPN70Ti7cI7x1uswMvQ+YflYwXlas6dq9irc68E+kwZt8X7Caq2Gq
         PuQUfJDtngH7h54Fp/0KQ3NEgDk1Y/HUOTEepb+75ckETsS/dYJzhwQ3/nSr9Mp8HR3Z
         GZVXS1LqRXhmV4qeRZyE+V3EYV1Yx2I8k2IkSNdV1GhDwOUjlsGyZwhAPM7nn5O2f/76
         T28Q==
X-Gm-Message-State: ANhLgQ1vgFB/LUQXHa2Yk6utRCQqgUsuiAaMNTIYYrs7VI0zxd5z3R91
        Imcou2fGD1ub8J3p0zF+rz00lZI9
X-Google-Smtp-Source: ADFU+vs8C17h9HlsS5h8I0/l8wXkw2N2ghkn1WI82uAzlJ+XjqjYEyytjoRU5zO+/RoFjiGf/HOnJw==
X-Received: by 2002:aca:57cd:: with SMTP id l196mr1574179oib.1.1584403047034;
        Mon, 16 Mar 2020 16:57:27 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id m20sm501431otj.37.2020.03.16.16.57.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 16:57:26 -0700 (PDT)
Date:   Mon, 16 Mar 2020 16:57:25 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <20200316235725.GA43392@ubuntu-m2-xlarge-x86>
References: <20200316222518.191601-1-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316222518.191601-1-sdf@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 03:25:18PM -0700, Stanislav Fomichev wrote:
> Commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux
> BTF") switched from --dump-section to
> --only-section/--change-section-address for BTF export assuming
> those ("legacy") options should cover all objcopy versions.
> 
> Turns out llvm-objcopy doesn't implement --change-section-address [1],
> but it does support --dump-section. Let's partially roll back and
> try to use --dump-section first and fall back to
> --only-section/--change-section-address for the older binutils.
> 
> 1. https://bugs.llvm.org/show_bug.cgi?id=45217
> 
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  scripts/link-vmlinux.sh | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index dd484e92752e..8ddf57cbc439 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -127,6 +127,16 @@ gen_btf()
>  		cut -d, -f1 | cut -d' ' -f2)
>  	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
>  		awk '{print $4}')
> +
> +	# Compatibility issues:
> +	# - pre-2.25 binutils objcopy doesn't support --dump-section
> +	# - llvm-objcopy doesn't support --change-section-address, but
> +	#   does support --dump-section
> +	#
> +	# Try to use --dump-section which should cover both recent
> +	# binutils and llvm-objcopy and fall back to --only-section
> +	# for pre-2.25 binutils.
> +	${OBJCOPY} --dump-section .BTF=$bin_file ${1} 2>/dev/null || \
>  	${OBJCOPY} --change-section-address .BTF=0 \
>  		--set-section-flags .BTF=alloc -O binary \
>  		--only-section=.BTF ${1} .btf.vmlinux.bin
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 

Hi Stanislav,

Thank you for the patch! This is targeting the bpf tree but it uses the
bin_file variable that comes from commit af73d78bd384 ("kbuild: Remove
debug info from kallsyms linking") in the bpf-next tree. In this form,
when applied to mainline, the first command fails because $bin_file
doesn't exist and falls back to the second command, which results in no
net change for llvm-objcopy.

When manually applied to next-20200316 or applied to mainline with
$bin_file replaced with .btf.vmlinux.bin, x86_64 and aarch64 successfully
 generate BTF with tip of tree llvm-objcopy.

Tested-by: Nathan Chancellor <natechancellor@gmail.com>
