Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACFA244CCC
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHNQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHNQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:38:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18A2C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:38:35 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 3so8454022wmi.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SBRnLFjikbgUE3zhul5CZPoOJXI826l4dDRWqFfAQRw=;
        b=KFwZiGgGsHOEQTkED76nmBtiNDbHKD6KDhybIgSAGbZvZJg0xNdODvEI53hyV7GVQq
         fv6hqAIMlvAzZZ/H+0svImJXztuW8n+06vvlckdkmKFvtA30QhP8xutcoXJqrxq0GxXk
         1b5uZAP095ez+KqvWry9UQgjiMeVB4IZkisACV1h9qlAVFN59iLGEeuij5V7ciNXqLrR
         DAHbNYpEOpitJZR4USDa+8UbITYPbhO6VHr6Rvfmo8CEKofCfAyITHcfBbrxc2szZznV
         FGGP9j5NnYrV6b8JVilkN+og4BUDJJIFUNq1WvIqeKb8lPc+kwlIO3BQdDraGHhz5SQL
         0UTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SBRnLFjikbgUE3zhul5CZPoOJXI826l4dDRWqFfAQRw=;
        b=VBUiIjqLhNit+qE1ddeSoZY6fquIfFulJNu/dCqyfwdswsaMmY67XdZkCllJDvGCTz
         7Ow5YVcDbnw+EEGkNmWV755LjjwpCE93UkdcarImEL3RjYtAkgREmVj6HWLuweu9dLBN
         TsB2hfstV81iz0XlC+Kh01v1vlMWRfUIw8H66oAnlmurNPn7JfpzMl3eh0Uu5kHFgXQm
         38yBCeEO+zRPWqTeFYfd2XV4uFtX8Skkiah+33skRyVgG8qP+yHHFIHeQGEmMF/y0n7u
         ED4uJ/B2EPhp3VC0EP2svx56GFrwjmrw6in29JptV/B1GatGiCOuO0F8cMOuWsyxNqza
         x86A==
X-Gm-Message-State: AOAM531t1cmngZbkipA41TZfUCZ1cWXx/hIwOqi4f3IfIXGFEVneLBdc
        UOKTtvZ2sV6X1ASJ3lVkwpyqsw==
X-Google-Smtp-Source: ABdhPJzibn0jjmtjzLY2ilhQ9fx+rMUtqgQREpZcOlyPu6KoHh7sYeqxx1ZLF1RbiozQAYxr3iNwGQ==
X-Received: by 2002:a1c:3285:: with SMTP id y127mr3273780wmy.104.1597423114464;
        Fri, 14 Aug 2020 09:38:34 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id r22sm16053717wmh.45.2020.08.14.09.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 09:38:33 -0700 (PDT)
Date:   Fri, 14 Aug 2020 17:38:31 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        Fabrice Bellet <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding
 style issues
Message-ID: <20200814163831.GN4354@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-13-lee.jones@linaro.org>
 <87r1s9l0mc.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1s9l0mc.fsf@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> 
> >  - Ensure spaces appear after {for, if, while, etc}
> >  - Ensure spaces to not appear after '('
> >  - Ensure spaces to not appear before ')'
> >  - Ensure spaces appear between ')' and '{'
> >  - Ensure spaces appear after ','
> >  - Ensure spaces do not appear before ','
> >  - Ensure spaces appear either side of '='
> >  - Ensure '{'s which open functions are on a new line
> >  - Remove trailing whitespace
> >
> > There are still a whole host of issues with this file, but this
> > patch certainly breaks the back of them.
> >
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Benjamin Reed <breed@users.sourceforge.net>
> > Cc: Javier Achirica <achirica@users.sourceforge.net>
> > Cc: Jean Tourrilhes <jt@hpl.hp.com>
> > Cc: Fabrice Bellet <fabrice@bellet.info>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/wireless/cisco/airo.c | 897 ++++++++++++++++--------------
> >  1 file changed, 467 insertions(+), 430 deletions(-)
> 
> This is a driver for ancient hardware, I'm not sure if it's worth trying
> to fix any style issues. Is anyone even using it? Should we instead just
> remove the driver?

Sounds like a reasonable solution to me.

I'm also happy to do it, if there are no objections.

As it stands, it's polluting the code-base and the build-log, so
something should be done.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
