Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0966CC1C2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjC1OMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC1OMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:12:18 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E9BCC14
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:11:15 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id r11so50307800edd.5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680012675;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aMDawhYLx3Mw1Ru7M4ieYmIRH4V6sKt21mgwWoKmlKA=;
        b=jXUAn/Z6hITgOzPMYHqlu22vv/v9lj0wbME6e5E1lq/uWP0rWxi3azFeLwT7+gYc8F
         EnE4cfiMxtY5iMbgzrWACCIQYQXEw8VjQemUSmxzA7fU0kiItaaQYrkrfPjevo5q75jj
         /sNETyCIeCU8czSjwz6eg0la1rEkAbthtRxZIbBdKQQu5+oj5L1rnAdAz+5VhuUaP1mD
         RPjoV8FzAuUdcDBAJs2tqit9bbUNRfDK+Q3oXiEuqM9Og/QFgyc5I8b7fev8QzhPl5bJ
         eyAHPh8NL02ImBpTrehZOSgEReclRst/gorfkbN0EPGvEY1A4fT+T5AahJYGCdF/BVam
         nUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680012675;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMDawhYLx3Mw1Ru7M4ieYmIRH4V6sKt21mgwWoKmlKA=;
        b=VFHerh4q6X5c0fqJP7zU1Yahnzu9yDie4uov53kkF+KtxjkLmdbNyUVt1aE+tQFH+j
         RioBFaMXcY807lhxa4y8vZkC4DJpXfiMXTMYYa8VFRCsfGParFLbUlL9Xvaz1jBNuUdh
         PR/hHUasMPN9afcY6pgCCVr7IZjFbXTvK3lNO/MD7VxFtqHg7OBKwV8X6LL+TKll1s8A
         zjA0wyOKvLezn0lLc2vv641KxlNukW+1cW/KcPpSvd3xT7DNutOZI1EXSSdo/hN5qjad
         UWa/+o6N/EFOAQ9hl7ELl/fJvTKePsQ+Lt1Pvw5+RqA+M4r6RTxSfgDvStvsJx5PshpM
         VLoA==
X-Gm-Message-State: AAQBX9cUoaiJdyADLZjyLq3wCcCsAGR60GYvuJwODggFLChEaUsrvk2b
        0mwzgPNgyF4m0IkO3wePV3/AiF4gPrxEQubCa87Y6PPQ7hlufG0h
X-Google-Smtp-Source: AKy350YZEW2CbWm5W4OfdvKPwFzImqWsjB+7OWrCv4UaWXpQ8rkzlVIfXTWnioMvypqQ19hdtAox10076gE8WXQwwTU=
X-Received: by 2002:a50:d68c:0:b0:4fb:80cf:898b with SMTP id
 r12-20020a50d68c000000b004fb80cf898bmr7359895edi.7.1680012674656; Tue, 28 Mar
 2023 07:11:14 -0700 (PDT)
MIME-Version: 1.0
From:   nancy dubuc <nancy.dubuc.b2business@gmail.com>
Date:   Tue, 28 Mar 2023 19:40:55 +0530
Message-ID: <CAO=bF_qBn54fohb9O9iPycU8r0uPS+LikJXiKNL4oWGkEz3xvg@mail.gmail.com>
Subject: RE: NTI - American Association of Critical-Care Nurses Attendees
 Email List-2023
To:     nancy dubuc <nancy.dubuc.b2business@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,FILL_THIS_FORM_LONG,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Would you be interested in acquiring the American Association of
Critical-Care Nurses Attendees Email List-2023?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
number, Industry and many more=E2=80=A6

Number of Contacts: 12,639 Verified Contacts.
Cost : $ 1,638

If you=E2=80=99re interested please let me know I will assist you with furt=
her details.

Kind Regards,
nancy dubuc
Marketing Coordinators
