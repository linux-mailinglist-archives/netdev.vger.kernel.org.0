Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9128EC42
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgJOE3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOE3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:29:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC12FC061755;
        Wed, 14 Oct 2020 21:29:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h4so1153813pjk.0;
        Wed, 14 Oct 2020 21:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9ZoAVfqbflRLpkXrUCWqnTItWukjEplCwqKSdU8/gNY=;
        b=f+nyTiPowS1e0Zr1/HEQUk8JPAOTObUdAO0SiPrz7Uj/dW4n3QvVjL8mFrCwVhnmK6
         jyZQCVWOvLmruMA5k2Y2+l45oOnfUT70E9X0H8Hu9LtKSuK2lJzFrPDcZTB3UsIqqhM9
         ctzFDYrS5cBRJm1Kk5FFXtcj7SJ55wXZasoQV2Y4+X8xuVOpO4H7KOEjE4aZlNICQuk6
         7Ugldn8OfA3ecqgDoEnpDuZzQK2CB0ACvkc9FxL+9CKTBZBFlO+MM/R7D/8F48DGBrHi
         2FPFqlkdfwwzudIkHPeQkt0+HBEFCiURm4VGwl3dvss6EEWylXSwoW+PJv6wpLXhE8QI
         zlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ZoAVfqbflRLpkXrUCWqnTItWukjEplCwqKSdU8/gNY=;
        b=NBXKHR9zfbEphKmbYCWp54FGPVM6lAYMkHMMI3fxmJuV9Ns1pL8xxTeX2NNgn1epJW
         Bn40GNMg9ARwKPM1MTDSu1qVViC+7cRmWrG8BR9/lz89mBaA8LsjekaCKggpXUC1lMwo
         6dWQWZgQKyhsaNdaDe6XyCHPS43SP9Jm+uRr2rKwR4s9/+HXlT9wAKoyFiyDKwXmsI1A
         XYCucukFRssGLtuTwi2J5rq8i4V6h6FfiRj2HxgXN9GmAIPQf4BnQ5qU0494f4SAnhY9
         g1mlmz/T/JvGOloX1e+5Y5/+fQ8oQ0rBMDl9/wJK22GXcDj59g5DkMr3bNvA9ZMqv9B7
         MLZQ==
X-Gm-Message-State: AOAM532dylPUXZFC1irvTbgPtpcab+msA/63p2k7xbrOZqPJW9M2N41Q
        NwY3Swuwt6QvTN0/sp5BZNk=
X-Google-Smtp-Source: ABdhPJwdLLwHRo/RdhrZNjjwLIMAx50gxpf8n1CcimKJhIf65X6Wjig6RXwm0FxX7o7OUHwiGX4+zA==
X-Received: by 2002:a17:90a:c796:: with SMTP id gn22mr2578655pjb.224.1602736171197;
        Wed, 14 Oct 2020 21:29:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f594])
        by smtp.gmail.com with ESMTPSA id w17sm1321383pga.16.2020.10.14.21.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:29:30 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:29:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Message-ID: <20201015042928.hvluj5xbz3qxqq6r@ast-mbp.dhcp.thefacebook.com>
References: <20201014043638.3770558-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014043638.3770558-1-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 09:36:38PM -0700, Song Liu wrote:
> Fix the following error when compiling selftests/bpf
> 
> progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
> 
> pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
> error by renaming pids_cgrp_id as pids_cgroup_id.
> 
> Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/testing/selftests/bpf/progs/profiler.inc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> index 00578311a4233..b554c1e40b9fb 100644
> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_node* node)
>  	}
>  }
>  
> -int pids_cgrp_id = 1;
> +int pids_cgroup_id = 1;

I would prefer to try one of three options that Andrii suggested.

>  static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
>  					 struct task_struct* task,
> @@ -262,7 +262,7 @@ static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
>  				BPF_CORE_READ(task, cgroups, subsys[i]);
>  			if (subsys != NULL) {
>  				int subsys_id = BPF_CORE_READ(subsys, ss, id);
> -				if (subsys_id == pids_cgrp_id) {
> +				if (subsys_id == pids_cgroup_id) {
>  					proc_kernfs = BPF_CORE_READ(subsys, cgroup, kn);
>  					root_kernfs = BPF_CORE_READ(subsys, ss, root, kf_root, kn);
>  					break;
> -- 
> 2.24.1
> 
