Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6E5A717
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF1Wjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:39:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34672 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1Wjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:39:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so7778019wrl.1
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3Ey3Y4ByMfizJAxXRBz5aXttJITy5aKIVc9GB+E8UY=;
        b=NNblCtqobC9C570A5Rbc3sgGCu6A8WsJDTxghRpiB42TdZ6HWoNvm06X3CXMWjjb5D
         +jS00grL3v9ColyI/e6n80xqCoHPOBUNlplJT2CwJ77aBsz0r/TrE7J3wWlw18irEbcU
         bCERF597+eqYFxiiTQkm3Te2D5UXPm0j8GNd9A7gG+OPmf4/BYJkr/ptKPlg+obZbl68
         5tTxSl+KrT2LWl6v4Vy5eozo4ivqqjnRSKHvd0jTrAPlnAyye7x0ZcJ/O0aRzgmbYYQE
         BPe04G4GPU5ePeQOXpwBytzgYekjHJm1wFk5po04bLQCwl9NR0tH7OraWc3+CenfTbim
         B2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3Ey3Y4ByMfizJAxXRBz5aXttJITy5aKIVc9GB+E8UY=;
        b=q5B1qRWGl4Ahnqr4egTZQEAPQf2TIopEA0AuNGk4vm3/Vwzgitkv8ZqdnRm5NXSVY+
         aMHyeBQ5oO7Xro9tfIRUu6zlz1VGaiF3SiHdQYdbig1ry6zYgcOWsMQZGe1oqZ5aT0oA
         KkZiWPRahr/D7ln4IPf/5a3wIgJR0FABM+OuyvFPqDNFRpCF5FG2WBuV7/NyZR1ZexCi
         +vaoqfBgyP8IG7sq/3uzvhZxUwoXEtAxJDqUsbrJNjrADrG5V6ippghaOZdB7pvROvag
         c51A+SjWscZnidnWQhU+rlP46L24ri8uLugQQDu3LRdvaIG2n1pL+6smY0CAPT/JGXR4
         5tXA==
X-Gm-Message-State: APjAAAXEpZJLMZ8KgJZyfhb0ab8aEw/JWZB5x4K1X8t/AFWN56g9kCgQ
        ZK8Fy+ze5Fu1/KRIKXHmUPWw7y+0yHaaUcPZgNinl2NYQKU=
X-Google-Smtp-Source: APXvYqzSI/O3y60faf/fTYDqZzrqI+tIndG8LUppC5/Z2vjwMBbbYNCW9VfU6t3+9PzWXy3sILiMhPsXx2pi998BEp0=
X-Received: by 2002:a5d:4909:: with SMTP id x9mr8693346wrq.226.1561761585452;
 Fri, 28 Jun 2019 15:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190627194250.91296-1-maheshb@google.com> <CACKFLi=9cY4aWLRgmsWbT9=AFQX2s5NFp35e7fWdfh35Yr2nfA@mail.gmail.com>
In-Reply-To: <CACKFLi=9cY4aWLRgmsWbT9=AFQX2s5NFp35e7fWdfh35Yr2nfA@mail.gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Fri, 28 Jun 2019 15:39:29 -0700
Message-ID: <CAF2d9jgr-pPm2p=TvLqUAa6v65vk82tXoA8XUeqWFQ7r8sa=pw@mail.gmail.com>
Subject: Re: [PATCHv2 next 0/3] blackhole device to invalidate dst
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 11:22 AM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Thu, Jun 27, 2019 at 12:42 PM Mahesh Bandewar <maheshb@google.com> wrote:
>
> > However, Michael Chan <michael.chan@broadcom.com> had a setup
> > where these fixes helped him mitigate the issue and not cause
> > the crash.
> >
>
> Our lab has finished testing these patches.  The patches work in the
> sense that no oversize packets are now passed to the driver with the
> patches applied.  But I'm not seeing these bad packets reaching the
> blackhole device and getting dropped there.  So they get dropped in
> some other code paths.  I believe we saw the same results with your
> earlier patches.
>
Thanks Michael for confirmation. I would say that is WAI. With the MTU
that low, I don't think .ndo_xmit for this device would ever be
triggered.
