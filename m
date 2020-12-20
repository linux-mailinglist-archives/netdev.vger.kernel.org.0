Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30742DF45C
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 08:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgLTH7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 02:59:19 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42172 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgLTH7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 02:59:19 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 377EB44008F;
        Sun, 20 Dec 2020 09:58:37 +0200 (IST)
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
 <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
 <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTScTEthUW=s+5_jnnHj4SQeFr0=HsgwVeNegNOaCNQ+C=Q@mail.gmail.com>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Ulisses Alonso =?utf-8?Q?Camar=C3=B3?= <uaca@alumni.uv.es>
Subject: Re: [PATCH net 2/2] docs: networking: packet_mmap: don't mention
 PACKET_MMAP
In-reply-to: <CA+FuTScTEthUW=s+5_jnnHj4SQeFr0=HsgwVeNegNOaCNQ+C=Q@mail.gmail.com>
Date:   Sun, 20 Dec 2020 09:58:36 +0200
Message-ID: <873600q577.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Thu, Dec 17 2020, Willem de Bruijn wrote:
> On Thu, Dec 17, 2020 at 2:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 15 Dec 2020 18:51:17 +0200 Baruch Siach wrote:
>> > Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
>> > used to be a CONFIG_PACKET_MMAP config symbol that depended on
>> > CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
>> > feature, implying that it can be disabled. Another naming variant is
>> > "Packet MMAP".
>> >
>> > Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
>> > text the implied mmap() feature disable option.
>>
>> Should we maybe say AF_PACKET mmap() ?
>
> I don't think that the feature name PACKET_MMAP implies
> CONFIG_PACKET_MMAP, or thus that the name is obsolete now that the
> latter is.

Current text says "if PACKET_MMAP is not enabled ...". This clearly
implies a CONFIG_ symbol. Besides, the PACKET_MMAP term is mentioned
nowhere else in the source tree. At the very least we need to clarify
what it means.

> If it needs a rename, the setsockopt is PACKET_[RT]X_RING. So, if this
> needs updating, perhaps PACKET_RING would be suitable. Or TPACKET,
> based on the version definitions.

So how would you rephrase text like "PACKET_MMAP provides a size
configurable circular buffer ..."?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
