Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59507400969
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 05:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242799AbhIDDJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 23:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhIDDJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 23:09:54 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AAAC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 20:08:53 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q21so1653700ljj.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 20:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AmpQXLuWcKRnRztqv+kSLcoJmxvozgSjiG4CeAGr8qQ=;
        b=sfyJhFaBa4uK+SSBPhd/eF4k07Aj80nFBB7vCPNVKEkF9uKeOaHfBT7RuZvzIsUEzE
         XXeqYxWvE3s42p5qi9NdG4KDTT8OHiMACpDikz5gC91tetB71HrRZVh77axBG3DBgEhg
         GFr49SqsZ3BkzgGGDeQtcP51QjLSI8IgNHDAIephZQfl6mXuePEg22ubbJNSFel50LL4
         edC0doDvokKv7XKD/+lRv1mi2pxsvkIBLPgGhsa6REF6IsHm0tLihImQtFz034KkCWg6
         8GLxmbDkVWjNQnRV5xAoG3z/rroeejVTAkZzYBJinJq42doRyVPS6MRFhIRlO3SE/eyz
         u45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AmpQXLuWcKRnRztqv+kSLcoJmxvozgSjiG4CeAGr8qQ=;
        b=ZED0VAT8l2ngx2dA3TJF7Xpl18tJWyPEJ6BoRpV2eC9xQE5CWfeS+s2qAPPULZWtUs
         YeURHreejTAtHsEiAIKn/pNNT36uIEAEXKeZh0kyqlRRR8O1C0DUAJrFl3KMLNIRHuSq
         C1uDJYSTzRrH6H1irBIWXa8snY5xHlWU1388PfVvAfM2hja5qy2aKc2XRTK9HhYzVtBQ
         9BkS+8RE3Jp/Xw9n/P1bHyBWOW81++5kA28XrlMFgrrPOriVx85V5b24pKBv6264bN2Z
         LNwJQJsiJoHVELxcnBcnAvF7fa2WOWJKOkLZd/lU7eL9pBrfJZLYQEuqr6piRCuZ+udP
         Q5rA==
X-Gm-Message-State: AOAM530Ng9jnBjZESLXK5X4EcYXWDG6ryfvCMQS4P7pSeVqHr0NwAatx
        gZhREhz3h/hkWYyHgpVww3tBmnncexB4mH0FzdiZef713Mo=
X-Google-Smtp-Source: ABdhPJy1f9aCfN00mkLWWlEv02qU2z1Qmz1eKux9khCqVN3B7yC7uwAYv9QVlE+vC8I7tU4LQ+fa5cQTcLEpkD/5O5Y=
X-Received: by 2002:a2e:a36c:: with SMTP id i12mr1417306ljn.427.1630724931420;
 Fri, 03 Sep 2021 20:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <CANcMJZBOymZNNdFZqPypC7r+JFgDWKgiD6c125t3PnP1O309AA@mail.gmail.com>
 <20210902092500.GA11020@kili>
In-Reply-To: <20210902092500.GA11020@kili>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 3 Sep 2021 20:08:40 -0700
Message-ID: <CALAqxLUqSis_chO53K+RqvDVmE8z=p9FB8kG6DE9cVM=KQupOw@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for v5.15
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srini Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 2:25 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> I'm sorry John,
>
> Can you try this partial revert?  I'll resend with a commit message if
> it works.
>
> ---
>  net/qrtr/qrtr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

As Srini already commented, this is working great, but I still just
wanted to say thanks for the quick fix!

Much appreciated!
-john
