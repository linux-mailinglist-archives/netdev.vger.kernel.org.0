Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967116B9DD4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjCNSEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCNSEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:04:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CB7A227E;
        Tue, 14 Mar 2023 11:04:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so7700292pjt.5;
        Tue, 14 Mar 2023 11:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678817083;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhkqZnqi4qAtizU4572s8HvBrOs+BKkBUUx8Pw/CxoE=;
        b=c+bqi0+JT0vFttYQOJNb2Ic8oXew+4kVrOfaOg2xmKcSnIJGx8Xdup0UqdRMf5dUL/
         VXnIwtxX8GUo5A/VCv/a1GdjFn+bVBwjwpQWJ+cBu4m8UDKCSgyM85Tky+TPPcAKxJ5u
         zgcblZlJgNoLW7myn3aU7skEOqxcInk7L6AutT4PaAUUVmIuwsj/OYzILLkiTg3Ba3dB
         9hgNY7Ov7+wipUdyvfB3eIhzBOMv4ECgzsjOn8DQTTf0ARtqe/urPO5SKeQ3zyPGTElS
         sYqbcKzAM8zqZ0nVEIAIjOcgEufwNUNZV2AlNOAa0jEIT0Uw3t31/toYwjk0pMp35RN9
         mr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678817083;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LhkqZnqi4qAtizU4572s8HvBrOs+BKkBUUx8Pw/CxoE=;
        b=V0mFcpaPJhzdSnj75qHj9CJ9K8Ob8Ies5aVYSNB9gZGb5kt/iK39NYvrVTSCn0PiGF
         0SotEjYZxXx1tnNX3X1ZrrYPGH3f0JTF6fWKyarqU2eX2xSoLIMAQQjBBapkwyU3I8Lk
         gbuNzTjKd/GDJFEwUBw2DkkA4jIuXHpL7hYb7kSRhk3PdzGEPYd6DMUL/bWihsz1jFsY
         K0G6J89cXwHvRx25g7XoC8YTHtArhzmGfFthLkDeJdjR1HSUp95SQZOdbaE3JPfVlL6b
         iZe9im4b1NpqPx2DISYjePVW9Mg8H/daB6QfWBbIxFtyhnwJIMrFYldkOpF0iKDqA/4W
         5CKA==
X-Gm-Message-State: AO0yUKUi3d+rxwClt8SkFSY8ccIRirVdDbi2Izqixt5zTg3Gz+5WI0g5
        17TWpcBTcRPoMk1BxJ2cDMFByrTdgp2rIg==
X-Google-Smtp-Source: AK7set/Q4wjxBNdIbzLMNPHBJLoPlDOxzT2y2XfcmTUJEuKzLqd9pAGYJBuO2TmWnQULlcfzobJ/Hg==
X-Received: by 2002:a05:6a20:3942:b0:cd:fe1b:df8 with SMTP id r2-20020a056a20394200b000cdfe1b0df8mr44681233pzg.56.1678817082638;
        Tue, 14 Mar 2023 11:04:42 -0700 (PDT)
Received: from localhost ([2406:7400:61:629c:58fb:a2bd:8b99:bfe0])
        by smtp.gmail.com with ESMTPSA id d16-20020a631d10000000b004fbd021bad6sm1880819pgd.38.2023.03.14.11.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 11:04:42 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Mar 2023 23:34:37 +0530
Message-Id: <CR6AZI7T6X51.AX26VA80VSUW@skynet-linux>
Subject: Re: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for
 pronto-v3
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Loic Poulain" <loic.poulain@linaro.org>
Cc:     <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
        <linux-kernel@vger.kernel.org>,
        "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "Kalle Valo" <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
X-Mailer: aerc 0.14.0
References: <20230311150647.22935-1-sireeshkodali1@gmail.com>
 <20230311150647.22935-2-sireeshkodali1@gmail.com>
 <CAMZdPi_uBLutBejSV1fz5p9GYqHYd75VTAePtndUnsu=JypdTQ@mail.gmail.com>
In-Reply-To: <CAMZdPi_uBLutBejSV1fz5p9GYqHYd75VTAePtndUnsu=JypdTQ@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Mar 14, 2023 at 2:19 PM IST, Loic Poulain wrote:
> On Sat, 11 Mar 2023 at 16:07, Sireesh Kodali <sireeshkodali1@gmail.com> w=
rote:
> >
> > From: Vladimir Lypak <vladimir.lypak@gmail.com>
> >
> > Pronto v3 has a different DXE address than prior Pronto versions. This
> > patch changes the macro to return the correct register address based on
> > the pronto version.
> >
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
>
> Acked-by: Loic Poulain <loic.poulain@linaro.org>
>
> Could you also submit a change for the new 'qcom,pronto-v3-pil'
> compatible in the related devicetree documentation ?
> (bindings/remoteproc/qcom,wcnss-pil.txt)

The changes to the device tree were only recently merged
LKML link: https://lkml.org/lkml/2022/9/30/1502
