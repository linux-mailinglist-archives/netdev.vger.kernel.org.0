Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1915C2F5778
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbhANCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbhAMXiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:38:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24DC122248;
        Wed, 13 Jan 2021 23:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580993;
        bh=mfpr1pidtzK2oHnDxw0V02JBC4LGx4qP/ggnlJdEj4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W611FSiv8Mv57Ax70jQ4D0KaP/CKR10OaBdtkxIvSwXGXeljODNQe9dcwsnbqBp+p
         jjpQyI7Q8sP87XcjqhVtT2GAHFe0s2JwRP4WZnD5hu4YksisgrMIqut9rhT4XjCL8M
         fdU2C94yRRSNmyCL6LXLjmcIB0GLYPcsjKx3KxwH8hiDWUQcQMdDjk7vWEG54cuOqN
         GAP22GXxQeF7PERKQYOPjR/VO8eEW0nsBuE+rdGX6Po1LV067mxuwDCmp/CZKhne03
         OvODIWjQFtUCfuJ4hMZNCfFCbDNUCOZilKqB+aW0Z5oPhdgeiz9A+S1ksia5I4b35D
         QeuvTH/h6W6Sg==
Date:   Wed, 13 Jan 2021 15:36:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mw@semihalf.com,
        linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
Subject: Re: [PATCH V3] drivers: net: marvell: Fixed two
 spellings,controling to controlling and oen to one
Message-ID: <20210113153627.615d8e46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2cf30ec7-07cc-650c-d94b-a9cd7aadb906@infradead.org>
References: <20210112103152.13222-1-unixbhaskar@gmail.com>
        <2cf30ec7-07cc-650c-d94b-a9cd7aadb906@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 09:26:48 -0800 Randy Dunlap wrote:
> On 1/12/21 2:31 AM, Bhaskar Chowdhury wrote:
> > s/oen/one/
> > s/controling/controlling/
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>  
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks. 

