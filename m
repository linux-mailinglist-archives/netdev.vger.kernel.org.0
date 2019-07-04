Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DF5F332
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfGDHFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:05:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46145 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfGDHFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:05:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so3457644lfh.13
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 00:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/jhMVFWL9zAP6DASgDxWvKe4pRoCVY+Bzzlbxt4Sws=;
        b=qwDSVwsECgzZhe2WwlG1p8BOPlPHnzsNTaQt1KS8uYPGmdPXJqoI8dUKZa4N9BH/bQ
         O7QOMjn0trVW6NJLJAgx1IQA8mYmF2lT6hZqFMtVdWO5d7EKSxWkwVQeA51/LKFBQFeR
         JfWOVSjVV3Af/VORKOstlu0LPLSn+zx1e+VbFF6GbnJnmvY/KumjMcv+KeAbxHIJFwHg
         47dCJgb1rCk/k6pxP9MR2KHQI7uoBai+qnkxbSrfGXVxvqclUX3PzMMxApCEHCY2xU6N
         vWNlOxTyomJ9DxPxQU4YiQJgFKC/tJkybV4VdVUcFXD85U/wq+refUau9H/AEzpPCUtB
         39AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/jhMVFWL9zAP6DASgDxWvKe4pRoCVY+Bzzlbxt4Sws=;
        b=aMieKCzCL7cSl88CHJh6ATSz7p9dDEHS/lj/MwLlPoIMhkPXPs6BhMMv5PQVDUcrZx
         glZ93peDpog81feJTgFawtbOxZOpu3dKQ9qaUSaG+h3h0FOfWe8ry0dre2BXnrtJHcls
         HbxhEyT9gvTt7ffdFVI9B2muS19rCqGPywNj8JcY1PHsz8T+T/GKW4t8IrUz3f5RYkKk
         3q1+fzQgHMF2+brmJbwdjnbaOl3bGxpl27SNdVb6u5E6JOm8HIC9FqmEfyowSTYu4EfN
         uhjeH3g140VobFbSN6sgNvblbbOtAknU1dWyToqCTRbXOjYMkw/Okyjn43lVGdkN9H/e
         vAAA==
X-Gm-Message-State: APjAAAVzZqoFvoMlVmyNRRcsv6SjP72Nh+RgZWJg/gQXzKlJPqDr+ADT
        EMJxaXNj1A7o5KjgHNuwwQUtNA1BoBrbglIeLW/9/w==
X-Google-Smtp-Source: APXvYqxQCD23eaeoAJhpEZfOc2Of9fwPsf/stmR5iwxoFFdrgqdv4D53+o/uLeap0VPJozhN950Mm7ck5RTeeImezjQ=
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr4161503lfp.61.1562223914898;
 Thu, 04 Jul 2019 00:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190703171924.31801-1-paweldembicki@gmail.com> <20190703171924.31801-2-paweldembicki@gmail.com>
In-Reply-To: <20190703171924.31801-2-paweldembicki@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 4 Jul 2019 09:05:03 +0200
Message-ID: <CACRpkdb5LonYLpbOHj=Oo8Z7XjVUWoO0CuhOokxfSoY_fRinPw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 7:21 PM Pawel Dembicki <paweldembicki@gmail.com> wrote:

> This commit introduce how to use vsc73xx platform driver.
>
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>

Nice!

> +If Platform driver is used, the device tree node is an platform device so it
> +must reside inside a platform bus device tree node.

I would write something like "when connected to a memory bus, and
used in memory-mapped I/O mode, a platform device is used to represent
the vsc73xx" so it is clear what is going on.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
