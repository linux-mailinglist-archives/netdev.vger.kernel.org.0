Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B11B4B0138
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 00:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiBIX24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 18:28:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiBIX2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 18:28:50 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72479E06C40E
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 15:28:34 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id n24so2927821ljj.10
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 15:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=aPTFbZr4LhKGppGQDkO7tNLWiZLizgW3cwR+POXjY4E=;
        b=Z3NxzVfc1PnJb2cdyBdhoiNkRlyDeOLb6wU6x1Pk/YmfQyz3YIkgi5b/8QvxKQG8yZ
         HEZ71Ht+ik7YtTTM9ct3Cdp8saHYx29O1CtRANNOuPNXshEBe+KPVsT87x6AXLETmf7t
         W3Rdq8S37V5wDNDJi46WrOkxHGZG8IoJkJGDcC07Iw7yfhcKkgD3R43ke5/1+VPOchcd
         YPGr00hYu4uNcIZDkqvqy0Ws6yshzxYeaECauzXJ8vcuEwPpQTf4Q1NuyPz0v23diU64
         3k3lRJXu+MA1uMpi1hM+CG5kv4IS8+K0kNy/PVdjOny3QpBJC4bXj/V/fkGtR2iYC7z+
         aBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=aPTFbZr4LhKGppGQDkO7tNLWiZLizgW3cwR+POXjY4E=;
        b=h4Y/0Y5DjQnlzkYo+A6BauIC9ozDV9EBhe7HSVOJ2zBIpKEcM9yfJni7/EOKeeVTLP
         O0sc1rvWrqxj7x17dOkj96gsxRsHbpGitZFHVCvkALyJRJ6eYTlg8FBJItcXkxIAYjWg
         D/wR93cRPBp7Hc6KLsqgi/f7U8+NDUf7AYrOSSP40wQS881AMQjQQC4tupdiEtLjQqAu
         UD81+o3twU1wdYQdqIB8RpEyqIU4AofGRXqlnS0V7+CfKO690madxGME9b7NNLTKL+Ym
         r0FJLzwz1niv9GqTvHn5m3gv/t+vc1DiKnpWSOjQRkZOoUvj7KD/Eqeu+EDA3JU3Cq5I
         xMtA==
X-Gm-Message-State: AOAM530N9Ir9MqW7ij9qsGBfYOFXX9A1JwIWOWeKyGukQDqHaqiKMBh1
        WclOqECaEGbWcppw6AXhCtaKk3mBLU7m+rXu0Oc=
X-Google-Smtp-Source: ABdhPJzUaVwylhVFseVAMmU2RsjXwtk8xvWwtX48xPZYnh6ef65ua6Dymq/ZWxBV182bqgrKU6PDGWG3GtY20YR6ORg=
X-Received: by 2002:a05:651c:315:: with SMTP id a21mr926604ljp.490.1644449312647;
 Wed, 09 Feb 2022 15:28:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: dr.tracymedicinemed1@gmail.com
Sender: jaochimzongo5@gmail.com
Received: by 2002:ab3:694e:0:0:0:0:0 with HTTP; Wed, 9 Feb 2022 15:28:32 -0800 (PST)
From:   Dr Tracy William <ra6277708@gmail.com>
Date:   Thu, 10 Feb 2022 07:28:32 +0800
X-Google-Sender-Auth: xfofTgQvZylz_SZsdgn4qJzdvP0
Message-ID: <CAF_YTPgR02w5hXZCj=K9C7Ui_0LbRSVRDVxbOwca9ouq1rS22w@mail.gmail.com>
Subject: From Dr Tracy from United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

how are you today,I hope you are doing great.

It is my great pleasure to contact you,I want to make a new and
special friend,I hope you don't mind. My name is Tracy William from
the United States, Am an English and French nationalities. I will give
you pictures and more details about my self as soon as i hear from
you Kisses.

Pls resply to my personal email(dr.tracymedicinemed1@gmail.com)

Thanks.
Tracy,
