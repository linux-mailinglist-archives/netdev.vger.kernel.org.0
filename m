Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745A22023E4
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgFTNH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 09:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgFTNH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 09:07:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB47C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 06:07:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r15so11428011wmh.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 06:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YzqlIzvC1SCVAsiTKNqnenpL25wxzjpMWoJN7187Agw=;
        b=EloGvOwxASmS1cmCogpsUJdBnzcgMGkRROToa4q74SJD2mbbdrwpTlNCLQG6TRsUOQ
         HUChIIg/Wg6ggKRVBFVIXUoepqPvGehELQi6jZuc55JLICqb0SuOfCIrg6gFnWOhsqLC
         lf30Q///KhUK0h1BcxP0M/yuMAODYFsV0uxbqZJq0gLjm8A6MSKWQ2eYfH6NxcRLWAdV
         E0p5udUP6n4HMWvsjcfNV/Yu2v4YOH5HEyDW8Yuf8KMI2nmDrzw2Md0tQUWUlpnC0nDC
         RG4t+i18Xr2r91V9bvTl7jy4qDE/muvHsbMDWUjQYGxrbe+Oi5YG9Kk28eP8jaer0mIv
         k/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YzqlIzvC1SCVAsiTKNqnenpL25wxzjpMWoJN7187Agw=;
        b=lrgYcjzoE9oeEkzCAnq8xtTbwFZCsgDAZFqfgTmhGmTS1PmW6/6MKu5ikSwxt+bqqE
         du9C6CXT5sKOnXVqucCK4CK909n1HsK/yJhT9bHBmZjfqMxLQMSjebaSnSpIJpoJm2Ta
         7TyHCMhynver+JR9f9WqzXwvE+ewR2zMjwMum9V48D88/wCtrFs5dNYp1BD/SC+1+WK2
         5Aw0HpMDKYhbNyVtrkNcVTCPD7iadOrZPt/N4GtVZprHsaFSNR/p5hq7g96MXwT3RxnF
         Y0Y40NQmDrl5BU8uGTlBkVu/LetvoBiNoDIbAhPSW8vO4uNP7huKEoLcNn4kmPf3rFOt
         0Umw==
X-Gm-Message-State: AOAM530bqlhWoBelkN6bIJM2FZtInFTjjb0KOAvV1OMnxjBCvD3kmxdL
        No/Hw9uHZkDaWDs7eMgb4yFj8Q==
X-Google-Smtp-Source: ABdhPJwP/FuqPSu60rT8i61fFd9pCnSLO/B09ISoq7QB0fTaiJSFfbQogOrOUZbh4Cxu0IREcAteug==
X-Received: by 2002:a1c:f007:: with SMTP id a7mr8597469wmb.103.1592658445559;
        Sat, 20 Jun 2020 06:07:25 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id o29sm2812470wra.5.2020.06.20.06.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 06:07:25 -0700 (PDT)
Date:   Sat, 20 Jun 2020 15:07:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 2/2] bnxt_en: Add board_serial_number field to
 info_get cb
Message-ID: <20200620130724.GC2748@nanopsycho>
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1592640947-10421-3-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592640947-10421-3-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jun 20, 2020 at 10:15:47AM CEST, vasundhara-v.volam@broadcom.com wrote:
>Add board_serial_number field info to info_get cb via devlink,
>if driver can fetch the information from the device.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>---
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index a812beb..16eca3b 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -411,6 +411,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
> 			return rc;
> 	}
> 
>+	if (strlen(bp->board_serialno)) {
>+		rc = devlink_info_board_serial_number_put(req,

No need for linebreak here.

>+							  bp->board_serialno);
>+		if (rc)
>+			return rc;
>+	}
>+
> 	sprintf(buf, "%X", bp->chip_num);
> 	rc = devlink_info_version_fixed_put(req,
> 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
>-- 
>1.8.3.1
>
