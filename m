Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469CBC257C
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbfI3QxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:53:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41228 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729964AbfI3QxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:53:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so4131768plr.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f+nerH7/3f5jVInNGQWz0pf5Q2oTiewZHT4IGh7OAlM=;
        b=u24PiQrBZ9wkrsV1JyAofa5Q/EtOFdvZVmwLAYLNZ041sgLRL+F7Ex2m9gS9K3t9Vo
         fqjokZE6O8IHOJteak/MSW7MxymZLGwq29nwKsot1G/AZpYLR+UlA5DaP8lsBirxjyDE
         HqvE4I9kK/ZE/0Da9LZeSHurwnqwLVJrfttCQnuVLoUG26SlonXpq1fPk3PMQ4OpClMZ
         3rHwZCRrpKOGjaAffxwDtfC1ZiM++dBtdlA5htmxlIfgZ5qg3IkNK0oGAcNrhoGuX7er
         XaFaGMlGqRQlYK17Aew5KelSOZ8qHErlYDRp+6FIr2F1VPdZIvgyvtpMq5oc5JNEuVYu
         nsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f+nerH7/3f5jVInNGQWz0pf5Q2oTiewZHT4IGh7OAlM=;
        b=U4tCTmbwyy3Ma7k59KNkwgkCnZlTolYrU6zuuRhAvzM7UITu6EgzDP4E5dzJlAqslt
         TzyN592X0rgO+xIMj/hdMAmHdHNSynx9XZZ67fu7CjFWWgBmssWVqP10JmWGxmdRnFHI
         sd1DxNBG+mdnxd+zEMcOwFGDxBwvd4K10UZ+7g5K3jrZejOolZtdrO1HjjRDqoAFcXst
         b3c2/ybyN4CJjwByeBY8/5lm1mAO+qMxwMzEfQI94snqoVkXWyzsdMjlX+FoB2M4COkd
         GtufE9yv8UkJBBN67vcD4HQc7NmR3M8emWb/pOVGcVrvxfASIHY4ulHj6BhFmygrmqB1
         6KKA==
X-Gm-Message-State: APjAAAWGCyjVw2m0esjn6daIxIgDYrcT0WqukZAHoNZdZsgTZyvL44ox
        6ASiPW9CoDf47I/+g2ibRQp/eg==
X-Google-Smtp-Source: APXvYqzS2SQCyITvMRpLg6lGb2f95ywFpL74G4S5Pm3QeC98Yx2Q4IidhLo77R+Fa5fDC2DN0+eJ+A==
X-Received: by 2002:a17:902:7003:: with SMTP id y3mr21428242plk.239.1569862386118;
        Mon, 30 Sep 2019 09:53:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h8sm12990265pfo.64.2019.09.30.09.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 09:53:06 -0700 (PDT)
Date:   Mon, 30 Sep 2019 09:52:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930095258.1db16eb2@hermes.lan>
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

Since align_base is a power of 2 masking should work as well.
