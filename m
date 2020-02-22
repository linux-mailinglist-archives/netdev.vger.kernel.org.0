Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F2168D38
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBVH2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 02:28:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgBVH2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 02:28:20 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857F02071E;
        Sat, 22 Feb 2020 07:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582356500;
        bh=rg6BHvSmrsmV2OX8BeP+SXJIKaQ8O5I//rEn5M4Ajbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZEM5L24hcHX3abcjtWqnpS9DcQp56mEdbs5MMSnkJjg8i/CqymBr9e393VFbqVil7
         t2UsXddS9iL1njPEu5+hT4/fJKMSVnIEYMvI3abL/b2p3dJVQFj0VEcHK5fQV8CBTe
         YDDV5fCwxHAXaDuf782/fUDAayi6NIVxJAhIfUyw=
Date:   Sat, 22 Feb 2020 09:28:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 02/16] net/dummy: Ditch driver and module
 versions
Message-ID: <20200222072817.GG209126@unreal>
References: <20200220145855.255704-1-leon@kernel.org>
 <20200220145855.255704-3-leon@kernel.org>
 <cde72970-e4f9-1747-0fee-75639190b127@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde72970-e4f9-1747-0fee-75639190b127@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 12:11:19PM +0300, Sergei Shtylyov wrote:
> Hello!
>
> On 20.02.2020 17:58, Leon Romanovsky wrote:
>
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Delete constant driver and module versions in favor standard
>                                                      ^ of?

Thanks, I'll fix.

>
> > global version which is unique to whole kernel.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> [...]
>
> MBR, Sergei
