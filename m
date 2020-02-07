Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0871554E9
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 10:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgBGJm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 04:42:26 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:34434 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgBGJm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 04:42:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 78F8520561;
        Fri,  7 Feb 2020 10:42:24 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jYJj-8btLiQV; Fri,  7 Feb 2020 10:42:24 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1A261204B4;
        Fri,  7 Feb 2020 10:42:24 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 7 Feb 2020
 10:42:23 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E62EC31803BE;
 Fri,  7 Feb 2020 10:42:23 +0100 (CET)
Date:   Fri, 7 Feb 2020 10:42:23 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>
Subject: Re: [PATCH ipsec v3] vti[6]: fix packet tx through bpf_redirect() in
 XinY cases
Message-ID: <20200207094223.GF3469@gauss3.secunet.de>
References: <20200204114604.GA59185@bistromath.localdomain>
 <20200204160027.29309-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200204160027.29309-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 05:00:27PM +0100, Nicolas Dichtel wrote:
> I forgot the 4in6/6in4 cases in my previous patch. Let's fix them.
> 
> Fixes: 95224166a903 ("vti[6]: fix packet tx through bpf_redirect()")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks a lot!
