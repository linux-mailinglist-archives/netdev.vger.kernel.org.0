Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD730D4FB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhBCIOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:14:24 -0500
Received: from m12-16.163.com ([220.181.12.16]:55294 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhBCIOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 03:14:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=KIBaD
        WNyCx0bXtQfpbd3fulkL/+NwY/AxkBgeJGfgSA=; b=R2zgs2txg0G5Xwq04e65i
        BKQMUpy/q4/B975f+Hv86Zwtv7gZPvptBGrSp9mKhwRZGaeEWOI0D4oybsx8/Ho5
        Wzwf1493jMyyarG8LGI8iwrm7kQBarEvPXZ7WIP63JhZMGkQKiT1MKqqCLmyo6gP
        z9hbXrPGnc2uIgL7JOEr28=
Received: from localhost (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowAB3e08WVxpgePkXaQ--.61908S2;
        Wed, 03 Feb 2021 15:56:07 +0800 (CST)
Date:   Wed, 3 Feb 2021 15:56:17 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: Re: [PATCH] wireless: fix typo issue
Message-ID: <20210203155617.00006345@163.com>
In-Reply-To: <74d4dfc5-51ae-5f53-6210-2cc14da55dcb@huawei.com>
References: <20210203070025.17628-1-samirweng1979@163.com>
        <9200710b2d9dafea4bfae4bb449a55fb44245d04.camel@sipsolutions.net>
        <74d4dfc5-51ae-5f53-6210-2cc14da55dcb@huawei.com>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAB3e08WVxpgePkXaQ--.61908S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48Gr13XrWUWw4UWw4fAFb_yoW8Jw1kpr
        WkJayUKayUKwnxAay8Xan2qryI93s5tr42gFWqvw1Fvr98Xw1ftFs0gw4jgrykJr4xJFZ8
        ZrWYqa43W3WYvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bjXocUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqhMusVr7sAkieQAAsl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 15:51:36 +0800
Miaohe Lin <linmiaohe@huawei.com> wrote:

> On 2021/2/3 15:33, Johannes Berg wrote:
> > On Wed, 2021-02-03 at 15:00 +0800, samirweng1979 wrote:
> >> From: wengjianfeng <wengjianfeng@yulong.com>
> >>
> >> change 'iff' to 'if'.
> >>
> >> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> >> ---
> >>  net/wireless/chan.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> >> index 285b807..2f17edf 100644
> >> --- a/net/wireless/chan.c
> >> +++ b/net/wireless/chan.c
> >> @@ -1084,7 +1084,7 @@ bool cfg80211_chandef_usable(struct wiphy
> >> *wiphy,
> >>   * associated to an AP on the same channel or on the same UNII
> >> band
> >>   * (assuming that the AP is an authorized master).
> >>   * In addition allow operation on a channel on which indoor
> >> operation is
> >> - * allowed, iff we are currently operating in an indoor
> >> environment.
> >> + * allowed, if we are currently operating in an indoor
> >> environment. */
> > 
> > I suspect that was intentional, as a common abbreviation for "if and
> > only if".
> 
> Yep. iff --> if and only if from:
> https://mathvault.ca/math-glossary/#iff
> 
> > 
> > johannes
> > 
> > .
> > 

Hi Johannes and Miaohe
  You are right, I make a mistake, please ignore this patch, thanks.


