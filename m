Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301AA3AA12E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhFPQZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:25:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235224AbhFPQZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uedR4ia+MZ8da2TARIWb7FpQBHxW4jorJuYhL71OXkc=; b=WdNPEQ+3HtAyhsR6dstdaeN+Qz
        indvShvRdzyKQ4kJ35MOmgY0pVUOR8DQvT3Uc0zu4Z+eX6j8rXT9i6CBKShDKva8atqm1pnIfH8X2
        pLUGDP6TB+I8yyDtqd4T4GlgKRAhc8wRR12xFAggYoK1l6ErF5RSBMlQ0B0cPZxTaZaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltYJu-009koQ-Os; Wed, 16 Jun 2021 18:23:14 +0200
Date:   Wed, 16 Jun 2021 18:23:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH net-next 7/8] net: hdlc_ppp: remove redundant spaces
Message-ID: <YMolcod68MZqfNFL@lunn.ch>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
 <1623836037-26812-8-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623836037-26812-8-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 05:33:56PM +0800, Guangbin Huang wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> According to the chackpatch.pl,
> no spaces is necessary at the start of a line.
> 
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/wan/hdlc_ppp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
> index 7b7c02d..53c668e 100644
> --- a/drivers/net/wan/hdlc_ppp.c
> +++ b/drivers/net/wan/hdlc_ppp.c
> @@ -34,8 +34,8 @@
>  
>  enum {IDX_LCP = 0, IDX_IPCP, IDX_IPV6CP, IDX_COUNT};
>  enum {CP_CONF_REQ = 1, CP_CONF_ACK, CP_CONF_NAK, CP_CONF_REJ, CP_TERM_REQ,
> -      CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
> -      LCP_DISC_REQ, CP_CODES};
> +	CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
> +	LCP_DISC_REQ, CP_CODES};

Do you think this looks better or worse after the change?

   Andrew
