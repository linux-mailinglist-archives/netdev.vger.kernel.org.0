Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B9F53EB26
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiFFNm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbiFFNm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:42:56 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DDF2497C
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:42:54 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso1038198wms.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=94FE0xqKYNBQJ8bbUNfhKNNPOc38KM25jE5hqWXLeJ4=;
        b=CrmEhJxq1l4OTomBhxJ7gibVbpSR4Ozlj5Nsilj9K6AFO/OohvC4DGByx8fV+QXa66
         mGkjtKaiCp8smDnW8O1+SxaRIBIxH1tAxdu47XHKgSu7yIkpXuu9SRXmuX1aYk/ddBHY
         /JROXXB3pXfMcv6Udz8jcnu4rM4EF0JFmIUqbaw647fCPUINGjsF/ve5yJGI6+4Rj17T
         5Us+fVA1i9c84/U757B4JGOXlZOjM8KJnGLPh5g2kuxxzU+6W02iDRpEisHt1dvWITyW
         hZJzLdZs9nJiqfr2PlBh22aFF3BUOOdzRIZZ6I2nSjm4xUAaVLKr1Z5q+z6+rWoW59vd
         kKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=94FE0xqKYNBQJ8bbUNfhKNNPOc38KM25jE5hqWXLeJ4=;
        b=jGM19OJmn7UwtqSPsiuUaMpT1J7t3RHBKuN0wAka0Ux1ssB+k7hIRYNMQjoEMzcLdJ
         hzAx0qLNQzyDQxCblCud7ooIXjAmLOhuNLvFVPMyrzrfjJOogD9gkysEbxlYsJQYe74+
         5fasko138ifWStvRV2h7WHpyO/cmmfqTezwhUvBXlI4l8ZgsOFMNA5eoF8/jevolNg9f
         KUT/YMV2zWHlyausxI9lsDVMQjAIVGXFbLnyrnCb4EbJQex6TiIJW+l5l0ZjyfaadaQ5
         b4ofIpCJ6Pi681M+9dURGCPaR1F9ccqdBAioTFbdta/9w/6bBy6sYY8Z0JPn9s/KYtUa
         X9Bg==
X-Gm-Message-State: AOAM531pXInaXAq+VtR68+p8x5T6N/Ox/VtA6JL0nwZhKNMRgAJoEU/l
        8ixzbk2lhej+gEr/ZcgAtINyH0BiaCOwy0z/hlk=
X-Google-Smtp-Source: ABdhPJwGHfn5+m2S21QKhNZ99xCSwXyl0zyR6a+qzNEYJSCkl+UeEUzE54LbQgHy1vt52jj5s4mnUb0TGFQTYGiCJHM=
X-Received: by 2002:a05:600c:1c22:b0:397:5c31:6669 with SMTP id
 j34-20020a05600c1c2200b003975c316669mr51941437wms.78.1654522973265; Mon, 06
 Jun 2022 06:42:53 -0700 (PDT)
MIME-Version: 1.0
Sender: smithwilson780@gmail.com
Received: by 2002:a05:600c:4988:0:0:0:0 with HTTP; Mon, 6 Jun 2022 06:42:52
 -0700 (PDT)
From:   Dina Mckenna <dinamckenna1894@gmail.com>
Date:   Mon, 6 Jun 2022 13:42:52 +0000
X-Google-Sender-Auth: EaXXmE4OXwulyGZqiodbHO0ge1U
Message-ID: <CADh0mysot8BCseQCf1G=QRMhL2B7U-741LWaHrC7e0N61cffRQ@mail.gmail.com>
Subject: Please need your urgent assistance,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:336 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5804]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [smithwilson780[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [smithwilson780[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear.,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you.. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Howley Mckenna, a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for..

I'm waiting for your immediate reply..

May God Bless you.,
Mrs. Dina Howley Mckenna..
