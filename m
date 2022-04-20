Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B84508AB0
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379400AbiDTOZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiDTOZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:25:47 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC4443CB;
        Wed, 20 Apr 2022 07:23:00 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k23so3921229ejd.3;
        Wed, 20 Apr 2022 07:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0CmqVSEyr5oxQFOzuYLQLKaW8kImH7fUNHhx+P1KJE8=;
        b=dQnEOcVbqA90ofiORko3dhR8FewYKP28J782X1pM6JW8ENFUzFO4OgW0Ga02BXNXeB
         xwBcgUpJWs9j5+iyiUQPpr2o3z/ZqpbWHZhIWPKCnk5EgaIc5q2Xmy7eBrBiKR71Z+pS
         6YvAUeH9CEKuEZ19x7udQghHuKP98VAPIMdFR4+xnGv4UwmwUd89ugTp+qQ1bOmOGU+o
         arOw8hXZpxMaFYcHklfekrsexgBDcAfDBmtZBfaNaFAYMXkE07crG9nNcwDp3c6LnDLD
         HvJIzOh3f2uBVjBKEumJazd2zzwmkiFISfTKPHegu4FWPK6g+sZzYhNWGXf9Pcz/C4cy
         jmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0CmqVSEyr5oxQFOzuYLQLKaW8kImH7fUNHhx+P1KJE8=;
        b=FfctC4Lz7hLGoh4FFXCAkQsZtq+Pxp5LHQ0p4jAkGtThXo2d9H7Bu5g4hrrESI14LO
         lItBvA9S6k9QOJb/xvVl4bZYje/5Bv9H/KlLK+NFbfT2YX8Vws1mj67HvlhMglgPd1PD
         XzfGb2YxZta676aos276SLayBuWQJGmLoaBdpk20nlk5Mcf0y0DbQRLQL1/v+NHlBW6B
         F4j7zZTNIvEJrBUXSDcFTCQJt6tAgJwZLor3/lU9uhgVa1oi1bkjIs3Htq4ZhCAfk3pm
         ngsayfttBNMYAcyzFi3JXVO6yvuLlOt8tR2Cd1OxOSoOsOqdAVOBwXZPUgWxN2gOuQTX
         QqXw==
X-Gm-Message-State: AOAM530R+wDQdrjQAKmntoh4nw8tqvX6aFmlVmVT+O2ZCX3nrI9e8d4G
        bIPk0DAPCiixx/IGeZHPhG4MWnB/e0vrRUD9BrEghH4q
X-Google-Smtp-Source: ABdhPJzHVZq9a1q9EtLrfdpycVRT4qJFO6PlqcbQ0dYoutDFb5PAe59znOIGP9nW2ueZ6mifemMr2vboCf4TAyqyoUM=
X-Received: by 2002:a17:906:68c2:b0:6b4:9f26:c099 with SMTP id
 y2-20020a17090668c200b006b49f26c099mr19118939ejr.41.1650464579188; Wed, 20
 Apr 2022 07:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220402155551.16509-1-krzysztof.kozlowski@linaro.org> <a3edf0e1-644a-38b2-b23d-30cc01005786@linaro.org>
In-Reply-To: <a3edf0e1-644a-38b2-b23d-30cc01005786@linaro.org>
From:   Jassi Brar <jassisinghbrar@gmail.com>
Date:   Wed, 20 Apr 2022 09:22:47 -0500
Message-ID: <CABb+yY3uRxKdQ_Q-yvWipmOqLNbJXmJ141oYJnq1di_Yu66T_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: mailbox: qcom-ipcc: simplify the example
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Alex Elder <elder@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 3:42 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 02/04/2022 17:55, Krzysztof Kozlowski wrote:
> > Consumer examples in the bindings of resource providers are trivial,
> > useless and duplicating code.  Additionally the incomplete qcom,smp2p
> > example triggers DT schema warnings.
> >
> > Cleanup the example by removing the consumer part and fixing the
> > indentation to DT schema convention.
> >
> > Reported-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> Jassi,
> Do you plan to pick this mailbox patch?
>
Yes, I do.  I am ok too, if you want it through some other tree as a
part of some bigger patchset.

thanks.
