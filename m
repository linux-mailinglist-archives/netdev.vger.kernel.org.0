Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5082279BF9
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgIZSzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:55:39 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:23100 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZSzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 14:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601146539; x=1632682539;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qiNRRaZGj9M0RYTlbddOnswZSAg6tm2yi+VCCw5to/E=;
  b=AY1VcwmQUlP5TYbx9m42hR2XYx2LoMiMfW0malXxeW9sLQerSGBsouBb
   Z3KQWkdQeqHpquIqD3aVd5dqNiilvMkBNcm5jVO/n0Y6mZ87GlceKPy8X
   OKdftpv0lx+pFSXKJEMk/ZT3EPrmOJ3S53/bJ/EXb2uy56nQ62hHdCuFl
   4tGrpyi1Mg4EzqhJ5Xv6RjE5g9iqmIkH50YXFllf/uKr6mkyXPUPJSd7B
   QXdSHp1GI/dGPXiNIwZ7/aMMxYyfTOJ43M943HTDuXk7FtIc+70w136o+
   lB6HrwTWiKfYdlDw8FMZnOlPXGKRj+FUGk6oVTgWIZ9j9URjhxH8D2Sdq
   A==;
IronPort-SDR: rKFG5D3XqR9In++T3wJcbsDdSPeE6TO7w3pEB5xkYnjE9K9YnJhjtsoeL5u8h2YvL8RtdxmN3k
 jmrEPLMhOEOb6/E5+FasxqcxKbbAl9Yl/9rMmz8JyGWbly9MZe9IrQNdKhgdE/asC1vg3m6RTV
 qP0GOH/2oR5RAp7IM24mmvGD/YjpLOqJLWIRO9QZBdMXVmXbDI/wFhof/+MK+ubChi2PmeQptD
 Mi/b7QuGyPkREYTjb7fMIaMVlRcFhDOZKsq3AMH3mpkGR3wUSjgNXp/8DWvWQVhuLdyTTeEM7E
 QX4=
X-IronPort-AV: E=Sophos;i="5.77,307,1596524400"; 
   d="scan'208";a="92492262"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Sep 2020 11:55:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 26 Sep 2020 11:54:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 26 Sep 2020 11:55:37 -0700
Date:   Sat, 26 Sep 2020 20:55:36 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "James Hogan" <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        <hongbo.wang@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200926185536.ac3nr6faxwvcaese@soft-dev3.localdomain>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
 <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
 <20200924233949.lof7iduyfgjdxajv@skbuf>
 <20200926112002.i6zpwi26ong2hu4q@soft-dev3.localdomain>
 <20200926123716.5n7mvvn4tmj2sdol@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200926123716.5n7mvvn4tmj2sdol@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/26/2020 15:37, Vladimir Oltean wrote:
> 
> Hi Horatiu,

Hi Vladimir,

> 
> On Sat, Sep 26, 2020 at 01:20:02PM +0200, Horatiu Vultur wrote:
> > To be honest, I don't remember precisely. I will need to setup a board
> > and see exactly. But from what I remember:
> > - according to this[1] in chapter 3.8.6, table 71. It says that the full
> >   entry of IS2 is 384. And this 384 represent a full entry. In this row,
> >   can be also sub entries like: half entry and quater entries. And each
> >   entry has 2 bits that describes the entry type. So if you have 2 bits
> >   for each possible entry then you have 8 bits describing each type. One
> >   observation is even if you have a full entry each pair of 2 bits
> >   describing the type needs to be set that is a full entry.
> 
> But if I have a single entry per row, I have a single Type-Group value,
> so I only need to subtract 2, no?

No, you will always have 4 Type-Group values regardless of number of
entries per row(1, 2 or 4). If you have a full key, then you need to set
all 4 Type-Group to be full key. If you have only a half key, you need
to set only the 2 Type-Group values of the half key. So the other 2 can
be used for another key. The same is for quater key.
For example. If you have a quater key on column 0 and one on column 3,
then the type group will have the valux 0bXX0000XX. (I forgot what is
the Type-Group for quater keys).
If you have a full key, then you need to replicate the value of type
group for full key for all 4 type-groups in the row. So if type group
for full entry is 0x1, then type group will look like this: 0b01010101.

> 
> >   Maybe if you have a look at Figure 30, it would be a little bit more
> >   clear. Even there is a register called VCAP_TG_DAT that information
> >   is storred internally in the VCAP_ENTRY_DAT.
> 
> See, this is what I don't understand. You're saying that the Type-Group
> is stored as part of the entry inside the TCAM, even if you're accessing
> it through a different set of cache registers? What else is stored in a
> TCAM row sub-word? The key + mask + Type-Group are stored in the same
> sub-word, I assume?

I am not sure how is store the mask. But regarding the key and the type
group you can see it like this.

| subword 3 | TG 3 | subwork 2 | TG 2 | subword 1 | TG 1 | subword 0 | TG 0 |

Where subwork is 96 bits and TG is 2 bits.
So when you access VCAP_ENTRY_DAT you access only the subwords, when you
access VCAP_TG_DAT you access TG. When you set the VCAP_ENTRY_DAT you
don't need to take in consideration that after 96 bits you start to
shift everything to left by 2. The internal implementation does that.
And that is the reason why the VCAP_CONST_ENTRY_WIDTH is 384 and
VCAP_IS2_ENTRY_WIDTH is 376.

> 
> > - so having those in mind, then VCAP_IS2_ENTRY_WIDTH is the full entry
> >   length - 8 bits. 384 - 8 = 376.
> 
> But there are 4 Type-Group (and therefore 4 entries per row) only if the
> entries are for quarter keys, am I not correct? And the IS2 code
> currently uses half keys. Does this variable need to be set differently
> according to the key size?

I think what I wrote above answer these questions.

> 
> > - then if I remember correctly then VCAP_CONST_ENTRY_WIDTH should be
> >   384? or 12 if it is counting the words.
> 
> Yes, it is 384 and the VCAP core version is 0.

Well, I still remember it :)
> 
> > Does it make sense or am I completly off?
> 
> So, in simple words, what is the physical significance of
> (VCAP_CONST_ENTRY_WIDTH - VCAP_CONST_ENTRY_TG_WIDTH * VCAP_CONST_ENTRY_SWCNT)?

I am not sure that I understand what you want to achive with this or
something is still wrong.

> To my understanding, it means the size used by all key+mask entries
> within a TCAM row (therefore without the length of Type-Group fields)
> when that row contains 4 quarter keys. Divide this number by 2, you get
> the length of the key, or the length of the mask, for a single sub-word,
> BUT only assuming that quarter keys are used.
> So, why does this value have any significance to a driver that is not
> using quarter keys?
> 
> Am _I_ completely off? This is so confusing.

I hope the first part explain a little bit better this. Maybe we should
ignore the internal representation and try to see it like this. Each
quater key has a type-group, then a full key is composed of 4 quater
keys therefore it has 4 type-groups. In case of a full key then all 4
type-groups in VCAP_TG_DAT needs to have the same value. In case of quater
key you need to set only the bits in VCAP_TG_DAT of the column where is
the quater key. In case of half entry then only first or last 4 bits in
VCAP_TG_DAT needs to be set.

> 
> Thanks,
> -Vladimir

-- 
/Horatiu
