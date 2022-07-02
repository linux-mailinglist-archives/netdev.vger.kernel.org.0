Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA595563EEB
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiGBHjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 03:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiGBHjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 03:39:47 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC7E1F602
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 00:39:46 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id t24so7356102lfr.4
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 00:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=PvPeZNSjmbUt3g4rxRetUVDhzEwblDzwMLQqhjF3auw=;
        b=RJ9jgHsFVDCoBmIG78wAmo4p+Hso/AfJzr5OAO6D4RMIKLQzEDN6w7VvspJG+ntpxY
         wcMP+HfWIowhhWpMwxmFwH7DggmcsR20iw0ke86aP0vO54SxEfkZM2chsTNPuZzdxAn5
         Ynm/I4nn8p2uwu0mWm0y198gPlZ324WFa7/N2epPhXRVXP9DW49jaZSb0fRLyxgcQ38P
         XUkfdm457qohH3OO1UhYhs2uBSZkL4YN8sK/i2FhFpudPj2tKzpzTjW7zBsYSKOyMhcq
         babv8fqsZMIxT1H9JptfMNTSiNdmXgjgalF5JVqQd/lksRTaHhhqhElSz8bAmYt0wYVg
         j7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=PvPeZNSjmbUt3g4rxRetUVDhzEwblDzwMLQqhjF3auw=;
        b=vT/u9gPKZyyRhcgW4TdZke5k2iTXEDQ3tToLqXUVr3flJrkEMKzBeHm+QaEnLiv6pI
         naHXKOST4sIHmESOVhbX3r3yE2dys9INvsDZUltnpGHV2K93o1Daw8Qn6JXBHKqiJ+qy
         Ys5YmY3NLmjXB53S2Tj41UgHJHvl9HC7T2I5U7eokcWrLzM9MyuxfJT2i23MbfL+BIWc
         iPnFRQgIwKjEia9o3yWLx+r9EH6ObX4KqCYe/S26a6FLlr3K8d3wWRfK1lLwSi6pqFzD
         GLoohSouHXPEKp/oKr3rPtOP80xZLZMUPZc/HQeMlIMb+0wfACSLKspZtBew1hNfwY8b
         wJEg==
X-Gm-Message-State: AJIora9oz+2JfOtkHxJQS1dGqNpl+irlA+TGu5whFGjFjnKIVYhTyO8r
        /4IkkdQ4/ZLWifySFAD/hA7OtVe6z66ylEJlumg=
X-Google-Smtp-Source: AGRyM1tAb54b2aqbx1Pj4/VccFKYYFhALtqIP23sEa07NUoFQ7IkfTMKLZwO8kclyPjoZBBol1paMov44ShdQmq5QOE=
X-Received: by 2002:a05:6512:1324:b0:47f:bda5:408 with SMTP id
 x36-20020a056512132400b0047fbda50408mr11740425lfu.649.1656747584519; Sat, 02
 Jul 2022 00:39:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:3e10:0:0:0:0 with HTTP; Sat, 2 Jul 2022 00:39:44
 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   sgtkayla manthey <sgtkaylam20@gmail.com>
Date:   Sat, 2 Jul 2022 01:39:44 -0600
Message-ID: <CA+RGHE8Ct0MG2+8A0V7NnckDSoTrP35Gg=2R8g39K0oTJq0-xQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
pozdrav,
Molim vas jeste li primili moju prethodnu poruku? napi=C5=A1i mi
