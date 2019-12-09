Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8250F117383
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLISLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfLISLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 13:11:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0C2206D3;
        Mon,  9 Dec 2019 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575915092;
        bh=tIdFcsEoS0tQukUPS2khU4DomKCIfvwgUfYDrYhh6e4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdOcoU29HB0wEELPzrUQD+TcZ+ihJglsEwzvsE83J4Vl/2Yjeml/k4ehX+bhLR/He
         PdtDR1hO8bNx+PwFCQpyYNQV4QJA5YxoTwBnePdhUpeQ7Tji0UuX/C5D+gEsSOMHwP
         XkF1wBc+w3EFgt7Dk/NFL7gpHGydFgFfa2Wz3ZqQ=
Date:   Mon, 9 Dec 2019 19:11:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     stable@vger.kernel.org, David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH stable v4.19 0/4] xfrm: Fixes for v4.19
Message-ID: <20191209181129.GA1456904@kroah.com>
References: <20191209083045.20657-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209083045.20657-1-steffen.klassert@secunet.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 09:30:41AM +0100, Steffen Klassert wrote:
> This patchset has some fixes for the xfrm interfaces
> that are needed but did not make it into the stable
> tree so far.
> 
> 1) Fix a memory leak when creating xfrm interfaces.
> 
> 2) Fix a xfrm interface corruptinon on changelink.
> 
> 3) Fix a list corruption when changing network namespaces.
> 
> 4) Fix unregistation of the underying phydev, otherwise
>    the phydev cannot be removed.

Thanks for these, all now queued up.

greg k-h
