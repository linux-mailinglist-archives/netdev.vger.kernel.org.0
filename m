Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A84607BA
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 17:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358438AbhK1Q6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 11:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346922AbhK1Q4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 11:56:34 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DECC0613D7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 08:53:18 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id ay21so29004255uab.12
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 08:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=paHVaxEa9CqakgP4O4RXlNI7wYyMct8sjfhm7iOajfc=;
        b=MBhxMJ0n8+deUaEsyWe2e3zVPG3xmbn3KqqP6ajtKMmIPWgamstLPp3XIt3Ez5jn30
         NRwQHEoXbkrGZGzznT47MazVQXYPm8vwRD8545msy4eAc4iELFdGgWXb2hsy41W/TW7g
         udtyk1H9LA8gyNsABfkltsuXYXVPWSYkJToBscqw8ePAtmwbKCm7Po5CQJ3iL+XjE8M3
         aWX8Ud8Kv/JUsDCY5N2cZl8jYJ141weTM6I4+Q33jChyT0J+CaM7u71WBnRInBw4hcdS
         P6bLGT98d4W204/WBcxV/nqJI3uJf2TRoqwBCKl59U2SCKTVGKPAfmUyoZDgLMQ/3i2z
         wY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=paHVaxEa9CqakgP4O4RXlNI7wYyMct8sjfhm7iOajfc=;
        b=BurFj6onBIEkLQpJEMmG53e9w0JUSSIXmkFNHCgcaEcls5tSrt+gfOMJjTA1EcG/W4
         0O+56+dqVKlTqG0aldua4kWRPMm07R0sFS3GuXnXj5AnpPpVQ9ax6vKmbDRqpghkkyzU
         i5SXsS3R32c6I26GryM2fL+YlEKzUOkG/YZTHnJgolccibRWK5HTKUy8hlTzE3LpqWDW
         iE8JXGkDBxiBn9jpQK76yF+hiyNE6CHoJDJgZa97/zb2WoRbiv5XT9KMbz4M1HIwhlch
         AHQJWVWTWedxB7XVEbFMELlKsHiJmyQVsUecEx7wQxOIIJrXIC1e3AZz5nbi7zjvhR8w
         amBw==
X-Gm-Message-State: AOAM530LXYLIaTzvHnKz51hBKJt9bh+nmp/UGv+yThiRaPpWm5ELTLgX
        3WEBzj/Ynm2Pszy84zDvmOIENh3S9QTC2d6LHmdDvGgtqwU=
X-Google-Smtp-Source: ABdhPJxWN7qNIIE3vAq2ZR2vshpG1uaxzBq1wbTb3rLlr7JezLI3V2ihBrM/Ufllc7d90MZoyaPemYIU9WiCKi86ESw=
X-Received: by 2002:a67:c29a:: with SMTP id k26mr28588936vsj.32.1638118397433;
 Sun, 28 Nov 2021 08:53:17 -0800 (PST)
MIME-Version: 1.0
References: <20211120162155.1216081-1-m.chetan.kumar@linux.intel.com> <20211120162155.1216081-2-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211120162155.1216081-2-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 28 Nov 2021 19:53:06 +0300
Message-ID: <CAHNKnsQjB2f=9nadsqKTSAA0ZewFrPrDFTx4H804+y6ztTrXCQ@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/2] net: wwan: common debugfs base dir for
 wwan device
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        krishna.c.sudi@intel.com,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Nov 20, 2021 at 7:14 PM M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
> This patch set brings in a common debugfs base directory
> i.e. /sys/kernel/debugfs/wwan/ in WWAN Subsystem for a
> WWAN device instance. So that it avoids driver polluting
> debugfs root with unrelated directories & possible name
> collusion.
>
> Having a common debugfs base directory for WWAN drivers
> eases user to match control devices with debugfs entries.
>
> WWAN Subsystem creates dentry (/sys/kernel/debugfs/wwan)
> on module load & removes dentry on module unload.
>
> When driver registers a new wwan device, dentry (wwanX)
> is created for WWAN device instance & on driver unregister
> dentry is removed.
>
> New API is introduced to return the wwan device instance
> dentry so that driver can create debugfs entries under it.

Thank you for taking care of the debugfs implementation for the WWAN core.

Please find my follow-up series that tweak the IOSM/WWAN debugfs
interface a bit:
https://lore.kernel.org/all/20211128125522.23357-1-ryazanov.s.a@gmail.com

-- 
Sergey
