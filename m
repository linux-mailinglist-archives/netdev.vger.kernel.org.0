Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F244EC533
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345724AbiC3NJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiC3NJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:09:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3267765BE
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:07:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id bq8so27454753ejb.10
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 06:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mlv8qQ9RHsSmGM7vt+kqUTsdkye6EjX5140lGAJvMsM=;
        b=kUvzQ1XBKLE3835UwUWogLc5+auScn9VhKal48Z7Lp0Uo3wEdUNfDUOucwa8Uwze41
         6niuUjhqaz5Ta5y7UwJAmAcbKOJVDx9CnTOEU4Cq4ZCq56Okw9/O6ff3iYOsfZButPtF
         OlyfBTW+noewrcqqLuZ8NYIxM2eWtwN+70urmDayGgF/sVSWFV7nE943cjDtK+lCEd+K
         o2GbEKf8zn0eYG4fftqWmThApx6GuV9H+X2+6z1E4Xa4t+MAdWTez2NaWXtUNce6VZvp
         MxLfe+AeM1ab2YwbDsd9aneRmNHj4qgFLk8LGU0MQIZsHlRcnoAoeBuEBiMkLWONx9iP
         qCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mlv8qQ9RHsSmGM7vt+kqUTsdkye6EjX5140lGAJvMsM=;
        b=dtm/DJA2vTJl64T2dGslSKGdPpHpS04lirpukj23liyvfPVIxS9IiUq6dS1t33wGkb
         +6dusL1ZS3ORGCM24CcX/rHrKPr0mhKFC+hPBKyW2Zme4CSLexwpCUlHKRbicUl545a9
         /eFtIeAHkhXW6fHaFHUJpJypthNwaOP2FBfqsmRXVeUCb6s7Guf07v12APdltiQx3qyF
         dLEUpymHlYeyuH0qUZWjZ3eoV5v9dGRmr9R0Sgnr8hq4E/xuEq/fU2M2ydximol3wNCY
         9bJSQ8FDG0KS61v8tweQ4Be+cvby4Q/yPV1ielgHovlul9xjjPV5UqMX+KyAqC6vquki
         Jf+w==
X-Gm-Message-State: AOAM533ynQE3D7A9xHt/nBIjsRDlA++wXAeWU/p4ZeXZUdOTvtm8Bp9+
        Rqq7VR+JU2Hcf1+aef9sq2WjeCRmwi4203LSwWk=
X-Google-Smtp-Source: ABdhPJytnVy2R5k9butLq4tiEW2nJT8YP2tpioLd0aBNDFMmQN3nBbl1dreMAraCdN+r7CeVMz9wKLZ9NymAze8kV4w=
X-Received: by 2002:a17:907:2d06:b0:6e0:2ec:c7bd with SMTP id
 gs6-20020a1709072d0600b006e002ecc7bdmr41708797ejc.656.1648645656923; Wed, 30
 Mar 2022 06:07:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:7204:0:0:0:0 with HTTP; Wed, 30 Mar 2022 06:07:36
 -0700 (PDT)
Reply-To: prettyalyonakozak@gmail.com
From:   Alyona Kozak <ladyamandarobert@gmail.com>
Date:   Wed, 30 Mar 2022 06:07:36 -0700
Message-ID: <CAM5t8GY=xuRYi8uZfO++hXBp-ZktOdvs9Jx0wNwFL7JiFNFvMw@mail.gmail.com>
Subject: URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,


Hope you are fine .


Please did you got my previous email to you ?


With Respect
Alyona Kozak
