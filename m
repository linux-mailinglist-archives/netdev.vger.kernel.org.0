Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0743084FA
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhA2FPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2FPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 00:15:01 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2972FC061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:14:21 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s23so4596861pgh.11
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 21:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVE9Ttfq8tGFpIUmMecs+0pKzVD+M5hB7h0k+slf5os=;
        b=nx7XzTRKfa/MIDySZ9cMEj0n9kRynGEM9WxwKEw6DJ9uccEjqFIZC0x3lopA0VFINo
         Xj7SBhP5UqHDVgeuplREYFZV5bM2LchsVYIFx7h3MW4ZIqW4ICsuWIocqzQ6T04Xc2JD
         nLoWH/DVE6XzOAOA912c4rF9sR3I9vecZS397c/7Xa0VXNR690W/auARoHOtxNyRaPxm
         ISe9kXUd1L3Glnf1OCkOakgsFuhINMhG44lfW0YFQgp5AA6Xu60E2rPCoZ5TeSN0i3Vd
         Sa0jFYeTQihFzBVvHFRzJ8s7bcld48kCBnsNW1PsRIPnWgGz/Q1otrCxEGsBOW5pIeQO
         9jHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVE9Ttfq8tGFpIUmMecs+0pKzVD+M5hB7h0k+slf5os=;
        b=D+HLr1PJI2Me8MotZU/X0ojpjHMTskox53zDyN143+gIl18zGCNgh07xWTVu6RgThy
         3+gBNplACYrm2DyTW4b4sQkFpe14mw50c2idnRh0pAErFsK1ve+LenIgASisXNHmz8Lw
         GDGkZG1inxFw7Dp1oX1/ul8VyZNEXL1Qdth0KdLIcEefO5t9GZBz6HdRxv8ltae9y4WW
         7IIDn+u3X42A+InMyV/dgbyDQsOGgtku4CjzLUyowT/QxfPbM4nmBAEvjyKkqw2j+bNI
         O7j/zeoIZnqG3THypvTaiFk9Jhf9wxZBDI2qdLLx7Eni3cSyKcgkkCRQCsn2Vhr7YP55
         LK1A==
X-Gm-Message-State: AOAM532kaRFQnvwPLTGohQE5vdpODTgiQIaOnjpwAShd0t1YTj/iFR3n
        wz/jPOZOnrP4sCO3NI+ruPmRZT6dXVKDLGtBles=
X-Google-Smtp-Source: ABdhPJxDS1GihSjAAC2jaG+mBri8HEP5yKpymTsrwE1Cgx7YLxm2oCA2Jm5fsVACLCgSYKhEbkaBgclfP0QlnOJzYn0=
X-Received: by 2002:a63:2265:: with SMTP id t37mr2978831pgm.336.1611897260717;
 Thu, 28 Jan 2021 21:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20210128014543.521151-1-cmi@nvidia.com>
In-Reply-To: <20210128014543.521151-1-cmi@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 28 Jan 2021 21:14:09 -0800
Message-ID: <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Chris Mi <cmi@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 5:48 PM Chris Mi <cmi@nvidia.com> wrote:
>
> In order to send sampled packets to userspace, NIC driver calls
> psample api directly. But it creates a hard dependency on module
> psample. Introduce psample_ops to remove the hard dependency.
> It is initialized when psample module is loaded and set to NULL
> when the module is unloaded.

Is it too crazy to just make CONFIG_PSAMPLE a bool so that it
won't be a module?

Thanks.
