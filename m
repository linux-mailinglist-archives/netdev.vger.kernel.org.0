Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547784CDB3C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbiCDRr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiCDRr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:47:28 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA5D1C3D12
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:46:39 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id e8so12015060ljj.2
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=gnW213AwC9ZFaX4TwovWIVI70m45ehAojubOFyKSXY8=;
        b=IQmnz36DS35/Dgtc0b9e02SIjzEs/440pwjmnb2DYr1Y0T4FvhRoN59WxTLm4RCSUj
         rysQewrnPbB3nPiFDpwZoa+kl6qAD0J+BnPfd0fy1fGauwwSc0Ybb1VNd+7IMva37xMW
         OYuS0g47JaJJOgVA+njCr+QyLMRwKxm/EEWqLI7TLu198y1kNJ3wNBFnYmIwcpWp6SLo
         /DkfUWMHimqY+k4AzGxluyB8hDzhLkRAQcxELRW8m77FpVqw0NmpNe2bipwQ2X9JZl09
         pNz/tFrmRe9nI9BdOKT+43eU0x5OblzFbss4DB7R3B/eiXmMPAGcZKH9Z644ntqSQdZO
         7WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=gnW213AwC9ZFaX4TwovWIVI70m45ehAojubOFyKSXY8=;
        b=m9Hof9gOMTV5p8awVRzh5oSBg3v/UpYqdCQLeJHeGmX2rnODqnTPSJdMY4EHVG9jRZ
         oWcPPwUni4mmh1QSTeES+L8cWJ8pdyXkfpxYEnFb7eh8Ln2qBCHrqs3bfLOdAymFPtzk
         2f5nF7YctkkfQySC2MCumKRIdaajVfZrkdu3DV6ASNDRHMyp6mIbIarIazEbq3T0Z3N7
         nntxtLUKcru+I3rU3ujYdhn3Ief56/ocCCf5RFzL1qWXLnzPiODTplr+6raHx4pQ1U93
         5IgMdao5gnZ6LnvV5RZBdBTJbgvVOcQCOUvE2Lgr0/VNhesTXpvFP1J1L9v5X/UgjMSt
         dkrQ==
X-Gm-Message-State: AOAM532vIRGAGzPuiWiPXeCfM4FnDxT8Jr7FWJ0LYw+1+T/MFnQ65taq
        pYHa5i13KwM+5RBeppFy+9iBw5arKVxEiwTS12U=
X-Google-Smtp-Source: ABdhPJzFrjNZOebBFA/kfzOlR87+fsrs5DR+DVqWTW084OTFeBA6H+wMB8oC2fiHT8KVz5gKkU9bWPFQfllIa+od0No=
X-Received: by 2002:a2e:925a:0:b0:246:4233:3835 with SMTP id
 v26-20020a2e925a000000b0024642333835mr25977095ljg.361.1646415994700; Fri, 04
 Mar 2022 09:46:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:aa6:c46b:0:b0:19c:e32d:4c9d with HTTP; Fri, 4 Mar 2022
 09:46:34 -0800 (PST)
Reply-To: douglaselix23@gmail.com
From:   "Mr. Douglas Felix" <legalrightschamber07@gmail.com>
Date:   Fri, 4 Mar 2022 17:46:34 +0000
Message-ID: <CALi75Ooames2Z5XnoGsvjEjJSzg_zOqnUgsHvf+q0rU3vbLEzQ@mail.gmail.com>
Subject: =?UTF-8?B?QnVlbm9zIGTDrWFz?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:241 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [legalrightschamber07[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [douglaselix23[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [legalrightschamber07[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Se le envi=C3=B3 un correo en alg=C3=BAn momento de la semana pasada con la=
 expectativa de
Recib=C3=AD un correo de respuesta tuyo, pero para mi sorpresa, nunca te
molestaste en responder.
Por favor responda para m=C3=A1s explicaciones.

Respetuosamente suyo,
Abogado. Douglas F=C3=A9lix.
