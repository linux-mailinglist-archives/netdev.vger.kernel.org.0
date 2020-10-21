Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FD5294718
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJUEAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJUEAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:00:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF68121D6C;
        Wed, 21 Oct 2020 04:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603252807;
        bh=U3C1dRUEOXaw854OlDNkuD1V3QaQr/gEZ7O/9uscTFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M9ZYfvhByjtwDWRTflH//ypwtk7ek7hB3gq8GffdPJ5mEsiNgt2NyjFOKwq4GiFqj
         AetrPKBr7ISMq+K3ncvznRw+YT69GXjDFZxDnKnu7X3wisBXJzFQWH8Lb4NwBP5h/9
         ue6zPIBm6nhpYGg8R7N33e6DCp7V6i12U+DXgFr4=
Date:   Tue, 20 Oct 2020 21:00:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: bcm_sf2: make const array static, makes
 object smaller
Message-ID: <20201020210005.7871ff74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0cdc86a4-66a0-2f1f-ba23-03b54ccacd69@gmail.com>
References: <20201020165029.56383-1-colin.king@canonical.com>
        <0cdc86a4-66a0-2f1f-ba23-03b54ccacd69@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 09:51:39 -0700 Florian Fainelli wrote:
> On 10/20/20 9:50 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Don't populate the const array rate_table on the stack but instead it
> > static. Makes the object code smaller by 46 bytes.
> > 
> > Before:
> >    text	   data	    bss	    dec	    hex	filename
> >   29812	   3824	    192	  33828	   8424	drivers/net/dsa/bcm_sf2.o
> > 
> > After:
> >    text	   data	    bss	    dec	    hex	filename
> >   29670	   3920	    192	  33782	   83f6	drivers/net/dsa/bcm_sf2.o
> > 
> > (gcc version 10.2.0)
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>  
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
