Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396C52C836F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgK3LoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgK3LoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 06:44:25 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65C4C0613D2;
        Mon, 30 Nov 2020 03:43:44 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w202so10213202pff.10;
        Mon, 30 Nov 2020 03:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RaHLzPE1eO6+iuatfZUUeCnsQ46TRXVJpL+R26wfEdY=;
        b=aKWrdF06lEsEW2HA12ZYDwToDfjtKzwKfsn3xEgLdPads8DMM7oYf9sHu8LVKU+aJV
         WFhtGqFv5wFHbxci48TJttdclzt0eVTRIBoTC2JFhhJELUoQpX+i075xf21FPK0GfPcJ
         kEkfTh6zSq6bD/yAwtpte64nSM3ZBw2373RVn7GsZ9VAFGECSch00gOi3/XlcL1ywTC4
         SI5QtPYG683+guJpxzR3J2RiWOQPgL+0hwYCZDkqC07BLV1mELepn5O0xwCzLsa3p2Gf
         YMx5ePOJFHa6mH2/QbrkFxSHFBBv7bsuKajvzJZkObyaifoVmJoOXjgyx10dsk4m6eY4
         PPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RaHLzPE1eO6+iuatfZUUeCnsQ46TRXVJpL+R26wfEdY=;
        b=rqMyM081I6tdJyXEB5y9eIHmvmZTTYWpZsWBz29oPlqkxAoSgLscjFIXNiPl6UjHUr
         t8QGPCkiGb4Dy5uRXTauF0sXVPz0KIMnivKM/4rre2e6+VRRUTnOmQh7NqDv/LvDruce
         RkF7YtnV1Bge5en761aAYtF52pe5dRPYm4wWyL+YsChTansAIOEfwktdH7ZRjOkZ0c+6
         WFC7VmSdq90fD1YbzfAeRiEMtrMvAiYV852Xgkyq/AfnhxZ1ftsL5KQGHsTBxJ9fIsWw
         lzG5UoTraEY8y0vywcsiq6QoS1U1ZG3keHtzd91egItYG5t9/eIgjeLM8ocBpNhWf4mH
         ghYg==
X-Gm-Message-State: AOAM533fGk4RRDogPYT6bUmv/MRDvewe8txyrdg7JibFvmP3i8LlOEGL
        aPNFd1wC4V2qC0Ky7GH9IhRegjYDL64nV4zPBgFONNStnB8=
X-Google-Smtp-Source: ABdhPJxj3qqhObDIhT/Qgil2+Y82CTNoTYfzObIRA4WioHjr5zb1sCgly0xBzgIFkN457BclywkrDDGnt+Xrmu4E+AM=
X-Received: by 2002:a63:ff10:: with SMTP id k16mr6761379pgi.4.1606736624502;
 Mon, 30 Nov 2020 03:43:44 -0800 (PST)
MIME-Version: 1.0
References: <20201130110447.16891-1-frieder.schrempf@kontron.de>
In-Reply-To: <20201130110447.16891-1-frieder.schrempf@kontron.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 30 Nov 2020 13:44:33 +0200
Message-ID: <CAHp75Vfwp_uvVW51FwwRWorDibJTu4zRpMhQ9iF3sTe1yrmsTw@mail.gmail.com>
Subject: Re: [PATCH] NFC: nxp-nci: Make firmware GPIO pin optional
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org, netdev <netdev@vger.kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 1:06 PM Schrempf Frieder
<frieder.schrempf@kontron.de> wrote:
>
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> There are other NXP NCI compatible NFC controllers such as the PN7150
> that use an integrated firmware and therefore do not have a GPIO to
> select firmware downloading mode. To support these kind of chips,
> let's make the firmware GPIO optional.

...

> -       gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
> +       if (phy->gpiod_fw)
> +               gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);

This change is not needed.

-- 
With Best Regards,
Andy Shevchenko
