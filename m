Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC92DA4C8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407769AbfJQEfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:35:15 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:38363 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfJQEfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:35:14 -0400
Received: by mail-lj1-f179.google.com with SMTP id b20so1002653ljj.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 21:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VPJ3mB1608R95JC5YBNUbRQf229THbYCXOvrZeVCJxw=;
        b=gQGt0QCvUpHV7tFycMYL4ozwWeBDfM2e8OQvC/Hz24R2xf/lal/vBX0QMT/DACCZE1
         UwxN2vHYr/COwwJew2gutIs6YYp8UbA+2jS+YiQasW0pnQg1ok+DgOq3Pt5Rpy/9pNCf
         jLhMsBCKJuEjsrcr/OiTsvaHfl6NJWnwYq6GMgbD3L3+rBnQ3zdppnNns4N1hgC62HBr
         TW2Qxx3mEL9zqXenX9QcRIpTOW9IYN/htzyei5+sSzq2ONQnfpN/B5b5lL+Ocmz9l1vx
         Xt758BSdgx4uXh/w/dt2FXunn2nlXZjThV8PHbIfrYq9MLdwqtyCZKXUSis4QqJEhqbF
         /GIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VPJ3mB1608R95JC5YBNUbRQf229THbYCXOvrZeVCJxw=;
        b=GphAIdD3cBEcSsnqEy36441Vq/rdByqijBdmuEntKdIVtdP1BARR6hBdCj81MjDDOj
         CscEWk+E2p+gZbgIk4JnP5w2Ka72Nt8zPTrvqrpFbyN4Lv9UGY7EQ5aRY7LVneGXBs2o
         TgfywKml4eKEn3V1bkqmC/A797x17zyDxBCfFGy6vjTMwjZFXly1u98QNjlr4h/1w+Va
         krYuvYv/4kA0nSPKAQRLAiLBvnZ41NnMSk6qRYyfQ42GqZys0FKzmgUE9uRSfdxyzUQQ
         VoDybl1GahC3DS7t63aKREXdQEVzKHCpCvFEXIj1ICztz+letj7rfktfIiQMM28vwf/J
         w9gQ==
X-Gm-Message-State: APjAAAWqmZftpkYLC5hpROTT4q6t4A2BHp23HoER7IIQdePPcQVVBWgy
        rmYQkE4IM7APFokEYQh9XWFdGBRhTb/H8DJJBgckgqe6
X-Google-Smtp-Source: APXvYqyALhbJx9V7Fz5/KaUM6k05Rx4MH/Zi1sqYUs7/GZKuYFbL19GrRkJztGEY1+jwY/avOGmjsrJwi1WaWWcllZ8=
X-Received: by 2002:a2e:934e:: with SMTP id m14mr1020009ljh.0.1571286912655;
 Wed, 16 Oct 2019 21:35:12 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 16 Oct 2019 21:35:02 -0700
Message-ID: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
Subject: Bunch of compiler warning fixes for ethtool.
To:     Linux NetDev <netdev@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You can merge them via:
  git fetch https://github.com/zenczykowski/ethtool.git fix-warnings
  git merge FETCH_HEAD

and I'll follow up this email with the full set.
