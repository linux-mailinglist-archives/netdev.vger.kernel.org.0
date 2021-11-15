Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C104645067A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhKOOVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhKOOUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:20:36 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC4EC061570;
        Mon, 15 Nov 2021 06:17:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id o4so15088129pfp.13;
        Mon, 15 Nov 2021 06:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+aDIq7mXZHK+RlyKih0pkpnCUcfMGHr49uqFeuSXHro=;
        b=mlKlfu92peTp/1KS46hBctFzV+s+5JJZ79aLeL+8YqVrT9RIlLn5OwGrmUC5Z5bJBv
         Yranh4tQT/wfcYZGYw8fIPPaCIomGRzRysRJVBx7RFiU42mmlQQsAoZscoIJGV4tW0J7
         GOOq+J9XB6NTr0bkfVfcPK0R0oqaubQQU3IuwFEwhmnr5HvFtNHN1KgIx9e1lPejk7d1
         BVfYUU90tupr2jUAG/IV3eT9HRRl2FreUGxpYgg0snpkpyhZPY0zKEDwoAWSRO3nkptp
         S++IkMyib4gU1klh9b9NYcEuElwO0O0y5//w8KxtuEVsOXMo91ti2fzWYMGYEu9sO2VK
         AunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+aDIq7mXZHK+RlyKih0pkpnCUcfMGHr49uqFeuSXHro=;
        b=1XpbLFdx5i7en5nbk/zCXB+btSqGlmiweHpamPv9qu2NgvkMlFa3uGD+/7NmVfmcAQ
         zcDyxlT4AucnHSW0jA5QX+rR9HOqd9kZDjeBANDu1TasLH4lFmC/LiQYLw06d8OiRIyW
         3Mwybc+lurITJ6fJjk0ld3N+sq28jAgczY3Fm5pGywC9WNtP8DtEm1+lSfwuosItyLsU
         cIjRt8GgKibA7FDd0GOplPziA6oy/KfFSXZJR/nCKSpsHR5Afials0j32rlGMJ1SS86F
         fHb9LK4b1S1/BJ3+Kprb9lXrXanXeBR/fz0i7yYxq59ex6X67RzkJYxzCPGAy5scgrLF
         Ggaw==
X-Gm-Message-State: AOAM530QVHDFllB3SLHNhv4Byp59gSoqt1o4bZeS82Hg+hi2qc1TJOB2
        Qi2SZyu4hjScN+iOZMXAM6s=
X-Google-Smtp-Source: ABdhPJzwYeSA1M7+Fx0lb7Vz5Gu8SyfHSiqr/5e7hOzVowVqcWxz3+pHBPpPzDNU8uZiRkTyBH1LDw==
X-Received: by 2002:a05:6a00:15c1:b0:49f:d21f:1d63 with SMTP id o1-20020a056a0015c100b0049fd21f1d63mr32672826pfu.18.1636985858948;
        Mon, 15 Nov 2021 06:17:38 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id w129sm15167238pfd.61.2021.11.15.06.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 06:17:38 -0800 (PST)
Date:   Mon, 15 Nov 2021 19:47:35 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ast@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: "resolve_btfids: unresolved" warnings while building v5.16-rc1
Message-ID: <20211115141735.o4reo2jruu73a2vf@apollo.localdomain>
References: <1b99ae14-abb4-d18f-cc6a-d7e523b25542@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b99ae14-abb4-d18f-cc6a-d7e523b25542@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 07:04:51PM IST, Pavel Skripkin wrote:
> Hi, net/bpf developers!
>
> While building newest kernel for fuzzing I met following warnings:
>
> ```
>   BTFIDS  vmlinux
> WARN: resolve_btfids: unresolved symbol tcp_dctcp_kfunc_ids
> WARN: resolve_btfids: unresolved symbol tcp_cubic_kfunc_ids
> WARN: resolve_btfids: unresolved symbol tcp_bbr_kfunc_ids
>   SORTTAB vmlinux
>
> ```
>
> I haven't seen such warnings before and have no idea are they important or
> not. Config is attached.
>
> My host is openSUSE Tumbleweed with gcc (SUSE Linux) 10.3.1 20210707
> [revision 048117e16c77f82598fca9af585500572d46ad73] if it's important :)
>
>

I'll take a look later today.

>
> With regards,
> Pavel Skripkin

--
Kartikeya
