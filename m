Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0A21139
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 02:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfEQAWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 20:22:24 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35058 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfEQAWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 20:22:24 -0400
Received: by mail-qk1-f195.google.com with SMTP id c15so3485581qkl.2
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/I26FM2SvHRFoqfHOyv0xSVQHq8qhhxCvyCkDGhgzkY=;
        b=y8TAZkCESRmF8mUBp1lQC6/ENSsqWGehzBGK13K50728zPgy4pw6a9al18ttHBVr6v
         vi2na+m8l1pZCB92uu6SXwRArizx05NAIOHBpjUIfvdDWaGbYN9eh7cDXuZ5WbSVzeQp
         w6RlV5j5vHrpREvTPOC4A5Zib5v03fceoHTr94VzbR9Xej64QKKUIkPTDKfKhhHwSqTC
         cM/ex/4XV8BANd2nhBrTPgd/vKCjqnCscG3ESqtvOKvarNtIU4lmYph7bOwnCEWxHU5q
         KgFuCjsFXkLkhg5n6zmowaoaVFDEM7o6aem1fS4pSxfa/nq40w52wHw9J4WMq4ycZRs3
         K0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/I26FM2SvHRFoqfHOyv0xSVQHq8qhhxCvyCkDGhgzkY=;
        b=VFypsCvpKnQmhsFxW2SXy+u1+jqBKTt0fwWsuNiqPv5XZsYyE9eruwLkLUHScy8AX9
         XC/Ek3RcAcbONwXbWdI3oWYg7qsQPPiNgwP2ptIu8SqB/Dgsg6SPUSZ7v5ci/FavgDPT
         +wlFfzbyjVopP3joN81uI50pWldVAinb0pNhU1B0l4ncfknEe6SqJx1TA/1R77bVVkep
         CwmCkBbXeV/EkA4z03kN+HvThPWx4igWw2JSy+UPpxCV1eJlj0UE2geYSUvB5Y1vwwV9
         8kcABXmNJ9MAWe5+4uI0bBzedVqYwnA5VQysWkUvMSS8YPhR1wpqlV1+LcY95DiU0UoM
         9xBQ==
X-Gm-Message-State: APjAAAUVeCa/Xbv2iqrdGv6fuJbzGE93Ddf5hApiege12Hp/mUPXrIqV
        3NcBSUrFgXDMYTQkttKY/lHyYw==
X-Google-Smtp-Source: APXvYqwQyXsy9Zks0iAXj6VwMqFnoBYopbRaa0pfiUo4CeW/x/0uTV8SnGfjwsFBmlaMPu3Ucg6tZw==
X-Received: by 2002:a37:6043:: with SMTP id u64mr30060069qkb.9.1558052045212;
        Thu, 16 May 2019 17:14:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k63sm2999366qkf.97.2019.05.16.17.14.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 17:14:04 -0700 (PDT)
Date:   Thu, 16 May 2019 17:13:37 -0700
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
Message-ID: <20190516171337.1447fb81@cakuba.netronome.com>
In-Reply-To: <20190516225255.4c5wctzh6sae5e4y@ast-mbp>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
        <20190515204123.5955-4-jakub.kicinski@netronome.com>
        <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
        <20190516105652.36c81a1a@cakuba.netronome.com>
        <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
        <20190516114203.6b8ca20b@cakuba.netronome.com>
        <20190516193257.2edzss37shzfrm6v@ast-mbp>
        <CAJpBn1xRd6mszXGQ87dYegnB530Bf3NWmmU1mYguRUAFsX7ivw@mail.gmail.com>
        <20190516225255.4c5wctzh6sae5e4y@ast-mbp>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 15:52:58 -0700, Alexei Starovoitov wrote:
> On Thu, May 16, 2019 at 02:39:03PM -0700, Jakub Kicinski wrote:
> > On Thu, 16 May 2019 12:32:59 -0700, Alexei Starovoitov wrote:  
> > > On Thu, May 16, 2019 at 11:42:03AM -0700, Jakub Kicinski wrote:  
> > > > On Thu, 16 May 2019 11:13:47 -0700, Alexei Starovoitov wrote:  
> > > > > On Thu, May 16, 2019 at 10:57 AM Jakub Kicinski wrote:  
> > > > > >
> > > > > >   The preferred method of reporting the Layer 4 (TCP) checksum offload
> > > > > >   for packets decrypted by the device is to update the checksum field
> > > > > >   to the correct value for clear text and report CHECKSUM_UNNECESSARY
> > > > > >   or CHECKSUM_COMPLETE computed over clear text. However, the exact
> > > > > >   semantics of RX checksum offload when NIC performs data modification
> > > > > >   are not clear and subject to change.  
> > > > >
> > > > > when host is consuming the tcp stream I don't see the value of
> > > > > tcp checksum on top tls.
> > > > > In that sense CHECKSUM_UNNECESSARY is fine and no
> > > > > need to update checksum field.
> > > > > Even in case of sockmap and tcp stream redirect it is still fine.
> > > > > Only the tcp payload being redirected to a different tcp socket
> > > > > and the headers are gone.
> > > > > So imo in all cases CHECKSUM_UNNECESSARY is fine
> > > > > even without adjustment to checksum field.  
> > > >
> > > > No question that CHECKSUM_UNNECESSARY currently works.
> > > > But it's not "entirely" correct without the header fixup?
> > > > Device modifies the data - it should fix up the checksum.  
> > >
> > > I think it's an interesting angle to discuss.
> > > Though ktls in hw is done per packet many key fields of ip/tcp headers
> > > are fully processed.  
> > 
> > Checksum has been validated, 5-tuple extracted and sequence number
> > confirmed.  That's not that much, aRFS will do most of it.
> >   
> > > socket is selected and payload is decrypted.  
> > 
> > To be clear socket is not assigned to the skb by the offload today.  
> 
> but it can cause issues...
> if anything after driver tweaks ip header the decrypted payload will go
> into wrong socket ?

Yes :(  Going to the wrong socket is king of a less bad version 
of leaving the box due to forwarding or redirect :S

> > I only realized it after replying to your other statements but the key
> > is that the device and the kernel are still tightly coupled by the
> > decrypted bit set in the descriptor and then the skb.  So there is no
> > wire-level middlebox going on here.
> >   
> > > imo it is better to state that such headers have been 'consumed' by hw.
> > > Where 'consumed' would mean that hw did what network layering suppose to do
> > > and the stack should not look at them (because they can contain garbage).
> > > (in that sense it's fine to keep csum unadjusted. imo it's ok to zero-out IP too)
> > > Such decrypted skb is essentially a wrapper of payload plus
> > > left-over headers passed to the stack.  
> > 
> > Expressing that cleanly in terms of sk_buff fields seems hard.  We
> > could add another checksum bit to denote CHECKSUM_BROKEN_BUT_OKAY,
> > if we really need it (today as stated for TCP streams UNNECESSARY
> > works with mangled csums).  
> 
> I'm not proposing any new skb fields.
> Only to document what fields were consumed by hw and should not be
> touched by the stack before skb reaches the user.
> If it helps I'm proposing a pseudo flag on a tcp socket that it's
> being ktls offloaded and care should be taken.

That should be doable.  IIUC we would use skb->sk but we would still
need an skb field to indicate that the sk is assigned on ingress/early
demux rather than for a TX skb (skb_orphan() handling would be
different for RX vs TX).

> > > I think it makes sense to clarify which headers have been consumed/processed.
> > > Like: IP4/6+protocol+port+csum - processed, whereas
> > > tcp bits, dscp, ecn are still valid and have to be processed by the stack.  
> > 
> > Invalidating the 5 tuple on the packet seems like a step backward,
> > the stack would no longer have the ability to match the packets based
> > on header fields for firewalling, accounting, whatnot.  
> 
> good point. IP needs to be preserved for lookup purpose,
> but not for rewriting.
> The fields that were not 'consumed' during ktls offload
> can be mangled by the stack.
> 
> > > > I was trying (unsuccessfully) to hint at the fact that it's okay
> > > > today to leave the checksum be, but at the same time if someone
> > > > is designing new HW or has the ability to fix this up in microcode
> > > > I think the TCP csum should be fixed..  
> > >
> > > I don't think so. hw should work together with the stack
> > > instead of being 'inline transparent decryption box'.  
> > 
> > I'd rather not extend socket handling into the firmware.  I'm hoping
> > that a narrower interface (checksum bit + decrypted bit) will give more
> > independence to the stack, and I see no negative implications for the
> > the firmware (negative in the sense we don't have to trust and be bound
> > by it).
> >   
> > > If hw decrypts stuff and adjusts csum it would imply that stack
> > > will see completely valid headers. It would also imply that
> > > the stack must check csum.  
> > 
> > What's wrong with the checksum being fixed up after data gets processed?
> > It's not that the stack _must_ check the checksum, it's that the stack
> > _may_ reasonably look at that field - CHECKSUM_UNNECESSARY.  
> 
> because it makes an illusion that the stack sees a valid tcp stream.
> But it is not. Arbitrary changes no longer allowed.
> The set of decrypted skbs must belong only to the socket that has ktls on
> and being offloaded.

Agreed, in valid operation the skb must hit its respective socket,
otherwise things will fall apart.  What remains to be figured out 
is how do we achieve that.  The biggest obstacle is probably getting
orphan_skb() to take appropriate action. void skb_orphan()...

Back to the csum - there is perhaps a slight conflict between offload
semantics here.  IIUC checksum offload mandates that the device passes 
a mere hint, the headers remain valid, and are not overwritten (so the
stack can look at them if it wants).  TLS offload makes csum invalid
so we either have to break the "must remain valid" rule, or the "must
not be overwritten" rule.  I think the first one is more important.
