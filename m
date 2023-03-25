Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919CE6C8D9A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCYLv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCYLvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:51:25 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9154714980
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 04:51:23 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z42so4211974ljq.13
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 04:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679745082;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FZRXrrCyhC/asJwSLOsOxy0dUDn7uJ0nZ8VEzBDUmgw=;
        b=GfakZUT2iT+rFsRV7aP4iN7ggHJ5ZjtKRLrq4OB1Mfgqw2HVS0o7/N4ZWUdAeuftl3
         ow0TjqznhTlN/u3IrjXD5ysTjdCDkQpY4VXwo/WnEGQTLK6DrW8lL9Fz7pqddpbuRrmw
         6LQ3Q93g+yqWoFJXv2lgN9jn/MaSAGrdL6OW20I6193/9M7EUggGqpwMJ3FspOnWROHs
         bkHwTHOT3ALjhn3RaEwSi3xrRWKU3fk5K41KWkxJBf7y/ato+ZLfKjhYxn6DoV1iuzw1
         v89eYo4HT/nUfjFflUsOCRjs6I1jjzC+EjZxSxaHGDUrvGIaxFmJ3xdnx4h4LL2Y8m3z
         Jf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679745082;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZRXrrCyhC/asJwSLOsOxy0dUDn7uJ0nZ8VEzBDUmgw=;
        b=AAhJ4UNMGi4/LQAgRuIWYHda5GyC2WvfsacWBAJ6yCfqShqTFiQ3jLEM5of3pW2g1K
         ALdHiPzSRcOVEYJHyzbXxnpXlJ6n4Gg5NaQbVvIr1eWGSuSRlHKszqEL0eNJ9Ug9kCc3
         GC607TqS/uMnocKuREG+6HDM34izQtQCrLkbw80Jqajn7weiCU4GWUqkYBO/apr/FRCy
         x4dAHbBVHcQRqY/MHJyJiYzXPOwJt408z8Uak20WaXSt9pvN2U4rHUZPfJPpz9NbtIhj
         y67N1+KvpsoOXII14XWXBKYa5Qx75OYdwoPoCv3xbKfnkNfRmks5jbqIuqYIKxT2KQLV
         Aw8w==
X-Gm-Message-State: AAQBX9czx0Mt0qZPrEwX3+HQmnjZ7JQmUzkuDMueWGVyVZ780Da8eDys
        dNaAPQPsZc2UGCdtTAhnqIEqDYPA1gBbsDl/IMc=
X-Google-Smtp-Source: AKy350Z+i8NuNzzdGjjzjG29+U5j+NthUM7xm5j4zaHeYDC37A8chd0RG7iBoJtgAll8JlYz2XJPgwTcHzKU06pcFr4=
X-Received: by 2002:a05:651c:113:b0:299:a9db:95 with SMTP id
 a19-20020a05651c011300b00299a9db0095mr1756889ljb.1.1679745081677; Sat, 25 Mar
 2023 04:51:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mkwesogo@gmail.com
Sender: graolvin@gmail.com
Received: by 2002:a05:6520:2f8f:b0:254:c676:23d7 with HTTP; Sat, 25 Mar 2023
 04:51:21 -0700 (PDT)
From:   "Mr. Muskwe Sanogo" <sanogokwe@gmail.com>
Date:   Sat, 25 Mar 2023 11:51:21 +0000
X-Google-Sender-Auth: _s0FcWK3Vy1CzXwxoIeVfyET58k
Message-ID: <CAF-GeyPcMcVjoWL74rE3FonPHc77=WeRzSGxXxOC-QvFg-5+ug@mail.gmail.com>
Subject: Greetings and articulate salutations.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=ADVANCE_FEE_5_NEW,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTTO_DEPT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:234 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sanogokwe[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 LOTTO_DEPT Claims Department
        *  0.8 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I bestow upon you a serendipitous and euphoric afternoon, With due
respect to your personality and much sincerity of this purpose, I make
this contact with you believing that you can be of great assistance to
me. I'm Mr. Muskwe Sanogo,  I'm the Chairman of FOREIGN PAYMENTS
CONTRACT AWARD COMMITTEE and also I currently hold the post of
Internal Audit Manager of our bank, Please see this as a confidential
message and do not reveal it to another person because it=E2=80=99s a top
secret.

It may surprise you to receive this letter from me, since there has
been no previous correspondence between us.  I will also like to make
it clear here that l know that the internet has been grossly abused by
criminal minded people making it difficult for people with genuine
intention to correspond and exchange views without skepticism.

We are imposition to reclaim and inherit the sum of US $(28,850,000
Million ) without any trouble, from a dormant account which remains
unclaimed since 10 years the owner died. This is a U.S Dollars account
and the beneficiary died without trace of his family to claim the
fund.

Upon my personal audit investigation into the details of the account,
I find out that the deceased is a foreigner, which makes it possible
for you as a foreigner no matter your country to lay claim on the
balance as the Foreign Business Partner or Extended Relative to the
deceased, provided you are not from here.

Your integrity and trustworthiness will make us succeed without any
risk. Please if you think that the amount is too much to be
transferred into your account, you have the right to ask our bank to
transfer the fund into your account bit by bit after approval or you
double the account. Once this fund is transferred into your account,
we will share the fund accordingly. 45%, for you, 45%, for me, 5%, had
been mapped out for the expense made in this transaction, 5% as a free
will donation to charity and motherless babies homes in both our
countries as sign of breakthrough and more blessings.


If you are interested to help without disappointment or breach of
trust, reply me, so that I will guide you on the proper banking
guidelines to follow for the claim. After the transfer, I will fly to
your country for sharing of funds according to our agreement.

Assurance: Note that this transaction will never in any way harm or
foiled your good post or reputation in your country, because
everything will follow legal process.

I am looking forward to hear from you soonest.
Yours faithfully,
Mr. Muskwe Sanogo
