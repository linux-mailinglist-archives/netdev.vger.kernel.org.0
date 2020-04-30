Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205EC1BF0A9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 08:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD3G7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 02:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726337AbgD3G7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 02:59:47 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C48FC035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:59:46 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id e25so5289356ljg.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DRuLB2fMbj1dQhXxpCJoy01gyg+HAGfCja4rwpDmXiQ=;
        b=bGnmqiEXN5JEywLdrad8Cv7Tmr/XJB+j+LMkBIt3U0oWAEfkHqQWptoVuWBKWUWXTW
         ugGo+Ael2ZtcpkGpacHgUbTlfyI2+P+CUHiXEPQGgFIhtA3yTizgE/QjPXPuOIPmq+Cx
         aIqvtWjnFQBaIC4frAt51L2zn5PBmyblaN3lzA5UtUfo3t28GSUxHcvY/+1Y18xpNjVt
         3cT+GkoKI2HH5H1WVDpZckDAyx6j779vqaOGl2J5fyxCDF196kg8GheUzAPIu4wnj0zJ
         lI15BfD60M9v9dOnTp3Ly/uyUzmrdE1rsUBhSfUoxeGENMyibomPM784hTi0BKuH/kQ0
         h7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DRuLB2fMbj1dQhXxpCJoy01gyg+HAGfCja4rwpDmXiQ=;
        b=PLZpJ/smPd4ijjtVr4CvPxCKaN2eCEwhngWdTNz4H07GhgeO/YHgV65h39Uq44adlI
         6Chs2m4OEv9e8FhmmH2io74yFRVn+vMCcSbi0eSElstfalAUyK+JlQdN+O14T98yGv3i
         hEg8N40W1T2A4GMl5CpbFpjHuVxV5WyW4FT+Rg7bQhbI14e0oYKC7jGp4x+AEmYICXav
         M+SIRamgn0/FvZ6zudpnr8Za8CDjopexIblczugvLnXeZFcCxlsYv6EM58wyqGxYLISX
         GPyEsksvKw61KTFE3w6HbuRCLByDcDXSbknHhQl8sTeptWOHrIMS59EtJXT+bZABaFFj
         xJJA==
X-Gm-Message-State: AGi0PubpfzKX04rvIxxAZjhmgueCuBVAwxOuvzI5jOV75LSZ3TVo0fRf
        BbH5zXfr0wUAdW+0zF/jp0SRmwFEul/KGwd60+9r3hkV
X-Google-Smtp-Source: APiQypJDx11YDF++eRVsdmkmUsFG6/9JRJBD4llOigjEEAXUuXhc8PiFCBW968ay7ndVym2C1iNNCw39z1xgKsruIc4=
X-Received: by 2002:a2e:8658:: with SMTP id i24mr1121344ljj.287.1588229984305;
 Wed, 29 Apr 2020 23:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200428060206.21814-1-xiyou.wangcong@gmail.com> <20200428060206.21814-3-xiyou.wangcong@gmail.com>
In-Reply-To: <20200428060206.21814-3-xiyou.wangcong@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 30 Apr 2020 15:59:33 +0900
Message-ID: <CAMArcTVvDfF8rOkrbHd_82NydB9KikD01WYrJGX+Tfv=QS1u6A@mail.gmail.com>
Subject: Re: [Patch net-next 2/2] bonding: remove useless stats_lock_key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 at 15:02, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,
Thank you for this work!

> After commit b3e80d44f5b1
> ("bonding: fix lockdep warning in bond_get_stats()") the dynamic
> key is no longer necessary, as we compute nest level at run-time.
> So, we can just remove it to save some lockdep keys.
>
> Test commands:
>  ip link add bond0 type bond
>  ip link add bond1 type bond
>  ip link set bond0 master bond1
>  ip link set bond0 nomaster
>  ip link set bond1 master bond0
>
> Reported-and-tested-by: syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Taehee Yoo <ap420073@gmail.com>
