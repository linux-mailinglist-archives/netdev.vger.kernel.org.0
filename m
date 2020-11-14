Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F72B2D0B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 13:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgKNMOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 07:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgKNMOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 07:14:16 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F968C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:14:16 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id p12so14173468ljc.9
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=7VjaBMnVvzc7Shq6LTos+jBHCC8oql/uRCuENVfXe5s=;
        b=XuYCoTXcSAWYNjF1UmPDA5Z3xpRPisuFHfWYsozy09/CpUrFsxus1odUhqvBgUaxrJ
         wzHyJaPWlmY4Si5ikiWkdxPTp/bhum5zpivCpNQN3leJkiyJsnvtm3BwAAgr4hdkDczb
         7JR2+cCj2pUw7oGPCLlHIdbQnZukx+hjXTHjlzUT2+TJukg/Gqg6XKo8AFAYGbj4XzEe
         ohfQIsQA7l0RBISDqZZFW8TfAuTD1AJI4id5zTNsxCfXLkLyL8eDchRc3W/DSF1imlwl
         VeScEnPnND59Ew2R3HE7oTfsyQmRKN2uqUWUUoOFKCqUQfjvD5eT6SfSKfPNdHX2kgf6
         j7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=7VjaBMnVvzc7Shq6LTos+jBHCC8oql/uRCuENVfXe5s=;
        b=phWeFnPMjUIogigeAjOpynHaIj8WTSs63v07IrcvjwvBDSkuGIpAa226el+fVCpFjU
         lNts5o5dHPt1ecDkadNkkXzK8wyUad0/fZ9x6ECWwZE5DIAmPW+yPAgHKzXQqhrdd89A
         OvG2gocDNtFf1tvwsPLGlQRtP66Tm5UDm3eYtbtEBMP7Y0+FIUeBaqoeBe6VL0VoES+b
         VQ/dObAnzRvTs8hF0zO9klT05YZk4la3Ev3v4ZOlvMIJhxkx7SyBIWiSUqde+H45i/cd
         j7XVWe3fK/jTiXVBNkiq8h5/vjTrQ6ihUqzIj1xffW5PiqObqsTsLDCu02oIorD83ldb
         QmLw==
X-Gm-Message-State: AOAM531bOu3CefeBcs/oFBPTv+LWiAUMEaXDD9cjM4M5cduZtL3QGVEw
        lUfm9QHjquxCPjFo7bx56hOKGA==
X-Google-Smtp-Source: ABdhPJxb86BrGpKLOJQ7YuvgD4HFDBecSLzHXOxEP2bx8nEAPNt0hYIm4SPCrUH6WsI+GEivukywMw==
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr3017079ljm.273.1605356054804;
        Sat, 14 Nov 2020 04:14:14 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id s21sm2010626ljj.101.2020.11.14.04.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 04:14:14 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Sat, 14 Nov 2020 12:29:32 +0100
Message-Id: <C72Y9Y96O02K.2J4BFT8MY7S6U@wkz-x280>
In-Reply-To: <20201114020851.GW1480543@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Nov 14, 2020 at 4:08 AM CET, Andrew Lunn wrote:
> Hi Tobias
>
> > +/**
> > + * enum dsa_cmd - DSA Command
> > + * @DSA_CMD_TO_CPU: Set on packets that were trapped or mirrored to
> > + *     the CPU port. This is needed to implement control protocols,
> > + *     e.g. STP and LLDP, that must not allow those control packets to
> > + *     be switched according to the normal rules.
>
> Maybe we want to mention that this only makes sense for packets
> egressing the switch?
>
> > + * @DSA_CMD_FROM_CPU: Used by the CPU to send a packet to a specific
> > + *     port, ignoring all the barriers that the switch normally
> > + *     enforces (VLANs, STP port states etc.). "sudo send packet"
>
> This only make sense for packets ingressing the switch. The
> TO_CPU/FROM_CPU kind of make that clear but..

Honestly yes, I think it is pretty clear. But I am happy to change it
if you have any particular formulation you would like in there.

> > + * @DSA_CMD_TO_SNIFFER: Set on packets that where mirrored to the CPU
> > + *     as a result of matching some user configured ingress or egress
> > + *     monitor criteria.
> > + * @DSA_CMD_FORWARD: Everything else, i.e. the bulk data traffic.
>
> I assume this can be used in both direction?

Yes. I can add a sentence about that.

> > + *
> > + * A 3-bit code is used to relay why a particular frame was sent to
> > + * the CPU. We only use this to determine if the packet was mirrored
> > + * or trapped, i.e. whether the packet has been forwarded by hardware
> > + * or not.
>
> Maybe add that, not all generations support all codes.

Not sure I have that information. The oldest chipset I've worked with
is Jade (6095/6185) and in that datasheet the TO_CPU tag is not even
documented. From Opal+(6097) all the way through Agate, Peridot, and
Amethyst, the definitions have not changed from what I can see?

> > +			/* Remote management frames originate from the
> > +			 * switch itself, there is no DSA port for us
> > +			 * to ingress it on (the port field is always
> > +			 * 0 in these tags).
>
> If/when we get around to implementing this, i doubt we will ingress it
> like a frame. It will get picked up here and probably added to some
> queue and a thread woken up. So maybe just say, not implemented yet,
> so drop it.

v1 actually had a sentence about this :) I can put it back.

> > +			 */
> > +			return NULL;
> > +		case DSA_CODE_ARP_MIRROR:
> > +		case DSA_CODE_POLICY_MIRROR:
> > +			/* Mark mirrored packets to notify any upper
> > +			 * device (like a bridge) that forwarding has
> > +			 * already been done by hardware.
> > +			 */
> > +			skb->offload_fwd_mark =3D 1;
> > +			break;
> > +		case DSA_CODE_MGMT_TRAP:
> > +		case DSA_CODE_IGMP_MLD_TRAP:
> > +		case DSA_CODE_POLICY_TRAP:
> > +			/* Traps have, by definition, not been
> > +			 * forwarded by hardware, so don't mark them.
> > +			 */
>
> Humm, yes, they have not been forwarded by hardware. But is the
> software bridge going to do the right thing and not flood them? Up

The bridge is free to flood them if it wants to (e.g. IGMP/MLD
snooping is off) or not (e.g. IGMP/MLD snooping enabled). The point
is, that is not for a lowly switchdev driver to decide. Our job is to
relay to the bridge if this skb has been forwarded or not, the end.

> until now, i think we did mark them. So this is a clear change in
> behaviour. I wonder if we want to break this out into a separate
> patch? If something breaks, we can then bisect was it the combining
> which broke it, or the change of this mark.

Since mv88e6xxx can not configure anything that generates
DSA_CODE_MGMT_TRAP or DSA_CODE_POLICY_TRAP yet, we do not have to
worry about any change in behavior there.

That leaves us with DSA_CODE_IGMP_MLD_TRAP. Here is the problem:

Currenly, tag_dsa.c will set skb->offload_fwd_mark for IGMP/MLD
packets, whereas tag_edsa.c will exempt them. So we can not unify the
two without changing the behavior of one.

I posit that tag_edsa does the right thing, the packet has not been
forwarded, so we should go with that.

This is precisely the reason why we want to unify these! :)

> I will try to test this on my hardware, but it is probably same as
> your 6390X and 6352.

Thank you!
