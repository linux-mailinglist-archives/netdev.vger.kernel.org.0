Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225DC30953
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 09:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfEaH1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 03:27:15 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:40963 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaH1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 03:27:15 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 03:27:14 EDT
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=wei.liu2@citrix.com; spf=Pass smtp.mailfrom=wei.liu2@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL02.citrite.net
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  wei.liu2@citrix.com) identity=pra; client-ip=23.29.105.83;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="wei.liu2@citrix.com"; x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  wei.liu2@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="wei.liu2@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL02.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL02.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: vZ/vfl2aWL/s2CrBoteUwRYksEByaVfCVcKUAHL+r/L7L0C9LKwCME3Jfwyqimk5UyqNI9Uekg
 QyY+0MYrqMjTsS+HXDmX8Ig34gUCd/4+8YpKfoxWA9ZZLIeLbZEKqavso5sj5z/7yfTo3/U3nq
 f8EDO5tH1IOUpds654nQ3M9asmbrkTU9/32zOEidozr3I67zQ/Pg3ESHZ95IoEUq8PCp/wEqWb
 22RcvvBK22nkB8FFw2j9Y3r9cgDfsq8dI/5VnfrwHVC2+LLZ4uKyXQN3hJcA6M1FCzW3hk2A91
 ZG8=
X-SBRS: 2.7
X-MesageID: 1142044
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,534,1549947600"; 
   d="scan'208";a="1142044"
Date:   Fri, 31 May 2019 08:20:05 +0100
From:   Wei Liu <wei.liu2@citrix.com>
To:     Colin King <colin.king@canonical.com>
CC:     Wei Liu <wei.liu2@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        "David S . Miller" <davem@davemloft.net>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-netback: remove redundant assignment to err
Message-ID: <20190531072005.GC25537@zion.uk.xensource.com>
References: <20190530190438.9571-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190530190438.9571-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 08:04:38PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -ENOMEM that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Wei Liu <wei.liu2@citrix.com>


> ---
>  drivers/net/xen-netback/interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 783198844dd7..240f762b3749 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -633,7 +633,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>  			unsigned int rx_evtchn)
>  {
>  	struct task_struct *task;
> -	int err = -ENOMEM;
> +	int err;
>  
>  	BUG_ON(queue->tx_irq);
>  	BUG_ON(queue->task);
> -- 
> 2.20.1
> 
