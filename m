Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAC68A369
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjBCUMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBCUMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:12:21 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964FFA8406;
        Fri,  3 Feb 2023 12:12:19 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id w11so9354404lfu.11;
        Fri, 03 Feb 2023 12:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fMFQuyDg7tzX9gWE8PkvqDa2BwLHKqigIWrByTh8BSQ=;
        b=LFTRXggel9ZZC0labNf019of7WFJApVT4MNwQ9heLNLFnbftDdcBTZDTR0/6cd6NKG
         E93QlMno29mNd0kaZi3n14LXkPWwy6hN+AFUri1mrApaoOIhQZGAp/pE8aJ9Qy94nZNZ
         md9Y7PYFbMydk/LvLlTpWix6tokVhzoeiRCoHU/ovhH6QTjipchlPX0fm9/NFTs6ZBQH
         5WyKkamEQmsRuqVZF8F9Xq0oM2lbOH+2WqnNx2F+RsvMXvWSrhmpLvd2Yo3TNSajf53P
         AaHSZCLrKl34IIrgAqGCRHSoqXD6SPSkgGP3W8d8Kvw/SJXs58X77LpQ5Olztr8qCnK/
         j5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMFQuyDg7tzX9gWE8PkvqDa2BwLHKqigIWrByTh8BSQ=;
        b=Th8O+tw6w22V9i91o1wSBZKJA6GkLxcwJ7HBsp2oanPoPbi9t0YV1nAoucMmwj5qGC
         43AoGbpCHYWVPpdJkoa5GfoVREwd+ZU7mx5i6eiYvKWWrsCJIiCahFcaJZm0szCWUyLZ
         0E1mJlxRsiX9/XVXdIKX+5pBqFHW8CBHQgTR7L+N/kztoZSzR5whSbmW+tblYPhJILOE
         Q10d5gSkL2KbovBlKQjtZp2Y0Qt0v/uBC53QW5uXNLJTWGy57IweCdxZLjDFZoBi1/Zx
         k7/sqk6MTva7F5tk6Eh8eUWeGLTc5sbo63UdQGqDqIx0F2zJf9Q+NWA5Cs2Cr0a1g8ko
         sRFg==
X-Gm-Message-State: AO0yUKXteMp5iIzik5IrGUwGhyfPyurYq5OhW/cg6agJOcQmGh+888JE
        WN/2oQE3W6EkwNnqxtwqbDQ9EFvbLN2NqRp7MEc=
X-Google-Smtp-Source: AK7set980B/SyaxkQ4aequbMQN+w2UzmzAl2fl4+/i5eO8RMGJ/dkHt8aBuu4Sr9iTH2xmZ1SsP1U5uuT/L1DyJdN+w=
X-Received: by 2002:a05:6512:3190:b0:4b5:b87a:3271 with SMTP id
 i16-20020a056512319000b004b5b87a3271mr2198518lfe.18.1675455137699; Fri, 03
 Feb 2023 12:12:17 -0800 (PST)
MIME-Version: 1.0
References: <c515aae3-88e4-948c-a856-7b45dd2caed9@linaro.org> <20230201031349.56405-1-steev@kali.org>
In-Reply-To: <20230201031349.56405-1-steev@kali.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 3 Feb 2023 12:12:06 -0800
Message-ID: <CABBYNZJPZChB0eOn05oFd2mknzOmr1RJRW3LFf3jbq_jpQ1UGA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
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

Hi Steev,

On Tue, Jan 31, 2023 at 7:13 PM Steev Klimaszewski <steev@kali.org> wrote:
>
> >On 31/01/2023 05:38, Steev Klimaszewski wrote:
> >> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> >> ---
> >>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
> >>  1 file changed, 68 insertions(+)
> >>
> >> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> >> index f936b020a71d..951438ac5946 100644
> >> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> >> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> >> @@ -24,6 +24,8 @@ / {
> >>      aliases {
> >>              i2c4 = &i2c4;
> >>              i2c21 = &i2c21;
> >> +            serial0 = &uart17;
> >> +            serial1 = &uart2;
> >>      };
> >>
> >>      wcd938x: audio-codec {
> >> @@ -712,6 +714,32 @@ &qup0 {
> >>      status = "okay";
> >>  };
> >>
> >> +&uart2 {
> >> +    status = "okay";
> >> +
> >> +    pinctrl-names = "default";
> >> +    pinctrl-0 = <&uart2_state>;
> >> +
> >> +    bluetooth {
> >> +            compatible = "qcom,wcn6855-bt";
> >> +
> >> +/*
>
> > Why dead code should be in the kernel?
>
> As mentioned in the cover letter, this is a bit closer to an RFC than ready to
> go in, and I do apologize that it wasn't clear enough.  I do not have access to
> the schematics, and based on my reading of the schema for bluetooth, these
> entries are supposed to be required, however, like the wcn6750, I have dummy
> data entered into the qca_soc_data_wcn6855 struct.  I know that these should be
> there, I just do not have access to the correct information to put, if that
> makes sense?

Well you don't have the RFC set in the subject which is probably why
people are reviewing it like it is supposed to be merged, that said I
do wonder if there is to indicate these entries are to be considered
sort of experimental so we don't end up enabling it by default?

>
> <snip>
>
> >Does not look like you tested the DTS against bindings. Please run `make
> >dtbs_check` (see Documentation/devicetree/bindings/writing-schema.rst
> >for instructions).
>
> Correct I had not, but I have now, and will make the corrections test and they
> will be included in v3.
>
> >Best regards,
> >Krzysztof
>
> I appreciate the guidance for what I was doing incorrectly.
>
> -- steev



-- 
Luiz Augusto von Dentz
