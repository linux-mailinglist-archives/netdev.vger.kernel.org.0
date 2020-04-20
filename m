Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319AF1B06BC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDTKk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:40:28 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33702 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTKk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:40:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5F0CF2058E;
        Mon, 20 Apr 2020 12:40:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SPkClZXSOjvd; Mon, 20 Apr 2020 12:40:24 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 31D2D20491;
        Mon, 20 Apr 2020 12:40:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 20 Apr 2020 12:40:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:40:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7FBFD31800B3;
 Mon, 20 Apr 2020 12:40:23 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:40:23 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony@phenome.org>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] xfrm: fix error in comment
Message-ID: <20200420104023.GI13121@gauss3.secunet.de>
References: <20200415194710.32449-1-antony@phenome.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200415194710.32449-1-antony@phenome.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 09:47:10PM +0200, Antony Antony wrote:
> s/xfrm_state_offload/xfrm_user_offload/
> 
> Fixes: d77e38e612a ("xfrm: Add an IPsec hardware offloading API")
> Signed-off-by: Antony Antony <antony@phenome.org>

Patch applied, thanks!
