Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029955785C0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiGROtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiGROtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:49:42 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715ADF88
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:49:41 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id f1so318683ilu.3
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WKnM3En4X1e6GlNcjgP6llkg24rxYaIi7UNj1me+FNU=;
        b=PAXD+j3ApkTx4GIpEJfWiHBRR0WKpxowpc8xV1I93FPGyPqltWWVF3o0E7jZaL+bLF
         TUCA0DSo07zc8DukHtrefvi5bccpxviPl8G7qVsvSFRcWd25zHb5jRrViN/nxGHzmAbp
         EW2u4F5fW4bJ3YhP+JZuPea+JlcoyGy2g32UZVi0eQm0NkANjmM7uOIxsCLyvGr0x/wu
         46eetzSH1EECPokijKEajL/iPNnlv4Kyuc86PK8vF77/YaSorWDHrTiXg1TTdXS537/1
         xmP0wrNgga0BGYjx7BNUxmn7eA1cE6lyXIyn1o61elRHYvCnQiCzCCh6IC7aHLr3bXIW
         WFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WKnM3En4X1e6GlNcjgP6llkg24rxYaIi7UNj1me+FNU=;
        b=H1UxeZH7zE3GgaGlqGbgHkBCXwmiJxMYW1ZHQJC0NHNFk+nbfDYmXwq1g/vY7UIVq2
         FfB8lxVLpXc035mN/FfEy/MZms6GXgW3igapmgj07R13uHHFH9dUHR+lZyVe8LPSwZ11
         y1guiAEASiLrNjxlM7hMH90KDKWXIlZzXxOzFvroDJSAh4r6kAiEkgx6a0mmgY6Qq/Ll
         6kpv7WdTqnaN7jGamNiG0/GRfKBmPQvPTnc9wOCThCMmScdpuu9cgENLJXGCXPemSej0
         M7ktpOfzqXhtxZroEiqG5qV6+b4c3QqeyFsTVvlLNZbgiIwmxnXkUH2JT773VQTe84Xw
         szBw==
X-Gm-Message-State: AJIora9mBGR+jgx7F5v9N2tiCJjMddW+oYOVELmZJ39Qm01xUKNVRvrg
        y9Wts9EpUXPklVWg+zJL607wbba2tHY=
X-Google-Smtp-Source: AGRyM1sfp8OAOS4nalrQ/K23dg4olA5OJp5Ffp7eLhLRBAI/CWl9iu8rbwet9RhagUIjA+DVAKwj5Q==
X-Received: by 2002:a05:6e02:1be9:b0:2dc:68b5:4c55 with SMTP id y9-20020a056e021be900b002dc68b54c55mr13502503ilv.93.1658155780987;
        Mon, 18 Jul 2022 07:49:40 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a884:659b:a795:3b16? ([2601:282:800:dc80:a884:659b:a795:3b16])
        by smtp.googlemail.com with ESMTPSA id d6-20020a92d5c6000000b002dc0ddef9cfsm4831938ilq.73.2022.07.18.07.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 07:49:40 -0700 (PDT)
Message-ID: <3e9b7274-7741-1b12-bfb1-db1bb8ae2c4e@gmail.com>
Date:   Mon, 18 Jul 2022 08:49:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next 1/2] lib: Introduce ppp protocols
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20220714082522.54913-1-wojciech.drewek@intel.com>
 <20220714082522.54913-2-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220714082522.54913-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/22 2:25 AM, Wojciech Drewek wrote:
> diff --git a/include/rt_names.h b/include/rt_names.h
> index 1835f3be2bed..6358650db404 100644
> --- a/include/rt_names.h
> +++ b/include/rt_names.h
> @@ -31,6 +31,9 @@ int ll_addr_a2n(char *lladdr, int len, const char *arg);
>  const char * ll_proto_n2a(unsigned short id, char *buf, int len);
>  int ll_proto_a2n(unsigned short *id, const char *buf);
>  
> +const char *ppp_proto_n2a(unsigned short id, char *buf, int len);
> +int ppp_proto_a2n(unsigned short *id, const char *buf);
> +
>  const char *nl_proto_n2a(int id, char *buf, int len);
>  int nl_proto_a2n(__u32 *id, const char *arg);
>  
> diff --git a/include/uapi/linux/ppp_defs.h b/include/uapi/linux/ppp_defs.h
> new file mode 100644
> index 000000000000..0013dc77e3b9
> --- /dev/null
> +++ b/include/uapi/linux/ppp_defs.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * ppp_defs.h - PPP definitions.
> + *
> + * Copyright 1994-2000 Paul Mackerras.
> + *
> + *  This program is free software; you can redistribute it and/or
> + *  modify it under the terms of the GNU General Public License
> + *  version 2 as published by the Free Software Foundation.
> + */
> +
> +/*
> + * Protocol field values.
> + */
> +#define PPP_IP		0x21	/* Internet Protocol */
> +#define PPP_AT		0x29	/* AppleTalk Protocol */
> +#define PPP_IPX		0x2b	/* IPX protocol */
> +#define	PPP_VJC_COMP	0x2d	/* VJ compressed TCP */
> +#define	PPP_VJC_UNCOMP	0x2f	/* VJ uncompressed TCP */
> +#define PPP_MP		0x3d	/* Multilink protocol */
> +#define PPP_IPV6	0x57	/* Internet Protocol Version 6 */
> +#define PPP_COMPFRAG	0xfb	/* fragment compressed below bundle */
> +#define PPP_COMP	0xfd	/* compressed packet */
> +#define PPP_MPLS_UC	0x0281	/* Multi Protocol Label Switching - Unicast */
> +#define PPP_MPLS_MC	0x0283	/* Multi Protocol Label Switching - Multicast */
> +#define PPP_IPCP	0x8021	/* IP Control Protocol */
> +#define PPP_ATCP	0x8029	/* AppleTalk Control Protocol */
> +#define PPP_IPXCP	0x802b	/* IPX Control Protocol */
> +#define PPP_IPV6CP	0x8057	/* IPv6 Control Protocol */
> +#define PPP_CCPFRAG	0x80fb	/* CCP at link level (below MP bundle) */
> +#define PPP_CCP		0x80fd	/* Compression Control Protocol */
> +#define PPP_MPLSCP	0x80fd	/* MPLS Control Protocol */
> +#define PPP_LCP		0xc021	/* Link Control Protocol */
> +#define PPP_PAP		0xc023	/* Password Authentication Protocol */
> +#define PPP_LQR		0xc025	/* Link Quality Report protocol */
> +#define PPP_CHAP	0xc223	/* Cryptographic Handshake Auth. Protocol */
> +#define PPP_CBCP	0xc029	/* Callback Control Protocol */
> diff --git a/include/utils.h b/include/utils.h
> index 9765fdd231df..0c9022760916 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -369,4 +369,14 @@ void inc_indent(struct indent_mem *mem);
>  void dec_indent(struct indent_mem *mem);
>  void print_indent(struct indent_mem *mem);
>  
> +struct proto {
> +	int id;
> +	const char *name;
> +};
> +
> +int __proto_a2n(unsigned short *id, const char *buf,
> +		const struct proto *proto_tb, size_t tb_len);
> +const char *__proto_n2a(unsigned short id, char *buf, int len,
> +			const struct proto *proto_tb, size_t tb_len);
> +
>  #endif /* __UTILS_H__ */
> diff --git a/lib/Makefile b/lib/Makefile
> index 6c98f9a61fdb..ddedd37feb32 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -5,7 +5,7 @@ CFLAGS += -fPIC
>  
>  UTILOBJ = utils.o utils_math.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
>  	inet_proto.o namespace.o json_writer.o json_print.o json_print_math.o \
> -	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
> +	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o ppp_proto.o
>  
>  ifeq ($(HAVE_ELF),y)
>  ifeq ($(HAVE_LIBBPF),y)
> diff --git a/lib/ll_proto.c b/lib/ll_proto.c
> index 342ea2eefa4c..f067516cde9e 100644
> --- a/lib/ll_proto.c
> +++ b/lib/ll_proto.c
> @@ -28,10 +28,8 @@
>  
>  
>  #define __PF(f,n) { ETH_P_##f, #n },
> -static const struct {
> -	int id;
> -	const char *name;
> -} llproto_names[] = {
> +
> +static const struct proto llproto_names[] = {
>  __PF(LOOP,loop)
>  __PF(PUP,pup)
>  __PF(PUPAT,pupat)
> @@ -90,31 +88,16 @@ __PF(TEB,teb)
>  };
>  #undef __PF
>  
> -
> -const char * ll_proto_n2a(unsigned short id, char *buf, int len)
> +const char *ll_proto_n2a(unsigned short id, char *buf, int len)
>  {
> -        int i;
> +	size_t len_tb = ARRAY_SIZE(llproto_names);
>  
> -	id = ntohs(id);
> -
> -        for (i=0; !numeric && i<sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
> -                 if (llproto_names[i].id == id)
> -			return llproto_names[i].name;
> -	}
> -        snprintf(buf, len, "[%d]", id);
> -        return buf;
> +	return __proto_n2a(id, buf, len, llproto_names, len_tb);
>  }
>  
>  int ll_proto_a2n(unsigned short *id, const char *buf)
>  {
> -        int i;
> -        for (i=0; i < sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
> -                 if (strcasecmp(llproto_names[i].name, buf) == 0) {
> -			 *id = htons(llproto_names[i].id);
> -			 return 0;
> -		 }
> -	}
> -	if (get_be16(id, buf, 0))
> -		return -1;
> -	return 0;
> +	size_t len_tb = ARRAY_SIZE(llproto_names);
> +
> +	return __proto_a2n(id, buf, llproto_names, len_tb);
>  }
> diff --git a/lib/ppp_proto.c b/lib/ppp_proto.c
> new file mode 100644
> index 000000000000..1c035095f375
> --- /dev/null
> +++ b/lib/ppp_proto.c
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Utilities for translating PPP protocols from strings
> + * and vice versa.
> + *
> + * Authors:     Wojciech Drewek <wojciech.drewek@intel.com>
> + */
> +
> +#include <linux/ppp_defs.h>
> +#include <linux/if_ether.h>
> +#include "utils.h"
> +#include "rt_names.h"
> +
> +static const struct proto ppp_proto_names[] = {
> +	{PPP_IP, "ip"},
> +	{PPP_AT, "at"},
> +	{PPP_IPX, "ipx"},
> +	{PPP_VJC_COMP, "vjc_comp"},
> +	{PPP_VJC_UNCOMP, "vjc_uncomp"},
> +	{PPP_MP, "mp"},
> +	{PPP_IPV6, "ipv6"},
> +	{PPP_COMPFRAG, "compfrag"},
> +	{PPP_COMP, "comp"},
> +	{PPP_MPLS_UC, "mpls_uc"},
> +	{PPP_MPLS_MC, "mpls_mc"},
> +	{PPP_IPCP, "ipcp"},
> +	{PPP_ATCP, "atcp"},
> +	{PPP_IPXCP, "ipxcp"},
> +	{PPP_IPV6CP, "ipv6cp"},
> +	{PPP_CCPFRAG, "ccpfrag"},
> +	{PPP_CCP, "ccp"},
> +	{PPP_MPLSCP, "mplscp"},
> +	{PPP_LCP, "lcp"},
> +	{PPP_PAP, "pap"},
> +	{PPP_LQR, "lqr"},
> +	{PPP_CHAP, "chap"},
> +	{PPP_CBCP, "cbcp"},
> +};
> +
> +const char *ppp_proto_n2a(unsigned short id, char *buf, int len)
> +{
> +	size_t len_tb = ARRAY_SIZE(ppp_proto_names);
> +
> +	return __proto_n2a(id, buf, len, ppp_proto_names, len_tb);
> +}
> +
> +int ppp_proto_a2n(unsigned short *id, const char *buf)
> +{
> +	size_t len_tb = ARRAY_SIZE(ppp_proto_names);
> +
> +	return __proto_a2n(id, buf, ppp_proto_names, len_tb);
> +}
> diff --git a/lib/utils.c b/lib/utils.c
> index 53d310060284..6b88ba31b335 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -1925,3 +1925,37 @@ void print_indent(struct indent_mem *mem)
>  	if (mem->indent_level)
>  		printf("%s", mem->indent_str);
>  }
> +
> +const char *__proto_n2a(unsigned short id, char *buf, int len,
> +			const struct proto *proto_tb, size_t tb_len)
> +{
> +	int i;
> +
> +	id = ntohs(id);
> +
> +	for (i = 0; !numeric && i < tb_len; i++) {
> +		if (proto_tb[i].id == id)
> +			return proto_tb[i].name;
> +	}
> +
> +	snprintf(buf, len, "[%d]", id);
> +
> +	return buf;
> +}
> +
> +int __proto_a2n(unsigned short *id, const char *buf,
> +		const struct proto *proto_tb, size_t tb_len)
> +{
> +	int i;
> +
> +	for (i = 0; i < tb_len; i++) {
> +		if (strcasecmp(proto_tb[i].name, buf) == 0) {
> +			*id = htons(proto_tb[i].id);
> +			return 0;
> +		}
> +	}
> +	if (get_be16(id, buf, 0))
> +		return -1;
> +
> +	return 0;
> +}


Remove the __ from these new functions and add this in a refactoring
patch. Move the PPP additions into a new, standalone patch
