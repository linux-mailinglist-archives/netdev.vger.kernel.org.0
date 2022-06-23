Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496EC5589E2
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiFWUQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 16:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWUQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 16:16:50 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED422527E1;
        Thu, 23 Jun 2022 13:16:49 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id o43so1685216qvo.4;
        Thu, 23 Jun 2022 13:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWrCQp6H9wIltSv1NIBwWayinjF3IWxeRXdz64C/6O8=;
        b=H0iRj/c6MpY2eSSDDZgyYSk4nDUWmxYHRjgj/m/4qUypbcJDTPIYhuazKHcWobrHr5
         gzMxPmUZ9TfzoBSbDy93yX8ibOTfAgZvUQ9nlTwbpwBobAafrndImc/rjqlIdrsjGgIU
         f939IpzQVfemTQC12tvKJFYdtEcTrC9hRKFPx1sxB9nFhDjPgJUcZl+Gj7cuYk5uqdlc
         Wuhk8GAWrGirtvCXM2trIZbiskzbpJqoWnkSSuLaP6YZXRsHMIp2vx68N6kkGoejR9Bc
         OnLAZPnHxE1tdrKATsSqZJRPMxMIxGVQ7N5PWXw8NOaCt9IJo+MjipZvs8RqUkY5as6R
         kA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWrCQp6H9wIltSv1NIBwWayinjF3IWxeRXdz64C/6O8=;
        b=t5iY1kIaeAGt94QrZdjRrTwAdd3Wsai7H3+/OsB/LM3FwgXoOQrKXXeNg9Dw146R/P
         l842nbLuuPhT2jnnVvOkoVedttM99TnpnL52yikM/yU1YqWirgPBnIJ0XV35ednPXHb9
         jMkO769m64sv9aM9NTyFbIQP4qzleVHC3DC1fY76lS1z3493jQqZKnld+G7nbj4+HMvA
         2fE693NGq30L7tiGCxujn1/apjr40D5vS06wMqVV9WvzMREY3ZUZsBz2EsaCLik8PiA6
         E4aet7uZegq5zge21kFyDeyH2FB8/VfP9S24Z+vLDWnCoTpCQRlP1PVJbY58XO1FVgTA
         9adg==
X-Gm-Message-State: AJIora84HQ1fgUyO59de1hyMboiahQTCeQg0fzTGsy1VaZRZCXA/B1V3
        evtY5Ph1zUtt2y30hy4GIdNrHn1pAlRqBerXZDc=
X-Google-Smtp-Source: AGRyM1uOtTXMj9r/qGMK6GqGlRRTsCptlK8dfpB68zWK8onR9QisCok7v5sadUPaTDEsbVzVvhUCa+H87ScWox2/GG4=
X-Received: by 2002:ac8:5dce:0:b0:305:300e:146d with SMTP id
 e14-20020ac85dce000000b00305300e146dmr10167380qtx.546.1656015409065; Thu, 23
 Jun 2022 13:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220621135339.1269409-1-robimarko@gmail.com> <a194d4c5-8e31-ecd9-ecd0-0c96af03485b@linaro.org>
 <CAOX2RU6fBo5f6cxAUgLKj3j+_oP7nSm7awCpr_yiO_p3NssWkQ@mail.gmail.com> <60ee4aa5-4fef-24e0-0ccf-b93eee1db876@linaro.org>
In-Reply-To: <60ee4aa5-4fef-24e0-0ccf-b93eee1db876@linaro.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Thu, 23 Jun 2022 22:16:38 +0200
Message-ID: <CAOX2RU7da_bUNM0Zr-YA1eQN96ENcfsKLD9C2PVVNijN6Y2hNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry
 for board ID
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Kalle Valo <kvalo@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com, Rob Herring <robh+dt@kernel.org>,
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

On Wed, 22 Jun 2022 at 16:55, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 21/06/2022 20:47, Robert Marko wrote:
> > On Tue, 21 Jun 2022 at 17:58, Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> On 21/06/2022 15:53, Robert Marko wrote:
> >>> bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
> >>> used for identifying the correct board data file.
> >>>
> >>> This however is sometimes not enough as all of the IPQ8074 boards that I
> >>> have access to dont have the qmi-board-id properly fused and simply return
> >>> the default value of 0xFF.
> >>>
> >>> So, to provide the correct qmi-board-id add a new DT property that allows
> >>> the qmi-board-id to be overridden from DTS in cases where its not set.
> >>> This is what vendors have been doing in the stock firmwares that were
> >>> shipped on boards I have.
> >>>
> >>> Signed-off-by: Robert Marko <robimarko@gmail.com>
> >>
> >> Thank you for your patch. There is something to discuss/improve.
> >>
> >>> ---
> >>>  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml     | 8 ++++++++
> >>>  1 file changed, 8 insertions(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> >>> index a677b056f112..fe6aafdab9d4 100644
> >>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> >>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> >>> @@ -41,6 +41,14 @@ properties:
> >>>          * reg
> >>>          * reg-names
> >>>
> >>> +  qcom,ath11k-board-id:
> >>
> >> The "board" a bit confuses me because in the context of entire system it
> >> means the entire hardware running Qualcomm SoC. This is sometimes
> >> encoded as qcom,board-id property.
> >
> > Hi Krzysztof,
> > I agree that the name is a bit confusing, it's not the same as
> > qcom,board-id AFAIK
> > and QCA as well as vendors are using a similar property in the wifi
> > node to override
> > the default qmi-board-id to the correct one as its rarely properly fused.
> >
> > I assume it would be better-called qcom,ath11k-qmi-board-id as you
> > dont even have
> > to be using a Qualcomm SoC as the same is used by PCI ath11k cards as well.
> >
>
> Thanks for the explanation. What is the "board" in that context? The
> card/hardware with ath11k? Then maybe qcom,ath11k-qmi-id or
> qcom,ath11k-qmi-hw-id?

Hi,

I assume it started off as a numerical value to match the board design and was
then simply carried off to the PCI cards as well.

qcom,ath11k-qmi-hw-id is fine by me, will just expand the description to make
it clear.

Regards,
Robert

>
> Best regards,
> Krzysztof
