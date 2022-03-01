Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39A74C8F03
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiCAP0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiCAP00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:26:26 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B1A94F2
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:25:26 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i8so4010048wrr.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=d4kr4pAg98lqH/uH3Zev8XKVwTO60gUUVq9C8iDreKs=;
        b=h8+VBqrO09R76NKQ6sAW0tFZvMk+noTINm1FCaEP3Mhcis+ZUlrVdoaZU5yDfazY+w
         Fjkg4T1Kus/THDf4DqY2hVDxcrR1m8Xr511ayimjLEWdt9ciMWwMOmbVVnJrWPGzySvB
         M9+oTsgMMpLKDwEjH4fa33YbXxUllX6hVXyX7DWv9HiZrTIedU1LFV3pBulgPdblxMnY
         GOZLrMMl76IJPG2+vM2kUrJY05FHDD4X9TaAyYVpvjP8wbxWL6miubaVJSb1ZNBG5l9n
         n5AesyBfbNP7EUZxsI4y9hOxzEOwRXNo3GEL1YYB4mUvu/CFXtKpUKcqqtrgo7OvA9QF
         m1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=d4kr4pAg98lqH/uH3Zev8XKVwTO60gUUVq9C8iDreKs=;
        b=rYu+deQrVQkCKZkfnql0RaxZaNMuHo1WJGzWo4gUquf+i6249I4ArtgFFHLDIjXBxf
         BB3sooV3Y6+TnHCdibc7D+RRM2OlxfSjXVI5MeJrllFWs+wXcDTekOE66i0Dz7ELs+t0
         Yx2yB3CjmFkd20A0Tfoweyio9RvwFMxhQm+SD7Ac8BNzJzsZl7Pu8/f2tgs1gC12Soeq
         nYG3O3eK6qoSxD5qAOpHlQAZsyXuPmdaWkMgnZNVK7zawW7CcgZC5AMd+hgoCDgxyZj0
         iZWrPUP2t9huvTJXTuO4Ip3/sB5ud8Ax3/8cdk4GDzWoJiQUojmP1jXbTYZHDdH5uGeC
         /PoA==
X-Gm-Message-State: AOAM5330WzMeVZKEo5p1dmLuRNi6l5MWmZ4uJyFrbX+XYDtfQWaVksXa
        WYbbl0Yw/q0cFe47/mbQk7boXKwaqPb23TPeXHQ=
X-Google-Smtp-Source: ABdhPJzTy94S/vq/1V4hdGT1XqbSveJCXIGmHTaKhQudF74zpXSFeaQT35LaYyIznNhZb+dYHs1OjSVo7n1DV/1tlkk=
X-Received: by 2002:a05:6000:11c8:b0:1f0:d64:fb0c with SMTP id
 i8-20020a05600011c800b001f00d64fb0cmr2859014wrx.279.1646148319917; Tue, 01
 Mar 2022 07:25:19 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:548d:0:0:0:0:0 with HTTP; Tue, 1 Mar 2022 07:25:19 -0800 (PST)
From:   Mohammed Abdul <mohammedabdul10201@gmail.com>
Date:   Tue, 1 Mar 2022 15:25:19 +0000
Message-ID: <CAJbW=BG48rro=ED5VAFoweJb7-1XEoO+0=peUoMUQBw2r9GLxg@mail.gmail.com>
Subject: Good day.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.9 required=5.0 tests=ADVANCE_FEE_3_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_5,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,XFER_LOTSA_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:441 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4840]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mohammedabdul10201[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mohammedabdul10201[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  3.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.1 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  1.3 ADVANCE_FEE_3_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am barr. Mohammed Abdul, personal attorney to Late Mr.J.B. I`m
contacting you because of funds safe-deposit of $10.5 million in a
bank. And what makes it easy for us to claim without any hitch is that
he left the funds in open beneficiary status which has been unclaimed
since the death of my client.This means that the bank will release the
funds to anyone that applies for it first. Contact me immediately for
details.
Regards,
Barr. Mohammed Abdul
