Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC341D9BAD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgESPu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 11:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgESPu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 11:50:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FACC08C5C0;
        Tue, 19 May 2020 08:50:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so1554973pjb.3;
        Tue, 19 May 2020 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AHB18FnKAoqJzm0hykNiv4yZDqIuhCRDkCqTAP0Fza4=;
        b=QnNPvhaHvPjBVI/mG9O+hAmqbMjquL9s/zmkb+9meC8rSuBDLe7FQ8nMwG+U8ZxSEi
         F6PjYH8sX+az7OnVlmnLh9hn1LLMNXj9d2qenWkcW+/W0YDcYh+rIXZM4W913siZRXuW
         KQKN897o5aLdFm/g8wz6Z/xwA92k2ifVjZOJn9V+2D9H/7LIyw3eX28YsA39YDdQGHJ8
         +ww4Ae9hT+klcE06nFRFvdahB4hoi5l4j8ZcV/g/Zi0zT6OGwvqMIrOo+Ya0/DU5BdQo
         DYH0rMRpgsLYv0T262RO87DhjL7iJRhbYvBHYuND/jI8xPNJNBt/maG7/bmhQGQrbtxa
         I9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AHB18FnKAoqJzm0hykNiv4yZDqIuhCRDkCqTAP0Fza4=;
        b=YpVXSdKVt4Sa0z6xeodaRR4y2gGy7DaD38egNGo5Z/oIfUpla+XX/XH+N2wTrWoGy4
         zf1Abub+X4Ai4kZOldGl6SA62mNgBG410djRkxS0vpMZh/5ToFl1NZIgVaBq8bdzZHsS
         F4Ul+2HORkhYpRntnHT20K1czaVuv3YRrayBNpX7dBKvfUCT+12/aFdNA7vcjv1SPLgA
         BjtcgW5htjVJdQUIeAiAMCqlqpiJLoRz5spvH0cKJtGUULH9sCX5ceVuVvUsSKLAeysv
         CQj80ko7E1Fjye7qWZPu0P3XvbYpoQND/oPrKtzyqUXcn5mPThh6/ICBqvj1RM3htMq7
         2xiA==
X-Gm-Message-State: AOAM5318LEkkmq+rzUfi6G92K5S+gh4ZhAm8izjGhlu6TV34CNk1BQNZ
        tW48zWGcxAys8Eze5valYdA=
X-Google-Smtp-Source: ABdhPJxcFDvvZRcc6B2dds0KSXBbh7Kpiwc0U5r6qb5JbXZg+WDQ8gRZfYUL49kKtBH7JSaQAfrzuA==
X-Received: by 2002:a17:902:599b:: with SMTP id p27mr129948pli.75.1589903426596;
        Tue, 19 May 2020 08:50:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7206])
        by smtp.gmail.com with ESMTPSA id s13sm7769280pfh.118.2020.05.19.08.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 08:50:24 -0700 (PDT)
Date:   Tue, 19 May 2020 08:50:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests/bpf: add general instructions for
 test execution
Message-ID: <20200519155021.6tag46i57z2hsivj@ast-mbp.dhcp.thefacebook.com>
References: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 12:23:10PM +0100, Alan Maguire wrote:
> Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
> are used, pahole is recent (>=1.16) and config matches the specified
> config file as closely as possible.  Document all of this in the general
> README.rst file.  Also note how to work around timeout failures.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/README.rst | 46 ++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
> index 0f67f1b..b00eebb 100644
> --- a/tools/testing/selftests/bpf/README.rst
> +++ b/tools/testing/selftests/bpf/README.rst
> @@ -1,6 +1,52 @@
>  ==================
>  BPF Selftest Notes
>  ==================
> +First verify the built kernel config options match the config options
> +specified in the config file in this directory.  Test failures for
> +unknown helpers, inability to find BTF etc will be observed otherwise.
> +
> +To ensure the maximum number of tests pass, it is best to use the latest
> +trunk LLVM/clang, i.e.
> +
> +git clone https://github.com/llvm/llvm-project
> +
> +Build/install trunk LLVM:
> +
> +.. code-block:: bash
> +  git clone https://github.com/llvm/llvm-project
> +  cd llvm-project
> +  mkdir build/llvm
> +  cd build/llvm
> +  cmake ../../llvm/
> +  make
> +  sudo make install
> +  cd ../../
> +
> +Build/install trunk clang:
> +
> +.. code-block:: bash
> +  mkdir -p build/clang
> +  cd build/clang
> +  cmake ../../clang
> +  make
> +  sudo make install
> +

these instructions are obsolete and partially incorrect.
May be refer to Documentation/bpf/bpf_devel_QA.rst instead?

> +When building the kernel with CONFIG_DEBUG_INFO_BTF, pahole
> +version 16 or later is also required for BTF function
> +support. pahole can be built from the source at
> +
> +https://github.com/acmel/dwarves
> +
> +It is often available in "dwarves/libdwarves" packages also,
> +but be aware that versions prior to 1.16 will fail with
> +errors that functions cannot be found in BTF.
> +
> +When running selftests, the default timeout of 45 seconds
> +can be exceeded by some tests.  We can override the default
> +timeout via a "settings" file; for example:
> +
> +.. code-block:: bash
> +  echo "timeout=120" > tools/testing/selftests/bpf/settings

Is it really the case?
I've never seen anything like this.
