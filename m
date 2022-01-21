Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ACF495F41
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380465AbiAUMsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:48:19 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:45096 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbiAUMsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 07:48:18 -0500
Received: from [IPV6:2003:e9:d70c:7733:6a50:4603:7591:b048] (p200300e9d70c77336a5046037591b048.dip0.t-ipconnect.de [IPv6:2003:e9:d70c:7733:6a50:4603:7591:b048])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 83B0DC05A1;
        Fri, 21 Jan 2022 13:48:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1642769296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dhz0F/V3adEU4+UC5E4OQzYWIX+X1i4+KWjCzuAs+I=;
        b=j2ZVSJaa7aKx3W6KVskhU86CuPGTAD/eBZ6AaMZkrf6vwYIgKNaxrHu14g9JxYFAHpDDZS
        BNetg6CE5yUwJZTeOQO4NmUjXPuuvYOTjYtpcgZjRscR2TBsztdhMTU4Fw0uwCenAbyXEs
        Oycyg6cJPAizbrk7c00Wox1qHPDDmbGpYjxZb2LZn+OmiHih2t94ImSFuvrELakjXw8rJ2
        sMWptsKp5GABsmcO1LBz2KJZgdL1scP9Ysxtzrf96MCYW2O7yLi6GOBwmBff7O/S5lEgGB
        yv4y6ODYHoyqbf104acYPX/sEy5A7B/yqUai3wjF3sjONbMOUgQXcRFbbazZGg==
Message-ID: <e401539a-6a05-9982-72a6-ac360b0bdf97@datenfreihafen.org>
Date:   Fri, 21 Jan 2022 13:48:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next v2 0/9] ieee802154: A bunch of fixes
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
 <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
 <20220121092715.3d1de2ed@xps13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220121092715.3d1de2ed@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 21.01.22 09:27, Miquel Raynal wrote:
> Hi Alexander,
> 
> alex.aring@gmail.com wrote on Thu, 20 Jan 2022 17:52:57 -0500:
> 
>> Hi,
>>
>> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>>
>>> In preparation to a wider series, here are a number of small and random
>>> fixes across the subsystem.
>>>
>>> Changes in v2:
>>> * Fixed the build error reported by a robot. It ended up being something
>>>    which I fixed in a commit from a following series. I've now sorted
>>>    this out and the patch now works on its own.
>>>   
>>
>> This patch series should be reviewed first and have all current
>> detected fixes, it also should be tagged "wpan" (no need to fix that
>> now). Then there is a following up series for a new feature which you
>> like to tackle, maybe the "more generic symbol duration handling"? It
>> should be based on this "fixes" patch series, Stefan will then get
>> things sorted out to queue them right for upstream.
>> Stefan, please correct me if I'm wrong.

Alex, agreed. I will take this series first and see if the patches apply 
cleanly against my wpan tree. Once in they can be feed back into net, 
net-next and finally wpan-next again.

> Yup sorry that's not what I meant: the kernel robot detected that a
> patch broke the build. This patch was part of the current series. The
> issue was that I messed a copy paste error. But I didn't ran a
> per-patch build test and another patch, which had nothing to do with
> this fix, actually addressed the build issue. I very likely failed
> something during my rebase operation. >
> So yes, this series should come first. Then we'll tackle the symbol
> duration series, the Kconfig cleanup and after that we can start thick
> topics :)

That sounds like a great plan to me. I know splitting the huge amount of 
work you do up into digestible pieces is work not much liked, so I 
appreciate that you take this without much grumble. :-)

I also finally started to start my review backlog on your work. Catched 
up on the big v3 patchset now. Will look over the newest sets over the 
weekend so we should be ready to process the fixes series and maybe more 
next week.

>> Also, please give me the weekend to review this patch series.

Alex, whenever you are ready with them please add you ack and I will doe 
my review and testing in parallel.

> Yes of course, you've been very (very) reactive so far, I try to be
> also more reactive on my side but that's of course not a race!

And being so reactive is very much appreciated. We just need to throttle 
this a bit so we can keep up with reviewer resources. :-)

regards
Stefan Schmidt
