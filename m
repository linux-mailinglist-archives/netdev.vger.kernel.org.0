Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA2C2583
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfI3QzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:55:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36041 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfI3QzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:55:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so5951226pfr.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQ5PoHAAz/ydjtjUiADmfaA6ywwQrUwXkJB8zfwKppI=;
        b=Y/rFnOlCbotMAk/hgn2CMTpa9RZ6Ewr3HU2nV06RqcNRs1WMPaucoXALh/KktpDw76
         /9moz7Uch8yc4H7Yc+zLjfFyximUz0/8lDsraAD+dJynCs8zUMbVCocX25k8ix4nIPMU
         YogwrS/JolfZxOGf91tK8NL/EPnaJtDvSOguVjvmXE5+LTf+nDoBbAKNNofsCMcPBLCQ
         4Gc4m6170fTN24g3kf2TuCKZUPU0304PeRpUAVDlmXheFzljiumOLEea7ViOx8gILa7I
         F1v29gJJOQ9702LyQ6ZDq3+EJcjcjYhpRhDcOPBvRKlAhgqL/SGLPTf4+eollQzfPAGi
         9irQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQ5PoHAAz/ydjtjUiADmfaA6ywwQrUwXkJB8zfwKppI=;
        b=NNC8TmTVFtUG0+NFXYsUsAKNbYfFb6TUKsw6J+B+MDXF30dLWOPTT72gFeDq3iD987
         BeM+poBaX/Iy6CYkAqhxxWmF61CUJ6SH9uA8BR6KUBecFyAX8oKMaOBrsv0xD15NvAsk
         vCiM3DAEsWiMWz9m4kQGskv0sc0CWspSZQB5ZhVRQeNtUKB3EINP/IASCHNigNTUj4sB
         /pDnimB36GMczQRAZKMNHHY/i4IQoLkaDpPz1Qomlw1iFDEvDqILQ1R/X0bhwmZKr/2A
         VjnfJhuk42Jfim/d4RR5bTRPz+0ZTmkXE7Ko/D8zWuXMCXqeE0Wi+9kjDmTqO9+KLHgy
         OxgQ==
X-Gm-Message-State: APjAAAXjKTRMTdBy3sQNSNalXSFYUfTwcl1dkyEc1y3ME+mcGl+BH3VO
        u9Dj4zF8E5Bz7Ol/Wpd1OMbEuw==
X-Google-Smtp-Source: APXvYqwjCDqBLEOPDPQWNw13mxD4oZsNLp3E6YocIt7Y38oBW3fCG6A4qPwyQDkOcNa8jx2+WWRGnQ==
X-Received: by 2002:a17:90a:b309:: with SMTP id d9mr253408pjr.8.1569862518487;
        Mon, 30 Sep 2019 09:55:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v44sm27124250pgn.17.2019.09.30.09.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 09:55:18 -0700 (PDT)
Date:   Mon, 30 Sep 2019 09:55:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930095516.0f55513a@hermes.lan>
In-Reply-To: <20190930162910.GI29694@zn.tnic>
References: <20190930141316.GG29694@zn.tnic>
        <20190930154535.GC22120@unicorn.suse.cz>
        <20190930162910.GI29694@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 18:29:10 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Sep 30, 2019 at 05:45:35PM +0200, Michal Kubecek wrote:
> > On Mon, Sep 30, 2019 at 04:13:17PM +0200, Borislav Petkov wrote:  
> > > I'm seeing this on i386 allyesconfig builds of current Linus master:
> > > 
> > > ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2  
> > 
> > This is usually result of dividing (or modulo) by a 64-bit integer. Can
> > you identify where (file and line number) is the __umoddi3() call
> > generated?  
> 
> Did another 32-bit allyesconfig build. It said:
> 
> ld: drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.o: in function `mlx5dr_icm_alloc_chunk':
> dr_icm_pool.c:(.text+0x733): undefined reference to `__umoddi3'
> make: *** [vmlinux] Error 1
> 
> The .s file then points to the exact location:
> 
> # drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:140:   align_diff = icm_mr->icm_start_addr % align_base;
>         pushl   %ebx    # align_base
>         pushl   %ecx    # align_base
>         call    __umoddi3       #
>         popl    %edx    #
>         popl    %ecx    #
> 
> HTH.
> 

Could also us div_u64_rem here?
