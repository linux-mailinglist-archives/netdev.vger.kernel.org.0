Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63F86B8DCC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjCNIun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCNIu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:50:26 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020925DCBF
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:50:12 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e26-20020a9d6e1a000000b00694274b5d3aso8043133otr.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678783812;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Kj9g/LeQ83xDX02olQrR6FP1LDCJnXQ1jcM5Q4/yMw=;
        b=GtuTf4HBgqcSh2fqp19H3x4iRzxGYvae2x9KB7fpwEoDgvrgJKPjAxr4vQuUM4cbRy
         2QGvD/PIQRxhFiTij/uOJsvmQ4NuOdCVzNYfVtqELEZDLTjyBvIrxGgXW0B5RUHCvIR9
         /ziHj0pymSx942ncx1cImXHVtCjKuTEhHUawMlmfmirY/5TGDW6LwEaWuRhB0+A8yTI7
         0aaISBHCOtUDq/2biuCKzeCZsa7Q3sDoCE8EmsyXSLXtrBLmgAb5mRmbjI79eLJBaEHW
         0KqVZBgNnpm3d5Rq2zgXd3rzna9fD0dyyXixWqpqrAxYowfGddh57elOZw6uL+HESEo1
         DqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678783812;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Kj9g/LeQ83xDX02olQrR6FP1LDCJnXQ1jcM5Q4/yMw=;
        b=Q2b2wH6d7WwjBvf3QLY9VO276/idpXPz43kT4OabiIpDq6/mkl1T/O6eOyqsimuhZj
         bOUngpKt1hqla/giMxugSa/CvT1UQGYw80IyDAynQwD9920v1aVWODVoIzoEMzv76IeC
         3vzoyWDrSpzF1BhA5m09pfsmdvX+Kx0SzvnE5u+OrpD6xa7oWO5tOLLHBCxy6XI5XcTO
         yrHnxGUuSZlcuB91HtTVx5XGDjGon4uHJcmNNETDZCBLIG/x3MINDOE5XnxHZuVFFtx+
         Hvdx0Tu265V5PLNfwuAkpo5PJ4oIhasy9Zi9GPdCN8lO7N4d3f7Hv3kpBVgHXUqJD4Oe
         WjXQ==
X-Gm-Message-State: AO0yUKUOX/ZzDLqNZfu6nPGJs2ThF3HoJYzq/xJZxzmGU3p3/woeyTLC
        YAsEc8qyyeyGgfsOAmrL050gZaZY+Ws6OwGpLqPT8Q==
X-Google-Smtp-Source: AK7set+IAL4itAqh8tizKhYgG8WyuNWlhwwXIki/T0OPK5VHPjohAzss6/pTOodxpfHcPE4Z3466u3wqaUcfE0o/uSI=
X-Received: by 2002:a05:6830:2464:b0:694:39ee:5f4a with SMTP id
 x36-20020a056830246400b0069439ee5f4amr12424644otr.2.1678783812257; Tue, 14
 Mar 2023 01:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230311150647.22935-1-sireeshkodali1@gmail.com> <20230311150647.22935-2-sireeshkodali1@gmail.com>
In-Reply-To: <20230311150647.22935-2-sireeshkodali1@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 14 Mar 2023 09:49:36 +0100
Message-ID: <CAMZdPi_uBLutBejSV1fz5p9GYqHYd75VTAePtndUnsu=JypdTQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for pronto-v3
To:     Sireesh Kodali <sireeshkodali1@gmail.com>
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        linux-kernel@vger.kernel.org,
        Vladimir Lypak <vladimir.lypak@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Mar 2023 at 16:07, Sireesh Kodali <sireeshkodali1@gmail.com> wrote:
>
> From: Vladimir Lypak <vladimir.lypak@gmail.com>
>
> Pronto v3 has a different DXE address than prior Pronto versions. This
> patch changes the macro to return the correct register address based on
> the pronto version.
>
> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>

Acked-by: Loic Poulain <loic.poulain@linaro.org>

Could you also submit a change for the new 'qcom,pronto-v3-pil'
compatible in the related devicetree documentation ?
(bindings/remoteproc/qcom,wcnss-pil.txt)
