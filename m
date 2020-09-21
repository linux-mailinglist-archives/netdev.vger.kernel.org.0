Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF5272A95
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgIUPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgIUPpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:45:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73DBC061755;
        Mon, 21 Sep 2020 08:45:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fa1so7578pjb.0;
        Mon, 21 Sep 2020 08:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ir04M09cwY3BUoPMN1Wi06xEKFUOseBSBQoS6jEdlnA=;
        b=TcmqrnJhPO2sEjXg/1jAmooXdo3FyGLVogLfrv++YKM73CyraNJgq0K7Y/7I+YeCXN
         rih+tyTUfK6RXt+TC12jPqYnTFkNuSBn86NYlMbOL4kwbK1UTi7PNlRV4BRJqI6hMot7
         18LG0P73Mser8HQTzQmH5Yd3UKgpJojaGjJwXTzoV4W7zOqumXqtR8vb+NRO9GakEtha
         3r+rzYpfG2HfolLKLwSIFEINA/vXp94MwLf9x+tnUIl2lUcHMpXW4nmvlKiFW0LCWXkz
         d58L4RW9W8jczqgmsGl8UWhmfavQarXANBg8VOxd3fE7ucn/IUeWku0WHMRcMvSwRnOL
         Hp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ir04M09cwY3BUoPMN1Wi06xEKFUOseBSBQoS6jEdlnA=;
        b=KL2/3bFZr9s1vCeTbeO8o+Q0Vi/BMu+DOqeQ1HNFaE1HJJltNM5FIf7ZeJGq3kTVjm
         qwGWfg0Z41HeDgTEw3nT1XALBHWBahK1Sd2T/OcqErersxTyKDJRCACmK8+6E7ub/Zup
         T8IiVOuoIHNObO8gDjXtdBGh0O2pHXoYXlymnmJxTx8dyPFfSruFS/8NLiDQK6O9eLDY
         Irsy2IhsUDqCTzRg3242/vhHSVk5IXSDQ5577J/nV9G5KZbj18RDHB6RegXiN9xsXKHm
         QXLaknb3LXs0VcSFNyG5ZmiH+xdYk8CQwStjlauDbKMXawz76a7orhBPuZJb6paTQsWZ
         odQw==
X-Gm-Message-State: AOAM530EMCcgerQdlA8nxYHLm1H7hATyYp2y0S9b/OwWa8TQqd6VFyxB
        bxGhJdCYEcUjO7hwk7fCK9o=
X-Google-Smtp-Source: ABdhPJx4kAjMmOp7LGnoaJfadMncLeVnldwL3ZHVVAu2D7sXvcsT8LiCZGqwqxZiRNBxcjlNFQwNCg==
X-Received: by 2002:a17:90a:71c7:: with SMTP id m7mr23756pjs.190.1600703138516;
        Mon, 21 Sep 2020 08:45:38 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y6sm6646pji.1.2020.09.21.08.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 08:45:37 -0700 (PDT)
Date:   Mon, 21 Sep 2020 08:45:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <5f68ca9c9302a_17370208f9@john-XPS-13-9370.notmuch>
In-Reply-To: <a635b5d3e2da044e7b51ec1315e8910fbce0083f.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
 <a635b5d3e2da044e7b51ec1315e8910fbce0083f.1600417359.git.Tony.Ambardar@gmail.com>
Subject: RE: [PATCH bpf v1 2/3] bpf: prevent .BTF section elimination
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Ambardar wrote:
> Systems with memory or disk constraints often reduce the kernel footprint
> by configuring LD_DEAD_CODE_DATA_ELIMINATION. However, this can result in
> removal of any BTF information.
> 
> Use the KEEP() macro to preserve the BTF data as done with other important
> sections, while still allowing for smaller kernels.
> 
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
>  include/asm-generic/vmlinux.lds.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 5430febd34be..7636bc71c71f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -661,7 +661,7 @@
>  #define BTF								\
>  	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
>  		__start_BTF = .;					\
> -		*(.BTF)							\
> +		KEEP(*(.BTF))						\
>  		__stop_BTF = .;						\
>  	}								\
>  	. = ALIGN(4);							\
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
