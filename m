Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD61048BA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKUCto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:49:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51544 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKUCtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 21:49:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id g206so1702270wme.1
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 18:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5cvbvE6GE7g9/dXzyiGB/2f+wTts3umRMXHbDNpPbGc=;
        b=GqEJGaAGEs1CgwCl6iqi+d88d0emEdO60JTgxsazyEn3mNoriElullE16TlTXGgXlN
         WI2jLus89YZvt4lGSRyRpJ3K/GVg1hgMqfOaky870B2/roRv90k1gS3K5gOCeQ1rLIPa
         0Gk+Xv3iOc+wTjQXlsEybMLWZojHgZwIKmvD+N7DuAsHAROh3M7g6mTftBeASFrk3iwz
         rlfuJFHdxJMTSo6276lbTf2U/sdOOXGF+rAJwSgCvso4nN9IRHkks4WZDTCzUZ7Dhu6X
         RgseWox+W3tiwGoD7ASLi6CPHkFqjBqAQBSWEuSg2mDyscpic8NDdduYWbAe6k3x1JRv
         HHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5cvbvE6GE7g9/dXzyiGB/2f+wTts3umRMXHbDNpPbGc=;
        b=RCwQliTvJ4Vekd+8lCrcVi8ASp2U88gQKkksuePN7KYGDnC9XhUUSKyi60TLw3WFxk
         QdB5M75YfWZH5WSL8MuASOHq7Fa4zftWl/C/mbC3ZZu5uLKUoH3Rir6OjuAu5LVftl75
         asXu5c5ETet6ssEFcrNyfBEMLjoaY0+VM4Xu5HCpx48EUjBbHUcnRHbrOn1l2vPOjWHI
         c1lzBw0z6MN/+qNxRqA7VzHR7zLSWDZNaSkrKLM+NLaIdxo79d5onbABhpe9XLyTln0z
         lTl4iHbfjmmQqahB71MmEm/QIqzMX3jgyl9HpEZKWxK1NtHlOPdTSh02dXoCH2ylWrTw
         27FA==
X-Gm-Message-State: APjAAAWw0c/kPtbWW5s2T0HhlCXrbq9ovmZWI1B+rfp8bJ1qiWj/1Ac/
        1xmguLqO1Clqaw1RJ39rpM2vSF7qrtbPXF7uGEOmBw==
X-Google-Smtp-Source: APXvYqzwZdOUiijLzdQC2YcAbrwpWA40m8yTNnD3T6cpmG7xpD/bbhz4Sia/3Itives9a2lATJGK/AL9GF7rVfCYKYc=
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr7310283wmb.142.1574304580009;
 Wed, 20 Nov 2019 18:49:40 -0800 (PST)
MIME-Version: 1.0
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com> <20191120164137.6f66a560@cakuba.netronome.com>
In-Reply-To: <20191120164137.6f66a560@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 21 Nov 2019 08:19:29 +0530
Message-ID: <CA+sq2CdbXgdsGjG-+34mNztxJ-eQkySB6k2SumkXMUkp7bKtwQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/16] Documentation: net: octeontx2: Add RVU HW and
 drivers overview.
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 6:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
>
> Please double check this renders the way you expect. You may want to
> add empty lines before lists.

Okay, will recheck.

> > +
> > +=============================================
> > +Marvell OcteonTx2 RVU Kernel Drivers
> > +=============================================
>
> Shouldn't these lines be the length of the text?

Haven't done this documentation before, will other files and fix if necessary,

> > +
> > +Resource provisioning examples
> > + - A PF/VF with NIX-LF & NPA-LF resources works as a pure network device
> > + - A PF/VF with CPT-LF resource works as a pure cyrpto offload device.
>
> s/cyrpto/crypto/

Thanks, will fix.

> > +
> > +.. kernel-figure::  resource_virtualization_unit.svg
> > +   :alt:     RVU
> > +   :align:   center
> > +   :figwidth:        60em
> > +
> > +   RVU HW block connectivity
>
> The diagram isn't really bringing much value if you ask me. The text in
> the last section is quite a bit better. Perhaps show packet flow?

If someone doesn't want read the text fully, then i thought the
diagram would help
in getting an idea about the RVU HW block connectivity.

> > +Firmware setups following stuff before kernel boots
> > + - Enables required number of RVU PFs based on number of physical links.
> > + - Number of VFs per PF are either static or configurable at compile time.
>
> compile time of the firmware?

Yes, firmware.

>
> > +   Based on config, firmware assigns VFs to each of the PFs.
> > + - Also assigns MSIX vectors to each of PF and VFs.
> > + - These are not changed after kernel boot.
>
> Can they be changed without FW rebuild?

No, they cannot be.

>
> Thanks for the description, I was hoping you'd also provide more info
> on how the software componets of the system fit together. Today we only
> have an AF driver upstream. Without the PF or VF drivers the card is
> pretty much unusable with only the upstream drivers, right?
>

I will start submitting netdev drivers (PF and VF) right after this patchset.
And just FYI this is not a NIC card, this HW is found only on the ARM64
based OcteonTX2 SOC.

> There is a bunch of cgx_* exports in the AF module, which seem to have
> no uses upstream, too (they are only called from rvu_cgx.c which is
> compiled into the same module).

In the very first patchset submitted CGX and AF drivers were separate modules.
Based on suggestions we merged both of them into a single module.
The export symbols are not needed, i will submit a separate patch to
clean them up.
