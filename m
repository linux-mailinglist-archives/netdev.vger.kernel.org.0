Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADD4DE4D2
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiCSATE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiCSATD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:19:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2825C44A02
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:17:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p9so13659357wra.12
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=nHz08v+KGykef/EY5wszhlvcWuKfz0UE0QFNYs1Ac5U=;
        b=Q6toToJqBK28YpZq1MyyDCF2CAyUrZqAFk2dXF1IPwqNs8pWoVRVuhaottgONGVYAA
         jr5+Qq9x3cel8BYWR9G6eB/+NJXqAZpuSBoIHEAcKwZeiS9C3tDbMYTEIkNi2Fe4jBgL
         0YbW0YQy40xaWUrEtQHZTuzc6rm95ZVsZfLHMbKMJJjWe3bwx0RIoYkELxr5T7CuXINc
         Eji7meqZkLLDmiS77pMLbT8OrJRrX1VGP8+b/TnS6fwUHdisrJeAMF727pDXoqWFjmCZ
         s3cAyozFVy4WVFvrcaJiR9aiPX3Mvoow2vScRaTqOKmCvEoZqpoKRoI9NHJbuvdil1SF
         ijpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=nHz08v+KGykef/EY5wszhlvcWuKfz0UE0QFNYs1Ac5U=;
        b=GvWqJiXJ43lN28Voouo7s0ee+UTc6+m3/pqa1spSUIq8Kh3y/Y8NtTUJB2DrDBuwiw
         bxRHIUyAKzywl7Y45D2/3Wm/XEJ0U84v1x21keTiwIi5/znK1RWN/WmGYZ9Hg4QbTQ8k
         +2WZzHx0uuDXn8T21q9fLRUYr5xPDfzQmi/p6u/WaOWONoufJIX0OaAPsuOc5WReynD6
         +C1DKocHg6/GgIWYfSWgOz3ZF7fXZFquTL5cgohd5VneSD6m0ZsTLy22Etdd9V8kYxGt
         4TzPFLTCPlGHZeaTGOnRHwTpfG9yFKsMsPAb95ou7zQQn0nvG2khxEHjB/ql1JaP/mgf
         gFtg==
X-Gm-Message-State: AOAM531dFY4fsbTLTU8t5dbm33ZvINF2RY3R8FoHafSo/oYdTKmRmL4x
        5metE37IGWh/2x0v6TFIg74=
X-Google-Smtp-Source: ABdhPJz0FP4a0DViVJh9IELMYZ+Ap2oCRsCx9vCUKUhEcp66SdoVpInpYCmw1o6Fs0PLSF9H5CF8pQ==
X-Received: by 2002:adf:d1c4:0:b0:203:6d79:f15 with SMTP id b4-20020adfd1c4000000b002036d790f15mr9446268wrd.489.1647649062804;
        Fri, 18 Mar 2022 17:17:42 -0700 (PDT)
Received: from [192.168.0.108] ([196.170.18.253])
        by smtp.gmail.com with ESMTPSA id h18-20020a05600c351200b0038c6d38b42fsm9080216wmq.36.2022.03.18.17.17.37
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 18 Mar 2022 17:17:42 -0700 (PDT)
Message-ID: <62352126.1c69fb81.f13d3.4d49@mx.google.com>
From:   "Vanina C." <curtisvani0090@gmail.com>
X-Google-Original-From: Vanina C.
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Regards to you
To:     Recipients <Vanina@vger.kernel.org>
Date:   Sat, 19 Mar 2022 00:17:32 +0000
Reply-To: curtisvani9008@gmail.com
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings, I'm Vanina C. how are you my dear, Kindly respond to me, it's my=
 pleasure to meet you, hope we can establish a relationship from here.
