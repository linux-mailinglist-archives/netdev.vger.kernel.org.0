Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6FD150EC0
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgBCRiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgBCRiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:38:16 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC1A2080C;
        Mon,  3 Feb 2020 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580751495;
        bh=7DceEA2M6fJ7fQhDMyXvM99m0I7lcjwIRZp76B2Fz5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sbHsOQXISEkqWPmrGiUsPIeqH6iLYLzuJ2YxqocZovcivw4CZPVv4cRZmNghrCCGI
         qF5wM1/NgCX9fokH92XwCVASySLaE7Zcx60ysmoEA0v6sGZiF7SdrCRHou2I1RNC+z
         8zV/XEnjasxEQbQCOBxII28a3QDW8qc416XXSjuw=
Date:   Mon, 3 Feb 2020 09:38:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] defxx: Fix a sentinel at the end of a 'eisa_device_id'
 structure
Message-ID: <20200203093814.69d33a2a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <alpine.LFD.2.21.2002031015530.752735@eddie.linux-mips.org>
References: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
        <20200203095553.GN1778@kadam>
        <alpine.LFD.2.21.2002031015530.752735@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Feb 2020 10:20:46 +0000 (GMT), Maciej W. Rozycki wrote:
>  Right, the code is good as it stands (I should have more faith in my past 
> achievements ;) ).  Except for the whitespace issue, which I suppose might 
> not be worth bothering to fix.  Thanks for your meticulousness!

For the white space clean up please resend after the merge window
(if you care), networking trees are only taking fixes fixes now :)
