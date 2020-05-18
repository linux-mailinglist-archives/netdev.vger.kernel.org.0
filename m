Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352D81D8959
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgERUgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgERUgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:36:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C204C061A0C;
        Mon, 18 May 2020 13:36:04 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 79so12193300iou.2;
        Mon, 18 May 2020 13:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9Os6SzRQrB2OOLMRxiUNsGN9aSHljvXdgezlaPSqbFU=;
        b=kFherxfhjVpJo4b7nUnO0nXmEvXRdxRkfb124ZXoSbWlDM6oyNIpHpnRl4MAeetrDG
         ATu9D1rn1nF2VvjRkm1LRTlcGrM/UG0y/N3fjU28tQWzOyPchgx+KoJ8XGEWoVc/JgHk
         WkruYcUJE0aLwNV61+I2TKI6HdcBXRO656B4aY5HqXPZ55cjtwqiPj8Kp8EpZqTCYI5v
         MbM0+Ipmqq/v2dfqnO5W+E/45dy2Cyr7NlPad/x1rIaaSL7SU5ynavY9DV1fMSsDYnlk
         urS37ZYxVDN0SpQqWbPw9w8Xj40/npE9LEB2kLYs1cc8lY6ujKDNvmWElcfeHx3N6z3v
         PsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9Os6SzRQrB2OOLMRxiUNsGN9aSHljvXdgezlaPSqbFU=;
        b=Ztm9hCVPwhlZbSqt9synjP6fg5uiox8HQzBMSFs8fyJgUs2AJz38YNlK7BEmR3ONZP
         rSfAqg9nSweXUk04ftoNtsFxnTutNaKi3Z0GFfyj/DHQ59B98+TCFP4d9/o0Q+iVwkVf
         b5ki0+iUtAbTqhnxF2EHwGLmAHMvyiuIznVWSh1oKamK9zhm9299ztPVTsr8zQe6I3ug
         RjkxnZN3evasIBY7DnST8VhbvNywqQnXOTIT5aMztaXv50f6rOT+UjKnp6WlYWAEmozj
         ywREbmIcewCDOD8ocKFYAX/kEbqtXicVZ1mv2EBw0uZbvNW7za+beavWkQe93hWTmRZN
         uInQ==
X-Gm-Message-State: AOAM531A9nu8oeshwiBmnzJNjlom5l8EcrTrL9pJi1RRuaK+BqV28Jl8
        Bq2K++8sC8jHZujLBj1Q2Os=
X-Google-Smtp-Source: ABdhPJxBlKC2agC8MVuEawSK0SdXhPEaJmIWIyQ/g2xw6l6yeui87N2VxZDV5JduXaaDlEJdRHnfrQ==
X-Received: by 2002:a02:b149:: with SMTP id s9mr15923078jah.81.1589834163624;
        Mon, 18 May 2020 13:36:03 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q19sm4220431ioh.28.2020.05.18.13.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 13:36:02 -0700 (PDT)
Date:   Mon, 18 May 2020 13:35:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Message-ID: <5ec2f1a9a9e6a_47112aee592725b435@john-XPS-13-9370.notmuch>
In-Reply-To: <158983215367.6512.2773569595786906135.stgit@john-Precision-5820-Tower>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
 <158983215367.6512.2773569595786906135.stgit@john-Precision-5820-Tower>
Subject: RE: [bpf-next PATCH 1/4] bpf: verifier track null pointer
 branch_taken with JNE and JEQ
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Current verifier when considering which branch may be taken on a
> conditional test with pointer returns -1 meaning either branch may
> be taken. But, we track if pointers can be NULL by using dedicated
> types for valid pointers (pointers that can not be NULL). For example,
> we have PTR_TO_SOCK and PTR_TO_SOCK_OR_NULL to indicate a pointer
> that is valid or not, PTR_TO_SOCK being the validated pointer type.

[...]

> Because at 51->53 jmp verifier promoted reg6 from type PTR_TO_SOCK_OR_NULL
> to PTR_TO_SOCK but then at 62 we still test both paths ignoring that we
> already promoted the type. So we incorrectly conclude an unreleased
> reference. To fix this we add logic in is_branch_taken to test the
> OR_NULL portion of the type and if its not possible for a pointer to
> be NULL we can prune the branch taken where 'r6 == 0x0'.
> 
> After the above additional logic is added the C code above passes
> as expected.
> 
> This makes the assumption that all pointer types PTR_TO_* that can be null
> have an equivalent type PTR_TO_*_OR_NULL logic.

I can send a v2 to update the last sentence here it is not true with code
below. Initially I thought to negate reg_type_may_be_null() so that the
guard in the branch_taken on this logic was

 if (__is_pointer_value(false, reg)) {
    if (!reg_type_may_be_null(reg->type))
       return -1;

But this pulls in other pointers which are meaningless in this context.
For example PTR_TO_STACK, PTR_TO_BTF_ID, etc. I think its easier to avoid
thinking about these contexts and also safer to just be explicit and
built a new type filter, reg_type_not_null() below. Better name suggestions
welcome.

> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  0 files changed

With the v2 I'll fix this '0 files changed' issue here messed up my
branch mgmt a bit here when moving patches around.

Will wait a bit though to catch any other feedback.

Thanks,
John

> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 180933f..8f576e2 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -393,6 +393,14 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
>  		type == PTR_TO_XDP_SOCK;
>  }
>  
> +static bool reg_type_not_null(enum bpf_reg_type type)
> +{
k> +	return type == PTR_TO_SOCKET ||
> +		type == PTR_TO_TCP_SOCK ||
> +		type == PTR_TO_MAP_VALUE ||
> +		type == PTR_TO_SOCK_COMMON;
> +}
> +
>  static bool reg_type_may_be_null(enum bpf_reg_type type)
>  {
>  	return type == PTR_TO_MAP_VALUE_OR_NULL ||
> @@ -1970,8 +1978,9 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
>  	if (regno >= 0) {
>  		reg = &func->regs[regno];
>  		if (reg->type != SCALAR_VALUE) {
> -			WARN_ONCE(1, "backtracing misuse");
> -			return -EFAULT;
> +			if (unlikely(!reg_type_not_null(reg->type)))
> +				WARN_ONCE(1, "backtracing misuse");
> +			return 0;
>  		}
>  		if (!reg->precise)
>  			new_marks = true;
> @@ -6306,8 +6315,26 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
>  static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
>  			   bool is_jmp32)
>  {
> -	if (__is_pointer_value(false, reg))
> -		return -1;
> +	if (__is_pointer_value(false, reg)) {
> +		if (!reg_type_not_null(reg->type))
> +			return -1;
> +
> +		/* If pointer is valid tests against zero will fail so we can
> +		 * use this to direct branch taken.
> +		 */
> +		switch (opcode) {
> +		case BPF_JEQ:
> +			if (val == 0)
> +				return 0;
> +			return 1;
> +		case BPF_JNE:
> +			if (val == 0)
> +				return 1;
> +			return 0;
> +		default:
> +			return -1;
> +		}
> +	}
>  
>  	if (is_jmp32)
>  		return is_branch32_taken(reg, val, opcode);
> 


