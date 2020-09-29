Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFE527D006
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgI2N4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgI2N4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:56:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C648C061755;
        Tue, 29 Sep 2020 06:56:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so3929870pgm.11;
        Tue, 29 Sep 2020 06:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cnOjlXg8/acRqjzJZ6Vpsc0wsLmh58ThBWZMSvOp7E=;
        b=DjI4928c6xr+7SC2mBQQiNnqNYZ6GlUnBuLnBcXMYvZgRU2V8uE04jLGPx4cAXa69m
         m5JX7psHW1a3V/udvX7xyCfPAhv/aOnWusvOyJl3wouE3oWYYBWcoP+updV83cc+EkPF
         o3i0NpUslv/6y68XpfFiY25H69FKN8rpOxM3fN65U8c3LB04AJ31MXwa9BNAu1W3pnsV
         0QtduGOdNspKtUdYWu6+0R/+mtYWcjTlI20Yz3QwZHsqgjgytJ1U2a+1qo/umKh8MW9B
         DbB7O3/EZlD161Bb5iFQjE8zxwVv/XcQSw2/buJUIPbumpEvmFTe+fj2bbMzfWmrxZV3
         rUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cnOjlXg8/acRqjzJZ6Vpsc0wsLmh58ThBWZMSvOp7E=;
        b=pg4Wjpd+FsO499wTvsUaxPWbCQ0a/niKzWeApOoUD2lCZizxx4cVoakagcm6CDJ8AG
         VxE3mWYl2ZK3rLNJyDDoVafJ8R9Zp+mey1AxnWEBcswZcOkTvYssu9qPyDl6OS1Ga/+H
         7ZX7AWZNCxTLv5n9lSO2V5Mcr+8bpU/Oe9gGAIG+iu6h8BzTSIHuZJIudtJP6AUynoMc
         /bYrB7QSQfIaZeFmPmdWGHTL4w6oNWUAdg+qOv02RnADHyI78wlFly179C8jfH9QdNxg
         xG/PsC1wjSsio/CJeC8p94xI/RZBy/9DPbGD/BYKBaI9EkQFGGwnGdNwyVjfB6V1n5ww
         eVug==
X-Gm-Message-State: AOAM533mXsI9dZGMLwJ18UKsOK0K1MM20CH2VYmJrGZcm8eP2OsYOSfc
        bJVIRr6vLvbVV1nxresZHdpL278K0j3AKqZ5Pv8=
X-Google-Smtp-Source: ABdhPJxQdYATfk8pYpnnHB7BmWkVCg3LXvB/+2axN4vn+pVt5bSBSAIbOvd476+VwMN4itBdj501sOYJrosKDjtKtQ4=
X-Received: by 2002:a63:d648:: with SMTP id d8mr3355331pgj.4.1601387760091;
 Tue, 29 Sep 2020 06:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com> <20200929134302.GF3950513@lunn.ch>
In-Reply-To: <20200929134302.GF3950513@lunn.ch>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 29 Sep 2020 16:55:40 +0300
Message-ID: <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:43 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> > On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:

...

> Newbie ACPI question: Does ACPI even support big endian CPUs, given
> its x86 origins?

I understand the newbie part, but can you elaborate what did you mean
under 'support'?
To me it sounds like 'network stack was developed for BE CPUs, does it
support LE ones?'

-- 
With Best Regards,
Andy Shevchenko
