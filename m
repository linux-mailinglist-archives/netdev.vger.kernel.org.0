Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D271B2364
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgDUJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgDUJ44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:56:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23AD20CC7;
        Tue, 21 Apr 2020 09:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587463016;
        bh=oi16NvTlPCds/PtaCDgtDmjiWjDjytiV8+wJFUXnaRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LO3vhmg6ln0Ts9dMDyhTcqEhwMy3WWqr8hbcF+fHutcc65SOPbbt18yezpmyH1aio
         KbUOGrRcO/Hkbmd961cCQ6IB7Gg1O+vzj7Y3yNhEjIDbETM0oD+O18WH1cxw067Vst
         qFx2S7WU9VsVIgGzxNajYc87i1R30TFjSLSmMz04=
Date:   Tue, 21 Apr 2020 11:56:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Wang Wenhu <wenhu.wang@vivo.com>,
        Tim Stallard <code@timstallard.me.uk>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Taehee Yoo <ap420073@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 00/40] 4.19.117-rc1 review
Message-ID: <20200421095654.GD727481@kroah.com>
References: <20200420121444.178150063@linuxfoundation.org>
 <CA+G9fYsPaoo5YE9pAKV+w=MnZ_AGn93iquOC-tAN5arVyUD8FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsPaoo5YE9pAKV+w=MnZ_AGn93iquOC-tAN5arVyUD8FQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 03:54:20AM +0530, Naresh Kamboju wrote:
> On Mon, 20 Apr 2020 at 18:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.117 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.117-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> Regressions on x86_64.
> 
> x86_64 boot failed due to kernel BUG and kernel panic.
> It is hard to reproduce this BUG and kernel panic
> We are investigating this problem. The full log links are at [1] and [2].

THanks for testing all of these and if you find an offending commit for
this, please let me know.

thanks,

greg k-h
