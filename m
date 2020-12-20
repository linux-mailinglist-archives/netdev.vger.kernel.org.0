Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1972DF45A
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 08:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgLTHxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 02:53:41 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42164 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgLTHxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 02:53:40 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 6B99144008F;
        Sun, 20 Dec 2020 09:52:56 +0200 (IST)
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
 <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
 <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Ulisses Alonso =?utf-8?Q?Camar=C3=B3?= <uaca@alumni.uv.es>
Subject: Re: [PATCH net 2/2] docs: networking: packet_mmap: don't mention
 PACKET_MMAP
In-reply-to: <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 20 Dec 2020 09:52:55 +0200
Message-ID: <875z4wq5go.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Dec 17 2020, Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 18:51:17 +0200 Baruch Siach wrote:
>> Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
>> used to be a CONFIG_PACKET_MMAP config symbol that depended on
>> CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
>> feature, implying that it can be disabled. Another naming variant is
>> "Packet MMAP".
>> 
>> Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
>> text the implied mmap() feature disable option.
>
> Should we maybe say AF_PACKET mmap() ?

I thought that PACKET is better because it is the minimal change, and
because of the reference to CONFIG_PACKET. Should we rename
CONFIG_PACKET to CONFIG_AF_PACKET as well?

What do you think?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
