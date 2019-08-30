Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F56A409D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfH3Wfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:35:45 -0400
Received: from mx3.ucr.edu ([138.23.248.64]:30154 "EHLO mx3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfH3Wfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 18:35:44 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2019 18:35:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1567204545; x=1598740545;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=wgVygESRDZ4+rg/c5sOJBi+QyyM3UkHfyRMFo8KoCxI=;
  b=bR4Yx9WRF2OABP8z4akZ/tCY9Vvbfmfrh9QHLv/c4+AzPRlcZT9ebhEI
   0zxeoQZyQs7lkbV/UUuprnGvbDVLaRj7P/I+BXzo5rgqFY/4NLkskfmbn
   RYaAE9el8P6tI4SvA7pc+WHs7AkRXQcAY4g29HiRaUcAEbxWelyDdE+mN
   UYcSi+UlXQSnwyWRsqtEhIMCFigGiKwt7TmB1UM0URxIOng8T7qhlOJ63
   JSJgb7JVxG5uCtQm13S8ArEsZJek13sbrE54PHfsc7g/Md4nkk05zFT3O
   95qM46fGFWZoJi0qZ+cSN1bDjOpphtzvrge0M+oBTr48SKQvTTSWNEv4X
   A==;
IronPort-SDR: 2h83xXi5c1FWL9hZWZTWmXMX9Gf2olsk+9dfttmY2+EbtFiRGRqT7fZKTy8GhEOVIQt16GTz4b
 0ec3vhJQq4x9KiCsxpBKHEgNpgV3hDkEYHxKHKp8+pgGVbQDP1cv8snORoWmRyzz5KJp3Vojex
 gMvOi/UlhxJMZksePCAgCaOGPADWCvzlt39qvu6elcXDw0oCBExTEU9YRqupRF/ey26onabrQe
 yISjtSESPDiqmzOTPBBbCys5eZGugL/Xx69H6Jzg7NeyUxfhfAzSumuwQNnHzpqL1V5XZ1tg8m
 vZ8=
IronPort-PHdr: =?us-ascii?q?9a23=3AaHUgzhAkwPjYUlJQya9kUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSPv9o8bcNUDSrc9gkEXOFd2Cra4d0ayP7f2rADVIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfK1+IA+roQjQtsQajpZuJrsswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwKLCAy/n3JhcNsjaJbuBOhqAJ5w47Ie4GeKf5ycrrAcd8GWW?=
 =?us-ascii?q?ZNW8BcXDFDDIyhdYsCF+UOPehaoIf9qVUArgawCxewC+701j9EmmX70bEm3+?=
 =?us-ascii?q?g9EwzL2hErEdIUsHTTqdX4LKUdUeG0zanI0DXDaO5d1jT96IfScxAqvPaBXL?=
 =?us-ascii?q?JxcMrR00YvFh/JgkmepIH+IjOayv4Nv3KF4OV9SOKikmgqoBxyrDi33soglJ?=
 =?us-ascii?q?XFi4YPxl3H9Sh12ps5KNy6RUJhYNOpFJ1dvDyAOYRsWMMtWWRotT4/yr0BpJ?=
 =?us-ascii?q?G0YjAHyI8ixx7Dc/yHdJWI4g77WOaRPzh4gHVldaq6hxmo8EigzvTwVs260F?=
 =?us-ascii?q?pXtyZFnNjBu3QX2xzc7ciHTfR9/kO/1jqVyw/T7eRELVg1lardNZEh3qY9mo?=
 =?us-ascii?q?QPvUnHBCP7m0X7gLWLekgl+OWk8eXqb7H+qp+ZLYB0iwX+Mqo0msy4BOQ1Kg?=
 =?us-ascii?q?gPXmmb+eum1b3v4VH1TbtRg/0rjqbZqorWKtoGqa6kGwNVyJos6w6jDze619?=
 =?us-ascii?q?QVhX8HI0xZeB2akYfpJUrDIO73DfihmVSgijRryO7cPr3nHJrNKmLPkLD7fb?=
 =?us-ascii?q?ZyuAZgz18fxM5e69pxC7UFLei7DkP4qtHdJhMwLQGxx+HpFJN7259ICkyVBa?=
 =?us-ascii?q?rMAaLAsUKPrtAvKujEMJ4HuD/8c6B+z+Pllzk0lUJLLvrh5ocedH3tRqcuGE?=
 =?us-ascii?q?6ee3e5x45ZSWo=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EPAACxomldgEWnVdFmHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBUwcBAQsBg1YzKoQhiByGb4IPk3aFJIF7AQgBAQEOLwEBhD8CgmEjNAk?=
 =?us-ascii?q?OAgMIAQEFAQEBAQEGBAEBAhABAQkNCQgnhUOCOikBgmcBAQEBAxIRVhALCwM?=
 =?us-ascii?q?GAQMCAh8HAgIiEgEFARwGEyKFC6FogQM8iySBMohuAQgMgUkSeigBi3eCF4N?=
 =?us-ascii?q?uNT6HT4JYBIEuAQEBjUCHFJYJAQYCgg0UjCuILBuYYi2mIg8hgS+CETMaJX8?=
 =?us-ascii?q?GZ4FOgnqOLSIwjzgBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EPAACxomldgEWnVdFmHAEBAQQBAQcEAQGBUwcBAQsBg?=
 =?us-ascii?q?1YzKoQhiByGb4IPk3aFJIF7AQgBAQEOLwEBhD8CgmEjNAkOAgMIAQEFAQEBA?=
 =?us-ascii?q?QEGBAEBAhABAQkNCQgnhUOCOikBgmcBAQEBAxIRVhALCwMGAQMCAh8HAgIiE?=
 =?us-ascii?q?gEFARwGEyKFC6FogQM8iySBMohuAQgMgUkSeigBi3eCF4NuNT6HT4JYBIEuA?=
 =?us-ascii?q?QEBjUCHFJYJAQYCgg0UjCuILBuYYi2mIg8hgS+CETMaJX8GZ4FOgnqOLSIwj?=
 =?us-ascii?q?zgBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="78119358"
Received: from mail-lf1-f69.google.com ([209.85.167.69])
  by smtp3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 15:28:37 -0700
Received: by mail-lf1-f69.google.com with SMTP id i13so1857274lfj.7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OqUmnBUo2TwngZckoAVX/16b3P4Ti0vmh5QbNPt/qI=;
        b=Zjh4SGpVYR+piopnwBVOH4Q5lkdWghRz9SyiBILs7mI+3ERKRFULlelwVI82ptxSBo
         kDiSZsXbpuFhrDSAHq5GmONPA2sJT06Fp/JS1T8NoREOwQgi510xNgNdwCNhRMp+bCxP
         pPs/2bJhdsOe6c28tlgBZNaqV00Ncr/AZPTGaO2yI948D+x/pvKc2IMlMR6ZHMgDLaDY
         1l6yxqQ2X6NTaA/AFRoq44yGz/qLY/Br3lZ7Cc63qNoUpVHHP0nc0LLvFEtZCw+ENBUC
         c06TyOnl8NNpSez3QBeo6vAjMOMhviMnN29/6KREnNTSjxpfzHgmceQFnpZXH5ONqWNv
         CTDg==
X-Gm-Message-State: APjAAAX6RZSJ0iBOiK5jZz6dnE4tNjuzIsT4xNSrSdlXB0vDeYuBlZy1
        eSq4vVKDegOIt+/DoiTkA4aB1OkwYj6kuXy/LOqois7gdg3lObWCHnO/FfdXzhu2rJdqAtiUnZv
        OuL4zuM8TeM2YT8om4ZcrJ+Btstm7jRVCBQ==
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr11134401lfp.15.1567204115688;
        Fri, 30 Aug 2019 15:28:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwa33Y9Bu9hA8LxhW9Vg/wJim85Pk0no7AsHr9XFg9pLsGspx5AJcu+yjlmeSKNUIJl9tL56jCgdsQd0GJsEII=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr11134392lfp.15.1567204115524;
 Fri, 30 Aug 2019 15:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190207174623.16712-1-yzhai003@ucr.edu> <20190208.230117.1867217574108955553.davem@davemloft.net>
In-Reply-To: <20190208.230117.1867217574108955553.davem@davemloft.net>
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Fri, 30 Aug 2019 15:29:07 -0700
Message-ID: <CABvMjLRzuUVh7FxVQj2O40Sbr+VygwSG8spMv0fW2RZVvaJ8rQ@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: Variable "val" in function
 sun8i_dwmac_set_syscon() could be uninitialized
To:     David Miller <davem@davemloft.net>
Cc:     Chengyu Song <csong@cs.ucr.edu>, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David:

Thanks for your feedback, this patch should work for v4.14.


On Fri, Feb 8, 2019 at 11:01 PM David Miller <davem@davemloft.net> wrote:
>
> From: Yizhuo <yzhai003@ucr.edu>
> Date: Thu,  7 Feb 2019 09:46:23 -0800
>
> > In function sun8i_dwmac_set_syscon(), local variable "val" could
> > be uninitialized if function regmap_read() returns -EINVAL.
> > However, it will be used directly in the if statement, which
> > is potentially unsafe.
> >
> > Signed-off-by: Yizhuo <yzhai003@ucr.edu>
>
> This doesn't apply to any of my trees.



--
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
