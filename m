Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6187F4AD7F7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351191AbiBHLyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343656AbiBHLyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 06:54:31 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C612C03FEC9
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 03:54:31 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id q204so20741838iod.8
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 03:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=JdLO1uGo1qKTqjwgdMPQCSFxSj8GdFFunMUYAZzBTanhX/Ki7vobKKFGlXs4+mSTXY
         pA5V2CPEyaltfrQ2TIs8Q+kC3KkzsPPI2ETcNsCLMWVp33NGyJU31pK8f9j0KVDYhagK
         OG7Ng/9Lish/gplpBDQaIRmgtq1dNcCGzAE/8koOAGXIn907SqUxrq/Eub9raET9hEpX
         oQLVNct++K6pxeOBC2AtIR3OHRjpTv8+g6JXnP/QG6CQ0Lf/53ZuXCg7RLY8fIOQ/oDQ
         wyDPtvlJswSN8McYwJrKFXCDH8d4wdpGm4htjDzuz2DU8vLW6Da8GoxoA1149T/rIJXr
         jf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=2LalEleIJSmHogCDOK+zcQE9uPWXSe6kBKQoa9MGlTQIMFL4BPGVqD9241mp6ZetJj
         NDELO+9L9agoZnZWp7Eh1r6iafR9dFY1pwx9KOONa8bxc6Ld66738VGYyIPq6YmnGBwD
         4hrSvjDQfNNf8Rbel5RmbyRx8XVUdIkI7x13B18OZPoPyqa5Z6A5GbBN/cglGeg1avDE
         rLw8zguYKBrFEvY6HH4p+tHvbepErTwzOf8UeNYd2Vw3ADWCfy8s56G3hwdxvRmLSqTn
         ppJczDmj70gh7e5x8pKiJ33bQ6+3pvEFQ4B4XNV3Ej1I56ITU1idduRHjZ70sqKSWoQP
         fcKA==
X-Gm-Message-State: AOAM533dfYecwQ+OK3BlB42lqhlhVzTh9Cf3ls2efXwgfl+l7WTsLV8v
        ZHIBCFbViCCykS/Nn5HQld2iJxjJp5yXK45gh1k=
X-Google-Smtp-Source: ABdhPJywql1hPmq1wXqjwi5uq7u6q8RN0O5Q8qlHAUR3fo0AA7+uCQtCrT18t1Tl7BqvnIuLnj1UBay6BJXLaE25KHM=
X-Received: by 2002:a6b:d90c:: with SMTP id r12mr1848593ioc.99.1644321270290;
 Tue, 08 Feb 2022 03:54:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: aliwat885@gmail.com
Received: by 2002:a05:6638:1ef:0:0:0:0 with HTTP; Tue, 8 Feb 2022 03:54:29
 -0800 (PST)
From:   Zahiri Keen <zahirikeen2@gmail.com>
Date:   Tue, 8 Feb 2022 11:54:29 +0000
X-Google-Sender-Auth: gF58IWijgIDvRmFofVXwQc4q33E
Message-ID: <CAA2insLs4Ezv=aPjagsKiunVEcra-6x0rEs9FjKPFGGnp_2Oig@mail.gmail.com>
Subject: Greetings to you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4937]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aliwat885[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [zahirikeen2[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
