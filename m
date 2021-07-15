Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7C3CAEEE
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 00:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhGOWJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 18:09:44 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:39464 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhGOWJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 18:09:43 -0400
Received: by mail-pj1-f51.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so7495358pju.4;
        Thu, 15 Jul 2021 15:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6F+susvN5sjUJ3zQkT+ICC7UqFu5SaK3lj12wZr4/0=;
        b=ZwCneMwbj0JO9x7iOUD9weXnHjdvJ1JryMnTL4rQoqSndLneFutoiK1/bRNQGEx8h8
         MHT+CsQwt2oE9+VIHGG6MMQPGqDpTMQG2lP6BB+5WQxBcPujd9rzNYkfrEWdMYq3e9Xk
         fTXec5hSRvV1Z5SRbgvhnT89NkN4Bb4g57PUtIpJYBzJYFPpnh28eZOe5AZv/GXSHwpz
         i3AfoPkGWBGgDG6SdMoyGcFO/sRSg/Q2MbHu9y4PU7yOnUNtUixG8hkbAF8q169c+maP
         Lp+inf+N+vH4SGpF7XcU7vtskdfuMpPse00gSccPOL9xpu8T2XZbV/yCTLzNhr4JdImp
         MmlA==
X-Gm-Message-State: AOAM531/fa5xDwNUsy8KpxUAx3Q/EtuVyIc1bOlr7e3dzhc3FfoIC2QK
        eFrzN7YXVzrEivBfaUT3clg=
X-Google-Smtp-Source: ABdhPJyAswla2aaWzBgfxN1RCTmTjsX0BIv5XRpXRfo5GXFJQkNYA0AgYLtvOnNpGa4lxcQIGAlRZQ==
X-Received: by 2002:a17:90b:1294:: with SMTP id fw20mr12313031pjb.100.1626386808202;
        Thu, 15 Jul 2021 15:06:48 -0700 (PDT)
Received: from garbanzo ([191.96.120.37])
        by smtp.gmail.com with ESMTPSA id y5sm7445783pfn.87.2021.07.15.15.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 15:06:46 -0700 (PDT)
Date:   Thu, 15 Jul 2021 15:06:44 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intersil: remove obsolete prism54 wireless driver
Message-ID: <20210715220644.2d2xfututdoimszm@garbanzo>
References: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 07:40:25AM +0200, Lukas Bulwahn wrote:
> Commit 1d89cae1b47d ("MAINTAINERS: mark prism54 obsolete") indicated the
> prism54 driver as obsolete in July 2010.
> 
> Now, after being exposed for ten years to refactoring, general tree-wide
> changes and various janitor clean-up, it is really time to delete the
> driver for good.
> 
> This was discovered as part of a checkpatch evaluation, investigating all
> reports of checkpatch's WARNING:OBSOLETE check.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
