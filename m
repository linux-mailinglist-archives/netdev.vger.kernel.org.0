Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9320252A
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgFTQRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgFTQRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 12:17:20 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F89EC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:17:19 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k15so266257lfc.4
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UkUnbe9U4Hv+Z3CYeDY5gFD2OMtbhj2r8fwBks3qG78=;
        b=COTy9N0MEytbcARLpbzGVT9u71HNT8GeWNorwX7WIwB2hllAjXCxJTL9KOZMtBjbrC
         wxsef/vDNfIf/1FppptalfD8PVzibr7OV6oWVAdzoI977e+pnkde+0dn0PZaszguCPTk
         XVXpSziXYS5IsqAGJvQMJFVtY9/2R27lEqhro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UkUnbe9U4Hv+Z3CYeDY5gFD2OMtbhj2r8fwBks3qG78=;
        b=qDsesHzx9ru6XheivkPTbodW40qCuOpFS0GtMros0fdtlx9ewcdb3b/cYMGjtl9Ahw
         dobHc9WzBs+oXjcqdQEgoFIkUmwPgedTgxWnRot5VMiLj+ISatgyYLAlSxjLc2baoVqf
         2Dw8hwgQzpIsQtSY5LuZb313xycgox/CYJm/IQUQzaB3qu2Hvc+/S2/Sc2D0GDDvxBOe
         OJD/TUZ2CsPeKRMvlYteVP2VzU2opBTDO8Yhek9XlZxqk/oCklq0E2LCVmgGDYR+YQPP
         zUh5jPDtKV0TO6E0n2RM3a/oxH1LoHx2TbCCnPaMkdcxufHz3IUnf/qFKnbfuLtkIQX3
         6+Pg==
X-Gm-Message-State: AOAM533UVdMBgUtnNJeDRZO75gEl8YKffKzgjeGJhd/ioxTkmN74KumT
        l0/KLUBFDnBRXSqx85/3OXHu5GkdQUabaidUHSwTIA==
X-Google-Smtp-Source: ABdhPJzA0W/jBDf6nT2aYX2ONyUYKHpZ+XrcDbR5FncweesM6CfUQzDcEhxrL7VxCDYyT99FUAxzl7hVJ1FPsiP2oSo=
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr4967779lfn.30.1592669837768;
 Sat, 20 Jun 2020 09:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200620120949.GA2748@nanopsycho>
In-Reply-To: <20200620120949.GA2748@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sat, 20 Jun 2020 21:47:06 +0530
Message-ID: <CAACQVJpxyqKxCFLq-uRrXdYujUQYNoASz=65mPy2-jrB4aAD6w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] devlink: Add board_serial_number field to
 info_get cb.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 5:39 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sat, Jun 20, 2020 at 10:15:45AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >This patchset adds support for board_serial_number to devlink info_get
> >cb and also use it in bnxt_en driver.
> >
> >Sample output:
> >
> >$ devlink dev info pci/0000:af:00.1
> >pci/0000:af:00.1:
> >  driver bnxt_en
> >  serial_number 00-10-18-FF-FE-AD-1A-00
> >  board_serial_number 433551F+172300000
> >  versions:
> >      fixed:
> >        board.id 7339763 Rev 0.
>
> We have board.id already here. I understand that the serial number does
> not belong under the same nest, as it is not a "version".
>
> However, could you at least maintain the format:
> board.serial_number
> ?
Thank you for reviewing the patchset. Yes, I will modify it as
board.serial_number in iproute patch.

>
>
> >        asic.id 16D7
> >        asic.rev 1
> >      running:
> >        fw 216.1.216.0
> >        fw.psid 0.0.0
> >        fw.mgmt 216.1.192.0
> >        fw.mgmt.api 1.10.1
> >        fw.ncsi 0.0.0.0
> >        fw.roce 216.1.16.0
> >
> >Vasundhara Volam (2):
> >  devlink: Add support for board_serial_number to info_get cb.
> >  bnxt_en: Add board_serial_number field to info_get cb
> >
> > Documentation/networking/devlink/devlink-info.rst | 12 +++++-------
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +++++++
> > include/net/devlink.h                             |  2 ++
> > include/uapi/linux/devlink.h                      |  2 ++
> > net/core/devlink.c                                |  8 ++++++++
> > 5 files changed, 24 insertions(+), 7 deletions(-)
> >
> >--
> >1.8.3.1
> >
