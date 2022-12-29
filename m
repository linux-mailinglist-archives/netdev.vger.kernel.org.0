Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82E6658E14
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 15:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiL2OwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 09:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiL2Ov5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 09:51:57 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6260614031
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:51:23 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id m18so45394392eji.5
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PG+WeC3Cp4TpgsJ28lC9Nv2YiRCP6D0mmvV9Og+R4oA=;
        b=OK5J0H2e/dKcIOGzZGy+Pp3X+YDuz4tq9WDn/3X82mdq1mn+ud7jg8iHR2hBWmArs3
         cFy41Nzd2uWa+HMrc7ZUawYFk98VWCqAhdJ0grt8vEKMOxmngwrM/YKo+39Od6gSsEGF
         0c+e6MFB+VBbuxnzsYqYrRfgGzFbEAsCwNuFivDp3dIYoode6lQYrGlXGYUU0myOTSZm
         FeTtfXAmUffUK3X7P7ArS+3XsrtIzrNcdQIeoKSYqF0bWNK8FcMTrs0vFutzswTjbfsP
         HNhctjEjacbfoSEbvR/0krB5TRw9vkQAjrUIOIqD4spI28KTILnPQ41qYeFBhhpId4Yd
         U+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PG+WeC3Cp4TpgsJ28lC9Nv2YiRCP6D0mmvV9Og+R4oA=;
        b=8R1WZv/Izwxir43rCGiTYelEi4O8MEtHd6ivIeEz4VkEYQks/h0Vyh5o+T5gvUyj3d
         webEJ+fZWWfBE/IyybJ8LRMMiI4svXTvYzYOKXOPz97jKn9VHN1Mr35YTePI5OuL/E+8
         lwHC5iY4kVtyhdZIhaQQZKGYiKMl9tBXgM+uexvUWbS/gkvl0IpK39FlpZLTr5xhuRFU
         eLPAP3lHkZ1YJpByvDlkrUdITLzW0WS19sQmEFHZOMutKa7mxZ1muAV3jKcru9DXCEd/
         TEP35wzGoDzN9nUagiI1M47Mg0YkxEOSjJ+rPPRvP1S0NOeoaRrLDMTZBUmYqiW2suHb
         Kpgw==
X-Gm-Message-State: AFqh2koBh3WO3TTczB2DiJNlPHZOZjzKgWe0xLltwjcgiIs5PZgasxvJ
        4K0YuwvQRU6uPnSSyDbVYh0SpgX2QJjLTpMRPs1KGA==
X-Google-Smtp-Source: AMrXdXtKIlc6jw7E54fcBCQ5FX+Kl/AOv8m9ALcUO2VJlP7dUMypLQQkf5iFDKzqsABBzquYAmDSqhggNSN+Du0tDK8=
X-Received: by 2002:a17:907:c388:b0:7c1:8fa0:527 with SMTP id
 tm8-20020a170907c38800b007c18fa00527mr3778161ejc.180.1672325481740; Thu, 29
 Dec 2022 06:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20221229142219.93427-1-mig@semihalf.com> <8e4ec6b0-63cf-c086-c00e-5b4e8a2b2d25@linaro.org>
In-Reply-To: <8e4ec6b0-63cf-c086-c00e-5b4e8a2b2d25@linaro.org>
From:   =?UTF-8?Q?Micha=C5=82_Grzelak?= <mig@semihalf.com>
Date:   Thu, 29 Dec 2022 15:51:10 +0100
Message-ID: <CADcojVOt+pWSZkVdOSE15HmdfFSZWNDUkEA1hNvn62vGAYjFsg@mail.gmail.com>
Subject: Re: [PATCH v3] dt-bindings: net: marvell,orion-mdio: Fix examples
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, chris.packham@alliedtelesis.co.nz,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        upstream@semihalf.com, mw@semihalf.com, mchl.grzlk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Thu, Dec 29, 2022 at 3:30 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 29/12/2022 15:22, Micha=C5=82 Grzelak wrote:
> > As stated in marvell-orion-mdio.txt deleted in commit 0781434af811f
> > ("dt-bindings: net: orion-mdio: Convert to JSON schema") if
> > 'interrupts' property is present, width of 'reg' should be 0x84.
> > Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and add
> > constraints checking whether 'interrupts' property is present
> > and validate it against fixed values in reg.
> >
> > Signed-off-by: Micha=C5=82 Grzelak <mig@semihalf.com>
>
> This is a friendly reminder during the review process.
>
> It looks like you received a tag and forgot to add it.
>
> If you do not know the process, here is a short explanation:
> Please add Acked-by/Reviewed-by/Tested-by tags when posting new
> versions. However, there's no need to repost patches *only* to add the
> tags. The upstream maintainer will do that for acks received on the
> version they apply.
>
> https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submi=
tting-patches.rst#L540
>
> If a tag was not added on purpose, please state why and what changed.

Deletion of tag wasn't on purpose, it was done by accident. Would you
like me to resend the patch with it being added, or leave it as is?

Best regards,
Micha=C5=82
