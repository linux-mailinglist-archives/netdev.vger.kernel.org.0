Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD40327D59
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhCALdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:33:35 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:53924 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233813AbhCALdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 06:33:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6FEFA205CD;
        Mon,  1 Mar 2021 12:32:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Y3xAkyP2FXpN; Mon,  1 Mar 2021 12:32:31 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0DBB12052E;
        Mon,  1 Mar 2021 12:32:31 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Mar 2021 12:32:30 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 1 Mar 2021
 12:32:30 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6F3C93180428; Mon,  1 Mar 2021 12:32:30 +0100 (CET)
Date:   Mon, 1 Mar 2021 12:32:30 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <fw@strlen.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: Fix incorrect types in assignment
Message-ID: <20210301113230.GC2966489@gauss3.secunet.de>
References: <1613791103-127057-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1613791103-127057-1-git-send-email-yang.lee@linux.alibaba.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 11:18:23AM +0800, Yang Li wrote:
> Fix the following sparse warnings:
> net/xfrm/xfrm_policy.c:1303:22: warning: incorrect type in assignment
> (different address spaces)
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Please add a proper 'Fixes' tag so that it can be backported into
the stable trees.

Thanks!

