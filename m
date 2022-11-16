Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC9A62CDC0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiKPWfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbiKPWfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:35:16 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D7A6B22A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:35:14 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id t10so391192ljj.0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/D+JOz7nkxYcdcRR3XuXah7sfLk3j19m5jZhc5FGfck=;
        b=iKmJAmiGtU5QKm8jIIR2ZeaPMMMsZRtOvWMjpwogDxouwIqF1/ojb7hqXMNMxwAEp7
         TQcXGJsSuebQpYIHgBgfb4rdSP1I3jQ1QpVqTjeCx/qYpQE0Qitg57ib0cRZ2oaObs4r
         NOs2Q+4X3NYZHFOeFIEKvwt+8NS+eUhZn2xicvgu2pA8RKCXI+W4G965WU/FVs4eQrmG
         qnSVyiNiHj110fCzob0cml56KPU1jGiHrOe0Uj2FBRSoCy1O13gj58KggHbg1+aFqwFO
         da8E87ZiqgnmpI4+DPD6/XAyThk6F4rCDpKbWsJbZNXH0uhKjP5rNE/1u/zvxa+B7KNE
         Ox0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/D+JOz7nkxYcdcRR3XuXah7sfLk3j19m5jZhc5FGfck=;
        b=U9htTAJmwy9Qq10l9+PffaILhZKKqqHP+pC+tr9/CJ6hxF1V4wXbHsrnEJLheQgXrM
         +2FvC8aBiuS++MnFb0Vem9d70Ot1U2aqFXEFSa1ImrQ87ZO5eUG1BH4/sV6XMa1tazy9
         yquO7FqyGwh5n3Ddj02K5oXuWPHRKlQq28S1CttZPqE8HomZOwR/d07rg2rTU2thtIS0
         JXZd0KRzsgxOQwnzPjZAfUgdqhQEoH9hZEmkkP/mV41bNi4rgikhwrE+lENMcPWtDQsN
         GUx1BAOLDhTdV4JDVeIEyt+6yvKqkNBxzCRTqFvMKqXGNTyL6Gb4x370WDdhJaqfYMUG
         c9uw==
X-Gm-Message-State: ANoB5pk2CFMeB0oGFqsVilojTOdqLOFhYdmOmJlfSg4qSj2FOjk32B1a
        CssQdx86ISirF3SulU8FkNQ8VlHGaaPfjAAyJQM=
X-Google-Smtp-Source: AA0mqf5Po37w3ltR+1lxpWxoQW5KliOKKRfo/I9Bb2OVxWSwa2pLK4PJuA2gvN2tBVaBf7OIdJ/PRrouT6GoqLo0Lf4=
X-Received: by 2002:a2e:983:0:b0:26e:2772:ffab with SMTP id
 125-20020a2e0983000000b0026e2772ffabmr118409ljj.97.1668638112984; Wed, 16 Nov
 2022 14:35:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:9dd4:0:0:0:0:0 with HTTP; Wed, 16 Nov 2022 14:35:11
 -0800 (PST)
Reply-To: mrshestherthembile580@gmail.com
From:   "mrs. Hesther Thembile" <mrshestherthembile25@gmail.com>
Date:   Wed, 16 Nov 2022 22:35:11 +0000
Message-ID: <CAJ2eRGC0Odnh4-7DLPcNL4s2KaL449aRj=iCg4qCzAWDjOEXbA@mail.gmail.com>
Subject: Selamlar
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:235 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4571]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrshestherthembile580[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrshestherthembile25[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrshestherthembile25[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Ge=C3=A7en hafta size bir e-posta g=C3=B6nderildi.
Senden gelen postay=C4=B1 geri g=C3=B6nderdim ama beni =C5=9Fa=C5=9F=C4=B1r=
tt=C4=B1, cevap vermeye
hi=C3=A7 zahmet etmedin. Nazik=C3=A7e
daha fazla a=C3=A7=C4=B1klama i=C3=A7in cevap.

Sizden tekrar haber alana kadar kutsanm=C4=B1=C5=9F kal=C4=B1n.

Rab'de k=C4=B1z karde=C5=9Fin,

Sayg=C4=B1lar=C4=B1m=C4=B1zla,
Bayan. Hesther Thembile.
