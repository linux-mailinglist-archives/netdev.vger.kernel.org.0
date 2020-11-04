Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0842A5EC4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 08:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgKDHbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 02:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgKDHbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 02:31:00 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAB7C061A4D
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 23:31:00 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id x7so20938739wrl.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 23:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=c6Dw4Oh70AUqvuYgkCEu2jgIdPZX0sPO5ocpgrcIOEU=;
        b=hHrQPgZGd4auGPAWPOUZtYfvCL+4WB52SCZQNXoR5qIFdHbJAdmH249e9aDuCAuknW
         LrYFn2HMGSZwDR4NQeselc6wGFtKDWlhsgcaaijqtmYUQysobyyihCSf/49CUnnO+tzm
         dtF3CfHGU/H2paQMdsflPGmdp6Z/oXuc7ZpisEDbQV+EnbA3pmBtiTbHYVnjmT9YEVYD
         6PKE9M8thpdokQSSLSrGi1qtTsJwpimarsvLv+e6IvBtbjWKsZrPBW0BcGIl7UJ6+pyE
         NbCwxyUK3hU9TjFaaz4/B4neitobaJMtmconSJsn01wdnjbra2S00XyPjAeqEJ1AnWtN
         fbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=c6Dw4Oh70AUqvuYgkCEu2jgIdPZX0sPO5ocpgrcIOEU=;
        b=JcNH+YxwCv7XdKYYYUBeH0TL+KRRaaXervwA96O7iFn4EAzmJ+wXOP7Rnf7ih3X5tA
         FcjApllSiy7VEwXVrZLjLObGGGu0yMdaelVWGYhw2Lvuib08rEX+0fXlkn+5kP77zaGV
         vTbxbS4FQ3PBtyDxcf0olxAdGdjZP1l8/QEKWqIi2TSzMnj8v/5sLP2t+Rdh2Ck9iytJ
         0CjBPEAjNs43uBF/QkxmA9hUGrHFjI5S5fR8Duji0MFfHc+zE2AVvRjdFAdPyp4fEZvD
         fC7WLbV8ywqNKXMTQDxyR/YJfZx/lXqhaAhAYRSq0LWU8zyowmbu7usthLOJNmyuqRnW
         cA1g==
X-Gm-Message-State: AOAM5338gJdVeJ1a7awg+exsWY7d1HW2WxZvr3/AugXf1XZTkwpreBHr
        62Z1Ti50QvZUo1rtwoIYYk9kiA==
X-Google-Smtp-Source: ABdhPJyjbAauULXGWqfZNu96N6BfmEmRX61Q0zlepKz8zipaaTq99e1uJzL3bhk1pwcaA9prM2uarQ==
X-Received: by 2002:adf:9069:: with SMTP id h96mr31943951wrh.358.1604475059051;
        Tue, 03 Nov 2020 23:30:59 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id 130sm1265646wmd.18.2020.11.03.23.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 23:30:58 -0800 (PST)
Date:   Wed, 4 Nov 2020 07:30:56 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 01/30] net: fddi: skfp: ecm: Protect 'if' when AIX_EVENT
 is not defined
Message-ID: <20201104073056.GQ4488@dell>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-2-lee.jones@linaro.org>
 <20201103164610.249af38c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201104072831.GP4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104072831.GP4488@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020, Lee Jones wrote:

> On Tue, 03 Nov 2020, Jakub Kicinski wrote:
> 
> > On Mon,  2 Nov 2020 11:44:43 +0000 Lee Jones wrote:
> > > When AIX_EVENT is not defined, the 'if' body will be empty, which
> > > makes GCC complain.  Place bracketing around the invocation to protect
> > > it.
> > > 
> > > Fixes the following W=1 kernel build warning(s):
> > > 
> > >  drivers/net/fddi/skfp/ecm.c: In function ‘ecm_fsm’:
> > >  drivers/net/fddi/skfp/ecm.c:153:29: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > > 
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Okay, I applied most of these,
> 
> Thank you.
> 
> > but please don't post series larger than 15 patches in the future.
> 
> No problem.
> 
> > Also each patch series should have a cover letter.
> 
> https://lore.kernel.org/lkml/20200817081630.GR4354@dell/

Whoops.  Wrong one.

Ah, I see what happened.

It looks like it was only sent to Dave for some reason.

Apologies.  Will fix in the future.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
