Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4120EDC
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfEPSma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:42:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43525 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEPSm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:42:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id i26so5103027qtr.10
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mPTJPHCdEcfhOLEDjB5TktzwKwV9x95msZl3RHRzVqk=;
        b=suAhXJuWOcG9iVswBCew4aAym6rw/nNGXwUSwaxGY7pOOTAtGdIXwB69LSvMawrDdb
         VUqdpTsntzYH3H8dEsVRY2dqinidEZ/00hZbqIEMaBh9QlDVsgcG7sh6iiA1zBhMbZoQ
         /3eS9hsRZda40Yg/D2T8PrSebUwAOeMwf089iqQuXGcil0Hcr32ltfRFc1vHxPv/Er4h
         ZweUrFAKpAva49HMQk4/8ixwGDUBuYsWP/fpEMPMvwZqbhsuB+yBS3ALM+2SAkZTaRjz
         ZnW3zPxXvKGohCNZ7rJTcej1j3SaTLbVNt1SWy/IKH2hXea5Jrd8dE1xdhyT8okdZNQu
         +65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mPTJPHCdEcfhOLEDjB5TktzwKwV9x95msZl3RHRzVqk=;
        b=WVQC2lpQqcaZQdGr1kJy6mYowC6/85ae5PrdwenfE/1oWT9M9ydW0P0OcE9bw8fd5X
         FfxV+bfeaM4dRSkZcAmIYizsNHREiKxqCVjrV1NCajvlQ4ASTCfYbjoGxg9fmTclCfe5
         HlVIMuKBbtKmOZTlXkzw6opcFQL24IP/32UE6X/W0szEtaiJ4FeFecHqxI6lwPBsBobg
         Zw529Pv+IJSHE9Px8WpOtx3UufxKU098AA7783wFG0d6X7bnu74jFDhCj2oKSkxCXWxR
         XZhkecqLjeXLIifX2JGjm8lkDg+q9+cGIXGQQESdUq1g0WUIsz3fDSepofSt66En+g89
         nscQ==
X-Gm-Message-State: APjAAAXwx3JR+BrtpkQVZE+c0Z9bMcolY7yzKxCq0x7W+tMJDX81yK7x
        s44I0Hz58nDID7x3Mme1/0wJoQ==
X-Google-Smtp-Source: APXvYqx+oUrWi+R7Ov+96BLIYt0ijCPoI6zdSWMQp0zbl9UYPS/VCBsilwv81JpUwVAIzKuoo4kEMg==
X-Received: by 2002:a0c:945c:: with SMTP id i28mr21886367qvi.92.1558032148858;
        Thu, 16 May 2019 11:42:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z11sm2548067qki.95.2019.05.16.11.42.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 11:42:28 -0700 (PDT)
Date:   Thu, 16 May 2019 11:42:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net 3/3] Documentation: add TLS offload documentation
Message-ID: <20190516114203.6b8ca20b@cakuba.netronome.com>
In-Reply-To: <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
        <20190515204123.5955-4-jakub.kicinski@netronome.com>
        <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
        <20190516105652.36c81a1a@cakuba.netronome.com>
        <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 11:13:47 -0700, Alexei Starovoitov wrote:
> On Thu, May 16, 2019 at 10:57 AM Jakub Kicinski wrote:
> >
> >   The preferred method of reporting the Layer 4 (TCP) checksum offload
> >   for packets decrypted by the device is to update the checksum field
> >   to the correct value for clear text and report CHECKSUM_UNNECESSARY
> >   or CHECKSUM_COMPLETE computed over clear text. However, the exact
> >   semantics of RX checksum offload when NIC performs data modification
> >   are not clear and subject to change.  
> 
> when host is consuming the tcp stream I don't see the value of
> tcp checksum on top tls.
> In that sense CHECKSUM_UNNECESSARY is fine and no
> need to update checksum field.
> Even in case of sockmap and tcp stream redirect it is still fine.
> Only the tcp payload being redirected to a different tcp socket
> and the headers are gone.
> So imo in all cases CHECKSUM_UNNECESSARY is fine
> even without adjustment to checksum field.

No question that CHECKSUM_UNNECESSARY currently works.  
But it's not "entirely" correct without the header fixup?
Device modifies the data - it should fix up the checksum.

I was trying (unsuccessfully) to hint at the fact that it's okay 
today to leave the checksum be, but at the same time if someone 
is designing new HW or has the ability to fix this up in microcode
I think the TCP csum should be fixed..

Maybe like this?

  The preferred method of reporting the Layer 4 (TCP) checksum offload
  for packets decrypted by the device is to update the checksum field
  to the correct value for clear text and report CHECKSUM_UNNECESSARY
  or CHECKSUM_COMPLETE computed over clear text. 

  Some existing devices may report CHECKSUM_UNNECESSARY without fixing
  the checksum field, which currently functions correctly but is not
  in line with the exact semantics of RX checksum offload. Such devices
  must make sure that RXCSUM offload is always enabled for TLS offloaded
  flows.

> Obviously the hw/firmware should have checked tcp csum before doing decrypt.

Ah, that is definitely worth stating, will add!
