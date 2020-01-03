Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C961E12F6F3
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgACLAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:00:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727220AbgACLAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578049232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E5Au8xJIaQm96eSB+9dhsPNsB7HRPg4aZOcnlnu0Rso=;
        b=I5A6HYttP/3D019JR+ZgVogLX85IBlhoWnCrpenA1EabgiaZg5xdbN/dVWwgbEtsgVCaap
        AMqPM7sDKCsHfEI1uwCi6AubYUKF1MWIHuLUKoqlyeLN+aRc3a3Ck80wsi95h7zQKz5Mic
        kTHeU0BMSItpmh9ZAK1gqL75pGmQOpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-tJawF3A-NP2DKw6W1adlag-1; Fri, 03 Jan 2020 06:00:23 -0500
X-MC-Unique: tJawF3A-NP2DKw6W1adlag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7926B107ACC5;
        Fri,  3 Jan 2020 11:00:22 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F79D808EE;
        Fri,  3 Jan 2020 11:00:18 +0000 (UTC)
Date:   Fri, 3 Jan 2020 12:00:17 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     brouer@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Update GIT url in maintainers.
Message-ID: <20200103120017.6d08ab8a@carbon>
In-Reply-To: <20200102.174602.1527569147186535315.davem@davemloft.net>
References: <20200102.174602.1527569147186535315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 02 Jan 2020 17:46:02 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

People also notice that the http(s) cgit URL also changed

From: https://git.kernel.org/pub/scm/linux/kernel/git/davem/
To  : https://git.kernel.org/pub/scm/linux/kernel/git/netdev/ 

>  MAINTAINERS | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c6b893f77078..77d4529dd2a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11460,8 +11460,8 @@ M:	"David S. Miller" <davem@davemloft.net>
>  L:	netdev@vger.kernel.org
>  W:	http://www.linuxfoundation.org/en/Net
>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
>  S:	Odd Fixes
>  F:	Documentation/devicetree/bindings/net/
>  F:	drivers/net/
> @@ -11502,8 +11502,8 @@ M:	"David S. Miller" <davem@davemloft.net>
>  L:	netdev@vger.kernel.org
>  W:	http://www.linuxfoundation.org/en/Net
>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
>  B:	mailto:netdev@vger.kernel.org
>  S:	Maintained
>  F:	net/
> @@ -11548,7 +11548,7 @@ M:	"David S. Miller" <davem@davemloft.net>
>  M:	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>  M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>  L:	netdev@vger.kernel.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
>  S:	Maintained
>  F:	net/ipv4/
>  F:	net/ipv6/



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

