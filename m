Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF1D80742
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbfHCQer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 12:34:47 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46997 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388572AbfHCQer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 12:34:47 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so50766721lfh.13
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 09:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eyxZxTomFfPbWiAetqtPgtMLib3xCsrhPFW0Jq8wnRg=;
        b=iz0qO4UN7zyLqHo40MXBXd7Setl4+0wgO/gaZKtH3sD9HlstoLG0PIUFyRqjR8TMlu
         dbjYr7sGFfjWcExujVX8pXfDR/7B1sqwjQixpvtoh9VfgO/TmoNGtraHMdMGWpmEOkGG
         tHaSfjIErv+Sg4L+aBIK7iLVjpmJYptTBlxBMM8s6s0cT3DRHfG19cmnb+EBG//IpXOP
         Yd85J0fxUMh/ZLYh0BIUQdRe40+buDZVF8Bw6/YJHK8gbeqobkNYHWdYlsaOoGCF4phS
         3zM3SUsMsr5JEdbSU8hFfEC2SIanAW8uv+9dvTFBhmvZFaxklRWKwCcUqpU4CZlu1GRk
         n3zQ==
X-Gm-Message-State: APjAAAWPMB/J4fmTSZm1xDtK4tAtFz4pYOIFVWKMmyhVoWdOQ/hCodXO
        cZjMmwB/91F8AA9Hmll9nm6WYeMDsjfI9ofT1u0ekB7o
X-Google-Smtp-Source: APXvYqy2Yn4aNBXqRTmW3Ppvae/bzICtUWoK0tK6vCVVBLGba1dgdveQnO4z/rXVFxBcOKGNWGfaP8kwPA571wDc03U=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr28943779lfy.56.1564850085457;
 Sat, 03 Aug 2019 09:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190723012303.2221-1-mcroce@redhat.com>
In-Reply-To: <20190723012303.2221-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 3 Aug 2019 18:34:09 +0200
Message-ID: <CAGnkfhwen3p9T3mNL3w6dQcLFFDUtfn4g-j=6yoda2o+TpGR5w@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: use shared sysctl constants
To:     netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 3:23 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> Use shared sysctl variables for zero and one constants, as in commit
> eec4844fae7c ("proc/sysctl: add shared variables for range check")
>
> Fixes: 8f14c99c7eda ("netfilter: conntrack: limit sysctl setting for boolean options")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
>

followup, can anyone review it?

Thanks,
-- 
Matteo Croce
per aspera ad upstream
