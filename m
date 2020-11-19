Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293582B924C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 13:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgKSMNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 07:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgKSMNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 07:13:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0449C206CA;
        Thu, 19 Nov 2020 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605787990;
        bh=YbzJp5AMK9z88hcsktSOd88hRueoWtYXU2IjjbIiBCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6Xs7ts5C3/99g9gS4+mcp1ePY8hQd9BxXi2oUvBBXwotCIF92NjTV7CFoIxG1E4s
         9JtQLEkNknkHe9faoqToaAPpjaSBrE9qm9lzix+wvr4vbqlesOi2e4SLRSjhHAJcSj
         tIMM5+Iwfw0Kr9S3FbGxd7TNtsUtCFTf4ZK+clQ0=
Date:   Thu, 19 Nov 2020 13:13:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 5.9 000/255] 5.9.9-rc1 review
Message-ID: <X7ZhguSg3BaII1BU@kroah.com>
References: <20201117122138.925150709@linuxfoundation.org>
 <CA+G9fYt+YNy=34HLHpDrc6=73Nhu14NEf7AP+woyZryny+b-2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt+YNy=34HLHpDrc6=73Nhu14NEf7AP+woyZryny+b-2Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:55AM +0530, Naresh Kamboju wrote:
> On Tue, 17 Nov 2020 at 19:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.9 release.
> > There are 255 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these and letting me know.

greg k-h
