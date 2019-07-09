Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87886390E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGIQHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:07:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40200 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfGIQHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:07:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so9512948pfp.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a2DLaUEaOKgGOvV8tI8UdDVB4ztPQnYhRDfhaHbkhuo=;
        b=jUZr6JEk1SwQqMONTF5QUie+BJhtzUnrCR8GCX9UnpIWphlIgeOS0IqIks1lHH2py0
         udJN9Aer8lPdFtGZ883viqBmr3Y+ml4Ncn3zPGbWozWMKVSkQnf5pEklY0iSDnU8jXJB
         cUobhJhicRnk7eQakAozSgBryzEW+zQ/bhu2CRuOFqr6+D2TcSZLQ2FIEvIgKYxruzXX
         /olexdKZqBVh7YInjzURXuBmniGs6Me2HPwvYjr5eZbQXj4J1S2WdoNFN37O8M22h7p0
         9eY3OiZXQKRehjaQYp3cV8bZrIe+KYpRG6q2B8HUe1cQqvcmX8f8c6FIclNNDbk7v46s
         3QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a2DLaUEaOKgGOvV8tI8UdDVB4ztPQnYhRDfhaHbkhuo=;
        b=KGHx215okWtIRxt7wjdmCk27zF6X3g9hZPUv1mu0e0V9f0KPa8qq4uj308gE69aFK8
         YGwPvS6oXp5AY6A5cOmu5c+Eaps1EN0yk5oF5Qg5vAFMGUjxs+rFyjv99U9UEX1AqFQW
         j3hRtWWyP0TKYqjQzSlFh/zUhGRMQ66wjsOkHS7oS8A0l1MiV8HPiKuNZT+hD9qOlmas
         wzAjYf0cKwf4pXjQTqEM1awFUC0lyfi8NSTXMHgXVc4/Zz7Qcu1SMMnL4c5QU91vrwqs
         x+17+b74TmxVXcuJ+fEFQXpGydSM5tnkdS0rHUtke629seFBJA/5dG5xK5cbTFMLEF9l
         hpnw==
X-Gm-Message-State: APjAAAU7U4uGl1d+ny0e6mJerQdqVHty+lhnGiNmq2RChYWbaevsEZve
        R5Te5uez0kdI8M6AR8zhqt7FVQ==
X-Google-Smtp-Source: APXvYqxt5OpKGxNnpvl9UGD+HaosbKnw16D4fMAgwdfS3YVx15plA0HwzRmgFXXG2wQm8J5VxtqfCQ==
X-Received: by 2002:a17:90a:338b:: with SMTP id n11mr908432pjb.21.1562688458622;
        Tue, 09 Jul 2019 09:07:38 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o15sm21894671pgj.18.2019.07.09.09.07.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 09:07:37 -0700 (PDT)
Date:   Tue, 9 Jul 2019 09:07:37 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH v3 bpf-next 0/4] selftests/bpf: fix compiling
 loop{1,2,3}.c on s390
Message-ID: <20190709160737.GA22061@mini-arch>
References: <20190709151809.37539-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709151809.37539-1-iii@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09, Ilya Leoshkevich wrote:
> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
> 
> This patch series consists of three preparatory commits, which make it
> possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.
> 
> Since the last time, I've tested it with x86_64-linux-gnu-,
> aarch64-linux-gnu-, arm-linux-gnueabihf-, mips64el-linux-gnuabi64-,
> powerpc64le-linux-gnu-, s390x-linux-gnu- and sparc64-linux-gnu-
> compilers, and found that I also need to add arm64 support.
> 
> Like s390, arm64 exports user_pt_regs instead of struct pt_regs to
> userspace.
> 
> I've also made fixes for a few unrelated build problems, which I will
> post separately.
> 
> v1->v2: Split into multiple patches.
> v2->v3: Added arm64 support.
For the whole series:

Reviewed-by: Stanislav Fomichev <sdf@google.com>

This should probably go to bpf, not bpf-next since it fixes the
existing compilation problem.

> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> 
> 
