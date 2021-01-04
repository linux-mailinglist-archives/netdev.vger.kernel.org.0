Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30A02E9221
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 09:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbhADIpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 03:45:20 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:59484 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbhADIpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 03:45:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8896D20082;
        Mon,  4 Jan 2021 09:44:38 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EY9LcrjXLiBV; Mon,  4 Jan 2021 09:44:38 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E91220080;
        Mon,  4 Jan 2021 09:44:38 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 4 Jan 2021 09:44:37 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 4 Jan 2021
 09:44:37 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7DE433182CCD;
 Mon,  4 Jan 2021 09:44:36 +0100 (CET)
Date:   Mon, 4 Jan 2021 09:44:36 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <shmulik.ladkani@gmail.com>
Subject: Re: [RFC ipsec-next] xfrm: interface: enable TSO on xfrm interfaces
Message-ID: <20210104084436.GE3576117@gauss3.secunet.de>
References: <20201223071538.3573783-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201223071538.3573783-1-eyal.birger@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 09:15:38AM +0200, Eyal Birger wrote:
> Underlying xfrm output supports gso packets.
> Declare support in hw_features and adapt the xmit MTU check to pass GSO
> packets.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Looks ok to me.
