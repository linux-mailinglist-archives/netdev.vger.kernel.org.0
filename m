Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F1382125
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 23:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhEPVTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 17:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhEPVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 17:19:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACF6C061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 14:18:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso2585443pjb.5
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 14:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kCIrbLqBtlAx7QY+Z5TKjspDHfrg/6kd7ctZWggV5PM=;
        b=BsnW1oG3Khg28ecYvJzBitBwRuebpVCVWjBhcgtph95AyDbG5vHYsGcDutQnPKn6Nv
         sebY6cOEGhaAf++GpctfWGqnZHbGe6vRAJr+sChtBncYIZWcgcm5LV3tA4pFw8Ss2YlV
         fP3UCMMT4Feor7w23nrG0yUnb7FNhmjQbAnYC6+kA6vs5qVv40y6Yvo5JVSwIWFKzfB4
         50IciilHLh3tDFow2ePfCEBm3/mq4sdxUyH0VjtwOP6qt3C8+7YyP6sXeRGmC0i54RnC
         YEEW8zIe6EoOoiGuzj5X/g+o4c2Y8tS0ETohsYq9YSrKPwQ0mEmhB3PPphrGrwh528SD
         JXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kCIrbLqBtlAx7QY+Z5TKjspDHfrg/6kd7ctZWggV5PM=;
        b=e8tmOzx92+rye4I27XjgIWfXj/ExH+38DeBBl1XS4nBt4ypYiy6RWRUugTgXWO0cg1
         T83C4tyzw7r6xZ2d7ifvV6q46Fj7IY3HDNwQKqyZeNtnE3C4I6+N/K3RM4KMRDAE8kha
         r+kZh/SNLY04tHoI3cmVvv+kGOv6+s5RL5jPXEuwUP7EhJqXI+awoyKENYndp2IjSzh0
         Lpx1m1YiV8XA5iryMGo31I8MDVXJeT0i0oZhUmFbCjxekcG1OBXqQ4lpJMdhoknIM0vq
         opuNQ+zvXGnFd8VjxCJ+VD/jhxGt9LomoRfkCKdoQzOSz/fIhyrX5hOLVnf5KsMuGq/T
         62LQ==
X-Gm-Message-State: AOAM531eKvEtj+KXxXgGPWMRJ2TrKWa98IZ0E04OvCjnYQNaHOyafyye
        u35ka1ENusmMB08nbduc8R3A2oBpU7EYcg==
X-Google-Smtp-Source: ABdhPJw9sANDjCF3OdRq1csxD5fSA8vFh3GeNAzm8X53CqS73e0jp6QSNnCXerAKQJrWF95bJPxl8Q==
X-Received: by 2002:a17:902:f548:b029:ee:8f40:ecc2 with SMTP id h8-20020a170902f548b02900ee8f40ecc2mr56736908plf.6.1621199891762;
        Sun, 16 May 2021 14:18:11 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id gm21sm10071952pjb.31.2021.05.16.14.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:18:11 -0700 (PDT)
Date:   Sun, 16 May 2021 14:17:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Crosscompiling iproute2
Message-ID: <20210516141745.009403b7@hermes.local>
In-Reply-To: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 May 2021 16:51:59 +0200
Frank Wunderlich <frank-w@public-files.de> wrote:

> Hi,
> 
> i want to crosscompile (a modified version of) iproute2 (git://git.kernel.org/pub/scm/network/iproute2/iproute2.git) for armhf
> 
> do you any idea how?
> configure-script seems to ignore "--host=arm-linux-gnueabihf" like i'm using for nftables
> 
> i modified Makefile
> 
> -CC := gcc
> +CC := arm-linux-gnueabihf-gcc
> 
> -SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
> +#SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
> +SUBDIRS=ip
> 
> and run make like this to use static linking:
> 
> make LDFLAGS=-static
> 
> but it seems ip always needs libutil
> 
> make[1]: *** No rule to make target '../lib/libutil.a', needed by 'ip'.  Stop.
> 
> if i include lib in SUBDIRS i get many errors about missing libs like selinux and mnl
> 
> regards Frank

It is possible to mostly do a cross build if you do:

$ make CC="$CC" LD="$LD"
There are issues with netem local table generation


