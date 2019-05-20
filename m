Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2C240D3
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfETTCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 15:02:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42061 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfETTCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 15:02:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id j53so17581180qta.9
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 12:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rSimkDm7XMtWGp3CbOhN2eq+HKNAn7462rh6jCkBk6Q=;
        b=HIM88p6vgQ9IEbg4sS/gShSZpe4RFYUyRtMREj36fVAyInhSa8kek9M+khgOl1n8rV
         G0qtGjjm6X0IZuS5lS64lZbE8pTbGXKNlgXzt83mSiPFmtcpukF/RFJ5oNJvBc2oua5Z
         z68UYK1qu9KmGuI0T9wusMJFSKcub3fJWokfcGsOiOCXOcQAqZgqfTk3G1r3H5615ofw
         DP43lSHBGekugvLloGEpWpQwggKRDD4Z+78spy/lfyIxo8aRsXOT+8UKmk/ftm3qkZaL
         phCqaPPo4cSBSY0Qkp8PRv9UOPj8aqC+Pk1EDPlT4G5vKS7HbWn02s4GRgHP49G+t8us
         Rukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rSimkDm7XMtWGp3CbOhN2eq+HKNAn7462rh6jCkBk6Q=;
        b=Htz8vfLO8l/VUNzaGNrtP1D5xD+vyXdD4Qb33mVhrtWBnPSLrWot15OI9GgLaF3uww
         ck0ewL6Xr9lHuHZQ4SPyKBtKhSsfkjJtoxR8Ce5cuOMmRifRaVbL1smaH+bvqhbIrtF7
         YXvQSMSEuD8Oh6boSevIN4xzdL+UAAltf23XGDPMkHpUaBnShIu+zE7FuPo8qCHBDTYQ
         l56Zw2eEaTfpZlnRg8sDvXCZrWvGverXP/NLCuOy/36K/WOURv/3zdScTp8DEnG9bbqS
         JHCYc8WyiUlIzmIa87IIXSrDsIMO0PjP0QjLKLgxZW+uJGIrnwHwgUe1M1hDap3ehMGW
         S20g==
X-Gm-Message-State: APjAAAUcLysQpaOcCF4MH8EySVk/1pLvGdYDHD2JsXyLTRgVQ/PAQQHb
        bEhIZO6cmpfa17LcLWE876vrSg==
X-Google-Smtp-Source: APXvYqywnZPsAqbhTw4YweG8UtB2jKgeRWfzTPlFUv0lyPbs/OxJNndVXTYGaW3wwTuW0Pms0EGiGQ==
X-Received: by 2002:ac8:2617:: with SMTP id u23mr64484715qtu.141.1558378967158;
        Mon, 20 May 2019 12:02:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v195sm9656912qka.28.2019.05.20.12.02.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 20 May 2019 12:02:46 -0700 (PDT)
Date:   Mon, 20 May 2019 12:02:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net 3/3] Documentation: add TLS offload documentation
Message-ID: <20190520120213.35d28f2a@cakuba.netronome.com>
In-Reply-To: <f9e09ac2-ea5e-5b76-8aaf-ae50b21d3162@mellanox.com>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
        <20190515204123.5955-4-jakub.kicinski@netronome.com>
        <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
        <20190516105652.36c81a1a@cakuba.netronome.com>
        <f9e09ac2-ea5e-5b76-8aaf-ae50b21d3162@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 May 2019 06:24:36 +0000, Boris Pismenny wrote:
> On 5/16/2019 8:56 PM, Jakub Kicinski wrote:
> > On Thu, 16 May 2019 09:08:52 +0000, Boris Pismenny wrote:  
> >>> diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
> >>> new file mode 100644
> >>> index 000000000000..32fecb3fbc4c
> >>> --- /dev/null
> >>> +++ b/Documentation/networking/tls-offload.rst
> >>> @@ -0,0 +1,438 @@  
> 
> >>> +RX
> >>> +--
> >>> +
> >>> +Before a packet is DMAed to the host (but after NIC's embedded switching
> >>> +and packet transformation functions) the device performs a 5-tuple lookup
> >>> +to find any TLS connection the packet may belong to (technically a 4-tuple
> >>> +lookup is sufficient - IP addresses and TCP port numbers, as the protocol
> >>> +is always TCP). If connection is matched device confirms if the TCP sequence
> >>> +number is the expected one and proceeds to TLS handling (record delineation,
> >>> +decryption, authentication for each record in the packet).
> >>> +
> >>> +If decryption or authentication fails for any record in the packet, the packet
> >>> +must be passed to the host as it was received on the wire. This means packets  
> >>
> >> This is not normal mode of operation, but rather an error handling
> >> description. Please try to describe only the good flow here, and leave
> >> the errors for a separate section.  
> > 
> > Normal as device is in sync with the stream vs the Resync handling
> > section.  It is not clear from the name, you're right, I will try
> > to split further and see how it turns out.
> 
> But it is not normal, as decryption or authentication failure are not
> normal. Such a packet is bound to terminate the TLS connection and
> forcing hardware to re-encrypt it is too strict IMO. Instead, I think
> that as long as the driver can provide the stack with the original
> packet in this case, then it is good enough.

Sure, you can try to recover original packet in the driver, if device
provides you with precise enough information (remember there can be
multiple records in a segment).

> >>> +should not be modified "in place". Splitting segments to handle partial
> >>> +decryption is not advised. In other words either all records in the packet
> >>> +had been handled successfully and authenticated or the packet has to be passed
> >>> +to the host as it was on the wire. The device communicates whether the packet
> >>> +was successfully decrypted in the per-packet context (descriptor) passed
> >>> +to the host.
> >>> +
> >>> +The device leaves the record framing unmodified, the stack takes care of
> >>> +record decapsulation.
> >>> +
> >>> +Upon reception of a TLS offloaded packet, the driver sets
> >>> +the :c:member:`decrypted` mark in :c:type:`struct sk_buff <sk_buff>`
> >>> +corresponding to the segment. Networking stack makes sure decrypted
> >>> +and non-decrypted segments do not get coalesced and takes care of partial
> >>> +decryption.  
> >>
> >> Please mention checksum handling as well. It would not make any sense to
> >> use CHECKSUM_COMPLETE here. Instead, CHECKSUM_UNNECESSARY should be
> >> expected.  
> > 
> > I was on the fence about adding the checksum info.  I had the feeling
> > that even for CHECKSUM_UNNECESSARY it's fairly strange to pass mangled
> > packets.  Looking at skbuff.h the checksum doc states:
> > 
> >   * CHECKSUM_UNNECESSARY:
> >   *
> >   *   The hardware you're dealing with doesn't calculate the full checksum
> >   *   (as in CHECKSUM_COMPLETE), but it does parse headers and verify checksums
> >   *   for specific protocols. For such packets it will set CHECKSUM_UNNECESSARY
> >   *   if their checksums are okay. skb->csum is still undefined in this case
> >   *   though. A driver or device must never modify the checksum field in the
> >   *   packet even if checksum is verified.
> > 
> > My reading of the last sentence is: the checksum in the packet must
> > still be correct (based on the context in which this comment was
> > written, which was in the days of UDP tunnel offload work).
> > IOW UNNECESSARY doesn't mean "don't look at the checksum field",
> > it means "I've looked at the checksum field and it's correct".
> >   
> 
> This interpretation is far from the text - "A driver or device must 
> never modify the checksum field". If it is correct, then it needs to be 
> fixed. 

Context in which these words were written matters.

> Moreover, one could consider the checksum field to be correct,
> because the encryption can be reverted by the socket/driver on demand.

Sockets (and ULPs) are above TCP checksums.

> AFAIU, CHECKSUM_UNNECESSARY is exactly for cases like this, where the 
> hardware might have mangled the known payload/headers. But it verified 
> the checksum before doing so. As a result, checksum fields might be 
> wrong (but unmodified), and setting CHECKSUM_UNNECESSARY informs the 
> network stack that it can trust this packet.

If I redirect a packet with CHECKSUM_UNNECESSARY it goes out as is, no
checksum recalculation.  The checksum should be valid.

> > IMHO CHECKSUM_UNNECESSARY without correcting the TCP header csum field
> > is only slightly less broken than CHECKSUM_COMPLETE with pre-decrypt
> > csum and without fixing the TCP header.
> > 
> > Not to mention the fact that users may disable RXCSUM offload.  
> 
> It does not matter if the user disables RXCSUM, because the HW *must* do 
> checksum validation for TLS Rx offload regardless of this setting.

Yes, that's what I'm saying, regardless of RXCSUM setting HW has
to do validation, and in case driver is passing frames with a broken
checksum driver has to feed CHECKSUM_UNNECESSARY to the stack, again,
regardless of RXCSUM.

> > Maybe the least broken option is to fix the TCP header csum and pass
> > CHECKSUM_COMPLETE of the encrypted data?  But then again clearly the HW
> > has parsed the packet (voiding the non-ossification gain), and we won't
> > be doing tunnelling on clear text..  
> 
> I don't see the point of doing this. TLS Rx offload is for L4 
> *endpoints*, not for L3 routers. As such, the socket will receive the 
> packet and process it as part of a TCP stream, thereafter the data can 
> be forwarded.
> The socket must perform the TCP checksum verification, and 
> CHECKSUM_UNNECESSARY makes all of this work without complex changes.

Yes, as I said it works today.  But I'm not documenting stuff that
happens to work today as the way things should be.  There are routable
L4 data modifications which _have to_ fix the checksum (tunnels).
I strongly prefer to have the devices behave the same for all L4 data
modification, instead of trying to define this behaviour on offload by
offload bases.  I only leads to confusion and conflicts when two
offloads are in effect and have different expected behaviour.

> > 
> > So CHECKSUM_UNNECESSARY "would do".
> > 
> > This is a long winded way of saying - I didn't see the perfect solution
> > here, so I thought it's better not to codify it in this doc.  But
> > perhaps I can phrase it tentatively enough.  How about:
> > 
> > 
> >    The preferred method of reporting the Layer 4 (TCP) checksum offload
> >    for packets decrypted by the device is to update the checksum field
> >    to the correct value for clear text and report CHECKSUM_UNNECESSARY
> >    or CHECKSUM_COMPLETE computed over clear text. However, the exact
> >    semantics of RX checksum offload when NIC performs data modification
> >    are not clear and subject to change.
> >   
> 
> I disagree with this. Modifying the original checksum field erases the 
> original checksum, which might not be recoverable later.

Checksum covers the data in the packet, if it was valid on arrival to
the device, and was recalculated to match the modified data - what do
you want to recover and to what end?
