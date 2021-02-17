Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA29231D9B7
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhBQMqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbhBQMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:46:24 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1746DC061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:45:44 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e133so13618137iof.8
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 04:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q55sd/izUmFibcPDlIS7WnRx2qffr2PtGImER4DsYpk=;
        b=u5NIdui/ubpC9L8S+jTLicrBiuSuuMi0/HtB/EKRs2CISJwjJHzxHuMp7y4F4alyEQ
         PqimhffsUgWKk5FEvaLYEuRCniVd5pcJPfmh5NgMHf5SSgSuF9bJzA9icN/Okn/cpM0X
         2Mf37Y8EJKNWn5TNIne3fxZ/VqYOvruJTwacWTYxrHa6t9q53S9s7SsosC5J1SrgHJQq
         3RSxmn/iEmSOZibwJrb8S9Q9jIn09P8pXUylJ7SEw1zE8/fHSGFGExdry//inV/cL8dp
         K0MhynhIXOVdrjjY2xLSjZlhyCsjWHxMLh7nLt8ICfaiab6PXeHAFpw5CRO5ShdzMC36
         Y9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q55sd/izUmFibcPDlIS7WnRx2qffr2PtGImER4DsYpk=;
        b=OhmsYzF9PG+t56hyWUuOwZ4fpdU0kq06k9aKvupB98QR1zWFYvglFnAHgstSbIwKcp
         fgrf7F4x8iqZwA3bkzfJzYzX9FZMPcAtt6gZq5Rc9xy7qBpjS90iuyf0Tm0Yvt/1GqoZ
         GZIGP2iIBkkrucvyUUPCFvdHzQ+Rd1F9sHItyiP0rsBL482J/wslAfTDA8zVpwtGJSIM
         L+AgEtk8OtqOb05fZ6GFB3r+17N7c0c0V9kfgg9TlchlABrZRDBs+uspDg45Ug+UB7af
         beumitBXZi7BkmWQJ7lNx4Hlb55JMdiyf/jGrfnIFNXcm/BL1LRhGgl93do9N/5/e2F2
         L85Q==
X-Gm-Message-State: AOAM5325I5nva0adizUeehyIBB35ooJjEjlq7Ff80SCrPzaxyLyz1ki4
        HNw0RLftlUEfTuCnQAQucdL2q6SsMUggErW7Cp/wttRIK5uKVzsh
X-Google-Smtp-Source: ABdhPJy6PblvrqCHwf/t7vIzjQdtEcwNF0xgBCtvDcG3s7JcbmNHZAUk2i1alkVVuBdCZ9AJFKWb1LpS8xzHiQ0AH4M=
X-Received: by 2002:a02:c509:: with SMTP id s9mr14134936jam.1.1613565943682;
 Wed, 17 Feb 2021 04:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-3-dqfext@gmail.com>
 <CACRpkdZEQYahteQ3GdftkS82O2rz_ZZ88AUN0HGMhNQDHaFWRw@mail.gmail.com>
In-Reply-To: <CACRpkdZEQYahteQ3GdftkS82O2rz_ZZ88AUN0HGMhNQDHaFWRw@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 17 Feb 2021 20:45:32 +0800
Message-ID: <CALW65jb0YfS4R2SVjYdBXVX69+MgT1whRx58dsmwWCogaXvP7g@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: dsa: add Realtek RTL8366S switch driver
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:12 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Overall the question about whether the switch is 5+1 or 7+1 is my
> big design remark.
>
> Maybe it is only 5+1 who knows...

Yes, it's 5+1.
https://cdn.jsdelivr.net/gh/libc0607/Realtek_switch_hacking@files/rtl8366s_8366sr_datasheet_vpre-1.4_20071022.pdf

>
> Yours,
> Linus Walleij
