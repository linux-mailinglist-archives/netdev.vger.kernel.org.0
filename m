Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B404324EC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhJRRZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhJRRZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:25:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE00C06161C;
        Mon, 18 Oct 2021 10:23:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v20so11723902plo.7;
        Mon, 18 Oct 2021 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:to:cc:subject:from:date
         :message-id:in-reply-to;
        bh=KDtNvROv/emFHAIcdrMJhdJgVC4zcXHGcLaLCPrH1OA=;
        b=Zj5uiURO92L8XvERHEm0QTtpUBIK8I8U+kgMLUJMWArshfy4CuQ5qBBwv35ptCjh/u
         0bwhw0+PSc5VO4G+EybDHgTrCFqIkTnha8ixKGazLDoFliUWDRWkgQLSBmmwPxtv+hmB
         FpnABZG5YW4HBAc3a27OkFcSv3y8YG5wvoHrQ4vZl3TNaNnXBx/KnXimjezsTPiwY8jB
         +TiGQ7NbyV2CZ6b02DjkHtDe7E4NWUGW/Vyb7ZtNyx1mKTDs9NrEpmbsMvvXR+CKPwtb
         7HBZ763ZdBuIOX04zmADDYA6KAEGlKnHq7OaAvfDkR+hOSVQ5IiiHjg5kR7BM/QLYk4I
         FFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:to:cc
         :subject:from:date:message-id:in-reply-to;
        bh=KDtNvROv/emFHAIcdrMJhdJgVC4zcXHGcLaLCPrH1OA=;
        b=W5HllaLhDv0tx0ocUAMYW4Y3/Wg8oxmsmVGDsl3hh86cuwnttQnAMutMnoPe+zz6zp
         ajI5xkSxGZc3pXbUFyQKyIZz2xVqtx/0Hksz/llOcJA01EL/jGLMeQIjRVhGcOjEn07t
         ZJP2d/Bp9sBIkYwUFRftQnGqAKHnwWgCvPZuyEs8ibXu6tXBXmPWKl+6f5LRFs4OwWjU
         aLuXrUSfzNSC8X54kSKP4ttB0XsBUSai4OQ4oGtFsnyCs7xQEkpdifxhVA4I3DJ9HK47
         S5vnRXZQowBMpQ076XfX78CAgDNIbOPxpM8I4NhjEgKqFuZeEdtYeKAzeSmPwL8wz0hn
         XXbA==
X-Gm-Message-State: AOAM530r8yBr3bGWEb/JWa7g7bhZ7Wu+DwveZ3BlY73BldmgQkd/WwsQ
        oNeTDQGsHBb/gKAvVIgVv/Q=
X-Google-Smtp-Source: ABdhPJx40xJU8YE1isP+oL8/lINyv5pBl24icWiCna71nEI8P6QEHIWo7YAGX9JEZRNhlcZrYal87A==
X-Received: by 2002:a17:902:e74a:b0:13f:3538:fca0 with SMTP id p10-20020a170902e74a00b0013f3538fca0mr28311600plf.22.1634577782509;
        Mon, 18 Oct 2021 10:23:02 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id ip10sm34849pjb.40.2021.10.18.10.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:23:01 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Cc:     "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 06/17] net: ipa: Add timeout for
 ipa_cmd_pipeline_clear_wait
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
Date:   Mon, 18 Oct 2021 22:32:31 +0530
Message-Id: <CF2P11HZE0H2.S4II3PH6QLCF@skynet-linux>
In-Reply-To: <5219dde9-665d-a813-a9b8-3db51aea97b5@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 3:59 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > From: Vladimir Lypak <vladimir.lypak@gmail.com>
> >=20
> > Sometimes the pipeline clear fails, and when it does, having a hang in
> > kernel is ugly. The timeout gives us a nice error message. Note that
> > this shouldn't actually hang, ever. It only hangs if there is a mistake
> > in the config, and the timeout is only useful when debugging.
> >=20
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
>
> This is actually an item on my to-do list. All of the waits
> for GSI completions should have timeouts. The only reason it
> hasn't been implemented already is that I would like to be sure
> all paths that could have a timeout actually have a reasonable
> recovery.
>
> I'd say an error message after a timeout is better than a hung
> task panic, but if this does time out, I'm not sure the state
> of the hardware is well-defined.

Early on while wiring up BAM support, I handn't quite figured out the
IPA init sequence, and some of the BAM opcode stuff. This caused the
driver to hang when it would reach the completion. Since this particular
completion was waited for just before the probe function retured, it
prevented hung up the kernel thread, and prevented the module from being
`modprobe -r`ed.

Since then, I've properly fixed the BAM code, the completion always
returns, making the patch kinda useless for now. Since its only for
debugging, I'll just drop this patch. I think the only error handling we
can do at this stage is to return -EIO, and get the callee to handle
de-initing everything.

Regards,
Sireesh

>
> -Alex
>
> > ---
> >   drivers/net/ipa/ipa_cmd.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
> > index 3db9e94e484f..0bdbc331fa78 100644
> > --- a/drivers/net/ipa/ipa_cmd.c
> > +++ b/drivers/net/ipa/ipa_cmd.c
> > @@ -658,7 +658,10 @@ u32 ipa_cmd_pipeline_clear_count(void)
> >  =20
> >   void ipa_cmd_pipeline_clear_wait(struct ipa *ipa)
> >   {
> > -	wait_for_completion(&ipa->completion);
> > +	unsigned long timeout_jiffies =3D msecs_to_jiffies(1000);
> > +
> > +	if (!wait_for_completion_timeout(&ipa->completion, timeout_jiffies))
> > +		dev_err(&ipa->pdev->dev, "%s time out\n", __func__);
> >   }
> >  =20
> >   void ipa_cmd_pipeline_clear(struct ipa *ipa)
> >=20

