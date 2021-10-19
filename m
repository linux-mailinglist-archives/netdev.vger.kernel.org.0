Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EAC433CCA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhJSQzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:55:51 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:39509 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhJSQzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:55:49 -0400
Received: by mail-oi1-f173.google.com with SMTP id s9so3552502oiw.6;
        Tue, 19 Oct 2021 09:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fnwMHmBtcUTzeN7AT8ukQSoNU1knCjzi3Fwq9Ac0g90=;
        b=HJdKu9Yc8oALg0EUXoUMBKenRfGSuc1q4BNOBnq1d3QPbXkCq0Q5jlBTo0ea8p8UZl
         TFoRbrGnbWaGpIrHbQBqSuwUjDBjln3eaN2Tq7E0W56vbVBbTfmfC0AToRtbsfbJrN2f
         TGQLAwhyx4BbOTgYtABGlXWrUetqHt59xqngUL10JUAD9n2+2D9oWEUJzviJL0Jxj5V5
         1ehW808u32vCVZl2iVvCq3srHVgLn+AvHiMGVaozwkhe/dawpGSKvp7qDZAT2I5VNhxs
         BJzngAMZ1t+SxOkjC/HJaDKF7a5CBdMUeB22usBCn/Xn19ZwnQcZOApGMc6tjISI+tdo
         6Amw==
X-Gm-Message-State: AOAM531GWuQFQ3L5WRDnGlhygdiI/0FEMysCTKio0KzcAOE7RqhVCKqw
        nUgroemq5t+BnedFQmoE8w==
X-Google-Smtp-Source: ABdhPJxG3M4MMDejwrse4k8mTAjT5I/40KR+eLLfq1+ZBF3yaKS308ugfGwsvK1xSATT6JQLbB2GBw==
X-Received: by 2002:a05:6808:1185:: with SMTP id j5mr5157383oil.16.1634662416108;
        Tue, 19 Oct 2021 09:53:36 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l26sm3843004oti.45.2021.10.19.09.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 09:53:35 -0700 (PDT)
Received: (nullmailer pid 427792 invoked by uid 1000);
        Tue, 19 Oct 2021 16:53:33 -0000
Date:   Tue, 19 Oct 2021 11:53:33 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Tony Luck <tony.luck@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Rob Herring <robh+dt@kernel.org>, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Shuah Khan <shuah@kernel.org>,
        Colin Cross <ccross@android.com>, Alex Shi <alexs@kernel.org>,
        Yonghong Song <yhs@fb.com>, Kees Cook <keescook@chromium.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, kvm@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        sparmaintainer@unisys.com,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v3 00/23] Fix some issues at documentation
Message-ID: <YW74Dez4/3cIbe1Q@robh.at.kernel.org>
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1634630485.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 09:03:59 +0100, Mauro Carvalho Chehab wrote:
> Hi Jon,
> 
> This series is against today's next (next-20211019) and addresses missing
> links to Documentation/*.
> 
> The best would be to have the patches applied directly to the trees that
> contain the patches that moved/renamed files, and then apply the
> remaining ones either later during the merge window or just afterwards,
> whatever works best for you.
> 
> Regards,
> Mauro
> 
> Mauro Carvalho Chehab (23):
>   visorbus: fix a copyright symbol that was bad encoded
>   libbpf: update index.rst reference
>   docs: accounting: update delay-accounting.rst reference
>   MAINTAINERS: update arm,vic.yaml reference
>   MAINTAINERS: update aspeed,i2c.yaml reference
>   MAINTAINERS: update faraday,ftrtc010.yaml reference
>   MAINTAINERS: update ti,sci.yaml reference
>   MAINTAINERS: update intel,ixp46x-rng.yaml reference
>   MAINTAINERS: update nxp,imx8-jpeg.yaml reference
>   MAINTAINERS: update gemini.yaml reference
>   MAINTAINERS: update brcm,unimac-mdio.yaml reference
>   MAINTAINERS: update mtd-physmap.yaml reference

Applied patches 3-12.

>   Documentation: update vcpu-requests.rst reference
>   bpftool: update bpftool-cgroup.rst reference
>   docs: translations: zn_CN: irq-affinity.rst: add a missing extension
>   docs: translations: zh_CN: memory-hotplug.rst: fix a typo
>   docs: fs: locks.rst: update comment about mandatory file locking
>   fs: remove a comment pointing to the removed mandatory-locking file
>   Documentation/process: fix a cross reference
>   dt-bindings: mfd: update x-powers,axp152.yaml reference
>   regulator: dt-bindings: update samsung,s2mpa01.yaml reference
>   regulator: dt-bindings: update samsung,s5m8767.yaml reference
>   dt-bindings: reserved-memory: ramoops: update ramoops.yaml references
