Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EB632A2DA
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837708AbhCBIdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241531AbhCBCJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:09:11 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAFDC061794
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 18:05:00 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n132so8232211iod.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 18:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HqdANY9y5AYuxPx3w0i4b01BDqKwut4FMsN/JKnUcuc=;
        b=c8XyROxhXBKl6A8mXQRLlLxvJ0tuIYYMr/dShL9FDdsJKDJK/IZGqRn4rQXGWWzGrm
         I4ImzBkN7G1t4I9UedzctqyupAUYh+vEjM0gZUXLyU0GVpe9Xtj5YiUGxuHJNbZrKSD5
         r0PKWZYDii0ZFrIg+qZZLTXmHynkl4SBDZ1Nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HqdANY9y5AYuxPx3w0i4b01BDqKwut4FMsN/JKnUcuc=;
        b=oD73OUQpwCnDsAP1VWeDVipGTOnD5xOYALPhb2PJ5y0MLWSbx5CI1ACmmkE4zTKQBy
         GocowZf6ea9xmbq1UOdgLDiGEw/WeXxLzQsH5PsY8rWv9uN5/g1BqpoN3Lj6Lvj5rWfP
         I7FbMlLvaX+cpkLOLfip6wgKiZHzsaSFJa0wrGh01MUgYtVAz5eK7IFXuXdlg7aqP/V7
         u03ebZO91lP4uuxPVYDAPx+Ad57/SnVQSJOdUyC72QkFJ5EIGIcSZjup0T1Ii6L+uYiE
         qy8SgDfGj6g30GBc/iB2Mmyd7qiSSHUof8YeBlHiL551ELtfjK184mSvzOoQOhe6PeRJ
         ZjPw==
X-Gm-Message-State: AOAM531aYazajIssgZSG+BA6tX9sA10Txm6hbWdVjfRrM9pVRgLKV5DC
        y4WppvSQ4Wj9yfrs0A5js/fkJg==
X-Google-Smtp-Source: ABdhPJzval9M2rcD/DMvSv6RLyCovCuBjN9rV6e0uf/10cBzJxxODj0S+DS288YKJTPfS7N9+FhpDQ==
X-Received: by 2002:a6b:6618:: with SMTP id a24mr4088209ioc.100.1614650699771;
        Mon, 01 Mar 2021 18:04:59 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k23sm11086143ior.12.2021.03.01.18.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 18:04:59 -0800 (PST)
Subject: Re: [PATCH v1 0/7] Add support for IPA v3.1, GSI v1.0, MSM8998 IPA
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <d47de177-e7ef-d39f-902e-1888968c0085@ieee.org>
Date:   Mon, 1 Mar 2021 20:04:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> Hey all!
> 
> This time around I thought that it would be nice to get some modem
> action going on. We have it, it's working (ish), so just.. why not.
> 
> This series adds support for IPA v3.1 (featuring GSI v1.0) and also
> takes account for some bits that are shared with other unimplemented
> IPA v3 variants and it is specifically targeting MSM8998, for which
> support is added.

It was more like "next month" rather than "next week," but I
finally took some more time to look at this today.

Again I think it's surprising how little code you had
to implement to get something that seems is at least
modestly functional.

FYI I have undertaken an effort to make the upstream code
suitable for use for any IPA version (3.0-4.11) in the
past few months.  Most of what I've done is in line with
the things you found were necessary for IPA v3.1 support.
Early on I got most of the support for IPA v4.5 upstream,
and have been holding off trying to get other similar
changes out for review for other versions until I've had
more of a chance to test some of what's new in IPA v4.5.

In the coming weeks I will start posting more of this
work for review.  You'll see that I'm modifying many
things you do in your series (such as making version
checks not assume only v3.5.1 and v4.2 are supported).
My priority is on newer versions, but I want the code
to be (at least) correct for IPA v3.0, v3.1, and v3.5
as well.

What might be best is for you to consider using the
patches when I send them out.  I'll gladly give you some
credit when I do if you like (suggested-by, reviewed-by,
tested-by, whatever you feel is appropriate).  Please
let me know if you would like to be on the Cc list for
this sort of change.

> Since the userspace isn't entirely ready (as far as I can see) for
> data connection (3g/lte/whatever) through the modem, it was possible
> to only partially test this series.

Yes we're still figuring out how the upstream tools need
to interact with the kernel for configuration.

> Specifically, loading the IPA firmware and setting up the interface
> went just fine, along with a basic setup of the network interface
> that got exposed by this driver.

This is great to hear.

> With this series, the benefits that I see are:
>  1. The modem doesn't crash anymore when trying to setup a data
>     connection, as now the modem firmware seems to be happy with
>     having IPA initialized and ready;
>  2. Other random modem crashes while picking up LTE home network
>     signal (even just for calling, nothing fancy) seem to be gone.
> 
> These are the reasons why I think that this series is ready for
> upstream action. It's *at least* stabilizing the platform when
> the modem is up.
> 
> This was tested on the F(x)Tec Pro 1 (MSM8998) smartphone.

I unfortunately can't promise you you'll have the full
connection up and running, but we can probably get very
close.

It would be very helpful for you (someone other than me,
that is) to participate in validating the changes I am
now finalizing.  I hope you're willing.

I'll offer a few more specific comments on each of your
patches.

					-Alex


> AngeloGioacchino Del Regno (7):
>   net: ipa: Add support for IPA v3.1 with GSI v1.0
>   net: ipa: endpoint: Don't read unexistant register on IPAv3.1
>   net: ipa: gsi: Avoid some writes during irq setup for older IPA
>   net: ipa: gsi: Use right masks for GSI v1.0 channels hw param
>   net: ipa: Add support for IPA on MSM8998
>   dt-bindings: net: qcom-ipa: Document qcom,sc7180-ipa compatible
>   dt-bindings: net: qcom-ipa: Document qcom,msm8998-ipa compatible
> 
>  .../devicetree/bindings/net/qcom,ipa.yaml     |   7 +-
>  drivers/net/ipa/Makefile                      |   3 +-
>  drivers/net/ipa/gsi.c                         |  33 +-
>  drivers/net/ipa/gsi_reg.h                     |   5 +
>  drivers/net/ipa/ipa_data-msm8998.c            | 407 ++++++++++++++++++
>  drivers/net/ipa/ipa_data.h                    |   5 +
>  drivers/net/ipa/ipa_endpoint.c                |  26 +-
>  drivers/net/ipa/ipa_main.c                    |  12 +-
>  drivers/net/ipa/ipa_reg.h                     |   3 +
>  drivers/net/ipa/ipa_version.h                 |   1 +
>  10 files changed, 480 insertions(+), 22 deletions(-)
>  create mode 100644 drivers/net/ipa/ipa_data-msm8998.c
> 

