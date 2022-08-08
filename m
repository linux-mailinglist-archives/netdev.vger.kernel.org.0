Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBEE58C19B
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 04:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbiHHC2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 22:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiHHC2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 22:28:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A33261
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 19:26:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t5so9625535edc.11
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 19:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GyIdygXpERIYq0zhovmgdDSjsG4Trhk4Rphv5GwxReI=;
        b=AcYngUUqMi7z0wcPZMRagIa7PoAdW07wfshuE+kut+yIbRA46gPjQ/fCbemc8jwUUp
         Jfn4n6X/Q36WPgAaHgDst95KQGo5rIP1YQaLajHO/5TjqrXXTKzWIiShxhMvURme/bW/
         E81DkcHa8Ul85tl2ld3wQSC5dZzaZU5uXsBc3RQ1WR3aa1XSX9g2S4XlhBHZZF9NeUET
         RGcyc4IDqZNP9DXUzFbtb84AJkZsasBi4hS2sMGD5gw0NYF8Gi3atnPkxdmzYnDy0Kvv
         Z5GJStchCF7/Qww7gPMDBwMdvaRsSZuSYxzsDSiLTa0ZeT2fbnC5Ext7abySWommIiUt
         DS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=GyIdygXpERIYq0zhovmgdDSjsG4Trhk4Rphv5GwxReI=;
        b=0kNhAW0eSJ3Mo7X9HnsZ3OQGNJ4WRlnHckE9+pF/kjZ6Jj3/PIr9jhYhOqNeTEmKBx
         H8tiETq++Cy72m1qTsp0EIdlOp4pfpHMsULr3jZ4SKB+y1IrhBgCWevCVIgjGnvQns/D
         7tfRmcyWijXV15ofkFzk/qM8OBCPNSHUrnB+BMI0Pz9MFk6rFZUzLszpx70OdFreje0q
         Isw8sTJdrAK4No1KweqvfUJLbc79rANtwl3EOxZAroCafC7lG2pdZJhOMDDqTS9CC6OA
         hNojO4o8u+XOh5LFOosOJdS0b4k34XXOBNJSc4r2w7uK6HoW2K1kt9dYPsVfcLHMPyDq
         mcdQ==
X-Gm-Message-State: ACgBeo0v4MzMTgjsuMgArnJJp++3z+f12YAZU2+6z68q8fVNpO7tVYpi
        9s4FATRnc4DhfxERqpydnKor8bNigsvxd2kn3sM=
X-Google-Smtp-Source: AA6agR49XMxHZZItasZZGlmmpgPSTUdD8og3CjgUIo3nWBbsiSBXhA5rcuKqKX2Keck7ERMr6fJqCCGUbzaswZ7Am5s=
X-Received: by 2002:aa7:d053:0:b0:43d:b75:fd96 with SMTP id
 n19-20020aa7d053000000b0043d0b75fd96mr15946154edo.12.1659925596764; Sun, 07
 Aug 2022 19:26:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:27:b0:20:d56a:d507 with HTTP; Sun, 7 Aug 2022
 19:26:36 -0700 (PDT)
Reply-To: aseanvietnam55@gmail.com
From:   ASEAN VIETNAM <rw49060@gmail.com>
Date:   Mon, 8 Aug 2022 02:26:36 +0000
Message-ID: <CACL3VFMwTqk8RCcJccjiDUs6BtUKziv5Ne6c--NLD5U65zV1Sg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:532 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rw49060[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rw49060[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [aseanvietnam55[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hello,

You have an important message get back to me for more information.

Mr. Le Luong Minh
(Ph=C3=B3 C=E1=BB=A5c Ng=C3=A2n kh=E1=BB=91) Deputy Department of the Treas=
ury
Vietnam.
