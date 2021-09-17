Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E750640FD82
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbhIQQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:03:46 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:60339 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhIQQDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:03:45 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4H9zHK4mhlz9sTL;
        Fri, 17 Sep 2021 18:02:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id coLvZUmcxDrI; Fri, 17 Sep 2021 18:02:21 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4H9zHK3tmvz9sSX;
        Fri, 17 Sep 2021 18:02:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 702578B799;
        Fri, 17 Sep 2021 18:02:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id AkNN26PrTgUl; Fri, 17 Sep 2021 18:02:21 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.202.36])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2A60E8B768;
        Fri, 17 Sep 2021 18:02:20 +0200 (CEST)
Subject: Re: [PATCH v2 1/8] bpf powerpc: Remove unused SEEN_STACK
To:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-2-hbathini@linux.ibm.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <c14c6111-ffe3-f8e9-f9d3-5a5f101096ba@csgroup.eu>
Date:   Fri, 17 Sep 2021 18:02:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917153047.177141-2-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 17/09/2021 à 17:30, Hari Bathini a écrit :
> From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> 
> SEEN_STACK is unused on PowerPC. Remove it. Also, have
> SEEN_TAILCALL use 0x40000000.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
> 
> * No changes in v2.
> 
> 
>   arch/powerpc/net/bpf_jit.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
> index 99fad093f43e..d6267e93027a 100644
> --- a/arch/powerpc/net/bpf_jit.h
> +++ b/arch/powerpc/net/bpf_jit.h
> @@ -116,8 +116,7 @@ static inline bool is_nearbranch(int offset)
>   #define COND_LE		(CR0_GT | COND_CMP_FALSE)
>   
>   #define SEEN_FUNC	0x20000000 /* might call external helpers */
> -#define SEEN_STACK	0x40000000 /* uses BPF stack */
> -#define SEEN_TAILCALL	0x80000000 /* uses tail calls */
> +#define SEEN_TAILCALL	0x40000000 /* uses tail calls */
>   
>   #define SEEN_VREG_MASK	0x1ff80000 /* Volatile registers r3-r12 */
>   #define SEEN_NVREG_MASK	0x0003ffff /* Non volatile registers r14-r31 */
> 
