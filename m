Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9A29DA0F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbgJ1XOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbgJ1XOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:14:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A7DC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:14:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c21so1100875ljj.0
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBhVOLjkm+yVz4gsQHo2cvoJOtQeQUVAyTOk9pxLXOk=;
        b=rUg++dcSFl9T8NZja3F7N+PX4ey1U1YvbIbpxK5uouSx4qPktzdDQx4yWz1Waizsmr
         ahjA+ab6mq/mDWtYiX+M9PT1rAxF9Ur6Iq/4xyBiwpb3cSDfrQ2Cz0c4axWWD7FHGS7T
         UytgCiQSanXd0Ivnora5WPvWo0O0UYkO1yMUwPUiXgwl5WNj64r9EdH31mq3RHO7YwEZ
         jWWVrWYJ/CRHApdo+mf4hn08Htcv6RhJk5cA77Iop8qEuy9sSR4mKFLwTSBdcbQHIJ0v
         1MYuihbYZY+gOTx5q0SIHxd1CbYfPKZfomjfDIj18N6frujSSpBFS5nGoA1F+dBmgVpz
         y1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBhVOLjkm+yVz4gsQHo2cvoJOtQeQUVAyTOk9pxLXOk=;
        b=Fldo7Ls6bh8TpGCG1h2Wq51CcX2n9qCvYgZiEUVSOeDR3yd5DrXp0PwXqvwzJlFGkl
         V2IaCkseY+4FwF4rjLp9QsKIC6+5TbWLNpRIw/51C+oHhvxQhZMPsBFXk66wxwGoUmv+
         IeSpQGnEhZomZgAYDDdJzj72BsOzEIkyo6bjHqWq15TAhA0zc3NokHOIJq70pi0ByV6h
         8ZFPHYpP2BS5TQaLAp9yOPLFXPAV1qnfrFX6T/UOnixEQGnbySpeHrNk6vuBUD4m5DGG
         WcT/fsalLk8fu6xQIlPL9H0OI4fOI+kgMDLQ18mEELlonLmbF4M0+K7+PxDGiMtuyypO
         WvcQ==
X-Gm-Message-State: AOAM5322n++BmefBkKB2eg6Y6edb3UNCftGzeAYbj8JBSG9vdLYw+bPn
        9cT38jAEIyfxkMkn0C7i9IKxwZXx9IBbW2ZGJZZTbXDUIA==
X-Google-Smtp-Source: ABdhPJwO+2fdXbu55wkLlksugTbeRACqlg11/n+Pdm9JWIp+etIbOLIIsSbxUwLC/kyyOSclp6/R1S1CR1h4LWtRDU0=
X-Received: by 2002:a17:906:c1d4:: with SMTP id bw20mr4996500ejb.91.1603846920117;
 Tue, 27 Oct 2020 18:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201028005350.930299-1-andrew@lunn.ch>
In-Reply-To: <20201028005350.930299-1-andrew@lunn.ch>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 27 Oct 2020 21:01:48 -0400
Message-ID: <CAHC9VhSTQrhBfMnfb0=UG=J4aa-ODu3Gqfrj9aiDr+KesuY4=g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: netlabel: Fix kerneldoc warnings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 8:54 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> net/netlabel/netlabel_calipso.c:376: warning: Function parameter or member 'ops' not described in 'netlbl_calipso_ops_register'
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/netlabel/netlabel_calipso.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
> index 4e62f2ad3575..a4efa99fb1f8 100644
> --- a/net/netlabel/netlabel_calipso.c
> +++ b/net/netlabel/netlabel_calipso.c
> @@ -366,6 +366,7 @@ static const struct netlbl_calipso_ops *calipso_ops;
>
>  /**
>   * netlbl_calipso_ops_register - Register the CALIPSO operations
> + * @ops: Ops to register

If we are being nitpicky, it might be better to drop the
capitalization for the sake of consistency, e.g. "@ops: ops to
register".

Acked-by: Paul Moore <paul@paul-moore.com>

>   *
>   * Description:
>   * Register the CALIPSO packet engine operations.

-- 
paul moore
www.paul-moore.com
