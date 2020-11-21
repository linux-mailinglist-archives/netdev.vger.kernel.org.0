Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447D52BC277
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgKUWhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 17:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbgKUWhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 17:37:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC6E2100A;
        Sat, 21 Nov 2020 22:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605998267;
        bh=y7bh6s1DsmtRa81gWn1HUSci8eomeCzJD84CIImaK+8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qva7GFfs53mtblPEpCt1Uu/FpSEow1fFushBxPBvXWfqp63f6sFPKcKfSHlU82uoc
         VGhfnpI2HEkouqKU0R9PcbTbgo8RbDZjf7b1UngJzt90LP34vPgnlE3ILbxH5ACAml
         XMu68FUCxTgmEg/mOvpibhd2XKWeyD4L7IQw6ULY=
Date:   Sat, 21 Nov 2020 14:37:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next] MAINTAINERS: Update page pool entry
Message-ID: <20201121143746.237e3bdc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160586497895.2808766.2902017028647296556.stgit@firesoul>
References: <160586497895.2808766.2902017028647296556.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 10:36:19 +0100 Jesper Dangaard Brouer wrote:
> Add some file F: matches that is related to page_pool.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f827f504251b..efcdc68a03b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13179,6 +13179,8 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	include/net/page_pool.h
>  F:	net/core/page_pool.c
> +F:	include/trace/events/page_pool.h
> +F:	Documentation/networking/page_pool.rst

Checkpatch says:

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#26: FILE: MAINTAINERS:13165:
 F:	net/core/page_pool.c
+F:	include/trace/events/page_pool.h

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#27: FILE: MAINTAINERS:13166:
+F:	include/trace/events/page_pool.h
+F:	Documentation/networking/page_pool.rst
