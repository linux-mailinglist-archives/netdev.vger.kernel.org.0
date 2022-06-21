Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504115539AE
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiFUSr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 14:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiFUSr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 14:47:56 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54866264;
        Tue, 21 Jun 2022 11:47:55 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id q4so9637594qvq.8;
        Tue, 21 Jun 2022 11:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUwsjMEcTcJGTkqP1tI4ks5+DOl4Jo9qz8wBuhs7k1Q=;
        b=Q+KB8KiHfVZN/IcFhqa6GwDdZVAb/1h5YJpQ4fznMd3FxHLy83GhnTWQ1iWjVerrRQ
         oIc+S7GlOeG2zMH3AUxQ69u3ZO08rrQGR787XFx7RR3Kw6Fo4484d5rGtoIv49PFSELW
         1JJjmO7hszywj4GDpeX//vV2vEkF1mORa19P7KWmna8rzhPDm0vsvm7M1xcuqWOUaRPH
         9FxUKMbFmncFHYT+GhagELHCylo+sxgXgrjada7iWE++btcWJCRGrLWNNmNst2Bg7PgT
         wTCRoHT2XZe5KHRdycaNfciWRGTrb9+NQWDCAymUVmMrzmW3sSyuMrAgMjJWtZOxxPj3
         v9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUwsjMEcTcJGTkqP1tI4ks5+DOl4Jo9qz8wBuhs7k1Q=;
        b=lZu9PVACC6j+QoNvYfcUqgNlPSEDtjuUniLKFwdenQkha5/Tyajsef2y0k2Fk7t2mu
         v24rD9f0AqtxDWBMura+MoHmdSaAv24wz4rfU4Lvz4VYivZepNmuEu7HXRSaZnJVRfva
         cBHao7ysae25GlhxnJSWIT9VQmxgdd+RmUsdombqDG/Nw8goqUKF4/1pDfyGbZvBRGZ8
         dmLmHfNCDmnM8sHQWeoOw+SF3gG/LuLMzBAKVk+et0B5QuaCYjmA5s82BhWM8A92ZmzI
         AGjsLDmebVRASCT19p1EbWxQzvWGLo1TeAWC1ydVtJq0QAYnDrllizowhN1UMJ6AOqfT
         rUcg==
X-Gm-Message-State: AJIora98QxLiL3t2F2Gn7GYXAqOLi5/xWUnOjtbpeMWOEz6hxiopRSOd
        q4k8+8jRZOA1YLKaNgPdoCKGcpUheUyRzrsxxhU=
X-Google-Smtp-Source: AGRyM1uJLrWycZyA/aGMIqVI7+AUGaxMZh/S4K2wMif+19wdQg8R7fUB79mtPGkugehrz92tJHI4mkE6SgU4G8Y/ujU=
X-Received: by 2002:ac8:5d8c:0:b0:306:6efd:7fe1 with SMTP id
 d12-20020ac85d8c000000b003066efd7fe1mr24286817qtx.318.1655837274765; Tue, 21
 Jun 2022 11:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220621135339.1269409-1-robimarko@gmail.com> <a194d4c5-8e31-ecd9-ecd0-0c96af03485b@linaro.org>
In-Reply-To: <a194d4c5-8e31-ecd9-ecd0-0c96af03485b@linaro.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Tue, 21 Jun 2022 20:47:44 +0200
Message-ID: <CAOX2RU6fBo5f6cxAUgLKj3j+_oP7nSm7awCpr_yiO_p3NssWkQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry
 for board ID
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Kalle Valo <kvalo@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Rob Herring <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Devicetree List <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 at 17:58, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 21/06/2022 15:53, Robert Marko wrote:
> > bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
> > used for identifying the correct board data file.
> >
> > This however is sometimes not enough as all of the IPQ8074 boards that I
> > have access to dont have the qmi-board-id properly fused and simply return
> > the default value of 0xFF.
> >
> > So, to provide the correct qmi-board-id add a new DT property that allows
> > the qmi-board-id to be overridden from DTS in cases where its not set.
> > This is what vendors have been doing in the stock firmwares that were
> > shipped on boards I have.
> >
> > Signed-off-by: Robert Marko <robimarko@gmail.com>
>
> Thank you for your patch. There is something to discuss/improve.
>
> > ---
> >  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml     | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > index a677b056f112..fe6aafdab9d4 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > @@ -41,6 +41,14 @@ properties:
> >          * reg
> >          * reg-names
> >
> > +  qcom,ath11k-board-id:
>
> The "board" a bit confuses me because in the context of entire system it
> means the entire hardware running Qualcomm SoC. This is sometimes
> encoded as qcom,board-id property.

Hi Krzysztof,
I agree that the name is a bit confusing, it's not the same as
qcom,board-id AFAIK
and QCA as well as vendors are using a similar property in the wifi
node to override
the default qmi-board-id to the correct one as its rarely properly fused.

I assume it would be better-called qcom,ath11k-qmi-board-id as you
dont even have
to be using a Qualcomm SoC as the same is used by PCI ath11k cards as well.

Regards,
Robert
>
> Is your property exactly the same?
>
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description:
> > +      Board ID to override the one returned by the firmware or the default
> > +      0xff if it was not set by the vendor at all.
> > +      It is used along the ath11k-calibration-variant to mach the correct
> > +      calibration data from board-2.bin.
> > +
> >    qcom,ath11k-calibration-variant:
> >      $ref: /schemas/types.yaml#/definitions/string
> >      description:
>
>
> Best regards,
> Krzysztof
