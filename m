Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3E23B7FA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgHDJnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:43:14 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56981 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbgHDJnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:43:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0BC6B5C0200;
        Tue,  4 Aug 2020 05:43:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 04 Aug 2020 05:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=cjBmqIM9+5mv2uiP07cYDoPaonT
        iqBxD1XI04vEZs68=; b=nAtgpS7LWMG6/2CgXZn0XgBEo6SGNf+0Zmx5YLC5lL0
        bOPCXbcOONVwb9ClrSXuAz3AeQ7R0tfCr5bpkVCfx1du1sPga3uoFh58mpwuoq3J
        uH7Mss1O/rqWwulrZFXlfkemagThxzbJkm5W4klZRUQUZmlAPKSV/gIPvcWpRdMM
        f9mVKNsdiopykUjx/QEBrpWhdF2VlIfNoiiFaFqO/BlxwNtL8uTTtKfI20CPGIun
        Fys7cxmLZ4SbgHuQFDBoYYWK/tz6MW0qCJyeYOWdFNArEeKqy9hKaQua+3vJbCjr
        VTfkVE5CuSRqzM55v9VxVRDxboR5wfvY2ULpsfOKuKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cjBmqI
        M9+5mv2uiP07cYDoPaonTiqBxD1XI04vEZs68=; b=efU+VnGc/SEcIFLkan12oR
        6ey8zxF5TlXEi9+e2D9/pdQECvxXRT04hGehE6xKVxJZRdusFuFNswe6JgqCgVO3
        pN0RwNn2j1yggX3kMx1+BNiX0GKxo3qWTs6MFZD8iCxpXZbAWc3hSFyAKIWjU64N
        8WPoX7HQzhevn2OuK4eNRTgQLLXXznnYeRpruwSDz8gTSSI0BJQA8P9MbIR/omWV
        479PXZhxsYdjp5YYTmsVUX+6KZ1IQT9UKoYstHu8cT2alLr0XQ5Vz+IBiVgOiH9j
        pqygEDDcz5Qx8v3VjtSwzdUpwcwgSPs1JvCN+MnRxxGwPkIFyeDr/tSjJsSdAHLg
        ==
X-ME-Sender: <xms:sC0pX5ce8V0YCMHf-IPaCTLG7jEve0j_XrdmaEX0Gs-S_cx03oT1yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeigddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpeffhffvuffkfhggtggujges
    thdtredttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtg
    homheqnecuggftrfgrthhtvghrnhepfeefteeuhfffleehvddtleejudekiedthfejjedt
    tdetkefgledtvdejgfeuteefnecuffhomhgrihhnpegrphhpshhpohhtrdgtohhmnecukf
    hppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sC0pX3PMTw5qwCJgqnXtEGgRncmFEn821-QMPRsSO6leY07HjDQdLg>
    <xmx:sC0pXyi3DfWtNMKPBN0-4DtyG9msFx-6ZXSCNtAfIPOC3vtGnHFabA>
    <xmx:sC0pXy9YKHdOVX4EnfjJEN-15W-EIbc_Tmp3EvEvTvqGxcACPpid6A>
    <xmx:sS0pX5hXT-Q3wCBEx5lmxkto-WSQAtmnHhrPn0T6Bui5Rn67LaSLsw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2741930600A3;
        Tue,  4 Aug 2020 05:43:12 -0400 (EDT)
Date:   Tue, 4 Aug 2020 11:42:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Linux-kernel-mentees] [PATCH] Bluetooth: Initialize the TX
 queue lock when creating struct l2cap_chan in 6LOWPAN
Message-ID: <20200804094253.GA2667430@kroah.com>
References: <20200804093937.772961-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804093937.772961-1-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 05:39:37PM +0800, Coiby Xu wrote:
> When L2CAP channel is destroyed by hci_unregister_dev, it will
> acquire the spin lock of the (struct l2cap_chan *)->tx_q list to
> delete all the buffers. But sometimes when hci_unregister_dev is
> being called, this lock may have not bee initialized. Initialize
> the TX queue lock when creating struct l2cap_chan in 6LOWPAN to fix
> this problem.
> 
> Reported-by: syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  net/bluetooth/6lowpan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index bb55d92691b0..713c618a73df 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -651,6 +651,7 @@ static struct l2cap_chan *chan_create(void)
>  
>  	l2cap_chan_set_defaults(chan);
>  
> +	skb_queue_head_init(&chan->tx_q);
>  	chan->chan_type = L2CAP_CHAN_CONN_ORIENTED;
>  	chan->mode = L2CAP_MODE_LE_FLOWCTL;
>  	chan->imtu = 1280;

Nice, did syzbot verify that this resolves the issue?

thanks,

greg k-h
