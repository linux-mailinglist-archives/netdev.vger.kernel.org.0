Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250773FE63D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbhIBAEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbhIBAD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:03:57 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02ABC061575;
        Wed,  1 Sep 2021 17:02:59 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q70so283249ybg.11;
        Wed, 01 Sep 2021 17:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5eS9joUEQxD2OUktUs9JyC6lsbZ0ql447Y8GghkRzc=;
        b=Xe9EoBAnQSexng2ntYcSbkLT+YZ28oNmzoAcZ9tdeeXYr8eamXz1oaT7RsoKqBuuh+
         tCAdBWus2CXqTCeaTQU3e4yZe0Rbk8tALkU2JJ8QO7OKSaJkSg3P/WI3KeNdaYAYVSI4
         Mav7Q5KkUq6KkeSQqpARfxFUdQ4W/u5mW8Brzhek1tcN1A8Y9pdDSywpa3+D6vRCIzV1
         L8UaCwQ/K/3BgXcH4KjvuC0NxeBGK+kuORp5S9Gx6Xs/gTMMsONwCMHX7wjw+Wy6d5Hi
         ras9IH3r5taXcI6j0LZSb2cIupb3YUCG2Kt+Kww39+82wdhmY37cLkpdjxsm7pY2XKTS
         JSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5eS9joUEQxD2OUktUs9JyC6lsbZ0ql447Y8GghkRzc=;
        b=Du6SIpQmfB19dkdpxK4s8H4YPgUrwVZXrcHZA2DiRlBUTB5JZFQZIxBKp8z446kr/7
         16JGVOtsmyiHJAjRHnRwdYIbq+6PIVZkZXPH5Yzet4M4/4JDBAawMhh9mEenkbFygzB0
         uK96IGw6TFAGLKFC1VqdsTzhlECDrkyC2guH6mhjBtdX/1tgflnu/rgxt4e97GWrupZa
         6whr3jglzCikNJYbZOJc+UaZVUCNKYY6klw1CwNoXa9bviyPM7CRQgvqxTEbvMUzlgCm
         NjouHD9OzRGBq96jEcjMORJCoEnTd3zz3I7krcb8zP7ioL2mAhuyueUCh8QyOEBwMC7X
         GtjA==
X-Gm-Message-State: AOAM531wyNis+EptG1bD79xiWqSSfd0TIqDMFy4C79xr9f2W3gYQXhgj
        MZZJNVncPUUFv619LCG4Cqe46S4WuG06Vz0ZEIU=
X-Google-Smtp-Source: ABdhPJw3paOQWUG+WZlV3zarXo6C9quj40RT4qzOvN0ZooEovcpBZ32Gw6TkVPLvldFmZW/OaSGz3IZqECL2VE7gnzQ=
X-Received: by 2002:a5b:142:: with SMTP id c2mr624932ybp.425.1630540978949;
 Wed, 01 Sep 2021 17:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210831203727.3852294-1-kuba@kernel.org>
In-Reply-To: <20210831203727.3852294-1-kuba@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Wed, 1 Sep 2021 17:02:46 -0700
Message-ID: <CANcMJZBOymZNNdFZqPypC7r+JFgDWKgiD6c125t3PnP1O309AA@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for v5.15
To:     Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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

On Tue, Aug 31, 2021 at 1:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Hi Linus!
>
> No conflicts at the time of writing. There were conflicts with
> char-misc but I believe Greg dropped the commits in question.
>
> The following changes since commit 73367f05b25dbd064061aee780638564d15b01d1:
>
>   Merge tag 'nfsd-5.14-1' of git://linux-nfs.org/~bfields/linux (2021-08-26 13:26:40 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.15
...
> Dan Carpenter (7):
...
>       net: qrtr: make checks in qrtr_endpoint_post() stricter

Hey all,
  Just as a heads up, I've just bisected down this change (commit
aaa8e4922c88 "net: qrtr: make checks in qrtr_endpoint_post()
stricter") as breaking audio (and I think wifi as well) on the db845c
devboard.

Let me know if there is anything you would like me to try. I have to
run now, but I'll be doing some further debugging on this later
tonight.

thanks
-john
