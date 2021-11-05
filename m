Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CBF4465A4
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbhKEP0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 11:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhKEP0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 11:26:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA214C061714;
        Fri,  5 Nov 2021 08:23:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t11so11232980plq.11;
        Fri, 05 Nov 2021 08:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dtxaiaqX8WBZCm8iJ4NOVFM1D7iO+vs2YKjl8WFcejc=;
        b=JDc4YDtQ+7lOLUeBklqjSnvvYcnQNeI6ZGGOh3iyW0GXvovezcuIpgYNNx8QjpqGL9
         6Sm0DN+DgepGAdXj7S+Am2cMKaL8dL1oipBoUhcA0df+uU13Tvao1DGpYU1h116ftA5w
         U8ONAHh2Fh6FIkqXYNyYIMlt2StU0TxO7EHcxFdAROA+FmKstxPJj2buXt8lVDjnHQ/1
         3/5RAZ9P+rc/w9CoUKHYQbbQvtiYZp7TP56vM1gjLcd1HBDhImelM2drUEvxi3XsPmV7
         YmZYkMyHuL13cI5qA3/yH0ASHwZ+yiEJFOnyhbsLoOj/FWY6LQ1voX2qsBXLOO1vApMI
         MDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dtxaiaqX8WBZCm8iJ4NOVFM1D7iO+vs2YKjl8WFcejc=;
        b=Fcx3EugN+xj0kqXDWImiJ7NChoMkjoycvT+GN0INo+yjQlo6mpB+pMrPamq2Tk6nUA
         xVRXRcS4ZmBgl3CoDMFU5Gedi1n439YJ2Re9Vq1pFBHyZGa2APBLyX4VRNAGeru7pW2q
         ra/ywW7pomMMBsS11L+t12zMmy+G5Wn5DfS1yXYene6vWMyprY3qFTqNXtd4cRNjkaHy
         S8hGvH1nCwRkgEaPG3BrS/LNyHzHB1xItuFUC79a8oLKAI/MDgHbfIAEmu8jaOur81WC
         hP5W7cW8GokTNAs4r0skm2rNAjoxoQx3HtNUkoun7Mr84w5V5CmOfmQk5+2QTOvjlH/4
         lvNw==
X-Gm-Message-State: AOAM530i2CLyWCfjRxL6mdrY47AWH+lpUGUGt0D5fHsDyetslnpUGlMu
        cv9SobUCK/RFqmieLMtyOtU=
X-Google-Smtp-Source: ABdhPJzdQjYpYbjXXxC2rfDwnMmafb5FVdnAUmvBClOKFeLkox1TwyRREtgEwJu/ipumOWQlUfC6CQ==
X-Received: by 2002:a17:903:408c:b0:142:45a9:672c with SMTP id z12-20020a170903408c00b0014245a9672cmr5560302plc.7.1636125838356;
        Fri, 05 Nov 2021 08:23:58 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id d7sm8415931pfj.91.2021.11.05.08.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 08:23:58 -0700 (PDT)
Message-ID: <6a6dd497-4592-7e28-72e0-ae253badba8b@gmail.com>
Date:   Fri, 5 Nov 2021 23:23:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, kpsingh@kernel.org,
        kernel test robot <lkp@intel.com>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-2-songliubraving@fb.com>
From:   Hengqi Chen <hengqi.chen@gmail.com>
In-Reply-To: <20211104213138.2779620-2-songliubraving@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Song

On 2021/11/5 5:31 AM, Song Liu wrote:
> In some profiler use cases, it is necessary to map an address to the
> backing file, e.g., a shared library. bpf_find_vma helper provides a
> flexible way to achieve this. bpf_find_vma maps an address of a task to
> the vma (vm_area_struct) for this address, and feed the vma to an callback
> BPF function. The callback function is necessary here, as we need to
> ensure mmap_sem is unlocked.
> 
> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
> safely when irqs are disable, we use the same mechanism as stackmap with
> build_id. Specifically, when irqs are disabled, the unlocked is postponed
> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
> bpf_find_vma and stackmap helpers.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

[...]

>  
> -BTF_ID_LIST(btf_task_file_ids)
> -BTF_ID(struct, file)
> -BTF_ID(struct, vm_area_struct)
> -
>  static const struct bpf_iter_seq_info task_seq_info = {
>  	.seq_ops		= &task_seq_ops,
>  	.init_seq_private	= init_seq_pidns,
> @@ -586,9 +583,74 @@ static struct bpf_iter_reg task_vma_reg_info = {
>  	.seq_info		= &task_vma_seq_info,
>  };
>  
> +BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
> +	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
> +{
> +	struct mmap_unlock_irq_work *work = NULL;
> +	struct vm_area_struct *vma;
> +	bool irq_work_busy = false;
> +	struct mm_struct *mm;
> +	int ret = -ENOENT;
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	if (!task)
> +		return -ENOENT;
> +
> +	mm = task->mm;
> +	if (!mm)
> +		return -ENOENT;
> +
> +	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
> +
> +	if (irq_work_busy || !mmap_read_trylock(mm))
> +		return -EBUSY;
> +
> +	vma = find_vma(mm, start);
> +

I found that when a BPF program attach to security_file_open which is in
the bpf_d_path helper's allowlist, the bpf_d_path helper is also allowed
to be called inside the callback function. So we can have this in callback
function:

    bpf_d_path(&vma->vm_file->f_path, path, sizeof(path));


I wonder whether there is a guarantee that vma->vm_file will never be null,
as you said in the commit message, a backing file.

If that is not something to be concerned, feel free to add:
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>

> +	if (vma && vma->vm_start <= start && vma->vm_end > start) {
> +		callback_fn((u64)(long)task, (u64)(long)vma,
> +			    (u64)(long)callback_ctx, 0, 0);
> +		ret = 0;
> +	}
> +	bpf_mmap_unlock_mm(work, mm);
> +	return ret;
> +}
> +
> +const struct bpf_func_proto bpf_find_vma_proto = {
> +	.func		= bpf_find_vma,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg1_btf_id	= &btf_task_struct_ids[0],
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_PTR_TO_FUNC,
> +	.arg4_type	= ARG_PTR_TO_STACK_OR_NULL,
> +	.arg5_type	= ARG_ANYTHING,
> +};
> +

[...]

Cheers,
--
Hengqi
