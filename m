Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8AE95AB0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfHTJKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:10:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:37704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728698AbfHTJKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:10:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBB09ADDA;
        Tue, 20 Aug 2019 09:10:22 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Yash Shah <yash.shah@sifive.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel\@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Subject: Re: [PATCH 2/3] macb: Update compatibility string for SiFive FU540-C000
References: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
        <1563534631-15897-2-git-send-email-yash.shah@sifive.com>
        <4075b955-a187-6fd7-a2e6-deb82b5d4fb6@microchip.com>
        <CAJ2_jOEHoh+D76VpAoVq3XnpAZEQxdQtaVX5eiKw5X4r+ypKVw@mail.gmail.com>
        <alpine.DEB.2.21.9999.1908131142150.5033@viisi.sifive.com>
X-Yow:  Are we live or on tape?
Date:   Tue, 20 Aug 2019 11:10:20 +0200
In-Reply-To: <alpine.DEB.2.21.9999.1908131142150.5033@viisi.sifive.com> (Paul
        Walmsley's message of "Tue, 13 Aug 2019 11:42:49 -0700 (PDT)")
Message-ID: <mvm5zmskxs3.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Aug 13 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:

> Dave, Nicolas,
>
> On Mon, 22 Jul 2019, Yash Shah wrote:
>
>> On Fri, Jul 19, 2019 at 5:36 PM <Nicolas.Ferre@microchip.com> wrote:
>> >
>> > On 19/07/2019 at 13:10, Yash Shah wrote:
>> > > Update the compatibility string for SiFive FU540-C000 as per the new
>> > > string updated in the binding doc.
>> > > Reference: https://lkml.org/lkml/2019/7/17/200
>> >
>> > Maybe referring to lore.kernel.org is better:
>> > https://lore.kernel.org/netdev/CAJ2_jOFEVZQat0Yprg4hem4jRrqkB72FKSeQj4p8P5KA-+rgww@mail.gmail.com/
>> 
>> Sure. Will keep that in mind for future reference.
>> 
>> >
>> > > Signed-off-by: Yash Shah <yash.shah@sifive.com>
>> >
>> > Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> 
>> Thanks.
>
> Am assuming you'll pick this up for the -net tree for v5.4-rc1 or earlier.
> If not, please let us know.

This is still missing in v5.4-rc5, which means that networking is broken.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
