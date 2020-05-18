Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA91D7EDB
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgERQn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgERQn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:43:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2E1207E8;
        Mon, 18 May 2020 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589820238;
        bh=Nf5+rdcJRKZIaQrmbvq7MlLLr+jxPoAdjzRPLNUd/l0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=STdk8hDmPWbZNh+ldRATYT96YfIEWAaQjFKYf8MJu/HQpLsUkTPTsLdgovsKiu1+a
         uq0wjl//KtWILucokHQYJSgm5+3yUD0ziCc6/R3Tmzeym1un7XbJP5eNu7r9JkGr2A
         RDyeB/O2wY34+XeqaclwYWumqvuB0oDkC8VBvskw=
Date:   Mon, 18 May 2020 09:43:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] sit: refactor ipip6_tunnel_ioctl
Message-ID: <20200518094356.039e934c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518114655.987760-6-hch@lst.de>
References: <20200518114655.987760-1-hch@lst.de>
        <20200518114655.987760-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 13:46:51 +0200 Christoph Hellwig wrote:
> Split the ioctl handler into one function per command instead of having
> a all the logic sit in one giant switch statement.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

net/ipv6/sit.c: In function ipip6_tunnel_prl_ctl:
net/ipv6/sit.c:460:6: warning: variable err set but not used [-Wunused-but-set-variable]
  460 |  int err;
      |      ^~~
