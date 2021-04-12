Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8235D1F4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhDLU0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbhDLU0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 16:26:31 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A833BC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 13:26:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e7so5266751wrs.11
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 13:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gut8ay3iZs5S7FG/Z3a4VB6o9mRUDpWc2hTg0rDiIB0=;
        b=mcqedKpzPmR7UY8FMOot9nzdy9KTs5EJxd/V5aMO2hR58TBbgpuDvJ3jL/fypJ50x6
         vuB91JwklpbSNk8Doz7KpherCTw6K3UP4vaZ8vr+tNeMhBJCczf0NSlvd491eqfndWXi
         AB2mdhrU757T4/zRECyjaMyEFud6kkgJC25tvdDNo0RllVpW7goEepLkK/6LGrajGxm9
         f/9qf4hgnsx9IyyF0p5h270/4OjbOiOivEVAAHgtB8ok6sRXO1QkOZwR8POa8K3p0uLv
         pOMmgpVG4jluAggApeVAaEFfJG+J4U72u9nTBi9BWViJ1jsuOHu8/pMh6wqJXGw3BfYF
         SO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gut8ay3iZs5S7FG/Z3a4VB6o9mRUDpWc2hTg0rDiIB0=;
        b=iCMoiWd2MNaMVDDG7siyYNE2T0Ywtq3c+hTe89blnFdDdfc2bS9eJeRFNXJrC7qTvi
         1uiDlq3VO/OCjkzdJ2o2WKK7X48EskG/tBN2u0EjfncJdtzfzbBDKt0NyoXA+vHmmfL9
         R2JLpq/JuV1Y8NzGJNl/NqVTG2vDON7vpVLewp0nWOElpeOqfIDAQoZDFu+sVa/0PllC
         S6Wk5MBMOvJoRmQmBwFwSyljIWRg3orzYr+vDtoLUFbk1cMmUFpebTXS1ov7mJvAuAzV
         BF3ZD8C8w2v+tg8M9qi3xCoHUcQ158RCM4csUwnUfINkOsSm/NsYF7NqXFq7t4NXoeEA
         IThA==
X-Gm-Message-State: AOAM530m60a5ePEyj7x3PuiwnUmQYsalpO/GrjVuQ5OOwB6C0W9kZh57
        8qY5sO9UB33V8nLvzSXP6rkhzwIEZ8mY0d/qVCL4s3tZ1uI=
X-Google-Smtp-Source: ABdhPJyF0zPBXqLDgoimzX1H08B/l1+kz/7pevqueQmZOj+I7YEcHmaTPNAZJRCIFNHDsr6LSV2iEauYGUKH2HzkaMo=
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr33437861wrj.420.1618259171511;
 Mon, 12 Apr 2021 13:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210412074330.9371-1-lijunp213@gmail.com> <20210412074330.9371-3-lijunp213@gmail.com>
 <20210412112323.26afa89c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210412112323.26afa89c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Mon, 12 Apr 2021 15:26:00 -0500
Message-ID: <CAOhMmr5H_0QuSwOU-FEBQb3CHegSi4f3hdtEtprKKF7i1WebEw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] ibmvnic: add sysfs entry for timeout and
 fatal reset
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 1:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 12 Apr 2021 02:43:30 -0500 Lijun Pan wrote:
> > Add timeout and fatal reset sysfs entries so that both functions
> > can be triggered manually the tested. Otherwise, you have to run
> > the program for enough time and check both randomly generated
> > resets in the long long log.
>
> This looks more suitable for debugfs.
>
> But can't you use ethtool or devlink reset functionality somehow?

ethtool and devlink reset seem better to be implemented by a FAILVOER reset for
this driver. ethtool/devlink reset are not implemented in this driver,
which will be a todo list for me.

This timeout reset can be triggered by tx watchdog,
.ndo_tx_timeout->ibmvnic_tx_timeout->ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
Do you know is there a way to trigger that ndo_tx_timeout from some
user space tool?

The FATAL reset is triggered by Firmware, quite specific for this driver.
So in order to verify that, I put it in sysfs entry.
