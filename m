Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827F421F07
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhJEGs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEGs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD43061019;
        Tue,  5 Oct 2021 06:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633416427;
        bh=p+bxFa9xSUFSlIjdgl60SpyfsYPInsp9KUGfqqbVv/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ovnn4WniriHw1xTQMn9Op6ILCRY/LtA1cBgiwfnUKsr2RPiCxEOFuWmPeG5vhGBnN
         UpEJprQLhp9tXeaS120CKPSb4H7yAmbVNqkOKHthmrUxxKHwD/xWKzY6x4r7fMFGgS
         9lwpiErvX5YBK/eqgKHrXCYpHcfZkC4VbQCG2tXk=
Date:   Tue, 5 Oct 2021 08:47:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
Message-ID: <YVv06WGg0LR1/e/W@kroah.com>
References: <20211004125033.572932188@linuxfoundation.org>
 <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
 <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 10:44:50AM -0700, Eric Dumazet wrote:
> On Mon, Oct 4, 2021 at 10:40 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Mon, 4 Oct 2021 at 18:32, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.209 release.
> > > There are 95 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regression found on arm, arm64, i386 and x86.
> > following kernel crash reported on stable-rc linux-4.19.y.
> >
> 
> Stable teams should backport cred: allow get_cred() and put_cred() to
> be given NULL.
> 
> f06bc03339ad4c1baa964a5f0606247ac1c3c50b
> 
> Or they should have tweaked my patch before backporting it.

Thanks, I have now queued that up, it was not obvious that was a
prerequisite for your change :)

greg k-h


