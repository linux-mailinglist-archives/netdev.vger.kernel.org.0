Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B91F47F2E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbfFQKFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:05:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32988 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbfFQKFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:05:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id i11so15360976edq.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=VGA9c22y9jIlHDQMx4uvOibs7sOik31ZYkHYuUn6B2A=;
        b=JyNz3YrQXeZQihiVS68RHnnLZ6o5UO46RUXYmjIXxMarXHjp3quUe0sTP89h2RU8qd
         t9xqv9wTj260UdX5wH35ZuuOvUBtisoit/qwfK5Kgpmzpzqi1hm9ICfiSCaa6aeOrD/O
         fnDMZPUTZVNhS3eCTNHUSRvBTwqgFi5qzNsMPubsWuJaAZyy/bf3WT0jpYzk5F3cpjGJ
         VbGYngxQwu3kBOwmupErYz+LZog68KzmNfkuKtjTK6pxTOoD474ZOc4ZxGlZV/+5UV+C
         b3tIuf1NKkxfHiXsESOMMHBxCIMFfYJ0qDfMiA9QurTcSwBttbk/tx5IZROKrZGAFOrw
         XN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=VGA9c22y9jIlHDQMx4uvOibs7sOik31ZYkHYuUn6B2A=;
        b=m5COZmoHen8J3ZLfbkQv7llXWCNHuOlRygS47eIR35mQS+XhpW2x337XJBo/K4FUld
         KeR0VVUMV32sNamygChBBPtXcekPVKRKV9LSrzcy9bP5QEMVBW4pOsYdYJIptfhFDD07
         s2KHXdL+kuW4A0INQ6WP5LGUcRfcbr1fp1cn3WsA583kW80kTMCC9/J6OCh7oydVz2I2
         IyztH6alay/i1ayIHTcgxyTR3H/2QOzYUC+onD2QTVmn8R/X5mEkrunh9It+2lHbDeyo
         6kitlcsnzpbas+DddK/HEzg0OFDRADMUwXTDDHHAJTsFv+dPc/6+a1jCE7xEJnUIIqEv
         BxtA==
X-Gm-Message-State: APjAAAU66wNEIxKvkLm6P+683fBhrA80aQ+TMaO4xqd/0FZ0IPma5sek
        jvQ3ebsCgP+YkhR1cCaIWaZse2gFyf4=
X-Google-Smtp-Source: APXvYqxgX3WrGXoEnt9ZLFi/AcNRTFEhFUprMEbyI8apql360t1iTkxRuRY3ryohJKMoEwBxTzhyYw==
X-Received: by 2002:a50:b962:: with SMTP id m89mr53812367ede.104.1560765907918;
        Mon, 17 Jun 2019 03:05:07 -0700 (PDT)
Received: from localhost ([81.92.102.43])
        by smtp.gmail.com with ESMTPSA id m3sm3433752edi.33.2019.06.17.03.05.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 03:05:07 -0700 (PDT)
Date:   Mon, 17 Jun 2019 03:05:06 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Andreas Schwab <schwab@suse.de>
cc:     Yash Shah <yash.shah@sifive.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
In-Reply-To: <mvmpnnc5y49.fsf@suse.de>
Message-ID: <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com> <mvmtvco62k9.fsf@suse.de> <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com> <mvmpnnc5y49.fsf@suse.de>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019, Andreas Schwab wrote:

> On Jun 17 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:
> 
> > Looks to me that it shouldn't have an impact unless the DT string is 
> > present, and even then, the impact might simply be that the MACB driver 
> > may not work?
> 
> If the macb driver doesn't work you have an unusable system, of course.

Why?

- Paul
