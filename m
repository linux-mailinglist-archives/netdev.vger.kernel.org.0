Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20336392F0
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 01:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiKZA5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 19:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiKZA5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 19:57:42 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1433DBE1F
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 16:57:37 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id e141so6856595ybh.3
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 16:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q5grRhzDgJlRek3REBN4Xq7JrHQXLu+Ef9bolVS8SjU=;
        b=Ufz5OfqUDUfIMirCxKDWO43DsvsWJ1oqgdKiZqPgRv09/28rIfFZ8NpiMyOBAdFfDY
         B8yvK1RQUH9Ebvvk2MVUx86PZbthLozMz838jG+v7t+9uGrdXfcxd6XcgBY+I5c873Ob
         jkaJK5TUq3KAkLgANnlDW2Knz5IHPIlbb8PNnlNoSREu77RNOVhotvmHTX2Tgzkrr2a8
         iiJjpfS67idZLDxMDpsmWTRRcfEfwOe1B0ftQbzu/d0DZQaDTj0YgylflaV2Hxn59Cou
         pUnGNPh+qOlU6yLT+A0FtSoOj40MxxYN0GUJPjZf1TqNEkxjTMs8WNlv6+sDxG6O7VuP
         4A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q5grRhzDgJlRek3REBN4Xq7JrHQXLu+Ef9bolVS8SjU=;
        b=RJOw+ybLdyAHxfqKJG/TzJsD/Vi/+Y7wzi9v/kRMqPYFTY9BVM0XU9yPLaDB2MHl3b
         rQ38fPDkCV8Bn19qDWpZeA853JMsQ1qs1r2exa9zw7MJZjsYLtU02k7ipJoWw8DJ0Dlu
         +O7+YQQLqGB3AR7MKQaU2qccODrfYjULqQDtL9pN9mcHBkQIUhzz50bcfB6T0sPyyRf1
         OaK0UHFFFv4p9QA586/YESoc/fwLGj2JhFAHokE4LZQWPFdS1iXGRtungWzi4zQ0kCif
         mhvZA3PkLx1ExPy3VUtZqAEMFThPDTgOSiqQdtM6FkKtI9KrEc6tl/8MWrQSFK2A/y1d
         R7Lg==
X-Gm-Message-State: ANoB5pmlY8P0qtPTx1eqrYl409Q+volH/6vBFg2IcCEMWFdaMxsvOUf3
        3SF+6DQxmF9/nHplEdI5UFW3TQpClyhNranBGsM=
X-Google-Smtp-Source: AA0mqf6lAacFzYg3rIKz88ZN9fz5psMu5sgcyTlmAeyetZlj8b1eQziZRWikEH87SQUtf+l4ujBBB6NnUcCQqEJwA0Q=
X-Received: by 2002:a25:8b85:0:b0:6dd:a4b9:442b with SMTP id
 j5-20020a258b85000000b006dda4b9442bmr39162129ybl.410.1669424256283; Fri, 25
 Nov 2022 16:57:36 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6918:6b07:b0:ef:f5dc:12ae with HTTP; Fri, 25 Nov 2022
 16:57:36 -0800 (PST)
Reply-To: samsonvichisunday@gmail.com
From:   Pastor Experience <experiencepastor@gmail.com>
Date:   Sat, 26 Nov 2022 01:57:36 +0100
Message-ID: <CAKLjfSFh+DHRDgnGeSxTCjXLebTcQtJPaciQV_x-f-sMEULaFA@mail.gmail.com>
Subject: INVITATION TO THE GREAT ILLUMINATI SOCIETY.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_LOAN,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [experiencepastor[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 T_FILL_THIS_FORM_LOAN Answer loan question(s)
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
INVITATION TO THE GREAT ILLUMINATI SOCIETY
CONGRATULATIONS TO YOU....
You have been chosen among the people given the opportunity this
November to become rich and popular by joining the Great ILLUMINATI.
This is an open invitation for you to become part of the world's
biggest conglomerate and reach the peak of your career. a worthy goal
and motivation to reach those upper layers of the pyramid to become
one among the most Successful, Richest, Famous, Celebrated, Powerful
and most decorated Personalities in the World???
If you are interested, please respond to this message now with =E2=80=9CI
ACCEPT" and fill the below details to get the step to join the
Illuminati.
KINDLY FILL BELOW DETAILS AND RETURN NOW.....
Full names: ....................
Your Country: .................
State/ City: .............
Age: ....................
Marital status: ....................
Occupation: ....................
Monthly income: ....................
WhatsApp Number: ......
Postal Code: .....
Home / House Address: .....
For direct Whats-App Messages : + 356 7795 1054
Email : samsonvichisunday@gmail.com
NOTE: That you are not forced to join us, it is on your decision to
become part of the world's biggest conglomerate and reach the peak of
your career.
Distance is not a barrier.
