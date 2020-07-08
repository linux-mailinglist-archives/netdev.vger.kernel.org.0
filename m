Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B030218AB8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgGHPFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:05:04 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA25C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:05:04 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so54688129ljg.13
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IuIREgaFxsDU+pS/cXgjaWR01i/KPr3Nog2mkPOgDb0=;
        b=ATMgt/mYA6eba5mDLhbU0ROg2NGB2ehpmyn6zKhkTjUE0WZ3QoB08ZGdBjCyvySGwU
         g0QF9xIafehBFyDA4Uo+7bq7pG5BJR9IJhVYn54uet8fknB94usrcKtpKZFyOFq2nZMz
         0gMIFyH4M+MqG00vedk+qO7olAzTJsXo/A7qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IuIREgaFxsDU+pS/cXgjaWR01i/KPr3Nog2mkPOgDb0=;
        b=KIDg/iCwi3jTCnLE2gdc6OhZ8HhAj7wMWsDDlcfpesjWgDfb20c8g3uXEX+bpL/MC0
         n16hmfZJiFNnz+5lJthBZkUTkToSuF+7FnEBhHpXZj0Vqg19Ca1OenJwZf1+m6mOfQzH
         Z7GRLNbc7i/FcrfcJxfPEVocYbs19r6i3LhVtggCyUFkC4r4pD+mYgxhCSZVIsn4RphV
         lHfg1ld7oJHM+3W4wMIHbz9h/6tFJYC7cWbIyD0kKZquR2MPgiC320xFS3Fbyz9r8C05
         otodkKv+N2hY1xZmnIqwfaU8IogHMSDHm7yRVzbm+kqFmDt/aKGTBpSTgikLBr1vUvi/
         2TwQ==
X-Gm-Message-State: AOAM531p9et1l9BmiI+8zl0OA2bNJQW1aUspZrVnjbzGXKyhL6ThdMVl
        fnmGT9up0gvwq3jSIAo8KL/WAUjLubMUBmtBtf/ERA==
X-Google-Smtp-Source: ABdhPJwDBB5VhFCblYICtEdCA2P6onjKTbvecmAohEqmjioT88iVSHetIXzOOLVlzxvUNNcXMWVFosGDfIoYE4znuIk=
X-Received: by 2002:a2e:b5c8:: with SMTP id g8mr18520221ljn.38.1594220702442;
 Wed, 08 Jul 2020 08:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200705110301.20baf5c2@hermes.lan> <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
 <20200708113505.GA3667@nanopsycho.orion>
In-Reply-To: <20200708113505.GA3667@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 8 Jul 2020 20:34:50 +0530
Message-ID: <CAACQVJpxsOXFPaSn9pjqeEeVRu_VJumvndpPpYNs_zx5SmiHgA@mail.gmail.com>
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to info subcommand.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>, dsahern@gmail.com,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 5:05 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Jul 08, 2020 at 11:40:12AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Sun, Jul 5, 2020 at 11:33 PM Stephen Hemminger
> ><stephen@networkplumber.org> wrote:
> >>
> >> On Mon, 29 Jun 2020 13:13:04 +0530
> >> Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
> >>
> >> > Add support for reading board serial_number to devlink info
> >> > subcommand. Example:
> >> >
> >> > $ devlink dev info pci/0000:af:00.0 -jp
> >> > {
> >> >     "info": {
> >> >         "pci/0000:af:00.0": {
> >> >             "driver": "bnxt_en",
> >> >             "serial_number": "00-10-18-FF-FE-AD-1A-00",
> >> >             "board.serial_number": "433551F+172300000",
> >> >             "versions": {
> >> >                 "fixed": {
> >> >                     "board.id": "7339763 Rev 0.",
> >> >                     "asic.id": "16D7",
> >> >                     "asic.rev": "1"
> >> >                 },
> >> >                 "running": {
> >> >                     "fw": "216.1.216.0",
> >> >                     "fw.psid": "0.0.0",
> >> >                     "fw.mgmt": "216.1.192.0",
> >> >                     "fw.mgmt.api": "1.10.1",
> >> >                     "fw.ncsi": "0.0.0.0",
> >> >                     "fw.roce": "216.1.16.0"
> >> >                 }
> >> >             }
> >> >         }
> >> >     }
> >> > }
> >>
> >> Although this is valid JSON, many JSON style guides do not allow
> >> for periods in property names. This is done so libraries can use
> >> dot notation to reference objects.
> >Okay, I will modify the name to board_serial_number and resend the
> >patch. Thanks.
>
> Does not make sense. We have plenty of other items with ".". Having one
> without it does not resolve anything, only brings inconsistency. Please
> have ".".
Okay so keeping the patch as-is.

>
>
> >
> >>
> >> Also the encoding of PCI is problematic
> >>
> >>
