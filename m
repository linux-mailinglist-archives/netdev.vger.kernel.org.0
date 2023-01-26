Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669F367D4AB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjAZSva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjAZSv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:51:29 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C373EFC6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:51:28 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id i38so956202vkd.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yno+jRNb4Nt0Og6fA8XW99Cds0X/y0wrCCK0aOHBoRI=;
        b=SCr93ilYxAZswj3sLWNsirI9XWF4X7C0WYG/bfnos+DsTX0/Bl6VtdEoTwyZosrZA5
         gc23R/L6x8NbpGQnmDkxOj32j8d/Ijtdz5m9DsU2fLTJZtl1Jenl+BO+pW6dIl7bFNmq
         FRyDp3KigNszYgkr1eCVp8rSvZF2Hn41ZTfqLefkzjBRQD+QG4xYAbnJTQxsi5dcB3Ze
         GYTs1dVbnHAHAOd2jZSpwNWpCrar5huEufYscfYIVzCwm8CY0dibiLAnoTGby8kfk+NB
         /b0CJsh22wIe+s74fcvtziroqAvEfmJrg4PUvWFD8ojiHGr2TYSSGKWGMI7+Wj3Si8e4
         0bQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yno+jRNb4Nt0Og6fA8XW99Cds0X/y0wrCCK0aOHBoRI=;
        b=Q4frWjBcoVyzWJfW8KSMOGixe/xOFyJMaIHHU5A2T/G2miJxW/6rFPgWmrwaG8ejAn
         UshOFio35WQkfGjbsVOJF2kMCPsPRFh69Q6X9uE6WgMxZt1j94Vu/tq7Scr+S8q39fNR
         9ySLbI1PdzLrpze7M//p1oDPiA9WO7si2m4+hPIwt+8RIJKIcx5OiGlIbYWRnN93aSb/
         AahrcRscipeBMdIkc/bBmEa0cXR82V1hXWwV/XZC8+T5OQ7o8M0lfrTw5elkxwfqepZ7
         VRPYmV+Meje1DrVPCnNFArm+jKm480P7+1+r1pmu2c9fNRnYn8kdbXl1BJSf0Ims09Cu
         MJ2A==
X-Gm-Message-State: AO0yUKXO55Y0dJ5w0eSbkKT+Y/hP27UqmO3S2XVkHh11XKqUl8M1yI2d
        iAoekxEhXUoRlmHxX2K9o4kavW70tYSJ1zhbZbY=
X-Google-Smtp-Source: AK7set9MHDgAXYuISL/4y9z9BHB3fGL6rvPq646ZjyaGn2Ctf+pufGAsm8F+pc+86zQBJgRpf6hPZwsm3f0VjsKccbg=
X-Received: by 2002:a1f:45d4:0:b0:3e5:c3be:da45 with SMTP id
 s203-20020a1f45d4000000b003e5c3beda45mr928744vka.37.1674759087638; Thu, 26
 Jan 2023 10:51:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:c966:0:b0:396:419c:b9ab with HTTP; Thu, 26 Jan 2023
 10:51:27 -0800 (PST)
Reply-To: engr.fred_martins@aol.com
From:   "Fred Martins." <sdo185325@gmail.com>
Date:   Thu, 26 Jan 2023 10:51:27 -0800
Message-ID: <CAKum-LtAhyV2Cgx_0T7kW2ZjP4JmZFten7G9WLfdkLKzuzMd-A@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2f listed in]
        [list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9649]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdo185325[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sdo185325[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I wonder why you continue neglecting my emails. Please, acknowledge
the receipt of this message in reference to the subject above as I
intend to send to you the details of the mail. Sometimes, try to check
your spam box because most of these correspondences fall out sometimes
in SPAM folder you can also add me on WhatsApp (+24107078133)
.

Best regards,
