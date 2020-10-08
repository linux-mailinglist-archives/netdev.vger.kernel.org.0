Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F66D286FA3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgJHHjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgJHHjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:39:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF2C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 00:39:08 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p15so5335078wmi.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 00:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=acT3mJ3SgCskMXGei75f2QgPPdiS23kx6LiqTgcMbyI=;
        b=i5CzYo7dzSmpMLz4rtu2Pkeh1wioILnCpnEabEsBViz7tWcc2f48rPuXmkfOu4+Rwz
         otLbJQ6Y6l7Rbh7U2IMQueo6eVKPyLujdFZKaP3krJTZrz+xToNJtIlE3SP75WOnrQlU
         MMJsaYYif+YYgsJlyM9vlQSKbpwdB/n52VJBvnyVk62Sk70xvfMj5D0AEU7DGgBzwMx3
         1gPiNFlzJNB7EvFG8zwD0+za37BmhXBPLbV19Z95vDN9UiWHO0TjUFrN4IefJLeFBQ/F
         aUIkAookidELNTC1LR3SLqlNfn1l6Kupn/qq8sPaSWZi1srvCeRYbySJZciFLwiFT7cw
         hDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=acT3mJ3SgCskMXGei75f2QgPPdiS23kx6LiqTgcMbyI=;
        b=Ni5RcOoR3Gl/5j0DTgkTEL9hKEcw9AlHUqQZtQkPMqv5BjPPJBBTIsYWwCarhHYWnV
         oqPWzKekXtRl/VQC+CoY8uLGRF5IIUOsFi+phZxortcRwUe09kb2gg3Ej5neavlkkSS+
         6DKQuvRCOxOPl+Xc1d74SmxrUEFCZZzHkvbZzEp8eAIWIFw9grJbkV/aEDCKFXu5hDER
         nbN1QrY6hoq7l7yqJtLW6yhHWyPzwoiZddN1vRhNH9FH+Ub7pn+s5omdODWSWkjoMfur
         +vUnSs+Cd6FFaHimXQ4lycq+NSJmFy+kvsfRKjbK4jqKh0Txpcz0kpOOM5WFcPdI9n9q
         A7+A==
X-Gm-Message-State: AOAM532Byk5D86h3xrx30NaISyCQyJooNbrWahTrnWlbzmGwpT4xtFlE
        kMCfX3hW9BrQ9XxFAQT2nuq39g==
X-Google-Smtp-Source: ABdhPJwjHpTJ7/ur9Z19VLp3xZ8ALp/j4Fp7NgchaRmjLtruqhs8jAB14QOUHbXX4R1qL5vuo4t8lg==
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr2929815wmk.73.1602142747144;
        Thu, 08 Oct 2020 00:39:07 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h76sm5708531wme.10.2020.10.08.00.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:39:06 -0700 (PDT)
Date:   Thu, 8 Oct 2020 09:39:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/16] devlink: Add devlink reload limit
 option
Message-ID: <20201008073905.GF3064@nanopsycho>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
 <1602050457-21700-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602050457-21700-4-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 07, 2020 at 08:00:44AM CEST, moshe@mellanox.com wrote:
>Add reload limit to demand restrictions on reload actions.
>Reload limits supported:
>no_reset: No reset allowed, no down time allowed, no link flap and no
>          configuration is lost.
>
>By default reload limit is unspecified and so no constraints on reload
>actions are required.
>
>Some combinations of action and limit are invalid. For example, driver
>can not reinitialize its entities without any downtime.
>
>The no_reset reload limit will have usecase in this patchset to
>implement restricted fw_activate on mlx5.
>
>Have the uapi parameter of reload limit ready for future support of
>multiselection.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
