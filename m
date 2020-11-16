Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF572B3F06
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgKPIpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgKPIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:45:50 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F48C0613CF;
        Mon, 16 Nov 2020 00:45:50 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id t18so8073829plo.0;
        Mon, 16 Nov 2020 00:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eE6kgra1YlTXQSwDwoBMLKyVfTjYvNxtsHARlvdv6S4=;
        b=goB7l1s/y8wJCBe1/fDM9JnlskpuHR+y6FluwWjlY05HpO62jX5xvTQZM5jicww7hC
         9bxMGsEnqTMpnOVphEa2Hiq0+tjONnY63Mw2h3/qm/qPxzMfGfUoCzwo8V/rWEe3SUFH
         wbfUd7DyHqoxehpsJ1/+hforL7ptxEUhU0G2DMGCbwKdQiZS5QTc2ro07hHU5RFkEfjN
         Uum732C6Emz1vrQZIRWMVZpLk/e91RUcRz+b15EW+nqlmMYlvjiJeAS10e53WNFlJ8sA
         rwBHC5PAFB5S1WhXBICorQp4RtGo4psnzzRuokrkZGcESA4xe2eZrH9J++86wyP7aq3h
         jtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eE6kgra1YlTXQSwDwoBMLKyVfTjYvNxtsHARlvdv6S4=;
        b=XSDCYRe1PkWIH+We6z/nX4iOri5WnW+lsQ5Rwje06etpHGe76jKoWV6yRuLoVwUkrR
         pHP3qu+1oKqm86k8YnucG7XjNSKvRnK1N2L3s37/Cwsr+AwteABcZNBf2BVMqzJpaEy1
         wAPkTceM5bGj5wI/cisRCkyx4onJRkPRBz929oznyo+p29GvrY/OUOiA/2gQ/AmfSDI/
         fWyk5gzrs1no3RQi2M2snNRFLZ1f/k8cQvVYNlHZmDLqmVejLOEGzou7frsB+EiJNm3h
         /Tz8kQl5GlYVgM7TjH/9scVCz8rdFSF4wHJR+7jkfu95Hbk7tnlYZi+xCRAfCdms+d65
         hY/g==
X-Gm-Message-State: AOAM533SYZVPUw09/WWXdnK3HsA5F+5IKoS83ZkKD53wFQoItQMYWXle
        Dgt7Eyiw2U9m5dkhT4KCO+CaVdBrJVYNpsa/5k0=
X-Google-Smtp-Source: ABdhPJx2dqKEw/WrYrgu4jYV6uRrlo/WRa7QeMR0lwbWVWuyiPLkrfJvubOdv9sQ5hjfYu3ROV6hkw9oUHVB2T7y5Wk=
X-Received: by 2002:a17:902:6b45:b029:d6:c43e:ad13 with SMTP id
 g5-20020a1709026b45b02900d6c43ead13mr12230806plt.77.1605516349681; Mon, 16
 Nov 2020 00:45:49 -0800 (PST)
MIME-Version: 1.0
References: <20201116073149.23219-1-ms@dev.tdt.de>
In-Reply-To: <20201116073149.23219-1-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 16 Nov 2020 00:45:38 -0800
Message-ID: <CAJht_ENxZhW9MK_HsY_6c_VjUbubQCYZwkVMYbHL-4aWJkaxuQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] net/x25: add/remove x25_link_device by NETDEV_REGISTER/UNREGISTER
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Thanks for the series. To get the series applied faster, could you
address the warnings and failures shown on this page?
https://patchwork.kernel.org/project/netdevbpf/list/?submitter=174539
Thanks!

To let the netdev robot know which tree this series should be applied,
we can use [PATCH net-next 1/6] as the subject prefix.
