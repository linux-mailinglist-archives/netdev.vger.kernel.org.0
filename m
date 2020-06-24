Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49038207633
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390826AbgFXO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389187AbgFXO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:59:13 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A04C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 07:59:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n24so2881629lji.10
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 07:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=QArRHYy5bCPjzM+HJWRUBN59qgGdN2Oy8/mnHa5kgyA=;
        b=JYy2U8EUkB7545+oRI8ngjpJIug5nTraw1kcahXKOzbuRckuFW7EmQ6Lo7YFYvQhjb
         d9W4shz5uU2GIvi0+pNao6cHn/6HgIaBZJQ7Te65lqrbiGbsUYgJS3STCQr3P4uLqjr9
         3Vb5UwiHiba51AwTw0p9oM7a58pLt5jSpAfGs1Ntwt0RGy7sAjixfy6kdUQTKyBklpgu
         DzlK2KgipLu/jC9PN/fIrACLjcANiVXJC14xxlMutTr5/VAvaA9nL33y16gRZGyZYtVf
         XMTje57z3if7jL600BgNYyr3KIS8lFuc04HxR2Jd9p0F8R8XFDnIrC2KsKeTEmUC0I2A
         0yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QArRHYy5bCPjzM+HJWRUBN59qgGdN2Oy8/mnHa5kgyA=;
        b=b7viJL3R9sp5HEfcSC+Nz9sAqv1blAbEqpTC4+07R2N4nGEagKMdRJfQGpSPrJ/vqc
         Tt8WIhyaclEwhzjsRW93r896Ye1ab7irE1zuMziQ0MeaZUXE5i7JH6KCbHIdcC91hFyi
         CPfSc0TGpdQaqS4rAHwCiwY86NLiN5YJejdM1q9RLS+vOzsRDbrJojFxg38cIoNEdbWQ
         dKiFiGMB01V25WvLrMzECIV4gHJ09JlFw0sO2OsSFZDVL8xFzxUXxiUrpQqygOHV4wV0
         UW0xdUwPFqG33M4wqCBHDOPnXx+eb2OXF6k/sv13jcddpIcxdOdP8dskR08clOcyJEol
         pH1w==
X-Gm-Message-State: AOAM533d+ESk/oDV2ZBDqSJryeN6jPVnqdp9HTruwFS6dbaFmTafCmMW
        ukC0nJ2wGJJph1EXmswnyEqkjefp83m5mdWMLiyDyOcJbXs=
X-Google-Smtp-Source: ABdhPJxYJix7JVbynRYR1Be1Q92EqMLJogUKJozxsTAQ3bsvGFyzlzCsUcnbFu5NBJNxIJn4ioQcn4t2QVlNemdUcO4=
X-Received: by 2002:a2e:6c17:: with SMTP id h23mr14668892ljc.48.1593010751141;
 Wed, 24 Jun 2020 07:59:11 -0700 (PDT)
MIME-Version: 1.0
From:   Matheus Rodrigues <matheusrk800@gmail.com>
Date:   Wed, 24 Jun 2020 11:59:00 -0300
Message-ID: <CAGNm9V9igWmDwV8fNQhvVTS0hJnBox40BWtqUV0sR3e6=QJs5g@mail.gmail.com>
Subject: Generic Netlink multipart messages
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to send a relatively "big" string (+/- 60Kb) through
generic netlink, for this, I know that I've to use the multipart
mechanism offered by the API, using the flags NLM_F_MULTI and
NLMSG_DONE, but I don't know how to implement it, there is some
example which breaks the string in various packages and send it to
kernel? I looked a lot for some example but I didn't find any that
does this. If there is none, so how do I do that using only the
mechanism offered by libnl and generic netlink?
