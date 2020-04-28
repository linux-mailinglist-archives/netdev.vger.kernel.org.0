Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2CB1BB9CC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgD1J1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:27:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60052 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgD1J1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 05:27:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 47AC220519;
        Tue, 28 Apr 2020 11:27:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yqlIhEH6iTm9; Tue, 28 Apr 2020 11:27:16 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D4CD4201A0;
        Tue, 28 Apr 2020 11:27:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 28 Apr 2020 11:27:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 28 Apr
 2020 11:27:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 175FE3180156;
 Tue, 28 Apr 2020 11:27:16 +0200 (CEST)
Date:   Tue, 28 Apr 2020 11:27:16 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm interface: don't take extra reference to
 netdev
Message-ID: <20200428092716.GM13121@gauss3.secunet.de>
References: <20200423093920.23962-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200423093920.23962-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:39:20AM +0200, Nicolas Dichtel wrote:
> I don't see any reason to do this. Maybe needed before
> commit 56c5ee1a5823 ("xfrm interface: fix memory leak on creation").
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks Nicolas!
