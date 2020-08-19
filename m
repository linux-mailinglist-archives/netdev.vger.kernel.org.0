Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1DE2493A5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHSDtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgHSDtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 23:49:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009B0C061389;
        Tue, 18 Aug 2020 20:49:31 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s1so10265449iot.10;
        Tue, 18 Aug 2020 20:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=31Pn+vyy/OxBJKmzJxO+6FXSIT/jmPkXuyC19k5Pzvs=;
        b=tONaBmoOnjOaHU/VOEMNYXxmfOdznr+BZCfZdQluPThLLdL5dr7uBPm8KEy+cSlRPE
         9CRB8HlU/XUON5y1jdnhtasvGpzgikjlcFhqjEcIqoeruLpnfaA3K+6LHJJYQxKKLeCm
         WINSm8gQWy8nxZr4uGGAdDe4I2WJEWD3QxJ3xPvM/47/NxI79huw4dwEvTcfz+KOjxHr
         3BgH8+Gb2GOtNZcBj3BlRGfAJViEY17VT79teaPto2gxNDmrYjUCVjn/II630n/oZZHy
         yjN61HSqDpX5MOvzUp/YJR9rrfG4Dhwv57f/a03DvH1RQ/vQmNwQM6J7n2DCNd9dgvSd
         YBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=31Pn+vyy/OxBJKmzJxO+6FXSIT/jmPkXuyC19k5Pzvs=;
        b=mDWEtZQsAQyQXaAJlB1QM3eM/ruw1KTpptD8H18Wo/bpdGLv+qJae1Qswc0kvpxYyv
         vou2dpN1Y0ESmlDyF7Q4I4cDwmxgZiiGSIi849zzvkAv2ze0JCqVdjQ3+XdVfWYRoXIU
         IO4KtVb8eJAUA86ubkJMmya7ADx+zXQUyPUJkSRhRliAms6YPI+Rmi81NerSsJD3GAnQ
         bArNMlRdi7Lt26VLcQ4YlZHkpN894pwH3//BfmyeJDXrO4k5ZLhT9UiNI8UrWNBH3Ydz
         X4QtPdi4F+5uYLvYFPgQ69AItGB523IY8rz14uZRpTNPVAh1wfIMsXh8nvpda/TiUhpS
         VCWw==
X-Gm-Message-State: AOAM530mY38gpE6+5SuUTX4d3zrErrccZ+y17O1PeTnukw4GXsWd6SzL
        8M1OpsU0WoEwIO+aXhAPUdGncmDnV1B6AWNyru8=
X-Google-Smtp-Source: ABdhPJxiFnwR4krw6L9w1YyGDNqAoI0e5YwKQ6usbijlbVVzNyvk9QdYWoQa+p7JAZtnW511U9jy+qym9HUzbER4o/c=
X-Received: by 2002:a05:6638:1a7:: with SMTP id b7mr21799413jaq.1.1597808971328;
 Tue, 18 Aug 2020 20:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597729692.git.landen.chao@mediatek.com>
In-Reply-To: <cover.1597729692.git.landen.chao@mediatek.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 19 Aug 2020 11:49:20 +0800
Message-ID: <CALW65jZRWwW4DqpsCM9J=GRp6KnxqT-9MHUO7WSRJtp4E9vnFw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/7] net-next: dsa: mt7530: add support for MT7531
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        vivien.didelot@savoirfairelinux.com,
        Matthias Brugger <matthias.bgg@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Is port mirroring working? Port mirroring registers on MT7531 have
moved, according to bpi's MT7531 reference manual.
Please fix that as well.
