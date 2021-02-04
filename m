Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7E30EAAF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhBDDIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:08:18 -0500
Received: from m12-16.163.com ([220.181.12.16]:52909 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234506AbhBDDIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 22:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=Reot6
        AsId5qeu1pVUXcL6feuR4qdIy6fvuI0wH6Qi3A=; b=RQZEfKfFqAnXN/utn8bqx
        HZLckvadbMdqJctAKUbwjJMuHgfvwni4JrgRwz5Qrw1O5ScF6oDS7Fs0x77VqKGa
        BVq/aQkTHj9acfSWbNMRo0R35JEuav5iWL8mqGe+2K3sAoWVVteV8grzMYiZRt/4
        5vrEux46vn8Leoukg6I81A=
Received: from localhost (unknown [119.137.55.230])
        by smtp12 (Coremail) with SMTP id EMCowAB3MTkDQBtgyX2RaQ--.24271S2;
        Thu, 04 Feb 2021 08:29:56 +0800 (CST)
Date:   Thu, 4 Feb 2021 08:30:07 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] rt2x00: remove duplicate word in comment
Message-ID: <20210204083007.000069d2@163.com>
In-Reply-To: <6bf90f62-f14e-9c4a-748b-4923fcae9bef@infradead.org>
References: <20210203063850.15844-1-samirweng1979@163.com>
        <6bf90f62-f14e-9c4a-748b-4923fcae9bef@infradead.org>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAB3MTkDQBtgyX2RaQ--.24271S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Jr4rAFW3uw4rZw45GFg_yoW8JFW3pF
        WrGFWjkFyDGryDWa4xJa4Syry5Zas0kryUKr4DC3y5ZrW5XF1rJrZ7WF1xu3WDJ3yrGa4j
        vr4Iq3W5WFZ8Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jC1v3UUUUU=
X-Originating-IP: [119.137.55.230]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqgkusVr7sA05owABs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 07:16:17 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 2/2/21 10:38 PM, samirweng1979 wrote:
> > From: wengjianfeng <wengjianfeng@yulong.com>
> > 
> > remove duplicate word 'we' in comment
> > 
> > Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
> > b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c index
> > c861811..7158152 100644 ---
> > a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c +++
> > b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c @@ -179,7
> > +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
> >  	 * Make room for new data. There are 2 possibilities
> >  	 * either the alignment is already present between
> >  	 * the 802.11 header and payload. In that case we
> > -	 * we have to move the header less then the iv_len
> > +	 * have to move the header less then the iv_len
> 
> s/then/than/
> 
> >  	 * since we can use the already available l2pad bytes
> >  	 * for the iv data.
> >  	 * When the alignment must be added manually we must
> > 
> 
> 

Hi Randy,
   So you means add it for byte alignment, right? if yes,just ignore
   the patch. thanks.

