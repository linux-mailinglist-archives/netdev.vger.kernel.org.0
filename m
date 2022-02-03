Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B27B4A86CC
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351226AbiBCOpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347434AbiBCOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:45:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B060C061714;
        Thu,  3 Feb 2022 06:45:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31193619C5;
        Thu,  3 Feb 2022 14:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94370C340F0;
        Thu,  3 Feb 2022 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643899500;
        bh=4X60c9J7dyhyGgFLDNX3tftCODVhTZ8aDgMpH70B4D0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jf2ap6sVW+iM13htQpVRMj6v0TsX63zQhDH0Iid4nvYy+4jUC6LZAF9/hV/9pFvIb
         57nDKwma+uVjiZTN7uWg1QiG1JxbMlNVHWFm4e+CpZPOvRPOmuai9iIfYlU+kfoInz
         r/lml87oTUn0Ofm/RSzrn9RAYc2eMEFL3x7n285JgcmN9KOOzwHQt8fif3Of9jso2p
         dePyU1cfQsnPZdsMiAiCt2O1RWn3diVmPeIvspC90rMUG11zbLJrwGJR4CHB9rE8Hy
         VCiHl74aBCfKVyeDqFbEL1fpWRDSixT3FjCZDKBeTCNkR3wJzpNKH2fqXw5C6strdF
         cUzerl3+PNJ5g==
Received: by mail-ed1-f52.google.com with SMTP id b13so6540367edn.0;
        Thu, 03 Feb 2022 06:45:00 -0800 (PST)
X-Gm-Message-State: AOAM532YG8WKpw47io7J9a7lucr76OZaStXkNRoNXt8y3q0Z5IRPXECp
        zSzcqvVxjN8s4c3ndb1MHNBd8+VB7XS3b5LOOg==
X-Google-Smtp-Source: ABdhPJw6USRzkUs2MpEdvbFzpbuH5Gg1vUqLb2ph6uvapwZFrBu6VIyITj/70KieoZLN7eeCJZLMyfifbm340ZVUEhI=
X-Received: by 2002:aa7:d6d4:: with SMTP id x20mr35580598edr.307.1643899498934;
 Thu, 03 Feb 2022 06:44:58 -0800 (PST)
MIME-Version: 1.0
References: <20220201140723.467431-1-elder@linaro.org> <20220202210638.07b83d41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <eb09c869-c5c6-4be8-5265-072849f1ecd0@linaro.org>
In-Reply-To: <eb09c869-c5c6-4be8-5265-072849f1ecd0@linaro.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 3 Feb 2022 08:44:47 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLMit=e6vdum-xm1uxfCZcoJsTFe_S3k-QyVbvJPfNHew@mail.gmail.com>
Message-ID: <CAL_JsqLMit=e6vdum-xm1uxfCZcoJsTFe_S3k-QyVbvJPfNHew@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: add IPA qcom,qmp property
To:     Alex Elder <elder@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Gross, Andy" <agross@kernel.org>,
        David Miller <davem@davemloft.net>,
        Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, Alex Elder <elder@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 5:27 AM Alex Elder <elder@linaro.org> wrote:
>
> On 2/2/22 11:06 PM, Jakub Kicinski wrote:
> > On Tue,  1 Feb 2022 08:07:23 -0600 Alex Elder wrote:
> >> At least three platforms require the "qcom,qmp" property to be
> >> specified, so the IPA driver can request register retention across
> >> power collapse.  Update DTS files accordingly.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>
> >> Dave, Jakub, please let Bjorn take this through the Qualcomm tree.
> >
> > I don't know much about DT but the patch defining the property is
> > targeting net - will it not cause validation errors? Or Bjorn knows
> > to wait for the fixes to propagate? Or it doesn't matter? :)
>
> It might matter sometimes, but in this case it does not.
>
> If the DT property is present but never referenced by the
> code, it doesn't matter.
>
> The code in this patch looks up the DT property, and its
> behavior is affected by whether the property is there
> or not.  If it's not there, it's treated as an error
> that can be safely ignored.
>
> In the case this fix is actually needed, we'll need
> both the code present and DT property defined.  If
> the code is there but not the property, it's OK, but
> the bug won't be fixed quite yet.

If there's only one possible node that qcom,qmp points to, you can
just get the node by its compatible (of_find_compatible_node()). Then
you don't need a DT update to make things work. Of course, this
doesn't work too well if there are 10 possible compatibles without a
common fallback compatible.

Rob
