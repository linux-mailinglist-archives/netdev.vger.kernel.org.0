Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4E222B15
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgGPShE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgGPShE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 14:37:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 344CA2065E;
        Thu, 16 Jul 2020 18:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594924623;
        bh=cyuHt7Jip0eq20sRWrd3G9ePaAZdPsdZ0yNGOmJPB9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PwNh51jz9iiPJqxQvrCKFhvU98fNfkgWc2XUrjOV7JZSO4fpFFc/m0euX8xX+P/oX
         LrOCD6PEBk9jFkSS6zoewEHcAMfEvE9BpUSvep5bI29LH6Fh/iN0bDT5tV4T+ZonvW
         YJtF7FqrR1m2bSTzrR2Q01ErAl6PBdT/QiBCJJnI=
Date:   Thu, 16 Jul 2020 11:37:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Sergey Organov <sorganov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [EXT] [PATCH net-next v2 0/4]  net: fec: a few improvements
Message-ID: <20200716113701.65b4f19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM6PR0402MB36071DED4EC0FAF0A02F5872FF7F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200715154300.13933-1-sorganov@gmail.com>
        <AM6PR0402MB36071DED4EC0FAF0A02F5872FF7F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 03:00:56 +0000 Andy Duan wrote:
> From: Sergey Organov <sorganov@gmail.com> Sent: Wednesday, July 15, 2020 11:43 PM
> > This is a collection of simple improvements that reduce and/or simplify code.
> > They got developed out of attempt to use DP83640 PTP PHY connected to
> > built-in FEC (that has its own PTP support) of the iMX 6SX micro-controller.
> > The primary bug-fix was now submitted separately, and this is the rest of the
> > changes.
> > 
> > NOTE: the patches are developed and tested on 4.9.146, and rebased on top
> > of recent 'net-next/master', where, besides visual inspection, I only tested
> > that they do compile.
> > 
> > Sergey Organov (4):
> >   net: fec: enable to use PPS feature without time stamping
> >   net: fec: initialize clock with 0 rather than current kernel time
> >   net: fec: get rid of redundant code in fec_ptp_set()
> >   net: fec: replace snprintf() with strlcpy() in fec_ptp_init()

Applied, thanks!

> For the version: Acked-by: Fugang Duan <fugang.duan@nxp.com>

Thanks! In the future please make sure to have the tag as a separate
line, patchwork is not clever enough to pick it up if it doesn't start
at the start of the line :(
