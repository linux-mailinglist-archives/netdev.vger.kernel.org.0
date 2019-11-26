Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7376610A728
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKZXgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:36:46 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40137 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfKZXgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:36:46 -0500
Received: by mail-il1-f195.google.com with SMTP id v17so15429903ilg.7;
        Tue, 26 Nov 2019 15:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4QtXK3lqaLHaq6XtASriT4B05w36puyBZjMlnscW3wo=;
        b=MsZNTlDR1qyPRv9VhiduXw0DQFXiS6fqYd5EvNKVoa7xu8wf1qwGagcJIRBK62vqQ2
         oRM04ZcThxzSOK3Ns9Z3TI3JFzpju/oQGoukA0KPOUBR3abT94rCJEZ2KZeH+KC7wH6U
         OG/pxaUhijQ8/VwH64KWK8FCz5DZ16CCqePmtGqZ6MEgzkJtAn7JmBuwNmKUKdz9S24K
         WtlMH5pvUNzpMFFzrr3SUILuP7hbptycnlFUrQ0Nv2N4TbMGqYFw2gZwMqzhHZtcUbVk
         SBT/5iYd31Pv/80Cf5whrV7q2DZXKzwsKjlfnpxpBVMhjzNeWZuEv2YWEZc7SY/ZchxX
         PogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4QtXK3lqaLHaq6XtASriT4B05w36puyBZjMlnscW3wo=;
        b=CViiC9fxlJE224FgCxY1bKpl7tS+Ykcguy7Y0D4xjZlFqVZcZH0KBLHrA/n7wMrnya
         DOVbu6O6VoXIXkTj2ZoWAud9uR8u7W1ZOcGX3IZMfAQeLPJkm77myJilDOQXISTpJqO6
         F8QiDUV5L0JjNbZugofVKHlIjqZuy16xX2/c2Gt1LI/NDPsypeCz4AAzpLLr0mr9NRrt
         /VvX6/nbUsCGpZ2r/FPb9rqKBgc16er/3efiaAeb43HStrnSrZ6ywOvX8Cs6QWLM3hvn
         NbEb9tJ0XnBcSdFwHPM/BN3i7MFiXJsM/y6ntC+bBYepdfQ1FNhD09G3I3utQ1s6rVUH
         4Acw==
X-Gm-Message-State: APjAAAV4/w4RsHwdz0zDHG4Md790c3ZbqMelBo7L2P3ZaMzOfQoqQJmv
        l8JcMXP6d/Ce8K3vGkCbJTE=
X-Google-Smtp-Source: APXvYqwj2BRI3DniXq0ke03BY/qVV5HTt+C2falLGDjp9Wnu42+jScI3JVjSoBGlsayoJjx32oR8lQ==
X-Received: by 2002:a92:bf08:: with SMTP id z8mr10041838ilh.11.1574811405305;
        Tue, 26 Nov 2019 15:36:45 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e15sm3619012ile.28.2019.11.26.15.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 15:36:44 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:36:37 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
In-Reply-To: <20191126232818.226454-1-sdf@google.com>
References: <20191126232818.226454-1-sdf@google.com>
Subject: RE: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for vmlinux
 BTF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> .BTF section of vmlinux is empty and kernel will prohibit
> BPF loading and return "in-kernel BTF is malformed".
> 
> --dump-section argument to binutils' objcopy was added in version 2.25.
> When using pre-2.25 binutils, BTF generation silently fails. Convert
> to --only-section which is present on pre-2.25 binutils.
> 
> Documentation/process/changes.rst states that binutils 2.21+
> is supported, not sure those standards apply to BPF subsystem.
> 
> v2:
> * exit and print an error if gen_btf fails (John Fastabend)
> 
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  scripts/link-vmlinux.sh | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 06495379fcd8..2998ddb323e3 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -127,7 +127,8 @@ gen_btf()
>  		cut -d, -f1 | cut -d' ' -f2)
>  	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
>  		awk '{print $4}')
> -	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
> +	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
> +		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
>  	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
>  		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
>  }
> @@ -253,6 +254,10 @@ btf_vmlinux_bin_o=""
>  if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
>  	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
>  		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
> +	else
> +		echo >&2 "Failed to generate BTF for vmlinux"
> +		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"

I think we should encourage upgrading binutils first? Maybe

"binutils 2.25+ required for BTF please upgrade or disable CONFIG_DEBUG_INFO_BTF"

otherwise I guess its going to be a bit mystical why it works in
cases and not others to folks unfamiliar with the details.

> +		exit 1
>  	fi
>  fi
>  
> -- 
> 2.24.0.432.g9d3f5f5b63-goog
> 


