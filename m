Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104CA65CD86
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjADHPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbjADHPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:15:45 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61657178AA
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:15:44 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 7so21674316pga.1
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 23:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dlc-ui-edu-ng.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh8EDekJmhMLShCyWmCdcD6wys81NqC9ot9tSgw4w5o=;
        b=IRz3Cj5OAAupp8dEpn2rKhSM1BpwouMmYDywnfUHdoNfKmqAxnmVZqAbftXs24eq1W
         nVNk1B77PWdmOMiQpxSbARhYndqW3BxZG3EWCoE/Aq0R91J/AX0fh1Bpw+ripwiDKQxM
         /cYBradDORsIyQM1OeBd9/4T6QnzAeKohkt10TbckqEotwUkEdfOS4CixZcceWVhkpM2
         2+lqD8M9WCGKe21aG82pyuAcPjhaSDzmgwNBT0tRnQHyaDWSgLiszm+DRyf2a/aAw4YK
         2lbScR5PeCuk5t0et1p6XawPxgz80eMPoPCNUiz+0oZ2wP6KZ4YbttFErwSMGzMa6B+8
         EboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nh8EDekJmhMLShCyWmCdcD6wys81NqC9ot9tSgw4w5o=;
        b=lbSrYFDuQOAAQDCexhD9Hov9Si2Mwg6d6JpDpcjia0rYY70nLLzMaTEeg3A8DHCvur
         dj6SsyIu46tjTjYNk9iRRNq86WTk5ojVF9kL/N3nUNwr2i8r6VJAVPgMebYHpxtFW9di
         hor5t+2z+/OVmo8eUH5Dp6VDYE/BLAiOhYs9BXlrpNFJwYHxzn0B8hs96lvhp2cD6PVL
         miKYCO5dbGcC/VgllAUwnpOzXUPQnQlvyPdY/KnJFO8EmD+2U8X3NABO2Fa3wXz39w1Q
         AQ1eN3E8ifubs74cRJ79H+sFjYbM5O0MBS+wj8wT7XI+ON13WgPmlCeQ36jT/OGzedhq
         C4Gg==
X-Gm-Message-State: AFqh2kq5keZN39U07nmD9I3wMqSQgGPsVPpyKk2PXnbxx8tmwvZLqnEy
        3lmiiptUFioWQEREETFuGvMDqYJbEj0heHfWYnkO26O4sgdHcii/XAyh+Q6ZQmF6MbkWWdkjc15
        xnLfjaEnrgDna2HHsy4iLZTDvhw==
X-Google-Smtp-Source: AMrXdXuhXIUyqMeTVBZ20TtY+O2w05lrcgmhUmlgKkQbKuM/QJLwq3QGZwFT4gRTYCYH4K3l11HiBy6b6C1achmZZf0=
X-Received: by 2002:a63:fe06:0:b0:492:23d5:1e3a with SMTP id
 p6-20020a63fe06000000b0049223d51e3amr2655520pgh.386.1672816543679; Tue, 03
 Jan 2023 23:15:43 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e212:b0:381:f7c0:aa2 with HTTP; Tue, 3 Jan 2023
 23:15:42 -0800 (PST)
Reply-To: cilimajeannette8@gmail.com
From:   Jeannette Chilima <e019361.aizojie@dlc.ui.edu.ng>
Date:   Wed, 4 Jan 2023 07:15:42 +0000
Message-ID: <CAJAErSpnEKLZFeBhOSdE42-FoJM4yW_bu5ntjg3=dUGTXd2Kxw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

How are you,I hope you are doing well,My name is Jeannette Chilima a
lovely girl and i believe we can get acquainted, so if it interests
you, please reach me back here for further communications. I stop here
awaiting your respond.

Regards
Jeannette Chilima

Please contact me direct to my email address for me to send you my
pictures and further communications.

--=20



UNIVERSITY OF IBADAN COMMENCES ADMISSION INTO ITS OPEN DISTANCE LEARNING=20
PROGRAMME FOR THE 2021/2022 ACADEMIC SESSION

In a bid to increase access=20
to the UI , the General Public should be informed that suitably qualified=
=20
candidates can now apply for admission into University of Ibadan through=20
the Open Distance Learning mode for the 2021/2022 Academic Session at:

**=20
<https://modeofstudy.ui.edu.ng>*https://modeofstudy.ui.edu.ng
*
For=20
enquires and support, WhatsApp/Call: Nike: +234 810 481 2619, Kehinde: +234=
=20
816 204 3939


--=20
This email and any attachments are confidential and may also be privileged.=
=20
If you are not the addressee, do not disclose, copy, circulate or in any=20
other way use or rely on the information contained in this email or any=20
attachments. If received in error, notify the sender immediately and delete=
=20
this email and any attachments from your system. Emails cannot be=20
guaranteed to be secure or error free as the message and any attachments=20
could be intercepted, corrupted, lost, delayed, incomplete or amended.=C2=
=A0*The=20
University of Ibadan, Distance Learning Centre* <http://dlc.ui.edu.ng/>=C2=
=A0and=20
its subsidiaries do not accept liability for any damage caused by this=20
email or any attachments.Any view(s) or opinion(s) expressed in this e-mail=
=20
are those of the sender and do not necessarily coincide with those of the=
=20
organisation.
Please consider the environment before printing this e-mail!
