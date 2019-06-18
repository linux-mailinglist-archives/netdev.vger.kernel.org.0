Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12754A7FC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfFRRPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:15:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940472084A;
        Tue, 18 Jun 2019 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878119;
        bh=41HLSU+pHqRldApbH/YXy2viTKPFa3SKgMhq3ODnJUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SquRO9iLmSpALXbpJPKSnE3SWGb89N1n4UiVrS+/NEoYOC6CX9VzTyfz/LNAmCZok
         bd2pcrvlF2fjSbHuym072/JM4914Go9f1i3NpIr7wFKsywxYgXDXzzRCexdPm+PGuP
         H2Fpc1bbeEzB0E0AdFj4lsgk1NHRc8VHYfdniY+o=
Date:   Tue, 18 Jun 2019 19:15:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     willemdebruijn.kernel@gmail.com, naresh.kamboju@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, fklassen@appneta.com
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
Message-ID: <20190618171516.GA17547@kroah.com>
References: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
 <20190618161036.GA28190@kroah.com>
 <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
 <20190618.094759.539007481404905339.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618.094759.539007481404905339.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 09:47:59AM -0700, David Miller wrote:
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Tue, 18 Jun 2019 12:37:33 -0400
> 
> > Specific to the above test, I can add a check command testing
> > setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
> > way to denote "skipped", so this would just return "pass". Sounds a
> > bit fragile, passing success when a feature is absent.
> 
> Especially since the feature might be absent because the 'config'
> template forgot to include a necessary Kconfig option.

That is what the "skip" response is for, don't return "pass" if the
feature just isn't present.  That lets people run tests on systems
without the config option enabled as you say, or on systems without the
needed userspace tools present.

thanks,

greg k-h
