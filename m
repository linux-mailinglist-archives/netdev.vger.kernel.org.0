Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F2F248FA7
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHRUkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHRUkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:40:49 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B55C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:40:49 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b16so22584455ioj.4
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wCPXqTCcrBmanxLPzR9iJlsfbsr9Lc7SljUUN8HwaIY=;
        b=HZEYx/2SlaPnJH6lQS2GRFmTYmhxtCYvrnZWgxkAoq41zn28wtsjoa2fOQNiFxVaea
         gvtSH7UxPN8WHc2musWGYTCvpp7fN156oyaD/JrHoM7tiLTfxWGVh1y8MWsqhEY/2DVE
         vwAjXrQqMva88MnPNwzBGK+Lmc9T4Jg2yTz2hKubSHeuN7YusLz0vnQcsCBWGYtXRByS
         nGsWarAXx6BPv/2unrClZ3UZerEB6GR+kc5O1CaZhr84SKa/pcVxNEgOJlCiRuWD1KT8
         flQJLIUR4Mja9jB4qfV+EGG677fKAkZDY4/U77ObBwvdq6AYUCkO9qE8ppRLYifTb9WD
         2fIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wCPXqTCcrBmanxLPzR9iJlsfbsr9Lc7SljUUN8HwaIY=;
        b=ZgccExkLegvyMSJ+5gHAUJ+7NaM311aY/WOX/pWL+a9B8blt36sP0Ced7mekavU2vB
         U+5tvuZzi0fCkNIPuzPCInEploTFI5LhHnONsMs34O7+zT4To7ihcW5qB5Qm/RTIO+QM
         /XkNFLlJJZXOFTaQbQQ7PUbRKrOJRBJhgACcOORh8UjVCmdr3XjVY3szjY4B2T4tKc9e
         YFmF9Foi7AZQsjzvZvP+qupgXCQxxCcVXYdQGkITxRBkqydnI3S1HXdl5k2zBQSidkbT
         tPsUe1vkZtDH88dTAlS7UmkQDVpnZuAYGBYpn2X3Gdt9IGkAbP0rapqmyex3MY3qaQEO
         hVeg==
X-Gm-Message-State: AOAM5318URmus54zqmJ/nZg0efuvGUjy/ajcDiy+bYJdUXsgMPxjMooQ
        L1HURDTyLUK0KBGQarw5dayPNRP1RzMKlrR1VSYd+/Ft0MmHNQ==
X-Google-Smtp-Source: ABdhPJzLM7EhlzEgiGSmNngavqpZEYlrYRyh6r+uHMTtEqrL2DENnIU6kc2OkxlTiD2hOZk5hywTXfLcinkOGbeAz9M=
X-Received: by 2002:a02:9f17:: with SMTP id z23mr21112266jal.63.1597783245100;
 Tue, 18 Aug 2020 13:40:45 -0700 (PDT)
MIME-Version: 1.0
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Tue, 18 Aug 2020 23:40:19 +0300
Message-ID: <CAE_-sd=TddkSgFTMH6MNb4p31cmVLayZGchtr2D0w5Bjb7t+pg@mail.gmail.com>
Subject: tc filter show pretty mode
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day, everybody!

I've got a problem with output tc filter show command in pretty mode.

I am looking to output and I don't see anything match mac address at all.

I've entered some command for test:
tc qdisc add dev ens5 ingress
tc filter add dev ens5 parent ffff: protocol ip u32 match ether dst
ce:22:a5:5a:1c:26 match ether src ce:22:a5:5a:1c:24


tc filter show dev ens5 ingress

filter protocol ip pref 49152 u32 chain 0
filter protocol ip pref 49152 u32 chain 0 fh 800: ht divisor 1
filter protocol ip pref 49152 u32 chain 0 fh 800::800 order 2048 key ht 800
bkt 0 not_in_hw
  match 0000ce22/0000ffff at -16
  match a55a1c26/ffffffff at -12
  match ce22a55a/ffffffff at -8
  match 1c240000/ffff0000 at -4


Then add -p (pretty) key and...

tc -p filter show dev ens5 ingress

filter protocol ip pref 49152 u32 chain 0
filter protocol ip pref 49152 u32 chain 0 fh 800: ht divisor 1
filter protocol ip pref 49152 u32 chain 0 fh 800::800 order 2048 key ht 800
bkt 0 not_in_hw

-- 
Best regards,
Denis Gubin
