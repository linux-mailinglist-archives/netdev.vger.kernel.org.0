Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBB7C121A
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfI1UUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:20:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36018 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfI1UUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:20:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id h2so5213755edn.3
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yrwgOptAkLzFADAqpNu0Kg/T5zSdxC+VNq/RLX+0U34=;
        b=ggMlvPJEz1q78YDv2RuA3M7mqvcLbDv5aF7Kn/ERFMnmgISQLwE+vc2kAAgilYElie
         m4uzCK+SdDlBv/ZTylAxAjX3Dqt5oPth8Ym9BGEM8h8NkNWdlndIh3np4PnAW4zUb0ar
         7I2Euuv4NUZ2zIam0f2CZuMKx31v7sDZSi/VE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yrwgOptAkLzFADAqpNu0Kg/T5zSdxC+VNq/RLX+0U34=;
        b=RhajYcseZkDCqmXA7l5aInOaL5gOAz2QwbXZO3lcYWIaC4ANVb4tm2aS/Ygm+ITTeA
         b2tP6pXhV7N63ClsSv7PN5CxajoF/xnoA5ANfzMcYU3C3KqY+UDtR5GxqM2qgiTEI6Iy
         R0BLAsJHLq8zybRThtexbAlOKsBzVKyFsQJd3UEomTIc4jG9QvceyYHYSGBUZRXe/B7L
         oVDTYxegmE6LLXARZl9HurYTBfho9qVhOl3kYfCgx8hx1YPyrcC3SYvK6jQeQ+SRw8VR
         /OLQmxsSIis7Yuu16HxLwiWwXADwI37GtHckZydk8t93RwTJkCW3AnQGUeMWgAg0COGE
         a/bw==
X-Gm-Message-State: APjAAAUmkeoPCmSEEuEi/Z7FsDFTnn3yJJqtLSpVzxwUpfi5MO5LoLF+
        3F07T1buoqqZ3lgvu2Ta3SOAT1bG3bgqOjUgp8dzMC5f
X-Google-Smtp-Source: APXvYqxWCHab2b8MRmk4vH/B/oSX07Tbddtm8pdObGKBIQtDeiaoduxhDWHjKevEhb5Mu4U8d1Wk5mvvahE7sFZ4Ezs=
X-Received: by 2002:a17:906:d8a9:: with SMTP id qc9mr13060166ejb.199.1569702034897;
 Sat, 28 Sep 2019 13:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <1569646104-358-1-git-send-email-roopa@cumulusnetworks.com>
 <1569646104-358-2-git-send-email-roopa@cumulusnetworks.com> <20190928084641.69233a5a@hermes.lan>
In-Reply-To: <20190928084641.69233a5a@hermes.lan>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 28 Sep 2019 13:20:24 -0700
Message-ID: <CAJieiUie-C39YRXKNBsLoRze6C+hCx4yheLivuXqtc5edUD6fQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 net-next 1/2] bridge: fdb get support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 8:46 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 27 Sep 2019 21:48:23 -0700
> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
> Overall, looks good.
>
> > +     if (print_fdb(answer, (void *)stdout) < 0) {
>
> Cast to void is not necessary in C (it is in C++)

thats a copy/paste from iproute get code. will remove it and post v2, thx
