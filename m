Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EEF3900F4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhEYM14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:27:56 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:33018 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhEYM1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 08:27:55 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2021 08:27:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1621945183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AKeKOgCE7NWwnOmjCbUIA4YU7NFmt7uNtxHEAfyB58c=;
        b=p6YqvN2wqp5t3PM/BJLCNo90zRBEsW6qp34e5QnzGRR9ptjCtw+mYbXTwAHNvGeDkMkfeQ
        nyMhN29AR0b5MeQwmuLHRb3c82NUq8HpeO7MaEpUbxC8jebxoimhveyHXZhDSj4jbMWj3z
        iqBoAM4goRJh2PNlEKO5L1dsDfK5NqE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7664fdc1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 25 May 2021 12:19:43 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id z38so13113418ybh.5
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:19:43 -0700 (PDT)
X-Gm-Message-State: AOAM532YP3E0LrPwmsHpEDYEW3Yt3rnr9Fhzs2mQgKkYavu1RTSkrawx
        fCCt63S9k50Jjo6HsYY4jHp0tAJumYHLmS+R5is=
X-Google-Smtp-Source: ABdhPJwM+2OTVzf470IfmxGXeYgjUg+/trSRPUP7nbDdvdxiKYWspZNRvIqO4+TyEIeaC4oP9v0Z7vIRaQT3T0Wu1QQ=
X-Received: by 2002:a25:be09:: with SMTP id h9mr44789146ybk.239.1621945182826;
 Tue, 25 May 2021 05:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210525121507.6602-1-liuhangbin@gmail.com>
In-Reply-To: <20210525121507.6602-1-liuhangbin@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 25 May 2021 14:19:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
Message-ID: <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

Thanks. I've queued this up in my tree and will send it out on the
next wireguard push.

Jason
