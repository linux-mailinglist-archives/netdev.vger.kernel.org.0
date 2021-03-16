Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2E33CC10
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 04:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhCPD03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 23:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhCPD0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 23:26:03 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE61C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:26:03 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o3so3221290pfh.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fjMIfUsZnCXQJsEAAAgrQIk9D2xVnNLZ9/liKfzD+b4=;
        b=egpVYnZuuRTGL8y732yGwV1ZbDLlXQbelFLrqv1LArLOr8lnij4ZYeJgpmmqLRnh51
         Ftwt99+TiiPWnxCG10q2Xo8saFKCGWPwkVA3CK0xfEP8qjY3Ec/9kHgU7gk64aQcDYpL
         C3l/DOmkIRicJJ5TPxPZI4bksMLiqQSQWLaHZkLnA2smGRIiEmq7w3jQ6Hi6NzCgbdsl
         Ur9LDs79rLytU973V5MkCuuAL18ukqbp8JWQDljLeolXLw+0F3pw0rQrUrMDe4O2PDMq
         +K3bXnKwQG5ZbrrmjTNr7MBkWTmtEcPUO0oVR+V9axbxBDoy05cPtzVvCksS03UrL8UZ
         jdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fjMIfUsZnCXQJsEAAAgrQIk9D2xVnNLZ9/liKfzD+b4=;
        b=csoIN64zZXA/KlepfjtRRB8ZIRg4shbhcbeEbuSRhoZO/9UfVwdW/l6rU9C0W9qo/D
         R7j7237IC6JmQSp0e6Lyen9sAzojUh0Ali0lnejsCURAZY14jqfVavMhCjuvZcBDXISG
         Fb/C1EaS/sJbAQ9Q+wx1w4ZGejHSLsiNADy5DFCerceXT8wlwSpPyNHD76tXZP3ffsTz
         jhROZr55xsydDL9hgKy33qN+J1vXY7ZP5iBjv6wBJA8wrMLX57Qs5K2RUCbn1Yr9naq7
         jG+JpdB918zXP61Noxzlzso168SEkYwq2sq6YILbZ16t4ojlLy9bAgt2xArRypv6YhCD
         aang==
X-Gm-Message-State: AOAM532BDv58W12mZB7XAXXIu28+PxMHpVCu4ntuveEkUG2vh9ClkD5A
        bQw78lSJ2zN37CtUrhjQQLDA
X-Google-Smtp-Source: ABdhPJysVgtuqvsFtF8Eq73eB4ke9iHm7myflKg6MywbLsbgxP8J4SxdgmBAEW2K/YQ7qeXQW9DFtQ==
X-Received: by 2002:a63:4d09:: with SMTP id a9mr2068867pgb.90.1615865162334;
        Mon, 15 Mar 2021 20:26:02 -0700 (PDT)
Received: from work ([103.66.79.72])
        by smtp.gmail.com with ESMTPSA id 35sm14151148pgm.64.2021.03.15.20.25.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 20:26:01 -0700 (PDT)
Date:   Tue, 16 Mar 2021 08:55:57 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: ipa: QMI fixes
Message-ID: <20210316032557.GB29414@work>
References: <20210315152112.1907968-1-elder@linaro.org>
 <20210315163807.GA29414@work>
 <3e01bc57-8667-4c56-2806-2ba009887bd4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e01bc57-8667-4c56-2806-2ba009887bd4@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 11:50:15AM -0500, Alex Elder wrote:
> On 3/15/21 11:38 AM, Manivannan Sadhasivam wrote:
> > Hi Alex,
> > 
> > On Mon, Mar 15, 2021 at 10:21:09AM -0500, Alex Elder wrote:
> > > Mani Sadhasivam discovered some errors in the definitions of some
> > > QMI messages used for IPA.  This series addresses those errors,
> > > and extends the definition of one message type to include some
> > > newly-defined fields.
> > > 
> > 
> > Thanks for the patches. I guess you need to add Fixes tag for patches 1,2 and
> > they should be backported to stable.
> 
> I did not do that, intentionally.  The reason is that the
> existing code only supports IPA v3.5.1 and IPAv4.2.  And
> these bugs seem to cause no problems there.
> 
> There are some patches coming very soon that will add
> more formal support for IPA v4.5 (where I know you
> found these issues).  Those will not be back-ported.
> 
> So these fixes don't appear to be necessary for existing
> supported platforms.
> 

Hmm, okay. Then please mention this information in the commit description(s)
that the fix is only needed for IPA4.5.

Thanks,
Mani

> If you still believe I should have these back-ported,
> I have no objection to re-posting for that.  But I
> wanted to explain my reasoning before doing it.
> 
> --> Do you still think I should have these back-ported?
> 
> Thanks.
> 
> 					-Alex
> 
> > 
> > Thanks,
> > Mani
> > 
> > > 					-Alex
> > > 
> > > Alex Elder (3):
> > >    net: ipa: fix a duplicated tlv_type value
> > >    net: ipa: fix another QMI message definition
> > >    net: ipa: extend the INDICATION_REGISTER request
> > > 
> > >   drivers/net/ipa/ipa_qmi_msg.c | 78 +++++++++++++++++++++++++++++++----
> > >   drivers/net/ipa/ipa_qmi_msg.h |  6 ++-
> > >   2 files changed, 74 insertions(+), 10 deletions(-)
> > > 
> > > -- 
> > > 2.27.0
> > > 
> 
