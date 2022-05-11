Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C251D522B59
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiEKElg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 00:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbiEKEkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 00:40:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C5014CA12
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 21:40:31 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d25so943021pfo.10
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 21:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=s3Cdswvtyrq8qHVwuRB9YRoTAIoD9G/2//h6WeFZHzo=;
        b=CpCECsPeifPt5spOY+hxF3SPXEjo/w6hty7zyWfoD7x9Q0r+hx23YMWQhTm8eOw7HH
         dvTnDs0/6cvkIxXvhw4qZKhOmeoleRgjjIA5RBu3s+gZeHpHgRib+NQqB0f7Rq1esj1J
         f9Fw2ZGyhylxsHzxTt03Hg8cvTdX2sMZs/2thSR3A0SR4njfPezKqxaQUsVj81B/eefB
         Vwj2HyNoTLjPPCBmqYpXxwJ4lOaoKqeQg5eDXmVTYbAPYxHYA2A+tLCM/M8mR7SMpYgj
         U1CjSMy1LA2jdSzKe3q5foQHZsYLdD6YbJPsHgbhhPgoEYcX/ShGIgvc1LxLQTsLx6MV
         oG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=s3Cdswvtyrq8qHVwuRB9YRoTAIoD9G/2//h6WeFZHzo=;
        b=HBMu/ifouu2SgzYxeHAj1YqnXLxMGs+J3n+fmpZwKWqvYLKnAfgPUCZyd3u/pfaIDc
         TRQsfE2MuBj1u72Fgzq+RNtM3RltaGeiIDz6IpBvLS14bBo1LN6i+vFkMnrpAPumAP8/
         s6Ed5RrtVttUQ9lPrD7DCqqH7i9PyTvYymnena73oCobkQ2/0ThxsnEguZDjqdhmCHuO
         54at8X9kLNXwypAuacjAe5YaCYCxh/EwywgoVzVISftZBYLq3lM2bb3N8fJ1KrPeqSfZ
         fxyL7OZTNDjRopHIRrpWT6t85tzgwFZ1bsjzplboXiBnJC/l027EPWOTfiFFfSdFmqmv
         9OOQ==
X-Gm-Message-State: AOAM530xy7q+LtVHTslrlCrP/470tZozAPpaDvJqxq2/yybIDEqxI9fn
        9xtWWH7IJiwISUyV0uWTewdxnpGLPyf9dMN/2pI=
X-Google-Smtp-Source: ABdhPJz6VOsq6tHEcJde7ze9Mwk8S/rcQCgVu5HGY72mYvCggXhNNJjlSk4uemHnGcPUzQVOuhhFYUqdwWTW5cbuyMk=
X-Received: by 2002:a65:694a:0:b0:3db:141c:6db2 with SMTP id
 w10-20020a65694a000000b003db141c6db2mr2414148pgq.198.1652244025817; Tue, 10
 May 2022 21:40:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:319:0:0:0:0 with HTTP; Tue, 10 May 2022 21:40:25
 -0700 (PDT)
From:   Private Mail <privatemail1961@gmail.com>
Date:   Tue, 10 May 2022 21:40:25 -0700
Message-ID: <CANjAOAjARYVC6Qk-Fnsn0bf7TP8Boo=pjYW5wBup0tWw9ZzxDA@mail.gmail.com>
Subject: Have you had this? It is for your Benefit
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DEAR_BENEFICIARY,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,
        LOTS_OF_MONEY,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our Ref: BG/WA0151/2022

Dear Beneficiary

Subject: An Estate of US$15.8 Million

Blount and Griffin Genealogical Investigators specializes in probate
research to locate missing heirs and beneficiaries to estates in the
United Kingdom and Europe.

We can also help you find wills, obtain copies of certificates, help
you to administer an estate, as well as calculating how an estate,
intestacy or trust should be distributed.

You may be entitled to a large pay out for an inheritance in Europe
worth US$15.8 million. We have discovered an estate belonging to the
late Depositor has remained unclaimed since he died in 2011 and we
have strong reasons to believe you are the closest living relative to
the deceased we can find.

You may unknowingly be the heir of this person who died without
leaving a will (intestate). We will conduct a probate research to
prove your entitlement, and can submit a claim on your behalf all at
no risk to yourselves.

Our service fee of 10% will be paid to us after you have received the estate.

The estate transfer process should take just a matter of days as we
have the mechanism and expertise to get this done very quickly. This
message may come to you as a shock, however we hope to work with you
to transfer the estate to you as quickly as possible.

Feel free to email our senior case worker Mr. Malcolm Casey on email:
malcolmcasey68@yahoo.com for further discussions.

With warm regards,

Mr. Blount W. Gort, CEO.
Blount and Griffin Associates Inc
