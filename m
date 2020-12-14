Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A1D2DA27C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503595AbgLNVUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:20:50 -0500
Received: from smtp-outgoing.laposte.net ([160.92.124.100]:54904 "EHLO
        smtp-outgoing.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503568AbgLNVUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:20:40 -0500
X-mail-filterd: {"version":"1.2.0","queueID":"4CvvKR2gWjz10MQR","contextId":"fc9c9fcb-86e0-4e10-9782-1a89285274a9"}
Received: from outgoing-mail.laposte.net (localhost.localdomain [127.0.0.1])
        by mlpnf0120.laposte.net (SMTP Server) with ESMTP id 4CvvKR2gWjz10MQR;
        Mon, 14 Dec 2020 22:14:35 +0100 (CET)
X-mail-filterd: {"version":"1.2.0","queueID":"4CvvKR19xlz10MQQ","contextId":"08deaf0b-0861-4074-9b43-d33f7839d2a2"}
X-lpn-mailing: LEGIT
X-lpn-spamrating: 36
X-lpn-spamlevel: not-spam
X-lpn-spamcause: OK, (-100)(0000)gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgudegjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfntefrqffuvffgpdfqfgfvpdggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggugfgjsehtkedttddttddunecuhfhrohhmpeggihhntggvnhhtucfuthgvhhhlrocuoehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvtheqnecuggftrfgrthhtvghrnhepffdtteetvedujeettdetleehhfehjefhueefhfeijeffleehuedugeegiefgffdtnecukfhppeekkedruddvuddrudegledrgeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheprhhomhhurghlugdrsggvrhhgvghrihgvpdhinhgvthepkeekrdduvddurddugeelrdegledpmhgrihhlfhhrohhmpehvihhntggvnhhtrdhsthgvhhhlvgeslhgrphhoshhtvgdrnhgvthdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehjfihisehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtohepfhhlohhrihgrnhdrfhgrihhnvghllhhisehtvghlvggtohhmihhnthdrvghupdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrk
 hgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Received: from romuald.bergerie (unknown [88.121.149.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mlpnf0120.laposte.net (SMTP Server) with ESMTPSA id 4CvvKR19xlz10MQQ;
        Mon, 14 Dec 2020 22:14:34 +0100 (CET)
Received: by romuald.bergerie (Postfix, from userid 1000)
        id 959EC3DFA8F4; Mon, 14 Dec 2020 22:14:34 +0100 (CET)
Date:   Mon, 14 Dec 2020 22:14:34 +0100
From:   Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [PATCH] net: korina: remove busy skb free
Message-ID: <X9fVuvAwIf57YZUJ@romuald.bergerie>
Mail-Followup-To: Julian Wiedmann <jwi@linux.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
References: <20201213172052.12433-1-vincent.stehle@laposte.net>
 <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=laposte.net; s=lpn-wlmd; t=1607980476; bh=FhA1NzlZW79MJc0KRvXihr5YWiW7pvjBdcRnaFAgDJY=; h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:Content-Transfer-Encoding; b=isJoemRoXZAwcDrK2OKoGo/LJNfzFuJiv1cqxE6nqRcO/fzkHocdpeTJxdB/RBHPifoudRHBx/kOK+1xk/uYWRSkdPnJSt9Di4D+UYVM4ME+iQWPwi70tVI+JmDUBLzDUi+4JyedtGTR0Sa+bQEkEUXqjf9ahYeXhLgK2XQACQpEz2adUzITu8ExjlNBIAPfAtnSjtTQMhOBjBvG34sMr1sTQf8OlJO5cxNDXheXMw6DFawaX4cQMawaB0O6vL/WPMvR4JpJjDxYby59ea8R6vfnrrAdaKleM5vufAAkP1yLol+ECmybxlLRMtyt0lqxJ0UjC2yhuF6yu69G8UYMGw==;
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:03:12AM +0100, Julian Wiedmann wrote:
> On 13.12.20 18:20, Vincent Stehl=E9 wrote:
...
> > @@ -216,7 +216,6 @@ static int korina_send_packet(struct sk_buff *skb=
, struct net_device *dev)
> >  			netif_stop_queue(dev);
> >  		else {
> >  			dev->stats.tx_dropped++;
> > -			dev_kfree_skb_any(skb);
> >  			spin_unlock_irqrestore(&lp->lock, flags);
> > =20
> >  			return NETDEV_TX_BUSY;
> >=20
>=20
> As this skb is returned to the stack (and not dropped), the tx_dropped
> statistics increment looks bogus too.

Hi Julian,

Thanks for the review.
I will respin the patch to remove the statistics increment as well.

Best regards,
Vincent.
