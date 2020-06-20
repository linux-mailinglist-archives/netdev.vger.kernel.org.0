Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DDD20252E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFTQUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgFTQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 12:20:00 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE08C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:20:00 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w15so7243969lfe.11
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l4iJ2E7Xi2ljadQWMaXtaXaEC60k+QprMrGg3wgBk2w=;
        b=CcIbqoc4rqkKpcI76OC4pYIt/Nvt4j+QcMC2Ikma1+V3fqtJUA/EH/bQ9CbG+5r7yY
         Y//c1E6cyLVsOp+K7razcK+hrQfeq3G35weqaCGu+4965MzyhEWxltC9x7+X3Xfv/LLZ
         mBwjjtB/g515XhfUk0p+YDSEGBErgi6qTs3tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l4iJ2E7Xi2ljadQWMaXtaXaEC60k+QprMrGg3wgBk2w=;
        b=njd5lZlY3o/tpuigcGtSieUuPV0CT2fTSYvKEw3Us9QP+hLSAtEa6eljBdLe5KItxs
         eKJ/87Jj4Crl+tDqwJnCUOatkYabzLo0hoIxYCkSJVmNNc0EIOI5JREBxeZ6D+dH74R6
         /3sY6yrdZ4voD1Gbmuo2RaLp7rk9xS+UrxbHB2i90j6CymmpJWLokdjaaq/bNHFQp3dR
         Jde82emsnGPVXE5jEA7XmjaejcSfviyoXdBTy2uBGTJM5uX08IrmSz0Ok11WTrA5l5nZ
         XRjgizjcgDBrznFphEIUECMGd0gCfkLZvrf0WR4KarEa3Jjhdx2cVZk2ajU1UqwtSVEg
         L8BA==
X-Gm-Message-State: AOAM533roWazDOXWzhKKEvXwpr3iUjfjmWhalzL8QnTLyIT4X+pFOS+U
        O/L7480RpiWpQdypSFeYiCnDtPgcO11T5bzdFsUG4w==
X-Google-Smtp-Source: ABdhPJwNTN99bTPcuh2qokz0Y1qx9WWVRnaRHXx7jW1fz8OP5rA7WcXVrTseMhFEwUSug+7f7QwPOIklUB2nm8r4QPs=
X-Received: by 2002:ac2:4a83:: with SMTP id l3mr4783920lfp.92.1592669998476;
 Sat, 20 Jun 2020 09:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1592640947-10421-3-git-send-email-vasundhara-v.volam@broadcom.com> <20200620130724.GC2748@nanopsycho>
In-Reply-To: <20200620130724.GC2748@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sat, 20 Jun 2020 21:49:47 +0530
Message-ID: <CAACQVJqUi8=tBqwKvEhDxYTVQHS9KpHqPsEaC=grf+7v1YRAGw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] bnxt_en: Add board_serial_number field to
 info_get cb
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

On Sat, Jun 20, 2020 at 6:37 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sat, Jun 20, 2020 at 10:15:47AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >Add board_serial_number field info to info_get cb via devlink,
> >if driver can fetch the information from the device.
> >
> >Cc: Jiri Pirko <jiri@mellanox.com>
> >Cc: Jakub Kicinski <kuba@kernel.org>
> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> >---
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 7 +++++++
> > 1 file changed, 7 insertions(+)
> >
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >index a812beb..16eca3b 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >@@ -411,6 +411,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> >                       return rc;
> >       }
> >
> >+      if (strlen(bp->board_serialno)) {
> >+              rc = devlink_info_board_serial_number_put(req,
>
> No need for linebreak here.
Ah yes, now the column limit is 100. I will fix and send a v2. Thanks.
>
> >+                                                        bp->board_serialno);
> >+              if (rc)
> >+                      return rc;
> >+      }
> >+
> >       sprintf(buf, "%X", bp->chip_num);
> >       rc = devlink_info_version_fixed_put(req,
> >                       DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
> >--
> >1.8.3.1
> >
