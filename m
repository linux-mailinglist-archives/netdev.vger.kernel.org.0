Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021CE6B2E28
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCIUIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCIUIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:08:14 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BCA31E0D
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 12:08:11 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id o12so11725427edb.9
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 12:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678392490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkdqh8Mn4yYVcJRbj0k73VKeCBqKduyHj6J+C4uNHbk=;
        b=GHJNSGs0ozGdUpE1NfeN06yA+sKV9j8iM4T3MaizrYC8y3Xkguqdvt9CGLF+wVxabQ
         GjHtzIdzGaMVhs5kRs0zcAZigoMTMgRR3rL/Un1Kdj9TWTmskh7OXWXP7oEMC1d+Gaxe
         t/J+tUlSjq7iO4QQtq3+CIcOZzkezl1W3+2ugK7blV0TOX4eWV+IWwKc6zwt7uqdFCaM
         iElGs/PMnlpE3t3Y/qyPUXjTpFM9GYMwcEAn/LZBqxW9FxupcNIsq5o1jzifC4uMTivz
         UA8uNSGT+x0gFE+bF+Hw5dOyKAhBM6CGLvIFEaBLVfQV1uT2DWqpO8z3uPf9wyUfgvK0
         ykrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678392490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkdqh8Mn4yYVcJRbj0k73VKeCBqKduyHj6J+C4uNHbk=;
        b=fOSoFGmGlwHwy2lSJSW2M8wVjselfLdPkLswe2n94FimB4ZAFohEdKlAI1MsjyadS6
         eSNkM4Zf52hThA7fgiksZYcz+uV6nddcVm1vUov4k0MhpPXzuLYLZ16chICg8nPWPFFd
         sf08pDEttMUhPvChvNzz+z5m3ZnzLqqT0hxDiSP3A40sNU4Y9j5bYo1LtBNP/D10zGCz
         ibTWNSDbaRe6X1+oMFANOs8uO/RJSqiRzTz52OgvNOodOMgLRM8SUKN4ODIRNgFps719
         Xe/5ULH9dM5XDqzvbHhlCblBFldQmzpblnuqOevqEr7QQKUCJ21/0CTImssM9UbtMYdy
         CSEw==
X-Gm-Message-State: AO0yUKV8Z0jLjO9pw5YvIiiR5iP950IB1wVi0fh9yNr99Mrq9xCQHqSp
        iybHezUoYAgLVkH/gfdKfbgoqc+ZfvHrcdcAgv4d9g==
X-Google-Smtp-Source: AK7set9FtsMby2FguByeoNJEQBInZqMAF0hTx+q7tMBEgbEGSz6VyxVYUtlDhjCvaUHueJ7BNK9KTXJ/2uQvQ7QqWB8=
X-Received: by 2002:a17:906:310d:b0:87b:d50f:6981 with SMTP id
 13-20020a170906310d00b0087bd50f6981mr10758001ejx.14.1678392489733; Thu, 09
 Mar 2023 12:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20230209020916.6475-1-steev@kali.org> <20230209020916.6475-5-steev@kali.org>
 <ZAoWdR7mppnWclFr@hovoldconsulting.com>
In-Reply-To: <ZAoWdR7mppnWclFr@hovoldconsulting.com>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Thu, 9 Mar 2023 14:07:58 -0600
Message-ID: <CAKXuJqgAbdALaRdcoSV+sXbGzwm6h54hZtG2rBobcGA9vyu50g@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
To:     Johan Hovold <johan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
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

On Thu, Mar 9, 2023 at 11:24=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> On Wed, Feb 08, 2023 at 08:09:16PM -0600, Steev Klimaszewski wrote:
> > The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> > add this.
> >
> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > Link: https://lore.kernel.org/r/20230207052829.3996-5-steev@kali.org
>
> This link should not be needed.
>
> Also, please update the patch Subject to use the following prefix:
>
>         arm64: dts: qcom: sc8280xp-x13s: ...
>

Yeah, that was me screwing up my  patch, will make those changes for v6

> > ---
> > Changes since v4:
> >  * Address Konrad's review comments.
> >
> > Changes since v3:
> >  * Add vreg_s1c
> >  * Add regulators and not dead code
> >  * Fix commit message changelog
> >
> > Changes since v2:
> >  * Remove dead code and add TODO comment
> >  * Make dtbs_check happy with the pin definitions
> >  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
> >  1 file changed, 76 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts=
 b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> > index f936b020a71d..ad20cfb3a830 100644
> > --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> > +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> > @@ -24,6 +24,8 @@ / {
> >       aliases {
> >               i2c4 =3D &i2c4;
> >               i2c21 =3D &i2c21;
> > +             serial0 =3D &uart17;
>
> This is an unrelated change that does not belong in this patch.
>
> > +             serial1 =3D &uart2;
> >       };
> >
> >       wcd938x: audio-codec {
> > @@ -297,6 +299,15 @@ pmc8280c-rpmh-regulators {
> >               qcom,pmic-id =3D "c";
> >               vdd-bob-supply =3D <&vreg_vph_pwr>;
> >
> > +             vreg_s1c: smps1 {
> > +                     regulator-name =3D "vreg_s1c";
> > +                     regulator-min-microvolt =3D <1880000>;
> > +                     regulator-max-microvolt =3D <1900000>;
> > +                     regulator-allowed-modes =3D <RPMH_REGULATOR_MODE_=
AUTO>,
> > +                                               <RPMH_REGULATOR_MODE_RE=
T>;
> > +                     regulator-allow-set-load;
>
> Don't you need to specify initial-mode as well?
>
> > +             };
> > +
> >               vreg_l1c: ldo1 {
> >                       regulator-name =3D "vreg_l1c";
> >                       regulator-min-microvolt =3D <1800000>;
> > @@ -712,6 +723,32 @@ &qup0 {
> >       status =3D "okay";
> >  };
> >
> > +&uart2 {
> > +     pinctrl-0 =3D <&uart2_state>;
> > +     pinctrl-names =3D "default";
> > +
> > +     status =3D "okay";
> > +
> > +     bluetooth {
> > +             compatible =3D "qcom,wcn6855-bt";
> > +
> > +             vddio-supply =3D <&vreg_s10b>;
> > +             vddbtcxmx-supply =3D <&vreg_s12b>;
> > +             vddrfacmn-supply =3D <&vreg_s12b>;
> > +             vddrfa0p8-supply =3D <&vreg_s12b>;
> > +             vddrfa1p2-supply =3D <&vreg_s11b>;
> > +             vddrfa1p7-supply =3D <&vreg_s1c>;
> > +
> > +             max-speed =3D <3200000>;
> > +
> > +             enable-gpios =3D <&tlmm 133 GPIO_ACTIVE_HIGH>;
> > +             swctrl-gpios =3D <&tlmm 132 GPIO_ACTIVE_HIGH>;
> > +
> > +             pinctrl-0 =3D <&bt_en>;
> > +             pinctrl-names =3D "default";
> > +     };
> > +};
> > +
> >  &qup1 {
> >       status =3D "okay";
> >  };
> > @@ -720,6 +757,11 @@ &qup2 {
> >       status =3D "okay";
> >  };
> >
> > +&uart17 {
> > +     compatible =3D "qcom,geni-debug-uart";
> > +     status =3D "okay";
> > +};
>
> This bit does not belong here either. We don't have any means of
> accessing the debug uart on the X13s so we should probably just leave it
> disabled.
>

Will drop it (and the above one as well)

> > +
> >  &remoteproc_adsp {
> >       firmware-name =3D "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
> >
> > @@ -980,6 +1022,19 @@ hastings_reg_en: hastings-reg-en-state {
> >  &tlmm {
> >       gpio-reserved-ranges =3D <70 2>, <74 6>, <83 4>, <125 2>, <128 2>=
, <154 7>;
> >
> > +     bt_en: bt-en-state {
>
> As you are configuring more than one pin, please rename this as:
>
>         bt_default: bt-default-state
>
> > +             hstp-sw-ctrl-pins {
> > +                     pins =3D "gpio132";
> > +                     function =3D "gpio";
>
> You should define the bias configuration as well. I guess we need to
> keep the default pull-down enabled.
>
> > +             };
> > +
> > +             hstp-bt-en-pins {
> > +                     pins =3D "gpio133";
> > +                     function =3D "gpio";
> > +                     drive-strength =3D <16>;
>
> bias-disable?
>
> > +             };
> > +     };
> > +
> >       edp_reg_en: edp-reg-en-state {
> >               pins =3D "gpio25";
> >               function =3D "gpio";
> > @@ -1001,6 +1056,27 @@ i2c4_default: i2c4-default-state {
> >               bias-disable;
> >       };
> >
> > +     uart2_state: uart2-state {
>
> Rename this one too:
>
>         uart2_default: uart2-default-state
>
> > +             cts-pins {
> > +                     pins =3D "gpio122";
>
> This should be gpio121 (gpio122 is rts).
>

You are right that it should be... however... if I actually set it to
be 121.... bluetooth doesn't actually come up/work?

> > +                     function =3D "qup2";
> > +                     bias-disable;
>
> Don't we need a pull-down on this one to avoid a floating input when the
> module is powered down?
>
Maybe?  I don't have access to the schematics or anything so I was
going with the best guess based on what worked by poking and prodding.
Will try this.


> > +             };
> > +
> > +             rts-tx-pins {
>
> Please split this in two nodes.
>
> > +                     pins =3D "gpio122", "gpio123";
> > +                     function =3D "qup2";
> > +                     drive-strength =3D <2>;
> > +                     bias-disable;
> > +             };
> > +
> > +             rx-pins {
> > +                     pins =3D "gpio124";
> > +                     function =3D "qup2";
> > +                     bias-pull-up;
> > +             };
> > +     };
> > +
> >       i2c21_default: i2c21-default-state {
> >               pins =3D "gpio81", "gpio82";
> >               function =3D "qup21";
>
> Johan
