Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F96C11A6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjCTMPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjCTMPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:15:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0452597C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 05:15:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eh3so45802278edb.11
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 05:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679314514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4rLpiklQSLUGu8en3KYDb4lZcdoMaRER+VnV6x571E=;
        b=YKG8m+Aqdx5YPl39zn6iGSYyHWV38GeeAbZ4FOt093BNQjCN5XOysHyXUnn/sBKF/S
         3NjqnlNtFKkOZk+F2DJXk3svD8HbUx1uIHgbNR+bWnhURgI9VUhsBqlw2026DyrHmwAs
         sQ+QKnIn7SNz2O46PZTu67AIoBQYMg1zCDMKQnXjzbznOF9042meTj8aU0UIkbrcjD30
         BlAQMqJBznlgMdpFtoPrqnSZAfel8UqOlQGZRbsbeH7lv1Q0RP/Il+O3kjSRj1q4e16V
         lzaQehfi5HWsOw8e4J8Hy0BVGvfyv0vygZR+rxkI7CplCBe9oh77SNfuazQ5o3ik/uKC
         L/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679314514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q4rLpiklQSLUGu8en3KYDb4lZcdoMaRER+VnV6x571E=;
        b=eyLjwmmHWeEBXBdi4/mR/NkYYtTjMaPX4sMcdAHUvonvjYHFtnM6W/q1b4FzMUqFty
         SmCNwalAf9gYepHEvpr4KzKgH+CdisKv9nB/EAoxI0L/ysedvp9tXVE/aa2bZCXaSZzE
         ZDFTh/wQQwct51pb97D6HL2chwIV01ZQm9VBwNMsqjj+0i+epZF2B+RRSQnUjg6Aass+
         e099DIg4VzYSn05BoQtNtBAVnl7xHkD3DxL5mwchUmWdJirRWhs+BMNFWSHjJZOO1Bhb
         AYoRX4cCsgklXDLZOgRKhxhNnE22ih/0Gh588naMwYuwPIfemkZkdiCxt0oWzHU/bBrE
         TAyg==
X-Gm-Message-State: AO0yUKXJV17uyeZXUaQxNNTmrTmtAmHvi8OL1NTWqQwNsDVYnrWyWLvb
        fndyAwmHAZb9NjlcRdci6Z+RfI/oxxr7E4N+ajPctA==
X-Google-Smtp-Source: AK7set8CdlHV303cHjYGX5Ktv/xbOxfBljEZYOn0HpF69QJIC+i8LkWfVEEgefDscUWRlJ/tuSIIQXZTfF+bGPJa4Ys=
X-Received: by 2002:a50:d58b:0:b0:4fa:d8aa:74ad with SMTP id
 v11-20020a50d58b000000b004fad8aa74admr6077014edi.8.1679314514201; Mon, 20 Mar
 2023 05:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230320104658.22186-1-johan+linaro@kernel.org> <20230320104658.22186-3-johan+linaro@kernel.org>
In-Reply-To: <20230320104658.22186-3-johan+linaro@kernel.org>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Mon, 20 Mar 2023 07:15:04 -0500
Message-ID: <CAKXuJqhOGcPrOROGJdbBGM47FriNjojWBvCMUs2hRYHkCG4qLg@mail.gmail.com>
Subject: Re: [PATCH 2/3] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Mar 20, 2023 at 5:52=E2=80=AFAM Johan Hovold <johan+linaro@kernel.o=
rg> wrote:
>
> Describe the bus topology for PCIe domain 6 and add the ath11k
> calibration variant so that the board file (calibration data) can be
> loaded.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216246
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts  | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b=
/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index 150f51f1db37..0051025e0aa8 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -711,6 +711,23 @@ &pcie4 {
>         pinctrl-0 =3D <&pcie4_default>;
>
>         status =3D "okay";
> +
> +       pcie@0 {
> +               device_type =3D "pci";
> +               reg =3D <0x0 0x0 0x0 0x0 0x0>;
> +               #address-cells =3D <3>;
> +               #size-cells =3D <2>;
> +               ranges;
> +
> +               bus-range =3D <0x01 0xff>;
> +
> +               wifi@0 {
> +                       compatible =3D "pci17cb,1103";
> +                       reg =3D <0x10000 0x0 0x0 0x0 0x0>;
> +
> +                       qcom,ath11k-calibration-variant =3D "LE_X13S";
> +               };
> +       };
>  };
>
>  &pcie4_phy {
> --
> 2.39.2
>

So glad to finally see this and confirm that it works!

Tested-by: Steev Klimaszewski <steev@kali.org> #Thinkpad X13s
