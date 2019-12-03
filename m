Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7A10FE4B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 14:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLCNDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 08:03:48 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51714 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfLCNDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 08:03:48 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 512E720533;
        Tue,  3 Dec 2019 14:03:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LD7gYDpLbC-a; Tue,  3 Dec 2019 14:03:45 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E20582052E;
        Tue,  3 Dec 2019 14:03:45 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Dec 2019
 14:03:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7A1E63182607;
 Tue,  3 Dec 2019 14:03:45 +0100 (CET)
Date:   Tue, 3 Dec 2019 14:03:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: xfrmi: request for stable trees (was: Re: pull request (net):
 ipsec 2019-09-05)
Message-ID: <20191203130345.GC8621@gauss3.secunet.de>
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
 <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
 <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 04:31:14PM +0100, Nicolas Dichtel wrote:
> Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
> > Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
> >> 1) Several xfrm interface fixes from Nicolas Dichtel:
> >>    - Avoid an interface ID corruption on changelink.
> >>    - Fix wrong intterface names in the logs.
> >>    - Fix a list corruption when changing network namespaces.
> >>    - Fix unregistation of the underying phydev.
> > Is it possible to queue those patches for the stable trees?
> 
> Is there a chance to get them in the 4.19 stable tree?
> 
> Here are the sha1:
> e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
> e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
> c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
> 22d6552f827e ("xfrm interface: fix management of phydev")

Nicolas,

I'm currently processing the stable queue for v4.19.
I guess we also need this patch from you:

56c5ee1a5823 ("xfrm interface: fix memory leak on creation")

before we apply the above mentioned patches, right?

