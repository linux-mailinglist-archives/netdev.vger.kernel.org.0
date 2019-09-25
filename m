Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE594BE133
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfIYPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 11:25:16 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:39172 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfIYPZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 11:25:15 -0400
Received: by mail-qk1-f178.google.com with SMTP id 4so5617877qki.6
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 08:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bsIBGBh4bWr442ac07k3ZiQva49Ja5zr8Or7EVTHrIQ=;
        b=vPeg5oEYNlgeXlUTNNQfkom5YxnLpa0Ni/Eu+JWFIPyuwJ2m//Yt/40AgkrKXKGb7U
         bihnSkneH5Odvbur4iiaCXNbXFAV7v3SJ2mfzmTZjfsEgLz7SZq1uLsoJIsdUrlorOT3
         wtwpMQCU9cnWS2dfk6uJOiJG1c8Q1IUr/T4wQMmmGAofhPzEkcdE5dj15UeF8M7aG5FF
         rrMPXFwyMoXQfpdiU1SLMmxpyuvl+DrMegoPCnEujqdrBPo7aBCmp8tS0Vc2NP8Z7258
         cqF5k3vNYISGtNbVdW2xA1xT+LyspKkqWsm3UABevoI4flwRUIRBKmn0pCvld4Y3SIMw
         2O4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bsIBGBh4bWr442ac07k3ZiQva49Ja5zr8Or7EVTHrIQ=;
        b=G4w5grhFck1B6/aA1S2Jg6VQVMMxZnXWhrPJrx6PiodaBi4QTgpYL7sy+w8K4YouAt
         Agli4WhSWE4vVOirl2g3DvQhouprXiuW57k4lGlXE3XW6PZsehAYhOtegUbPSeNBMnuG
         qftZND8yObL6Ee9HYlwcywRGpbnmBiCQRqv/ibVZJSU1frzEE8qNmNwradtg+wetwLUG
         XsqQyOlG0KlMsBHw+ig1bflSBB0FFiPU7L+FcvlTQDlS5UApPtwqGorccdoOWHl+ThtC
         scJbWbj2jzs8UDTiAqJ0ZyZg+TPd1mi1fjJMw0NViBzGloNLpaPNAD0QHkANvUVhVolW
         DJkg==
X-Gm-Message-State: APjAAAUro6UiCpVK0mPLqH7e2OW7vBo3DeIRvaikwZzzdEhkP8dFHxB3
        wbfTe8P1PPeWO0eu9Ox1mrP9dglWodWTdbcnwU0XExM7Hmk=
X-Google-Smtp-Source: APXvYqwq5kGLdHAlbPsxvjANEONQ1XdPAJVKBMwnIcQrgoodgbEf4Djgyq3u6iZfcXtcCkmCbPqq/oki4SZMPejd/6o=
X-Received: by 2002:ae9:c110:: with SMTP id z16mr4269740qki.352.1569425113946;
 Wed, 25 Sep 2019 08:25:13 -0700 (PDT)
MIME-Version: 1.0
From:   Levente <leventelist@gmail.com>
Date:   Wed, 25 Sep 2019 17:25:02 +0200
Message-ID: <CACwWb3BE7msW6=XADuG2Di4xYnoJq5qScc4Wsu4xOS=ycYPDww@mail.gmail.com>
Subject: IPv6 issue
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear all,


I don't know if this is the right place to ask, so please be gentle.

I have a router running OpenWRT, and it fails the some test cases
defined by the IPv6 forum.

https://www.ipv6ready.org/docs/Core_Conformance_Latest.pdf

It fails 1.2.3 / 1.2.4 / 1.2.5 / 1.2.8 test cases.

My question is if there's any particular settings (either compile or
running time) in the kernel that affects the outcome of these test
cases?

Other question is that is there any open source test program to test
the kernel's IPv6 stack against this test specifications?


Thanks,
Levente
