Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592E568FD08
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjBICWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBICWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:22:06 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE7023C7F;
        Wed,  8 Feb 2023 18:22:06 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id bx13so498023oib.13;
        Wed, 08 Feb 2023 18:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkOr+bC6GSE4PaFDcVf3s0vpXzrXW0xaXvgsA7MPZWk=;
        b=biy6dsKOzpwVgSKMng7nUmlYCPilwqbdgWPu3tM2z2kmflcS+BR0CXtV88c+Im2t2i
         aNWpcLsAwWSsKFmZsGYUmsFl5/AgkGpaMM+Aj7KOSkYfmadH+VyYSVKXsgssh+9QgfMV
         L2Q+kODbF2lqyr7CVAuAomT+kTmtU1IWuVEHzhdixg/oWWFL4sGhb+wGrZpbfn7lTt+1
         VxEmKYngWhDzYToD5t54s8zX5QHIJjFJD2BpQbB8Gtjppn7vxNysgZ0Mv1MMnNDdjQL2
         2AjvQfTHFcXp7+KkDD6POtsYC9nvl2oHMLUNNXIIyAEaKWvQFUAoBdjiJgKJwP7SWyLt
         cKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkOr+bC6GSE4PaFDcVf3s0vpXzrXW0xaXvgsA7MPZWk=;
        b=hPspt5nCtkguvi2xfW9RS1XN48guZgX1yYyvGGNV7V9auuejMqAS3rtq+FYrn08S5b
         6fcnVruFbHL8IY2wjCiToYk+GVVs6OYvSHSQC2aCEtjLuyNWuyZB8IZKhluefkOQSoHb
         jMCmWhq5hWoQC/EIuPtMthbXpkxJEg9burgnJ3flmv6g9hYkR0zUHb2GvkdQ2hZ8frT3
         /hUyV2ji38IUhLFe9fTVqbs9rB6rg4oR81rzuxQYQzbmdSFJ/kYNlGhWiFhcct67Mvpj
         KJdlh/2HpL7iPNR0XNfPaXk2NCqXcIWlL1HI9kpbo1dKvihS+Kq1wkOaxe2/TxJsGThc
         /J8w==
X-Gm-Message-State: AO0yUKVHX39RceLrMK+NtrTvCZTBHoQJTkaMkcUg6wzgR3/1PdBK4ZcG
        oG0Jn5t6jttPfyPWoM4IQ47kQNLSHMg=
X-Google-Smtp-Source: AK7set+582K3dQ59tYaRvLgQ3yiQ/b29vgJZASRoUfBCWHPHN7uVIprA+cA2ezCMPhnbwai2Eet5DA==
X-Received: by 2002:a05:6808:6197:b0:364:be69:fbc with SMTP id dn23-20020a056808619700b00364be690fbcmr4012464oib.9.1675909325214;
        Wed, 08 Feb 2023 18:22:05 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id h8-20020a056830164800b0068bb7bd2668sm29536otr.73.2023.02.08.18.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 18:22:04 -0800 (PST)
Date:   Wed, 8 Feb 2023 18:22:01 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: duplicate patches in the bitmap tree
Message-ID: <Y+RYyblnIL0Zrrwj@yury-laptop>
References: <20230209130224.76c7f357@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209130224.76c7f357@canb.auug.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 01:02:24PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> The following commits are also in the net-next tree as different commits
> (but the same patches):
> 
>   2386459394d2 ("lib/cpumask: update comment for cpumask_local_spread()")
>   a99b18849bc8 ("net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity hints")
>   af547a927f9f ("sched/topology: Introduce for_each_numa_hop_mask()")
>   439829e1bfba ("sched/topology: Introduce sched_numa_hop_mask()")
>   c0d13fba970d ("lib/cpumask: reorganize cpumask_local_spread() logic")
>   8ec0ffa233ab ("cpumask: improve on cpumask_local_spread() locality")
>   6139966175ca ("sched: add sched_numa_find_nth_cpu()")
>   ded3cee7db80 ("cpumask: introduce cpumask_nth_and_andnot")
> 
> These are commits
> 
>   2ac4980c57f5 ("lib/cpumask: update comment for cpumask_local_spread()")
>   2acda57736de ("net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity hints")
>   06ac01721f7d ("sched/topology: Introduce for_each_numa_hop_mask()")
>   9feae65845f7 ("sched/topology: Introduce sched_numa_hop_mask()")
>   b1beed72b8b7 ("lib/cpumask: reorganize cpumask_local_spread() logic")
>   406d394abfcd ("cpumask: improve on cpumask_local_spread() locality")
>   cd7f55359c90 ("sched: add sched_numa_find_nth_cpu()")
>   62f4386e564d ("cpumask: introduce cpumask_nth_and_andnot")
> 
> in the net-next tree.
> 
> There are some slight differences (I got a conflict merging the bitmap
> tree today), but the net-next series is newer than the bitmap tree one ...

I removed those from bitmap-for-next. Let's move with net-next.
