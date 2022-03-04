Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E5F4CD330
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiCDLPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiCDLPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:15:06 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5664E1B0C43
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 03:14:17 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id f7so3932367vkm.12
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 03:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JtW4b+qwTJzlBoKIO1sXHQAtzesu4RDdTdSms2H5wnU=;
        b=AlNpdsqpbCn2Yetd1ffaFRBlPzgafoVTs0FBOsOIZjEoBKRQDSCTb+6mGbuv/2XATX
         EhjuheI+WcXKmKn9x8eWILTIJr0TsmOjqHbTDrJM1qAIEvIjqIcBfUo9/EVNuYLGgJVx
         O43JxZDxWZfFo5r87yfu6FDuK+RwZZU168U1fDbdxAWbXIudmsjgyc58/Kl3ptc9LBng
         ZVi1bJ6exUiNbYxneW0vxfE4SIt8sMHN6RF0LuaQ1YmMPI7ltlxEmpD6JgO3a7kA9Amd
         L22lwvKqTV6ZLKOgxbjEPLQB34dtDtjZDybZUIm0SX/kwW89kj0a4MynguDe5M02C8pu
         8s4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JtW4b+qwTJzlBoKIO1sXHQAtzesu4RDdTdSms2H5wnU=;
        b=Ebsgy2tl8VSJiwdJPDmuykVW0fP0KRCDR4sJyaWv2gZzFHxyEzL4WpVYl398U96Q4M
         LJqkTltCmXV+NPTY8jhHNNXzl+2I+I+xMjHEY3t6HVeHXkjC+ZcdoDKdRgS+4q8kN0ny
         ekyOqZ8xJbgqwMHvhXwEj9uAwstafXXBZgg6R0ibWQ8Y4BdST7Nh4+M4Mw7znkLxiun9
         usCvv0cjdYgjSti2/PdlK1eYxbHGajQOZk969Mco03ykB+fFv47WbNdtBcpx6s1uhi4S
         s/2D17sN2ck6mq8m3kAOh4ojHl4xQh7KXZe3zSyZcQcNEZePvWN1p1JFZ64ru6mLKIiu
         tKuA==
X-Gm-Message-State: AOAM531huyuSQuYCsn7TJ79JQofrJO4NRDcCoho9ODdOdyKjjbuDD3Pk
        mZJ5Vqly75EFT3JuUVVF9kQ7pIDMMV1iuaSjH08=
X-Google-Smtp-Source: ABdhPJz1rpQjDECrn19lTG2ebSffPmKQJ2Iblxv3Rq70DSEyGBMvz0rwInDoihy0pfduAfQ4o6CArNIXa8zgrou1Uwo=
X-Received: by 2002:a1f:1e4b:0:b0:333:6c3d:bd45 with SMTP id
 e72-20020a1f1e4b000000b003336c3dbd45mr9309619vke.29.1646392456472; Fri, 04
 Mar 2022 03:14:16 -0800 (PST)
MIME-Version: 1.0
From:   Kelly Brown <kelly866x@gmail.com>
Date:   Fri, 4 Mar 2022 12:13:59 +0100
Message-ID: <CAMaHCoo1g=kC0cerncSb9Sz=+iUPhc53dBZriGT=UKm9=E7XbQ@mail.gmail.com>
Subject: ATTN: SIR / MADAM,
To:     Alicia.lemon@gmail.com, Emailarvedicycling2019@gmail.com,
        Sklemon2@yahoo.com, Sydneyk.lemon@gmail.com, akyebambe@drt-ug.org,
        akyebambe@drt-ug.orghttps, allankyebambe@gmail.com,
        almalika.lemon@gmail.com, anthony.c.lamon@gmail.com,
        ariesalamon045@gmail.com, beartaihitech@gmail.com,
        bill.lemon@gmail.com, cheryl.lamon@gmail.com,
        dario.bristol@gmail.com, davem@davemloft.net,
        drkiranmathai@gmail.com, fleur.lamont@gmail.com,
        foster.lamont@gmail.com, hanako.and.lemon@gmail.com,
        jonathan.lemon@gmail.com, klaus.zuberbuehler@unine.ch,
        kornel.lemon@gmail.com, mckiever01@gmail.com,
        misssaitharn@gmail.com, moeks.lamont@gmail.com,
        netdev@vger.kernel.org, noemie.lamon@gmail.com,
        owen.a.lamont@gmail.com, regular.lemon@gmail.com,
        richardcochran@gmail.com, susannah.lemon@gmail.com,
        thammaratkoottatep@gmail.com, thanyaporn.c@chula.ac.th,
        thejungleishellpodcast@gmail.com, travelbassinfo@gmail.com,
        tunta2009@gmail.com, ugleduc.bi@gmail.com, uttara.dhaka@gmail.com,
        vietanhctn@gmail.com, wanpen.chongrak@hotmail.com,
        whatif.lamont@gmail.com, wilasinee.y@gmail.com,
        wilasini@cbs.chula.ac.th, wtylerlamon@gmail.com,
        www.iwa2014ait.thailand@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORM_FRAUD_5,FREEMAIL_FROM,FREEMAIL_REPLY,HK_SCAM,LOTS_OF_MONEY,
        LOTTO_DEPT,MONEY_FORM_SHORT,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.5 SORTED_RECIPS Recipient list is sorted by address
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kelly866x[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 HK_SCAM No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  0.7 LOTTO_DEPT Claims Department
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  1.1 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.0 ADVANCE_FEE_4_NEW_MONEY Advance Fee fraud and lots of money
        *  0.6 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.0 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLEASE READ IT CAREFULLY.


I am aware this is not the conventional way to establish a
relationship of trust, and I apologize for this unsolicited letter to
you, but as you read you will realize and see the need for my action.


I am writing to inform you that the United Nations Compensation Unit
has been having meetings for quite some time now with the IMF and we
just came to a logical conclusion a few days ago.


This message is to a few well listed people that have been scammed in
different parts of the world.


The Executive Officers and Presidents of IMF/UNITED NATIONS
COMPENSATION PROGRAM, have agreed with the Board of Directors of the
Organisations which I am a member to compensate all contractors and
Individual scammed victims.


This mail is to officially notify you that your email address has been
listed as one of the Scammed victims to benefit from this ongoing
program.


Please be informed your REF.NO./PAYMENT CODE IS: ALPHA -
01.UN/IMF/O379/ATM, AMOUNT- =E2=82=AC7.1M EURO and are to be quoted in your
corresponding.


For claims you are advised to contact-FOREIGN SCAM PAYMENT OPERATIONS
DEPARTMENT:


CONTACT PERSON: Dr.Gita Gopinath.


Email: gita.g2018x@gmail.com


With your details as below for processing and payment release of your
compensation fund:

1. Full Name:
2. Phone Number:
3. Occupation:
4. Nationality:
5. National Id.card or International passport for Identification and
clearance as the bonafide owner of the fund.


All the requested information as above is to enable us to prepare all
the documents so that everything will bear your name for claims.


Reply with this proposal to make sure this message is delivered to the
right person.Moreover,the information provided above will not be
shared with any third party unless somebody that will be of help to
this transaction.


Yours faithfully,
Anita Jones, (email: a.jones7x@gmail.com) For The organisations.
International Scammed Victims Compensation Coordinator - Copyright 2022.
