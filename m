Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3030653E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhA0Ue6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhA0Uex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:34:53 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441F3C061573;
        Wed, 27 Jan 2021 12:34:13 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id hs11so4554485ejc.1;
        Wed, 27 Jan 2021 12:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j11Iu9yfS9cnbK3IBbJ4mPKwbUlMKjGaBsCh68ev+BQ=;
        b=HGItaCqdG1CAAVTkD8MHs/EESz39yPpGXVxY41CGKJFTFjw7KKOQ9NCMw4PjbVnM99
         29UqB5bboFAKHhG6nhxEEh4HCF6g5zgUb4T0g3nyXZ4d1DWrpZ37HYub4Zuc91ZGdh4H
         IJvy97AQMnqujE53OmbJ/JGgCZW/luZZJbAjQAUKqCgu0P4/dAOZHUURNlXcxKV/T9Eg
         ukSb6IaikgyHCcKQ1HCZ8VTrsDHYHMy08Uz1WX4FSd14jhCTHG16LCX+x9AZkFqWFWSi
         cKLSk/D+Iys0ceN10xnyXEGOA6HYPm9aE9MN5U2bjziIu/OQUFsicpCyDLKFE7L1V/mG
         TInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j11Iu9yfS9cnbK3IBbJ4mPKwbUlMKjGaBsCh68ev+BQ=;
        b=WtKCmdyp1CApKuzxu5e+Us8tVCoi4Ou7HAqM37Eo8BrhcYjfhQRlnKI4scMz16WZtA
         5e3iCVJzEHKYMRahZEoV8/cvQkSbuGwwk8ijQL+eCDi9gkdXfhuc2YZqmo78lvCOeaix
         G94Je46kQD6nTwZzC/qIRYUBEIn1ukDx6ZOllHyyWo0qIYSYPEHUZN1WL0YaDRic1ErH
         pnp9Hn3vqeGkPBhrnCWaZkDMSBO9LBbJptx31muOsgUj9YXCP8ndn6eIeyvF42++Mgwr
         XlkBrnNbLXWalbA9BYVTK/piC2pDZiOUfKMHbnZxfUr3AL9CP3SeQfFF4nX6YccHSMbt
         iOOw==
X-Gm-Message-State: AOAM530Wzf6CbSITQYygbaKCsXGTVZCfFpkx9HxA/EszZq71YSqVWaI5
        OHIsHohmoRrPfTooU27sC8U+zZUDagc+jCZVNKdCcn5PV+I=
X-Google-Smtp-Source: ABdhPJwVR8lQMcpcj72Za8KAxh7vzEPm7KD8KyWKAQmHJDdNhE3oOsZLfxG2bWMGBV6kvh/8NxBppo5Yl9VMERcoeNY=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr7935906ejj.464.1611779651709;
 Wed, 27 Jan 2021 12:34:11 -0800 (PST)
MIME-Version: 1.0
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com> <1611733552-150419-5-git-send-email-hkelam@marvell.com>
In-Reply-To: <1611733552-150419-5-git-send-email-hkelam@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:33:35 -0500
Message-ID: <CAF=yD-+cHaOjHDXfQx2b+N14V-DfQdiC7EPcRKwXzGVdWbm89A@mail.gmail.com>
Subject: Re: [Patch v2 net-next 4/7] octeontx2-af: Physical link configuration support
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, sbhatta@marvell.com,
        Christina Jacob <cjacob@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:02 AM Hariprasad Kelam <hkelam@marvell.com> wrote:
>
> From: Christina Jacob <cjacob@marvell.com>
>
> CGX LMAC, the physical interface support link configuration parameters
> like speed, auto negotiation, duplex  etc. Firmware saves these into
> memory region shared between firmware and this driver.
>
> This patch adds mailbox handler set_link_mode, fw_data_get to
> configure and read these parameters.
>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

> +int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
> +                                      struct cgx_set_link_mode_req *req,
> +                                      struct cgx_set_link_mode_rsp *rsp)
> +{
> +       int pf = rvu_get_pf(req->hdr.pcifunc);
> +       u8 cgx_idx, lmac;
> +       void *cgxd;
> +
> +       if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
> +               return -EPERM;
> +
> +       rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
> +       cgxd = rvu_cgx_pdata(cgx_idx, rvu);
> +       rsp->status =  cgx_set_link_mode(cgxd, req->args, cgx_idx, lmac);

nit: two spaces after assignment operator.

on the point of no new inline: do also check the status in patchwork.
that also flags such issues.
