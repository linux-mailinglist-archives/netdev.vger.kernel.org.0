Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7319BECE
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgDBJmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 05:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgDBJmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 05:42:47 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6C72072E;
        Thu,  2 Apr 2020 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585820566;
        bh=Ocr0IjWqiJFKmYYQ7OMkFAY+dmCRv305czhSy6FmIIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KCLS2ZJ5f+xGIYsOjo6xopsQtTpQmpvdCzLszXHg0WALU9yy4jUWn5COFAGig84Jn
         DTHmnJsijX99dgWnRfxhi1y8v+n46oHmy9M37cA81HKYxw2FdiGV3n1nFTuU44JNfm
         4/ym/T3Vw59zCVGwIHGeKnng5UYSeV9LRTpj9OLU=
Date:   Thu, 2 Apr 2020 10:42:40 +0100
From:   Will Deacon <will@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     davem@davemloft.net, arnd@arndb.de, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, kishon@ti.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        m-karicheri2@ti.com, netdev@vger.kernel.org, nsekhar@ti.com,
        olof@lixom.net, olteanv@gmail.com, peter.ujfalusi@ti.com,
        robh@kernel.org, rogerq@ti.com, t-kristo@ti.com,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
Message-ID: <20200402094239.GA3770@willie-the-truck>
References: <20200401.113627.1377328159361906184.davem@davemloft.net>
 <20200401223500.224253-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401223500.224253-1-ndesaulniers@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 03:35:00PM -0700, Nick Desaulniers wrote:
> >> I think the ARM64 build is now also broken on Linus' master branch,
> >> after the net-next merge? I am not quite sure if the device tree
> >> patches were supposed to land in mainline the way they did.
> >
> >There's a fix in my net tree and it will go to Linus soon.
> >
> >There is no clear policy for dt change integration, and honestly
> >I try to deal with the situation on a case by case basis.
> 
> Yep, mainline aarch64-linux-gnu- builds are totally hosed.  DTC fails the build
> very early on:
> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246218
> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246270
> There was no failure in -next, not sure how we skipped our canary in the coal
> mine.

Yes, one of the things linux-next does a really good job at catching is
build breakage so it would've been nice to have seen this there rather
than end up with breakage in Linus' tree :(

Was the timing just bad, or are we missing DT coverage or something else?

Will
