Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2A20E4C
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfEPR5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:57:19 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43746 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEPR5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 13:57:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id z6so2807163qkl.10
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 10:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wWRxwS1VlezAfjE7TIB+nDKIGrHQQLO54jbRH9mQ8FI=;
        b=Yw8EN3ndkDwZYwKwTNJWEdex6JBZnqo5SyjpB9TV8jrgZoXrAhF5q2sz1x+1rBOQFW
         Gj4GSiyLfOLov8bRaZROvBe3k9ayKZ2VcffUVRNMDgyRsR/R+oXoHIitx2FNf29xQX6x
         V2CRDG/hxItmPDQEmyXssUlyPK1EjsQ5hhJQDsctAr094kZzmybNqtvwEBUOxU29dC5J
         r0lWH1ZLgyr9J4G8dFQ66wvac904mS7FCzNQUpsoU8iIDrW/97JR5aZs5SPUGfOeeJSP
         b62T1b8tE1dTPXi4Hqh5+KwkUy8GIBcneB0jdjwX6DGAM8/I3Do+UoTcvNDUgGkXXwjO
         JpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wWRxwS1VlezAfjE7TIB+nDKIGrHQQLO54jbRH9mQ8FI=;
        b=fdQcRbMlM7lpmSZ8LphMuV/CFcCg1vz3hQPNKIz7LfvetU6gb6tlIr7tfIRSpE/+vd
         u6D3KdD9wEsRxp9D++xQVVCwytRYz8Hrh7zWjof488g74ue+fsdVUEg/GLFc/kEHlOzx
         MYkQ9yIuUHji8qEnU/cDIAvGpe8940sgh6yvG13cZgMFMElMsQb5a0YWggZWQ/WBxjfF
         YqqIPXoqpEY9ODr24/9IBMPr5JGQQsCV4bIwenRp+sSyZmk4Uy8heD7jPqD2F7veWOxU
         42OMGgGvI5f2c3Q0XzaIFdbpzIFYhqwAO+9kYwlwtvKQU+6J9YlluqEdHUrCgqInruel
         g6rA==
X-Gm-Message-State: APjAAAUqf5Xnf6Yi6WQQOm9dWYmIcO9VyUg3yQDNfkl8Q3hk0t93yAkZ
        eHTGbu6I8engFbn4mHszNOcrHw==
X-Google-Smtp-Source: APXvYqydczxaz+bS8uO4zhJ+qorVrAOI8JAc60z59k0r3/W8ZwIdaJ4NhIVuS2vXofk4rYmZzEQBlg==
X-Received: by 2002:a37:b607:: with SMTP id g7mr20099493qkf.257.1558029437721;
        Thu, 16 May 2019 10:57:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s185sm2697186qkf.74.2019.05.16.10.57.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 10:57:17 -0700 (PDT)
Date:   Thu, 16 May 2019 10:56:52 -0700
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
Message-ID: <20190516105652.36c81a1a@cakuba.netronome.com>
In-Reply-To: <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
        <20190515204123.5955-4-jakub.kicinski@netronome.com>
        <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 09:08:52 +0000, Boris Pismenny wrote:
> > diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
> > new file mode 100644
> > index 000000000000..32fecb3fbc4c
> > --- /dev/null
> > +++ b/Documentation/networking/tls-offload.rst
> > @@ -0,0 +1,438 @@
> > +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +
> > +==================
> > +Kernel TLS offload
> > +==================
> > +
> > +Kernel TLS operation
> > +====================
> > +
> > +Linux kernel provides TLS connection offload infrastructure. Once a TCP
> > +connection is in ``ESTABLISHED`` state userspace can enable the TLS Upper
> > +Layer Protocol (ULP) and install the cryptographic connection state.
> > +For details regarding the user-facing interface refer to the TLS
> > +documentation in :ref:`Documentation/networking/tls.rst <kernel_tls>`.
> > +
> > +``ktls`` can operate in three modes:
> > +
> > + * Software crypto mode (TLS_SW) - CPU handles the cryptography.
> > +   In most basic cases only crypto operations synchronous with the CPU
> > +   can be used, but depending on calling context CPU may utilize
> > +   asynchronous crypto accelerators. The use of accelerators introduces extra
> > +   latency on socket reads (decryption only starts when a read syscall
> > +   is made) and additional I/O load on the system.
> > + * Packet-based NIC offload mode (TLS_HW) - the NIC handles crypto
> > +   on a packet by packet basis, provided the packets arrive in order.
> > +   This mode integrates best with the kernel stack and is described in detail
> > +   in the remaining part of this document
> > +   (``ethtool`` flags ``tls-hw-tx-offload`` and ``tls-hw-rx-offload``).
> > + * Full TCP NIC offload mode (TLS_HW_RECORD) - mode of operation where
> > +   NIC driver and firmware replace the kernel networking stack
> > +   with its own TCP handling, it is not usable in production environments
> > +   making use of the Linux networking stack for example any firewalling
> > +   abilities or QoS and packet scheduling (``ethtool`` flag ``tls-hw-record``).
> > +
> > +The operation mode is selected automatically based on device configuration,
> > +offload opt-in or opt-out on per-connection basis is planned to be added
> > +in the future.  
> 
> I see no reason to document future intentions here in docs. Unless you 
> want to have a full blown list scattered over this document, please 
> remove it.

Sure, I will implement it soonish, and I will have to update this
section one way or the other :)

> > +TX
> > +--
> > +
> > +At a high level user write requests are turned into a scatter list, the TLS ULP
> > +intercepts them, inserts record framing, if non-offloaded encrypts them  
> 
> Maybe it would be best to describe how this is done in each mode?
> In particular mentioning non-offloaded, and following with what happens 
> on offloaded mode is confusing.

Ack, will do.  FWIW I think it's clear when you can see the SVG
graphics.

> You should also note what fields of the frame are filled with actual 
> meaningful data, and what is just a buffer to be filled by hardware.
> Being as explicit as possible will prevent problems in the future.

This is an overview section, I will add the details in the section
below.

> > +and then hands the modified scatter list to the TCP layer. From this point on
> > +the TCP stack proceeds as normal. When packets reach a device driver,
> > +the driver will mark the packets for crypto offload based on the socket
> > +the packet is attached to, and send them to the HW for encryption and
> > +transmission.  
> 
> Maybe we should mention something about software fallback here?

I will beef up the information in the detailed sections, but perhaps
not in the overview.

> > +
> > +RX
> > +--
> > +
> > +On the receive side if the device handled decryption and authentication
> > +successfully, the driver will set the decrypted bit in the associated
> > +:c:type:`struct sk_buff <sk_buff>`. The packets reach the TCP stack and
> > +are handled normally. ``ktls`` is informed when data is queued to the socket
> > +and the ``strparser`` mechanism is used to delineate the records. Upon read
> > +request, records are retrieved from the socket and passed to decryption routine.
> > +If device decrypted all the segments of the record the decryption is skipped,
> > +otherwise software path handles decryption.  
> 
> Maybe we should mention that decryption is per packet, as an skb can 
> represent a GRO skb as well.
> Also, we should mention that the GRO layer doesn't coalesce plaintext 
> with ciphertext.

This is stated in the detailed section.

> > +
> > +.. kernel-figure::  tls-offload-layers.svg
> > +   :alt:	TLS offload layers
> > +   :align:	center
> > +   :figwidth:	28em
> > +
> > +   Layers of Kernel TLS stack

> > +Normal operation
> > +================
> > +
> > +At the minimum the device maintains the following state for each connection, in
> > +each direction:
> > +
> > + * crypto secrets (key, iv, salt)
> > + * crypto processing state (partial blocks, partial authentication tag, etc.)
> > + * record metadata (sequence number, processing offset and length)
> > + * expected TCP sequence number
> > +
> > +There are no guarantees on record length or record segmentation. In particular
> > +segments may start at any point of a record and contain any number of records.
> > +Assuming segments are received in order, the device should be able to perform
> > +crypto operations and authentication regardless of segmentation. For this
> > +to be possible device has to keep small amount of segment-to-segment state.
> > +This includes at least:
> > +
> > + * partial headers (if a segment carried only a part of the TLS header)
> > + * partial data block
> > + * partial authentication tag (all data had been seen but part of the
> > +   authentication tag has to be written or read from the subsequent segment)
> > +
> > +Record reassembly is not necessary for TLS offload. If the packets arrive
> > +in order the device should be able to handle them separately and make
> > +forward progress.

> > +RX
> > +--
> > +
> > +Before a packet is DMAed to the host (but after NIC's embedded switching
> > +and packet transformation functions) the device performs a 5-tuple lookup
> > +to find any TLS connection the packet may belong to (technically a 4-tuple
> > +lookup is sufficient - IP addresses and TCP port numbers, as the protocol
> > +is always TCP). If connection is matched device confirms if the TCP sequence
> > +number is the expected one and proceeds to TLS handling (record delineation,
> > +decryption, authentication for each record in the packet).
> > +
> > +If decryption or authentication fails for any record in the packet, the packet
> > +must be passed to the host as it was received on the wire. This means packets  
> 
> This is not normal mode of operation, but rather an error handling 
> description. Please try to describe only the good flow here, and leave 
> the errors for a separate section.

Normal as device is in sync with the stream vs the Resync handling
section.  It is not clear from the name, you're right, I will try
to split further and see how it turns out.

> > +should not be modified "in place". Splitting segments to handle partial
> > +decryption is not advised. In other words either all records in the packet
> > +had been handled successfully and authenticated or the packet has to be passed
> > +to the host as it was on the wire. The device communicates whether the packet
> > +was successfully decrypted in the per-packet context (descriptor) passed
> > +to the host.
> > +
> > +The device leaves the record framing unmodified, the stack takes care of
> > +record decapsulation.
> > +
> > +Upon reception of a TLS offloaded packet, the driver sets
> > +the :c:member:`decrypted` mark in :c:type:`struct sk_buff <sk_buff>`
> > +corresponding to the segment. Networking stack makes sure decrypted
> > +and non-decrypted segments do not get coalesced and takes care of partial
> > +decryption.  
> 
> Please mention checksum handling as well. It would not make any sense to 
> use CHECKSUM_COMPLETE here. Instead, CHECKSUM_UNNECESSARY should be 
> expected.

I was on the fence about adding the checksum info.  I had the feeling
that even for CHECKSUM_UNNECESSARY it's fairly strange to pass mangled
packets.  Looking at skbuff.h the checksum doc states:

 * CHECKSUM_UNNECESSARY:
 *
 *   The hardware you're dealing with doesn't calculate the full checksum
 *   (as in CHECKSUM_COMPLETE), but it does parse headers and verify checksums
 *   for specific protocols. For such packets it will set CHECKSUM_UNNECESSARY
 *   if their checksums are okay. skb->csum is still undefined in this case
 *   though. A driver or device must never modify the checksum field in the
 *   packet even if checksum is verified.

My reading of the last sentence is: the checksum in the packet must
still be correct (based on the context in which this comment was
written, which was in the days of UDP tunnel offload work).  
IOW UNNECESSARY doesn't mean "don't look at the checksum field", 
it means "I've looked at the checksum field and it's correct".

IMHO CHECKSUM_UNNECESSARY without correcting the TCP header csum field
is only slightly less broken than CHECKSUM_COMPLETE with pre-decrypt
csum and without fixing the TCP header.

Not to mention the fact that users may disable RXCSUM offload.

Maybe the least broken option is to fix the TCP header csum and pass
CHECKSUM_COMPLETE of the encrypted data?  But then again clearly the HW
has parsed the packet (voiding the non-ossification gain), and we won't
be doing tunnelling on clear text..

So CHECKSUM_UNNECESSARY "would do".

This is a long winded way of saying - I didn't see the perfect solution
here, so I thought it's better not to codify it in this doc.  But
perhaps I can phrase it tentatively enough.  How about:


  The preferred method of reporting the Layer 4 (TCP) checksum offload
  for packets decrypted by the device is to update the checksum field
  to the correct value for clear text and report CHECKSUM_UNNECESSARY
  or CHECKSUM_COMPLETE computed over clear text. However, the exact
  semantics of RX checksum offload when NIC performs data modification
  are not clear and subject to change.
