Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A43689C7C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjBCPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjBCPBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:01:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA1C9E9C5
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:01:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso4050645wmq.5
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 07:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GE8LRefBbCr+vfDK+OAPRXSUgs+NOR142JeKY5u24zc=;
        b=LbUuH5UEuP73PWC09cXbSfNJFSyI6t9S4ESqcCgGc5OPXRySMU+sNLi8I/4V++dW6G
         nYzmtTXFoLYnxhiPrQedmvb3vRAlNm0CK4MC4f1QUm4o7kHg0G08hgexvGu1KIheWThm
         GO3C9p2nGe1gKjQ0Y18mzrdWysOTqwJ1AtAAHJvBY3mhZZjdihVGpmueNxLDujKROAbf
         iSCYKiFMEysPXBqHaU77/Phn1qTxHiC6N/xa47V/8w7fGvp/5Q8Bxq+Jo4gdxLBe67XT
         E6B8lzbYRTwc2KOZa0vCkyXbUMOYple8fRZs//+ZPR4UDj3yKqk9rXmZdX6YZRBJydZM
         LhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GE8LRefBbCr+vfDK+OAPRXSUgs+NOR142JeKY5u24zc=;
        b=SPHoi3MCSZcya+z6zOzQbbB3mbtA8S4Owez2f/fszk4RmlXCMOfjhXMmFzsXkz4AJl
         aVVVfX5ALipCmQBhoxRKIV5fDGiE2ye8jt7Dty4x2UcE7VUaeZzBwL9u+syyIkQYU7VW
         ycC+GoC662Y1xdQB9VkN73cpl2Jb5yF0qxzsNBBw4HTtMBORQpHWzHU2KQfabqhl/1Ni
         3h8rp62fqGNwlsbs9dQ9y9GCYyBggWIvdCKPHxi4rs8bDvhxyMKvnhWcPV2hx9ONBBtL
         40ZEuyRrx0YWM8RS38Ffw40K7BBEhQWv3q1ACUZms5fJOx50GwG+hHnaLK10IZPpxaHD
         2d6g==
X-Gm-Message-State: AO0yUKU3KXHX1TcfKncWlirYCeU3X8SPl1iO15QDlOKDjiEvqcS+7Wuw
        D0llVkjGZqMY56xem/PZaOjHDGU/mtDJ9RhrxhA=
X-Google-Smtp-Source: AK7set9iq7Mo/y1jkiqffiqvO6SJCmXDHi4KForRc6SZoPnuACIx1SU40kOz2qdLu9XErjm2o4/eHFZvf/wnSysGk5U=
X-Received: by 2002:a05:600c:5569:b0:3df:e1d9:8914 with SMTP id
 ja9-20020a05600c556900b003dfe1d98914mr342946wmb.189.1675436509521; Fri, 03
 Feb 2023 07:01:49 -0800 (PST)
MIME-Version: 1.0
Sender: dareadja5@gmail.com
Received: by 2002:a05:6020:4710:b0:259:ad88:21bb with HTTP; Fri, 3 Feb 2023
 07:01:49 -0800 (PST)
From:   Kayla Manthey <sergeantkayllamanthey@gmail.com>
Date:   Fri, 3 Feb 2023 15:01:49 +0000
X-Google-Sender-Auth: 1eULOAvE87U1QZf6DUFscZpDEUw
Message-ID: <CAE9bZtOYKpCan6Pak0EJYtKswp5F17Tn0S+ax=CRzForRBYL6Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dia duit a st=C3=B3r, an bhfuair t=C3=BA mo theachtaireacht roimhe seo?, Go
raibh maith agat.
