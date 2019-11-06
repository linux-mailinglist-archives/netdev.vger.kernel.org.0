Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDAF1858
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfKFOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:21:55 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45349 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfKFOVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:21:55 -0500
Received: by mail-yw1-f65.google.com with SMTP id j137so3399720ywa.12
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 06:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1Mka2nMQ2b4Zm5LP4QSs3Y3FiZY1RoxduK6aMmKIKc=;
        b=JkhB1bqczystPZjOCAtb3gc6EkzwUgNsrd3y00ug3zg9WUhaiLwGRG4fCJeWXTOeN8
         TPN+agmThKDR3mC31ru/HolTmJIUiNTIFfZ7KS0e3ns29jkHIiK0oEaEZ/839Eb/ayUF
         mi0NrWh1hwyyWUBtYB9G6Rif/UywvxCuk0uqIYNE1aaR2RsUplo8LwRIPTJ1J5m7C3dn
         ND42j7ZXJcqcvJInMBx1UcwsxVmchM7nkR0ikW/mBMOQEfkTuyjLDM6LCZ/kPKZqqVZ1
         dBCQZhIUc3Q6A1u2bEmt2QT1BcOecYVHv3ZOP7ojKDoYuXICAkVg/5XS/lOS4X+JDjzl
         2GYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1Mka2nMQ2b4Zm5LP4QSs3Y3FiZY1RoxduK6aMmKIKc=;
        b=KaTc6xn5fqOoQbbkK2iPT1+c3n/1e+Wh9I+Jt+yxhduOpTwrJQn3ntHliK8Pg4uD02
         CPZ9Q2NryuQNxY+/9Jd59iIU19N+E7YPl0dUZomMvgg+hsb3zTC8cYN+txFhmwC3yFld
         imCcOHTNKh20Oqw9woFBMcxcpvrUI/K+M/w894X3YrJWvGIVEEDju/z4alYHWqnDfZGo
         LexXT58euNij4ZWT1jvruc7v8mVruNrPGe+6YE19cQC0okAFLubEF2NabfzFZhk55sIS
         ESrLcSxMab0MSxRy1WRpQWJJFhGIG9cRIY5Oh3el9SXRIesjkPCNsL4lklE0ospJufus
         RNjg==
X-Gm-Message-State: APjAAAV82H5Tspvgjhu80y34gVnokCuoIs4S7k9B/h6L5ejvRqBy1Jh6
        qp03TmiRSThZ6aU1b1I74NAliy17D96E0RuWCsDlYEc+
X-Google-Smtp-Source: APXvYqyRuOHYPVJG3no43M9JBZNmMao06WHtXvQ7sGLaT07ywQ6euSbMp5BTXqssC/cds4OKMF/t3z3wkvUyRhax40g=
X-Received: by 2002:a81:9115:: with SMTP id i21mr1701819ywg.500.1573050112716;
 Wed, 06 Nov 2019 06:21:52 -0800 (PST)
MIME-Version: 1.0
References: <1572764384-130234-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572764384-130234-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 6 Nov 2019 16:21:41 +0200
Message-ID: <CAJ3xEMhTGUMMpH5UGhWViNcpHS8SkrzmXmQG72dfXMgYznb8cQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: select vport upcall portid drectly
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     ee07b291@gmail.com, pravin shelar <pshelar@ovn.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        dev@openvswitch.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 3:04 PM <xiangxia.m.yue@gmail.com> wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>

drectly --> directly in the commit title
