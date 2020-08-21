Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D024CFDE
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgHUHr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:47:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55130 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgHUHr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:47:28 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597996046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QYrfH5qNal9t0t0APe2l5SVZJtFbnfRRUDVhsTelToo=;
        b=r4ziFvu5Vua5RWt9RS6TyJ5FZrQA5+Y2S9lyVMTaNfgowWdFrSXCvOPB5uxQb34QROkIWt
        9RYA/fmbYFNvqiwo1LQ9y7eSlrK5yO2mxxNyKcLQaiD4XPcmJSFZbVkhfBo1gQEwuDyQ8f
        XgdPUIyRuGtUWXQIlsXqz+7BVvuZ0MVSOyLH7hDEVRxDRMFxM1UJk43jNtQ8oIGfBay9p2
        /1Sawlax/0f3Dbfi4XneyztBd0DwN1l8GSjWnYXSq/boVAYV2Cpm9ZNt02nNnuaSAicRL0
        6RFy8DlPCWq9HAjx4HcbvmY8OdmABXAaQr8zgdHUSPh1Arbazq3c5rXQeA3rCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597996046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QYrfH5qNal9t0t0APe2l5SVZJtFbnfRRUDVhsTelToo=;
        b=w/7+d0Tny9TyRZEVmtObOKW02dRTXpJAS3imgLh6EBGfYkg5b+3BfbTaKNMKIATS3i1eMT
        IbNQxdWek8IwM3Bw==
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: bridge: Don't reset time stamps on SO_TXTIME enabled sockets
In-Reply-To: <5affe98d-bb16-0744-5266-db708fb9dc16@cumulusnetworks.com>
References: <20200820105737.5089-1-kurt@linutronix.de> <5affe98d-bb16-0744-5266-db708fb9dc16@cumulusnetworks.com>
Date:   Fri, 21 Aug 2020 09:47:25 +0200
Message-ID: <87mu2oe8z6.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Aug 20 2020, Nikolay Aleksandrov wrote:
> The new conditionals will be for all forwarded packets, not only the
> ones that are transmitted through the bridge master device.

I see makes sense.

> If you'd like to do this please limit it to the bridge dev transmit.

I'm wondering how to do that. The problem is that the time stamp is
reset to zero unconditionally in br_forward_finish(). This function is
also called in the transmit path.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8/fA0ACgkQeSpbgcuY
8KYR+BAAiaaCs1BIj0Ogf9yXoq5Krdd1Wi27yOkqGGkP081+wuLYUwsFDtxXRxJ8
d4Eh/M6TxWWKHovkzEc0HXtBhWNkbt+SYXiJ6tNTv4OkaNNJl/PmPPOG5CWpUr3j
scFu9xwYR0EeOir79QaTpsNR3dpxbLkrjZFQBAyqVO6UrdZ+Ra8iWT9/iNY/rDXH
Fjabd6QkWO1hIprWdrC+pMKAtre38xHdO+GjCWUQi8GY09X44FcpZwoHJsC9u7AD
ClAHLHGQWMqqqui1QQGN9pXN5iiwwNefSUOCr1VMxg1s0dNE8G5PLYegteDwyDAi
to6sXj7bGa28M1uxkjtxxL4SXhGiCTjeRDImTZGjMCrP8KSyxDiZNI1VbDCqd6+3
QKLiS65/W9vLVY/BSd7/nk5+7aG8KwxtPubKLQ/EN3z24HDtUUajw1UKtuP7XdQa
+DGX0KbJDNGKsQW9yAznM0RBRj9w6bH19tsABbyaA2QUBAJz/VNOO2sHPOjC9hCr
7FsVL7MPhKBf9FuuEQdbq0xB+XpXOZSjKYnAQrqW0J7x+IJKRbrhdVLLfU3OVuH8
QBOSGkBhY9S8wW/LjPCFbCs1ziez0wIHjdbz8l+1QJLVe/XFjZiFY6X+/HgJv4Ap
TDAhSvn2Hqk5ezYbzJCLuEGTeEPhGQgyjHYJK8XEYwOQwgyvNgM=
=enjn
-----END PGP SIGNATURE-----
--=-=-=--
