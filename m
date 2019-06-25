Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD052172
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfFYEAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:00:23 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33689 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:00:23 -0400
Received: by mail-yw1-f65.google.com with SMTP id v15so6247502ywv.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 21:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zi9UCFv4AjLIxSB/WwtCALU5aD6YqXofaXUJviL555U=;
        b=gTRtSXBCU6WqriiUl5PuBpNPQAAWSMlAQPc+FWKvSL/W5q0Zwqv91lrIG1Lst9AH+L
         8vYGZ0xjTZugb2HYSffe42wlWT1MFL5Fpmxz7VbdRCxgi1LqKItxgcJ0wg0607FA5PSw
         Ko0Fvxr91Fgsy39/DtTrf3XTNLkBcDrkCa1Ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zi9UCFv4AjLIxSB/WwtCALU5aD6YqXofaXUJviL555U=;
        b=de2qC+6erL0sUjryv/siRRoCNLjIXHSXN9eHNr3d1NwRgPzddkWzSrQH0Fv+6geA+g
         lY5cYiN5XdJY6iyurdwmFXcKidR0/23emx9MeKnkKqwrxO/mReuXHx3WJjvEx52IAnsK
         hdqeE5J5nYJU9C0l3y62EPQy+KLG9rOfYpxYq4f9YT+Y/hHHIvCG2X38U1nLIlXYl26/
         E7OD7OLnXhHAuh7cDRISwg3/r5vxx+o0MaHM+M3y+t1ndNlzJsDN5zGv9sKSx7KGe40i
         67ezFdaRIqQf27haalqtEKYxEY4GHgtFuOrGIWwpnQHnVVxIFFjPpPKwbgBCYNTNr+NT
         ZRHA==
X-Gm-Message-State: APjAAAVlsUJo92b7X4ioGYdjDhNUt6m8dyTyYkA9A4akKbfJRFJyKPQm
        Lk6ECzPqHI12hUTj2gASyu1UY3bAzieeowgkafkE/A==
X-Google-Smtp-Source: APXvYqw+U9W1CUKepgKmOwfli6NXkGMUcOP+H3PURD4Km6HFOPbnArancXMovku/gWc3X282Trn/Ai9N4yS27xnrZ5k=
X-Received: by 2002:a0d:ef41:: with SMTP id y62mr91503111ywe.204.1561435221979;
 Mon, 24 Jun 2019 21:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190622004519.89335-1-maheshb@google.com>
In-Reply-To: <20190622004519.89335-1-maheshb@google.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 24 Jun 2019 21:00:11 -0700
Message-ID: <CACKFLinDN+cOEBfm9wnoXU-iDDtZZpCu+NPMHs9aCQ1RjJcNBw@mail.gmail.com>
Subject: Re: [PATCH next 0/3] blackhole device to invalidate dst
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 5:45 PM Mahesh Bandewar <maheshb@google.com> wrote:

> Well, I'm not a TCP expert and though we have experienced
> these corner cases in our environment, I could not reproduce
> this case reliably in my test setup to try this fix myself.
> However, Michael Chan <michael.chan@broadcom.com> had a setup
> where these fixes helped him mitigate the issue and not cause
> the crash.
>

I will ask the lab to test these patches tomorrow.  Thanks.
