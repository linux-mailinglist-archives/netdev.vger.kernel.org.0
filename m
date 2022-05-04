Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB57519FA3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349627AbiEDMiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349665AbiEDMhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:37:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE46326F5;
        Wed,  4 May 2022 05:34:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j15so1839647wrb.2;
        Wed, 04 May 2022 05:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=tnWNyhQSjbSW1ZO8S+jLwuWc52C1vg2ZYoLqEkg9VVo=;
        b=M5eQHUad9vyWBqzWqb8052I0MGQDeeCATC1x07l/Fd4Om2nrRiHnqmohNoizAI2YR+
         HWJTBNraJVptSh9KgpZRiAwSJEYTTA3ju2dCW/LalVaBQLhcXHz6BIl2NnxJwF394CTK
         vvJOLNYuf10rAIKiuZ7n7gitS5Q3MCx7GOlrqrAD79f15xZMxVv+bJi6iHI9/kmFVCo/
         gO2hGhNctwqewJxOtV4AJUq3yA4aICQWTCQ0xWGifAW8hBTi6NfztJuZI30dM4KvXxXT
         esnDgqZQVwsFPhr2izwTli+CqK7mwADZ40FGZBnP5KgCjGN/5OevMzxOA4gw7UuOaIHy
         cEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=tnWNyhQSjbSW1ZO8S+jLwuWc52C1vg2ZYoLqEkg9VVo=;
        b=0lwJZC9fi4yz0YiqDPT2Mj2k+IesumyPpYEMa40zHtZ85FmCC9xUjFrNVLqt6DuvjA
         YCPvI+X4Qh4SQSZYJMXp8og1SEsAx/+W3O6fBXTS9YrRkqtWiOGmuJ5k/pYFViq/VxkY
         0lACk+yK96Cg2jEtG+aRwnFcYYX7ANqOtgavMQf9g9ZNboADIkGXBVatV1V6rH8hInoV
         3NS0ESCqtVp45e1+8VX0gQkRaLvvzUIkc4b1IXzliNtDm2BUrGWgtnY2BqudmUPoyht6
         8Sn5bC/XnQnx5wCMuS93lIoJq0jwMNsoCHDb9njusMkLO7Us2ZHW3ZcVB0PP2fpvQRY2
         jVxg==
X-Gm-Message-State: AOAM532PBqwUMK9fquTRuvx9YfX1rGLfgqyYp0p67s3TyyzHSUhQ6bYO
        9vlTO4WNLYzvSOEC7uEavd8=
X-Google-Smtp-Source: ABdhPJwn+yH2ogKzQg2HjPyx/pZwvP9viOZjAnfOnSDjNY7Y7PLeRD8hY2+ZTAxhFAvmdF2NgQw2SA==
X-Received: by 2002:a5d:64e6:0:b0:20c:4f23:96fc with SMTP id g6-20020a5d64e6000000b0020c4f2396fcmr16511038wri.154.1651667648470;
        Wed, 04 May 2022 05:34:08 -0700 (PDT)
Received: from [192.168.0.104] ([212.154.23.44])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c460600b003942a244ed6sm3698856wmo.27.2022.05.04.05.33.55
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 04 May 2022 05:34:06 -0700 (PDT)
Message-ID: <627272be.1c69fb81.1f7a9.6539@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re:
To:     Recipients <henrydacciani0@gmail.com>
From:   "LAWRENCE A. BIDDENBACK" <henrydacciani0@gmail.com>
Date:   Wed, 04 May 2022 20:33:48 +0800
Reply-To: lawrence_biddenback@hotmail.com
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attn: Sir/Madam

I hope this E-mail reaches you in good health. I'm Lawrence A, an Entrepren=
eur, Venture Capitalist & Private Lender. I represent a group of Ultra High=
 Net Worth Donors worldwide. Kindly let me know if you can be trusted to di=
stribute charitable items which includes Cash, Food Items and Clothing in y=
our area.
 =

Thank you.
Lawrence.
