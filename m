Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AE533AFF4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCOK1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:27:06 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36876 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhCOK0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 06:26:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C1EE120491;
        Mon, 15 Mar 2021 11:26:48 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YjNLl0WALVz4; Mon, 15 Mar 2021 11:26:42 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D95522057B;
        Mon, 15 Mar 2021 11:26:42 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 15 Mar 2021 11:26:42 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 15 Mar
 2021 11:26:42 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D45EC31803BF;
 Mon, 15 Mar 2021 11:26:41 +0100 (CET)
Date:   Mon, 15 Mar 2021 11:26:41 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     angkery <angkery@163.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Junlin Yang <yangjunlin@yulong.com>
Subject: Re: [PATCH] esp6: remove a duplicative condition
Message-ID: <20210315102641.GX62598@gauss3.secunet.de>
References: <20210311020756.1570-1-angkery@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210311020756.1570-1-angkery@163.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 10:07:56AM +0800, angkery wrote:
> From: Junlin Yang <yangjunlin@yulong.com>
> 
> Fixes coccicheck warnings:
> ./net/ipv6/esp6_offload.c:319:32-34:
> WARNING !A || A && B is equivalent to !A || B
> 
> Signed-off-by: Junlin Yang <yangjunlin@yulong.com>

Applied to ipsec-next, thanks!
