Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26F3E3776
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhHGWus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 18:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhHGWun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 18:50:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88750C061760;
        Sat,  7 Aug 2021 15:50:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so25099965pji.5;
        Sat, 07 Aug 2021 15:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=uEem7psRvM7YsBApVUOIYNX9Q3BxPkvG81EmDGqOa9s=;
        b=N9IES7qCgsNkrW/7jSSrTnkTQSYBHoyCYvBGetifVfUNrX8wXw6sERlAP8taH+i2zW
         VreBpQswl30ZTDEKo9ubDqhnKR4MGU1zbgQXZ/rNwMOIiBt4KdEsjCs4kl9QagcKQA/n
         phVqqkZbWyRsrmMEjB9qlrBopnPk8joNV/Qf/jUy+8P0a6yra+8nt9lWvrgReAPo8wlf
         js0IAx9DEa3iNLOEjbgj/1o3quIVfBofnnyULTRcG0zToVHix/eV4mbUtLLLTwbmZREe
         4OrQ3Zx88qszNlElZrYUgetb0k8ANPf3GnpSmYTycKz0UpKOuH50G+JDQY0iA+KX0Ipp
         CN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=uEem7psRvM7YsBApVUOIYNX9Q3BxPkvG81EmDGqOa9s=;
        b=jjYwJDtCcDeUYA08JiRr7t2uQuFA/KyEHRL9w8LwA0sBZ3rrbbTqBk7FuDR8+5C6Rh
         YtHTc+Nw3IyLzbI432J3WEQwRk64GDZWr9AcTI7AFKU3qOYq9VPiReP+eGmuZrnFdbcI
         drVsNw+QkWfM/jBtsrKTGISVRyxCrAYXAM6ZkvfdDlFMJzdZlGW5hGxKLmxdhkeJr1JW
         tRPATYaaa8KKe+6I/HTeOYQ1WjgoFki8NCQlhDIUDNxoPY/3yKjo1Y/hIVdhgFmX3izI
         ReT2KzjNBwwsU62x5U5q6pCKEw9L63v1mK9k9i1ni0YQWe8hkjaM79WjzlnfSeQYaoQp
         4ZGA==
X-Gm-Message-State: AOAM530+tbDF9IsZ7I3pigbiOSGtC/CWNwO2Xc9w6gXKEqBa05sWhKa0
        KGcD311G334+GDyY8Wbnz+fUJcsae6Q=
X-Google-Smtp-Source: ABdhPJy9UlLVGkcYgyLrV9r1YxVDfu1PzXTl1kbZkqY3lWe00Gf4nUWjbWZNHRWFNzd/ZIfjiW2jIg==
X-Received: by 2002:a17:90a:ea82:: with SMTP id h2mr17383874pjz.99.1628376623850;
        Sat, 07 Aug 2021 15:50:23 -0700 (PDT)
Received: from [10.1.1.25] (222-152-189-37-fibre.sparkbb.co.nz. [222.152.189.37])
        by smtp.gmail.com with ESMTPSA id b15sm17880465pgj.60.2021.08.07.15.50.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Aug 2021 15:50:23 -0700 (PDT)
Subject: Re: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
To:     Cai Huoqing <caihuoqing@baidu.com>, davem@davemloft.net,
        kuba@kernel.org, arnd@arndb.de, geert@linux-m68k.org, jgg@ziepe.ca
References: <20210807145619.832-1-caihuoqing@baidu.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
Date:   Sun, 8 Aug 2021 10:50:16 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20210807145619.832-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cai,

a number of the 8390 drivers are still in active use on legacy 
architectures. These drivers get occasional updates (not just bugfixes, 
but support for 'new' network cards - I have a patch to add X-Surf 500 
support somewhere in the pipline).

Removing the 8390 drivers would leave most m68k legacy systems without 
networking support.

Unless there is a clear and compelling reason to do so, these drivers 
should not be removed.

Cheers,

	Michael

Am 08.08.2021 um 02:56 schrieb Cai Huoqing:
> commit <0cf445ceaf43> ("<netdev: Update status of 8390 based drivers>")
> indicated the 8390 network drivers as orphan/obsolete in Jan 2011,
> updated in the MAINTAINERS file.
>
> now, after being exposed for 10 years to refactoring and
> no one has become its maintainer for the past 10 years,
> so to remove the 8390 network drivers for good.
>
> additionally, 8390 is a kind of old ethernet chip based on
> ISA interface which is hard to find in the market.
>
> Cai Huoqing (2):
>   net: ethernet: Remove the 8390 network drivers
>   MAINTAINERS: Remove the 8390 network drivers info
>
>  MAINTAINERS                           |    6 -
>  drivers/net/ethernet/8390/8390.c      |  103 --
>  drivers/net/ethernet/8390/8390.h      |  236 ----
>  drivers/net/ethernet/8390/8390p.c     |  105 --
>  drivers/net/ethernet/8390/Kconfig     |  212 ---
>  drivers/net/ethernet/8390/Makefile    |   20 -
>  drivers/net/ethernet/8390/apne.c      |  619 ---------
>  drivers/net/ethernet/8390/ax88796.c   | 1022 ---------------
>  drivers/net/ethernet/8390/axnet_cs.c  | 1707 ------------------------
>  drivers/net/ethernet/8390/etherh.c    |  856 -------------
>  drivers/net/ethernet/8390/hydra.c     |  273 ----
>  drivers/net/ethernet/8390/lib8390.c   | 1092 ----------------
>  drivers/net/ethernet/8390/mac8390.c   |  848 ------------
>  drivers/net/ethernet/8390/mcf8390.c   |  475 -------
>  drivers/net/ethernet/8390/ne.c        | 1004 ---------------
>  drivers/net/ethernet/8390/ne2k-pci.c  |  747 -----------
>  drivers/net/ethernet/8390/pcnet_cs.c  | 1708 -------------------------
>  drivers/net/ethernet/8390/smc-ultra.c |  629 ---------
>  drivers/net/ethernet/8390/stnic.c     |  303 -----
>  drivers/net/ethernet/8390/wd.c        |  574 ---------
>  drivers/net/ethernet/8390/xsurf100.c  |  377 ------
>  drivers/net/ethernet/8390/zorro8390.c |  452 -------
>  drivers/net/ethernet/Kconfig          |    1 -
>  drivers/net/ethernet/Makefile         |    1 -
>  24 files changed, 13370 deletions(-)
>  delete mode 100644 drivers/net/ethernet/8390/8390.c
>  delete mode 100644 drivers/net/ethernet/8390/8390.h
>  delete mode 100644 drivers/net/ethernet/8390/8390p.c
>  delete mode 100644 drivers/net/ethernet/8390/Kconfig
>  delete mode 100644 drivers/net/ethernet/8390/Makefile
>  delete mode 100644 drivers/net/ethernet/8390/apne.c
>  delete mode 100644 drivers/net/ethernet/8390/ax88796.c
>  delete mode 100644 drivers/net/ethernet/8390/axnet_cs.c
>  delete mode 100644 drivers/net/ethernet/8390/etherh.c
>  delete mode 100644 drivers/net/ethernet/8390/hydra.c
>  delete mode 100644 drivers/net/ethernet/8390/lib8390.c
>  delete mode 100644 drivers/net/ethernet/8390/mac8390.c
>  delete mode 100644 drivers/net/ethernet/8390/mcf8390.c
>  delete mode 100644 drivers/net/ethernet/8390/ne.c
>  delete mode 100644 drivers/net/ethernet/8390/ne2k-pci.c
>  delete mode 100644 drivers/net/ethernet/8390/pcnet_cs.c
>  delete mode 100644 drivers/net/ethernet/8390/smc-ultra.c
>  delete mode 100644 drivers/net/ethernet/8390/stnic.c
>  delete mode 100644 drivers/net/ethernet/8390/wd.c
>  delete mode 100644 drivers/net/ethernet/8390/xsurf100.c
>  delete mode 100644 drivers/net/ethernet/8390/zorro8390.c
>
