Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71D443A64C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhJYWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhJYWGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:06:31 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F610C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:04:08 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id z24so11700849qtv.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=PWmLgUUUIEpm43pJPQUHS3z3qqZFxLkrBTS877KAD78=;
        b=LuqDcbd8H7qkopzr1USIK1akm3Yd5d4jB9T0sLzmEu1HSOx58p/VM6UJBY8IbXxYVN
         qvtsEhATKck6w6Y8HkDdwrvlMgw0c/2SQnRKhkJ3WGG+FqUETDumP4KkLrMoVw4ifI/H
         cW1znoaQ3ZDiNxpy5XByJhUGOf3+XbfZr9F7QSIj7A0HGk5HdQNAJjR+YeBJEWpVxejb
         0ELctdm3eN8T3q47O15sCHDKog2fmFrUPy/gRW5pdobpOHVUdVlOAQsA6xMbU0nuooaE
         1/OcjtgqpMqvbOD7qVkZOfNV0Ms6bQUFvoAfTpJ+qLCXT/qMJYww2cntO0OzrGenv63k
         b7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PWmLgUUUIEpm43pJPQUHS3z3qqZFxLkrBTS877KAD78=;
        b=wmNfGc3gkmKner0HFeW71+r4hlTj8r5oHrUr70ciNZPaz/stAb/nIb3zxnBxj1rzqc
         F6LrkWHQNY8xMocig4nxw+1whkuRVvagVckH0kitpui2KvXzwEs2nsvYXPFICIZivqU4
         faJKQgXP4fsXz1mLrQZU5trCdb/GB3TZTbPT5UGUJc3EJ7u7bRv1Up4bLTGcP5PRtkb1
         VNpbCyi8JzgRtpLEPk+okQlVRt189yy+EjZi2UQS7UdFXjoI90OjRenbrKe8lR+JSCL/
         CEBUefxlhVJ2/NfrTca89jjxCYkmChnMaKcC/OXjaSZiNRz396BFGRTK7O5nIkxbAGzs
         TIFg==
X-Gm-Message-State: AOAM530XGk6qdeHY8srRk1bLfwgLwoStbL/gk4scpJM2p3NjxDQPggH0
        PIJKKH/27e1H0FzABvrIgtasS73VBSuG1NfvrinroBngKwg=
X-Google-Smtp-Source: ABdhPJxQfVEW70Xrc06qM6Or8dbtl9EmIa8p7P+czceY/8Bt8Y/FonkO9SRNf5zBy0taTents9WvzJQd+denR8YQatg=
X-Received: by 2002:a05:622a:285:: with SMTP id z5mr20112711qtw.315.1635199447299;
 Mon, 25 Oct 2021 15:04:07 -0700 (PDT)
MIME-Version: 1.0
From:   Gilberto Ferreira <gilberto.nunes32@gmail.com>
Date:   Mon, 25 Oct 2021 19:03:30 -0300
Message-ID: <CAOKSTBt2ak2BNZ-MvX+2d6gxRk9-sSUeZ8_DmA5gV9Xk=j+ddQ@mail.gmail.com>
Subject: Laptop NIC just run at 100Mbps!
To:     Realtek and the Linux r8168 crew <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there

Why my laptop Acer A515-41G-13U1 which has a giga ethernet realtek
network card just run at 100Mbps even using most recent kernel (AKA
5.14.14-051414)

lspci | grep Ether
01:00.1 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 12)


Thanks
---
Gilberto Nunes Ferreira
(47) 99676-7530 - Whatsapp / Telegram
