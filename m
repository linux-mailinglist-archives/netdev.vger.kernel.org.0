Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E421170C3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLIPoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:44:11 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40952 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfLIPoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:44:10 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so7427599pfh.7
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 07:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=tbzTbeyl/8XwN3k52wr3eg/VqZSynTDuhwz1EazujQE=;
        b=ouL9ziqHztYQ2UpDCT/bVS8K1ptjYZFw9PPKKBhQt1RjUzok6fFzYeW1+zsiHcYv7r
         ONS587OIBdgdJ2f7lT+t82WR/7WyomxX3/wOFP+whu9RjYM1E7uyTaZGKO5fXHi7my4i
         wSdWpFnZ+QjZk8kl8jOWZ1irHTUdW6QeKpA9N2b8crZeONmevD0gAcuSu/DOQMHKvqjW
         zs0YpfwKkhgommozi6lKbdTDp0mxBXg/ybRA0/9pHJP8Btc9p/0DkjO5EFnkkvNU4KID
         bDFS+tsKDNp0NEYtwduXWn4Gc6jcWJXReXEKn3hudxuyNEYLP5Tpr2jBqItdIC8zvG8q
         SWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=tbzTbeyl/8XwN3k52wr3eg/VqZSynTDuhwz1EazujQE=;
        b=VStV+HGRBGXydaxFHK07gyzfkYoz7+aO0l2Ctrl8Xceew7UQUs5PRl6icjVATU1So/
         qw4jAb4rI9dn64ffmfEgNxHj3G+QdxzMp4DsVJFLi8CgB7waDApMzm9/CQfRBdyGcxwC
         8hOtvP4qtLnW/UaKRCAGg5EVgP03ZJ820jP/qOHa2uM+Q+R/LQ8I3qyqr8zB9ht8fQWk
         qIR6i5R0Hs+0l9y9bdimaF/ZhMUvfJ1XF9ChO+/JSWWRJyp9oU1x9OGVtr3OblRGWq/6
         6bv4ipCFgvDgkh6QWPjrYdbYzKQUoshyu/zgts+keMko5nUwUfFrHbCHjc/UcWEWyr7R
         Ajmw==
X-Gm-Message-State: APjAAAVi6d2qkOhAjdvooHfq/m29xuWfVMY5eNa/2kcHfSBSIlxht2B6
        u5dAZSnKrmiTtyz4wCrL8Ve1V6V5Ie3YyRIuMk8=
X-Google-Smtp-Source: APXvYqz7yt2SLsE0vyKW34uDb0J2xsQUBB6tnyvYKwwzYenUwuGoJeBFE9Qu/j0+P9cg+2BzJVxMacecRSeULdxXkbo=
X-Received: by 2002:a62:7a8d:: with SMTP id v135mr30096877pfc.217.1575906249656;
 Mon, 09 Dec 2019 07:44:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:77c2:0:0:0:0 with HTTP; Mon, 9 Dec 2019 07:44:09
 -0800 (PST)
Reply-To: edimjoy39@gmail.com
From:   Joy Edim <samueldaniel15000@gmail.com>
Date:   Mon, 9 Dec 2019 07:44:09 -0800
Message-ID: <CAFvXjvcmOBRZtAhwy07Xtp1b+03hWrUSrNZ-hL+Dizkbg3j=9g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hei, det er noe jeg vil diskutere med deg. Kan vi snakke?
