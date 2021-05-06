Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2273757F3
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhEFPyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhEFPyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:54:17 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C567C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 08:53:18 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id w15so7668723ljo.10
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlMZm8qP69Al3Joqv9S9RHvuIC1TNczNv8/63HOy14Y=;
        b=lU3c1d7i09G+aqfTgWg1p5jY0d7KLboFsL12CXrnwzUymoZyXDdekJ8KVpDrAiNRwA
         2vzcj0FeHDZpPNagY7v431D648vK72uvlMPVsZNFcT5tQ8+m37cr3ItPmmnOanXdAm1Z
         efte8mlzUJUZ9WWHL1pbiX5EyqZ0x4GsYIHPh1BCUBOOh35PgpdO143EaO259nRQnJIP
         w3RU1S/TWKg9dPXdDARBaLUxJsMyBm7pI8oOXPMC9jWfzmEfTCBjLDk87xGZgb27yAu+
         gzER+n20W3T25AEbaaTZTLPWv+gxyhKBZFj79M7J+LTPm8zwlrVeDOGJQJc9x66JJNd7
         4Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlMZm8qP69Al3Joqv9S9RHvuIC1TNczNv8/63HOy14Y=;
        b=k0iHfCWuFvepQX7HKA4fkhhfcZp7AXNbOQTUPM3jc+Izg/clzY2Iznhe92t44C0Dre
         Ai5UI2iMl/CZg5c3Yr66Eo59XOQ5/m+OAQyQUU7XjG27o2gDQf9X4T/09ASABpeJX4ru
         dxifG5/rsGZicmvA+L9HA1C7SQAjAsKMMGYV21wwaQaQX4QEkpz0EUtziFZSr+3bygp8
         wOpwk5ogT100NI3VQlqwIMHnRwvvmTq2vvIOVfg0uyxTHKj01Xa9p1Z4lY4p5q1CaQKa
         HW9+pmZ32uS+bVbS3N/+DITmxYtEs4glfARL9NsxJoRM034ZLwCr6gbvBUN12URomsE1
         0qxA==
X-Gm-Message-State: AOAM531eUa1bNzZoc5tT7+uI6/mUon00YvL2pJADTYGSAPOzeujOBk/p
        kkjF0kzEtbaK+x4hP5rh85CQ+phFl/7hLRvOJkw=
X-Google-Smtp-Source: ABdhPJyfG/oQ4khtx01U4GR6pJzAxrVuvV7s54Mk/7PqjTTGIOCe3gO/wmM1FXbH9acTYEJHieJ7neNSbRDN/353v2M=
X-Received: by 2002:a2e:8e66:: with SMTP id t6mr4079729ljk.481.1620316397211;
 Thu, 06 May 2021 08:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210505180808.20505-1-cpp.code.lv@gmail.com> <202105060934.AXpcx9gB-lkp@intel.com>
In-Reply-To: <202105060934.AXpcx9gB-lkp@intel.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Thu, 6 May 2021 08:53:06 -0700
Message-ID: <CAASuNyXeRdD-KzQiXZGsFdj4y38v1mXC8K+gJ3B3wOqfoeBvBQ@mail.gmail.com>
Subject: Re: [PATCH] net-next: openvswitch: IPv6: Add IPv6 extension header support
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry, wrong git tree.


On Wed, May 5, 2021 at 7:03 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Toms,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net/master]
> [also build test WARNING on ipsec/master ipvs/master net-next/master linus/master v5.12 next-20210505]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Toms-Atteka/net-next-openvswitch-IPv6-Add-IPv6-extension-header-support/20210506-021045
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 4c7a94286ef7ac7301d633f17519fb1bb89d7550
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> cocci warnings: (new ones prefixed by >>)
> >> net/openvswitch/flow.c:378:2-3: Unneeded semicolon
>
> Please review and possibly fold the followup patch.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
