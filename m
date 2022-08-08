Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7658C56E
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiHHJTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 05:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242298AbiHHJTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 05:19:01 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2702FD2A
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 02:18:58 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31f443e276fso74385307b3.1
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 02:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=2ER2WW01ET2wH1WV2jGlyhputEhjwKA2tNpxchjmONE=;
        b=ns4Z4Qw3HN7ByKntT54lr0KZphv48KeDUWD1k1UW3R1KoBf5F1T8XEjwKPK32dfY7U
         MLMhmluVbNOuPEVugEHd6BkD7aldp8PowK01M9qph6P0gKPiwjjwMFCsbFDHSJJECiY9
         Kd993gNFDl0WRhbv9CByAJrwjg/xBZKdOsSAsaLtmD2pkF7lxX10kVbfqcs2unf2MV4E
         FaPEXRSihRGcelYMT1TkWB2R/jU/qAbiGY2H1kq0FBr1uHnq0MWXyQteIJMx912fFVbV
         NyNd8SDbKAGRxEexVtMVkFhTG7uWnwuV3MG5VF7Q3WIcdB2BZGzdG6chz6opOjMSruqx
         Ouig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=2ER2WW01ET2wH1WV2jGlyhputEhjwKA2tNpxchjmONE=;
        b=CdrcfSq2QHsXfoBpSVvO8sAsvsG1ww8CkWeriT9r8ybzTjgsyVC7VCxqy+xFrVXZP8
         OspqsPCogTt6hhvnbV79GtAe3vENxLv7H3ZVTjc02+IMXuRqsmryovtygvDyE+SIpwr5
         zXibx/Ux9kfeTS6nApyBb09cS0sKCXK2kikWfauA2OT6aBsyivXJE0gRgV76hjdH4MTe
         oAx7YPxn+A+52ppg7nCfSVeQ+nulqDFJ9Ag3k9CyGlhSb0gmukZgw2F2m6XfjeXW8aGD
         0VFheA+6qj0E2Z8pPzDTg7JawEYe27KK7Vk17c7y26hjpqvqctMQVNYNDVB3sQzTC4Z0
         kEcQ==
X-Gm-Message-State: ACgBeo1XyXV8bg7MPGI4Ng1qtLHC8sy8NrrMqkBebvcZGTzs5NCR2Hbu
        ggE99XlaYrA65tTW96VEUZToMGeEDrI4WgnnVOo=
X-Google-Smtp-Source: AA6agR6GDnMa49jmsrWS5fsehS14rltoD3kXaidQATPQsuWTUQCHU+8HM0QQLybJ5Bnf0Dj7/oLaJ+CSCA7ob5G7eso=
X-Received: by 2002:a0d:e88e:0:b0:328:297a:fd9e with SMTP id
 r136-20020a0de88e000000b00328297afd9emr18480073ywe.88.1659950338012; Mon, 08
 Aug 2022 02:18:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:4a9c:b0:18e:7ed4:6c87 with HTTP; Mon, 8 Aug 2022
 02:18:57 -0700 (PDT)
Reply-To: Drlisawilliams919@gmail.com
From:   Drlisawilliams <grahamkhudori@gmail.com>
Date:   Mon, 8 Aug 2022 11:18:57 +0200
Message-ID: <CAOPDNSG0YJ40knOxvLpsDCjnEcc2xh8fm3OehtiAAcGr76VzFQ@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks
With love
Lisa
