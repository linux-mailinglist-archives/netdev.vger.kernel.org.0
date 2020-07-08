Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BDB218B2B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgGHP0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHP0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:26:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24644C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:26:34 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so17425103plm.10
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bCwi179233gzohscNZ7VZ+bahR6sC1TbXO6rxG4BpGY=;
        b=hjGrTuxYzCjidq48q03Yt62F4KlEPwyB10K6mxgKoLOFlj4YigHiTcRiMXFKDUdZGB
         +w9p0Lz3v201kVpUxlKQHhbiYVZ1aQPcZhtj6sOsPGHYQqmM15FZz9yXPuVlLyb+SkYW
         tOA856TPAz2FdcsRlN87zc3HopsC6KsCQaTIZmzVnxHelmzJfBFI7TrxlWMlPBf+36Wo
         aKnYRQ1jFeg1iAFTf/D/lNy0kv0CGzb3l9IpAZ0nTLKLGk+qAr/8sHZOeW0n8BuRASQ4
         AI0oPna8TJc9h+vt9T1SA8b3KpJtVd/AK10LLkMPIIpoKBy9OFsMM+xZ3EMMtKU2atIR
         B5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCwi179233gzohscNZ7VZ+bahR6sC1TbXO6rxG4BpGY=;
        b=nAlBrdOwLmqmyPr9KfavYU0iu4L6Gik2LnalepTkvsYL2xKKxmSJoHp8F+xMXxVTWV
         EV2Jf58I3yC8qzrKO0KaKCDKyJB2auxgzDY+POcS+50zDJbUFJ82r4IzHqrArtLHZyNy
         +ZA666OO7ZRCNOYat6Y9z60ZxGpHfPU2ij7Hcp1l9GRUclNpxA3MmnG6nRRUwRl2cpYS
         ekepniA2RflyAvw6e5P31AWyH9EZEDLTRlFq8yD6U239lXmbx43AjuzFbU7gtPO24Dcf
         DsNJnbsjD2c+D4/pTBbIGD+hFtNw3hpxH1lXkkZWafaWlzCr3M33sPbmDjUNUrycbJ2l
         t88Q==
X-Gm-Message-State: AOAM530YYCc0DVD5+rfxrvPgiUuqnWPFNvRKULKCgyt+G4aG5wYTUSuW
        az+4EOgu3RYBcYjFWmP2gZHQPQ==
X-Google-Smtp-Source: ABdhPJxRGNJYA0DhkA+WGXzwW+7Xqh/YULG144eBXOZBE+8swcyKrgdO01GNCli/4pY+t+j+EbaTqA==
X-Received: by 2002:a17:90a:2069:: with SMTP id n96mr10835970pjc.213.1594221992199;
        Wed, 08 Jul 2020 08:26:32 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f15sm222513pgr.36.2020.07.08.08.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:26:31 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:26:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Netdev <netdev@vger.kernel.org>,
        dsahern@gmail.com, David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to
 info subcommand.
Message-ID: <20200708082623.2252d2e8@hermes.lan>
In-Reply-To: <CAACQVJpxsOXFPaSn9pjqeEeVRu_VJumvndpPpYNs_zx5SmiHgA@mail.gmail.com>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200705110301.20baf5c2@hermes.lan>
        <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
        <20200708113505.GA3667@nanopsycho.orion>
        <CAACQVJpxsOXFPaSn9pjqeEeVRu_VJumvndpPpYNs_zx5SmiHgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 20:34:50 +0530
Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:

> On Wed, Jul 8, 2020 at 5:05 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Wed, Jul 08, 2020 at 11:40:12AM CEST, vasundhara-v.volam@broadcom.com wrote:  
> > >On Sun, Jul 5, 2020 at 11:33 PM Stephen Hemminger
> > ><stephen@networkplumber.org> wrote:  
> > >>
> > >> On Mon, 29 Jun 2020 13:13:04 +0530
> > >> Vasundhara Volam <vasundhara-v.volam@broadcom.com> wrote:
> > >>  
> > >> > Add support for reading board serial_number to devlink info
> > >> > subcommand. Example:
> > >> >
> > >> > $ devlink dev info pci/0000:af:00.0 -jp
> > >> > {
> > >> >     "info": {
> > >> >         "pci/0000:af:00.0": {
> > >> >             "driver": "bnxt_en",
> > >> >             "serial_number": "00-10-18-FF-FE-AD-1A-00",
> > >> >             "board.serial_number": "433551F+172300000",
> > >> >             "versions": {
> > >> >                 "fixed": {
> > >> >                     "board.id": "7339763 Rev 0.",
> > >> >                     "asic.id": "16D7",
> > >> >                     "asic.rev": "1"
> > >> >                 },
> > >> >                 "running": {
> > >> >                     "fw": "216.1.216.0",
> > >> >                     "fw.psid": "0.0.0",
> > >> >                     "fw.mgmt": "216.1.192.0",
> > >> >                     "fw.mgmt.api": "1.10.1",
> > >> >                     "fw.ncsi": "0.0.0.0",
> > >> >                     "fw.roce": "216.1.16.0"
> > >> >                 }
> > >> >             }
> > >> >         }
> > >> >     }
> > >> > }  
> > >>
> > >> Although this is valid JSON, many JSON style guides do not allow
> > >> for periods in property names. This is done so libraries can use
> > >> dot notation to reference objects.  
> > >Okay, I will modify the name to board_serial_number and resend the
> > >patch. Thanks.  
> >
> > Does not make sense. We have plenty of other items with ".". Having one
> > without it does not resolve anything, only brings inconsistency. Please
> > have ".".  
> Okay so keeping the patch as-is.

For now yes the patch is ok as-is, but we should have a discussion about the best JSON style.
The current free form style is getting out of hand.

Resolving may mean doing more widespread changes across iproute
