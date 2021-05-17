Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93551383D8E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 21:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhEQThy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 15:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhEQThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 15:37:54 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F759C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 12:36:37 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id n40so7017479ioz.4
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 12:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4v2V7azcGbzrCl29TLY1oXgzrrkKk8pui1+Aba8QRDk=;
        b=uUxF6Ovix+av6a2eqPYJGxNCEbAum/Bus9BKGwvk2jDmWKM6rl9o1nLpi6qNVXNpbo
         2vmcXBqBHleqt6YkGm8tnmMRKlFYgipLeeFK3P/L1wiIv1VyAcx1WE7W4QAQKQzOHVpc
         pn/86ZozC87SKsUSvHA5n8Z4KbTI0bPS9+JF7Fe22Yf4ScwthScraD5vVzJT7vweuprJ
         xIzemv8AAWjV9KZLtM/89PooupZwV5FRtCfYpUrspU4rBH2pkD1vPs/S0KMl+zaRq8P4
         n99MdgGVh1MB3ZYxZW1SuOEMRyNN5OktsbPdFwMkxJjQfqox9vIeqNfO2Jf5nIb7AQsA
         wUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4v2V7azcGbzrCl29TLY1oXgzrrkKk8pui1+Aba8QRDk=;
        b=a3BNmBDn3ym4+eFOx6qQEiWl+6LeeJOM+4nXEn22wpXBH2yIwVaYp4/IDO9ZlkzNw/
         ryJ9p6QNxKhQE6Yg+NTn10x5Zo9T62Vor4kfJGuUkCLY6TAmvJWdOgPHhI9KPGKLSvr8
         GFWygLfxof4xi0LiCmPA0XA+aF3vLmtR1aW22waTvMgEM0FZ47AjjoeS6rg/4ANsHdor
         r3aiIUSQ9dbmwOHjm4aOXToAPuPhnfcAroLbP1QH26oKSYDp0EwOS7dl4Ol4Yiacw4Eb
         uW7eNHEwrNozwY49+UW+NZeLMInXzL74TFhrdG48FGf4p89xbLzBVuJUz5p8bQkSPnmq
         ke1A==
X-Gm-Message-State: AOAM530AyKj53k+LecITnCtXz8dwuJVIIyNX8oQnHx1wuOCwbPoL3dBa
        JL5/7o0aHyzETgQ3jtm9OMiKIbG00ZP1Eg==
X-Google-Smtp-Source: ABdhPJze+g861//OtKiQoXlx+xwPnn6Zc5EePp41j5tHrdvB60/BjoFtnlCFT7NOerOXzl0JZuQQ+A==
X-Received: by 2002:a02:7f57:: with SMTP id r84mr1648786jac.108.1621280197096;
        Mon, 17 May 2021 12:36:37 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 67sm7789412iow.16.2021.05.17.12.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:36:36 -0700 (PDT)
Date:   Mon, 17 May 2021 12:36:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Crosscompiling iproute2
Message-ID: <20210517123628.13624eeb@hermes.local>
In-Reply-To: <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
        <20210516141745.009403b7@hermes.local>
        <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 May 2021 09:44:21 +0200
Frank Wunderlich <frank-w@public-files.de> wrote:

> > Gesendet: Sonntag, 16. Mai 2021 um 23:17 Uhr
> > Von: "Stephen Hemminger" <stephen@networkplumber.org>  
> 
> > It is possible to mostly do a cross build if you do:
> >
> > $ make CC="$CC" LD="$LD"
> > There are issues with netem local table generation  
> 
> Hi,
> 
> thank you for your answer, but with this way i got this:
> 
> ./normal > normal.dist
> ./normal: error while loading shared libraries: libm.so.6: cannot open shared object file: No such file or directory
> 
> i guess it's the netem issue you've mentioned, imho i cannot install armhf-libs on ubuntu, so i disabled subdirs in Makefile beginning with netem
> 
> -SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
> +SUBDIRS=lib ip tc bridge misc
> +#netem genl tipc devlink rdma dcb man vdpa
> 
> it seems to did it now
> 
> $ file ip/ip
> ip/ip: ELF 32-bit LSB executable, ARM, EABI5 version 1 (GNU/Linux), statically linked, BuildID[sha1]=b36e094bc8681713d91ffe3a085ad4d3c6a1c5ea, for GNU/Linux 3.2.0, not stripped
> 
> thank you
> 
> regards Frank

Cross compile needs to know the compiler for building non-cross tools as well.
This works for me:

make CC="$CC" LD="$LD" HOSTCC=gcc

