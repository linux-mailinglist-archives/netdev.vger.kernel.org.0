Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53E41099F0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 09:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKZIMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 03:12:23 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:56296 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfKZIMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 03:12:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E119A2051C;
        Tue, 26 Nov 2019 09:12:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b7-L8WErnxmu; Tue, 26 Nov 2019 09:12:21 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6E6C92008D;
        Tue, 26 Nov 2019 09:12:21 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 26 Nov 2019
 09:12:21 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1F0713180357;
 Tue, 26 Nov 2019 09:12:21 +0100 (CET)
Date:   Tue, 26 Nov 2019 09:12:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     <nicolas.dichtel@6wind.com>, <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: xfrmi: request for stable trees
Message-ID: <20191126081221.GA13225@gauss3.secunet.de>
References: <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
 <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
 <20191124100746.GD14361@gauss3.secunet.de>
 <20191124.190249.1262907259702322148.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191124.190249.1262907259702322148.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 07:02:49PM -0800, David Miller wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Date: Sun, 24 Nov 2019 11:07:46 +0100
> 
> > On Mon, Nov 18, 2019 at 04:31:14PM +0100, Nicolas Dichtel wrote:
> >> Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
> >> > Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
> >> >> 1) Several xfrm interface fixes from Nicolas Dichtel:
> >> >>    - Avoid an interface ID corruption on changelink.
> >> >>    - Fix wrong intterface names in the logs.
> >> >>    - Fix a list corruption when changing network namespaces.
> >> >>    - Fix unregistation of the underying phydev.
> >> > Is it possible to queue those patches for the stable trees?
> >> 
> >> Is there a chance to get them in the 4.19 stable tree?
> >> 
> >> Here are the sha1:
> >> e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
> >> e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
> >> c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
> >> 22d6552f827e ("xfrm interface: fix management of phydev")
> > 
> > I'm ok with this. David does the stable submitting for
> > networking patches usually. So I guess he will pick them
> > into his stable queue after the patches are mainline some
> > time.
> 
> Steffen you can submit things directly to -stable for IPSEC if you
> wish, and it would help me in this case.

Ok, can do that, no problem.
I'll submit these and do all the future IPSEC -stable submits directly.
