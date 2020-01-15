Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A644B13D0A5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgAOX0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:26:31 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52318 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgAOX0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:26:31 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so629575pjh.2;
        Wed, 15 Jan 2020 15:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zdml4UeLEt0s/1BLRCQY3uiyNW6whOFDg1JrZMFRe+k=;
        b=ba211we2+vdKuAuSUqJdcl526e7qKNQB/cjbuvV0FwuKGSkRGCuACVLQ5NmWM6awSo
         PfO/Hkb/gCIaH61OrjvRY8EFJUSmvPU0wHTuxj523dZd4zBh6xIYBsk1DLYHxJ91wG88
         rzvoHKhqLezIiveDSrLYYRWIrYch+U7n3dhlObowknOTb52TN96mMeMpk++Ov+J5+yQ3
         JWEu7HQa3YquJnrFnnuah7oLNvhhc32U4MjhRz0hMg3Qhx6pixXQP6eT2YjWpP9tn6Ou
         CJdUP9Nqx0cXRZ+I+qeRApDSoyBHb1VhceRcXvBnbGNCDjviFLdxuLl33N6uhPMs34Ka
         LS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zdml4UeLEt0s/1BLRCQY3uiyNW6whOFDg1JrZMFRe+k=;
        b=nhjSzRsiX+CVtf4q6Dgbm3Zf9PdmCkytVhoxmjXiUF0E9W799rZKGlOPa4Y6icpDeN
         DU6ti/iZ19C0JCNLiXM8BuA6F2v4/WDMpsizhUYRI1pUp+Gxm2XkdJsxjhZKpw4X6MOm
         2s6mVvswM9lGb91P6UmS1Ta/B23OGi7qUcJqKLbKAOLuWs1BMSCkbMTtQ9wijBILo10K
         s8KIRzoXrrFufhOS2/596S55dQcmyS0vDAgD4xOevLj36Lv6PNLUPI/8dzHlYNH82gYt
         D8ZvzW/ZEhJZWftUQCH+hhxIXKDXFlfB0mbpojEeWDfwbfkiVrJJnEdi9gSPjHD129c3
         dp4g==
X-Gm-Message-State: APjAAAUZbU6JI610y+cLxlH5DO0teHHeMhCw5czYOB2JBDSR7UY5duGY
        tlbGA88w++FKsE8tB3TUh2A=
X-Google-Smtp-Source: APXvYqyCgs4oi/ryRUaLYW4oKuzkhEyawPem25BwP6bRI+ZirmVy13l5/6i8quPKdYjXU/3WKalMhw==
X-Received: by 2002:a17:902:bd87:: with SMTP id q7mr21397922pls.239.1579130790308;
        Wed, 15 Jan 2020 15:26:30 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:e760])
        by smtp.gmail.com with ESMTPSA id r20sm21576905pgu.89.2020.01.15.15.26.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 15:26:29 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:26:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 0/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Message-ID: <20200115232626.x5qzdvmx2d3d4abl@ast-mbp.dhcp.thefacebook.com>
References: <20200115230012.1100525-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115230012.1100525-1-kafai@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 03:00:12PM -0800, Martin KaFai Lau wrote:
> When a map is storing a kernel's struct, its
> map_info->btf_vmlinux_value_type_id is set.  The first map type
> supporting it is BPF_MAP_TYPE_STRUCT_OPS.
> 
> This series adds support to dump this kind of map with BTF.
> The first two patches are bug fixes which are only applicable to
> bpf-next.
> 
> Please see individual patches for details.
> 
> v3:
> - Remove unnecessary #include "libbpf_internal.h" from patch 5

I think the subj of patch 3 is fine as-is.

Applied. Thanks
