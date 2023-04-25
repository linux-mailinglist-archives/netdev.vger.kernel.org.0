Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD526EDBE5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 08:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjDYGsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 02:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjDYGsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 02:48:33 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E958FC142
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:48:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f3cd32799so992998866b.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1682405291; x=1684997291;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1ZE7zkQJkA5e8pU4DAT31Q8ZdOD3Fw5YHswnvzUZmg=;
        b=olsY2tC3Gx43o+1zlMobkyWpvjqynYcSpBNJpha9GJ236pWS48I5T6fRMsjnEXvXW6
         nPi0bqOs+1TlaWLvYdtK05Phwd64bnf8h8lpwCoavOQKecIrT39b+c9OXon5xQQ/G8v5
         C9ljuQugTDRKMyiQ5qglbXWyDGR5BHf2xgBOnY4Ic4pvsZ2wdQd/paK4gDRXz5hVaFo1
         4sGV2PZjTYKCVn15Pw/Akl3g3hkRNCNsRHG7vFd0Yq0YJiWgig0JZOf8yfF87vpttcMF
         HG7HPRei4vraUYDcnXZreqsqGm02uputbga0Nei8umyDLFxVgq8OAfyloV/3rrSUMB2q
         yv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682405291; x=1684997291;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M1ZE7zkQJkA5e8pU4DAT31Q8ZdOD3Fw5YHswnvzUZmg=;
        b=WFEM3XvyKCG6x6heigERX8RKTYo7PN7uMhHdgLMBeu025MjR08aLLdYo0O+IZRWWGT
         HeWXrq6qoA+MMCOkilrayEIrzVwlLI+rfsSjq/3GjmEgJ/e16x76rgjMgUun0TZSuXMM
         ebSSsfuvZqvkmAdXBhFHeLri88nXxQb0BG+yVmGvaL6z+3GlSoZjoQ/0eBwwIe/1Zmdo
         n7L1r6u+ZvL4Q9ECPD75vFdkwW5CMXJJ4IxY+BjF2MZkULV2irEtfvLLatYkG2610lkN
         NnxSsgUrhOV8XBYSWTkehdZnMJvb0kMjGW+GkQwPyWri+Fjq0eKB4bmPxvO6P6KH9JY9
         ueXg==
X-Gm-Message-State: AAQBX9fe5z3N2oigkTvlsD02WO9x9Idzr5z+dztIHUxohyqBT5aKR+ul
        b1h0P0LRViGI9uHVhtEpOGqgTg==
X-Google-Smtp-Source: AKy350Z1GFt6IUApk1g0YPdKIdF8wPBWzQ1iG4DdhA44udPMwwV1bqNKEmVs8J1NANW0v9bSPKkIgg==
X-Received: by 2002:a17:907:38c:b0:94e:fdec:67e2 with SMTP id ss12-20020a170907038c00b0094efdec67e2mr12906256ejb.77.1682405291266;
        Mon, 24 Apr 2023 23:48:11 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id sd14-20020a170906ce2e00b0094f5d1bbb21sm6340135ejb.102.2023.04.24.23.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 23:48:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 25 Apr 2023 08:48:10 +0200
Message-Id: <CS5MWGNURMH4.2VD8BIIJ3V3Q4@otso>
Subject: Re: [PATCH RFC 0/4] Add WCN3988 Bluetooth support for Fairphone 4
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Balakrishna Godavarthi" <bgodavar@codeaurora.org>,
        "Rocky Liao" <rjliao@codeaurora.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>
Cc:     <~postmarketos/upstreaming@lists.sr.ht>,
        <phone-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
 <0f2af683-07f9-7fc7-a043-ee55e41d65c3@linaro.org>
In-Reply-To: <0f2af683-07f9-7fc7-a043-ee55e41d65c3@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Apr 22, 2023 at 2:03 PM CEST, Konrad Dybcio wrote:
>
>
> On 21.04.2023 16:11, Luca Weiss wrote:
> > Just to start with the important part why this is an RFC:
> >=20
> > While Bluetooth chip init works totally fine and bluez seems to be
> > fairly happy with it, there's a (major) problem with scanning, as shown
> > with this bluetoothctl snippet and dmesg snippet:
> >=20
> >   [bluetooth]# scan on
> >   Failed to start discovery: org.bluez.Error.InProgress
> >=20
> >   [  202.371374] Bluetooth: hci0: Opcode 0x200b failed: -16
> >=20
> > This opcode should be the following:
> >=20
> >   include/net/bluetooth/hci.h:#define HCI_OP_LE_SET_SCAN_PARAM    0x200=
b
> Not a bluetooth expert or anything, but does that thing support
> bluetooth LE?

I don't know too much about Bluetooth details either, but hasn't
Bluetooth LE been a consistently supported thing since like 10 years?

All the info I can easily find just states SM7225 SoC supports
"Bluetooth 5.1".

Regards
Luca

>
> Konrad
> >=20
> > Unfortunately trying various existing code branches in the Bluetooth
> > driver doesn't show any sign of making this work and I don't really kno=
w
> > where to look to debug this further.
> >=20
> > On the other hand "discoverable on" makes the device show up on other
> > devices during scanning , so the RF parts of the Bluetooth chip are
> > generally functional for sure.
> >=20
> > Any ideas are welcome.
> >=20
> > @Bjorn: Patch "arm64: dts: qcom: sm6350: add uart1 node" should be fine
> > to take regardless the RFC status, I don't think the problem is caused
> > there.
> >=20
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> > Luca Weiss (4):
> >       dt-bindings: net: qualcomm: Add WCN3988
> >       Bluetooth: btqca: Add WCN3988 support
> >       arm64: dts: qcom: sm6350: add uart1 node
> >       arm64: dts: qcom: sm7225-fairphone-fp4: Add Bluetooth
> >=20
> >  .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |  2 +
> >  arch/arm64/boot/dts/qcom/sm6350.dtsi               | 63 ++++++++++++++=
++++++++
> >  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  | 17 ++++++
> >  drivers/bluetooth/btqca.c                          | 13 ++++-
> >  drivers/bluetooth/btqca.h                          | 12 ++++-
> >  drivers/bluetooth/hci_qca.c                        | 12 +++++
> >  6 files changed, 115 insertions(+), 4 deletions(-)
> > ---
> > base-commit: cf4c0112a0350cfe8a63b5eb3377e2366f57545b
> > change-id: 20230421-fp4-bluetooth-b36a0e87b9c8
> >=20
> > Best regards,

