Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E282104210
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfKTR1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:27:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55163 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfKTR1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:27:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id x26so183408wmk.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O9NM3AuzPLu6szAJZtY1J9I3WX0osMbqUOTF+jQVm0s=;
        b=Hb0rPCBlj8gviGzb/bLe9PKCotIKW6BjnBZBC0w4UgDeDqg+5W3F74lCPUBXWMDzZ4
         R9VffT6wZU2N6GGWL7GcN63e2oLaxDsANvdGi/+q39lIVYgCg+IPql+ep4Lm0cCGLdui
         mSF4gTSimfrBybd4/v1aIkPniClkrsXADSpXLt9ZFyvIjK3JTLIFTpg2aBuKoTCkC8pw
         MhjlUMh4VhXiWvgbKnCEmAoqtpPSnMzUPSM7tZoPgN6T7dSA0zT6e+qIJFFfpN1daKal
         fgsUjO4HYmCTy2GdnAZqSIAQc8IN/5eaAPMgq09VyfRkEkQK0PWJtR2BtVvultGL/Bqg
         +mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O9NM3AuzPLu6szAJZtY1J9I3WX0osMbqUOTF+jQVm0s=;
        b=H9Q16aCcQVJzrLcL4cPHXMIzuWXY8OLsqZ1KhDE/TW6sRGKNwfAErpVrc1y8kJDJeK
         Wka4x2fOAZfTE+JtPfYF+dx+g1xYkcdVMXumNH8I19xjZl//A9jGihJRkWVtLQ8nyMdR
         R1UB4GCND9WGqvEeIJP8j4XdIBDRK18ptTaYxCqxWTk07iHyAgU5jSUnrUQfg3BW0IY3
         /1WVzQLePXQKjn8G94H8zF8JhHcbgvMrZtoLCiNrWHczDsjFfeh3f0i7KxZ7xkwmxSc/
         lqrGT4AksdYYZamXGJ0RK3fKeCnVTVR/lizHE99wbJw86ev+1XhmfY7f52Q8QRtw0G5B
         XUAQ==
X-Gm-Message-State: APjAAAWztgvIZTdmOVmt92s42wQMZqMymVgRbYMASNgFKwLo2z3NwJuV
        zK3/Qxeb1+N5Jrd6kBl3LKsppTVeKttJx48iedA=
X-Google-Smtp-Source: APXvYqx3aT+8zX+GOqzH4x/0/sKfxF8g0n2XcWckpkKIo1Gn/zuh/s2rqYaMNe2Vs/6AZPTLTqtTg5L5k9PurVr24e0=
X-Received: by 2002:a1c:7e91:: with SMTP id z139mr4640117wmc.15.1574270820128;
 Wed, 20 Nov 2019 09:27:00 -0800 (PST)
MIME-Version: 1.0
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
 <20191119134638.6814285a@cakuba.netronome.com> <20191119.140222.1092498595946013025.davem@davemloft.net>
In-Reply-To: <20191119.140222.1092498595946013025.davem@davemloft.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 20 Nov 2019 22:56:49 +0530
Message-ID: <CA+sq2CeHTxmpv5moJvW8QZn=z+NqqkZJefM6Zg0ru56HwhFMQA@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] octeontx2-af: SSO, TIM HW blocks and other
 config support
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 3:32 AM David Miller <davem@davemloft.net> wrote:
>
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Tue, 19 Nov 2019 13:46:38 -0800
>
> > As I asked in my review of patch 4 in v1, please provide us with
> > accurate description of how does a system with a octeontx2 operate.
> > Best in the form of RST documentation in the Documentation/ directory,
> > otherwise it's very hard for upstream folks to review what you're doing.
>
> Yes, please do this.

Sure, will submit v3 with documentation which provides a high level
overview of the hardware
and the kernel drivers.

>
> Some of us are strongly suspecting that there is a third agent (via
> an SDK or similar) that programs part of this chip in a complete system
> and if that is the case you must fully disclose how all of this is
> intended to work.
>

The ones which configures HW are the drivers which may be in kernel or
userspace.
Few minor things are setup by firmware before kernel boots.

Thanks,
Sunil.
