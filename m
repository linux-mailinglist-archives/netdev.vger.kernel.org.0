Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267F53CF7EE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhGTJwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237860AbhGTJuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBCA61003;
        Tue, 20 Jul 2021 10:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626777062;
        bh=BZba0u6E9Kj1O213hoo7yTY3/yz9W+IOIX9KJAiF4e8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N4GG6hoPQa81JJCoJVxQIAcZlj5NgehDh+P2I+oh6ErOzM2YKXf4X21jbgSmm9c79
         hBDpuQH4rgIcnvqXisd3Tb27ZoXoRDLBiNcoyPAeASG3Xil0/FyHk3hB1CfagbrP0U
         RRDTuguM36tdZUzBohd7K+H+niro65N2VZBjiEzXA1G5LjbVmOQmZ5BSgRiyVADB4o
         d1wAbHPbkoc4vxEal9E3IebBn+Ok1Q+cB1pnEvKff5/4yDr21uKseagsbyAFNrch2J
         URm3cbBfAR+vtoeX055mmZgTY59ee0Mfzz9W3CT/eO6KUcBkv1yzpqMJHU32ePWTfQ
         ZsbBvXgYB9Org==
Date:   Tue, 20 Jul 2021 12:30:55 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Message-ID: <20210720123055.1cee93c7@cakuba>
In-Reply-To: <20210719171135.GD5568@hoboy.vegasvil.org>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
        <YPWMHagXlVCgpYqN@lunn.ch>
        <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
        <20210719171006.GC5568@hoboy.vegasvil.org>
        <20210719171135.GD5568@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 10:11:35 -0700, Richard Cochran wrote:
> On Mon, Jul 19, 2021 at 10:10:06AM -0700, Richard Cochran wrote:
> > On Mon, Jul 19, 2021 at 02:45:06PM +0000, Ruud Bos wrote:  
> > > Do I need to resend again?  
> > 
> > No need, this time I saw it.  
> 
> Actually, on second thought, please resend.

While at it please also make sure the patches apply on the right tree,
that is this tree most likely:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

unless you're basing them on some Intel tree on purpose.
