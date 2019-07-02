Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D975CEB7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfGBLs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:48:28 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:58998 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfGBLs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:48:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F38CE201F9;
        Tue,  2 Jul 2019 13:48:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rMSbPqLTm27r; Tue,  2 Jul 2019 13:48:25 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8EEE020097;
        Tue,  2 Jul 2019 13:48:25 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 2 Jul 2019
 13:48:25 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 395A031805EF;
 Tue,  2 Jul 2019 13:48:25 +0200 (CEST)
Date:   Tue, 2 Jul 2019 13:48:25 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: Re: [Patch net] xfrm: remove a duplicated assignment
Message-ID: <20190702114825.GI17989@gauss3.secunet.de>
References: <20190629191714.5808-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190629191714.5808-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 12:17:14PM -0700, Cong Wang wrote:
> Fixes: 30846090a746 ("xfrm: policy: add sequence count to sync with hash resize")
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks Cong!
