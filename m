Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BE330EB96
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 05:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBDEnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 23:43:24 -0500
Received: from m12-16.163.com ([220.181.12.16]:33946 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhBDEnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 23:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=GIyNb
        ave6wKEQYpyFc7Z4WZNIdF9Yp34fkRVzgFa2XY=; b=qBSIabZN2oEMl+HRtMALK
        HquMTpZCl/w5Fs2TZD0ymhLp7VDr5SuY4iEV1St62CfdLUaTEqxYnAp8L5YbXksa
        nxtZ1xNSPObZuya616V8zAD2VCI9nYtMvIVavZ4zAzZZFKruxQKufQBcZMcWvp2t
        d31CFaDDGo8w+pyzWAnAJ0=
Received: from localhost (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowADXykQ3QhtgZMSSaQ--.21799S2;
        Thu, 04 Feb 2021 08:39:20 +0800 (CST)
Date:   Thu, 4 Feb 2021 08:39:31 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] rt2x00: remove duplicate word in comment
Message-ID: <20210204083931.00004d11@163.com>
In-Reply-To: <1ee1b354-0550-3fd8-f547-10827b3974ad@infradead.org>
References: <20210203063850.15844-1-samirweng1979@163.com>
        <6bf90f62-f14e-9c4a-748b-4923fcae9bef@infradead.org>
        <20210204083007.000069d2@163.com>
        <1ee1b354-0550-3fd8-f547-10827b3974ad@infradead.org>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=GB18030
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowADXykQ3QhtgZMSSaQ--.21799S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJry5CF1DWr4rCF4rZF1rCrg_yoW8Ar13pF
        WrGFW0kFWDGwnrWa4xtayfXryYva4rKr12qrWDW3yrZrn0vr1rJr97GF18u3WDJw48Ga4j
        vr4xt3W3WF9xZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bFlksUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqhgvsVr7sBIkNwAAs8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 16:33:37 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 2/3/21 4:30 PM, wengjianfeng wrote:
> > On Wed, 3 Feb 2021 07:16:17 -0800
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> >> On 2/2/21 10:38 PM, samirweng1979 wrote:
> >>> From: wengjianfeng <wengjianfeng@yulong.com>
> >>>
> >>> remove duplicate word 'we' in comment
> >>>
> >>> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> >>> ---
> >>>  drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
> >>> b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c index
> >>> c861811..7158152 100644 ---
> >>> a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c +++
> >>> b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c @@ -179,7
> >>> +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
> >>>  	 * Make room for new data. There are 2 possibilities
> >>>  	 * either the alignment is already present between
> >>>  	 * the 802.11 header and payload. In that case we
> >>> -	 * we have to move the header less then the iv_len
> >>> +	 * have to move the header less then the iv_len
> >>
> >> s/then/than/
> >>
> >>>  	 * since we can use the already available l2pad bytes
> >>>  	 * for the iv data.
> >>>  	 * When the alignment must be added manually we must
> >>>
> >>
> >>
> > 
> > Hi Randy,
> >    So you means add it for byte alignment, right? if yes,just ignore
> >    the patch. thanks.
> 
> No, I mean that there is a typo there also: "then" should be changed
> to "than" while you are making changes.
> 
> thanks.

Hi Randy£¬
  Ok£¬ I¡¡will update the patch£¬thanks for your reply.

