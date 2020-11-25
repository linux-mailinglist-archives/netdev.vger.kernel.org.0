Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192672C43F5
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731355AbgKYPiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731336AbgKYPiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:38:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6490E221FB;
        Wed, 25 Nov 2020 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318690;
        bh=Lsui0+Kczcst+qjCEcBPCK/CrBK9iVXw2kRO2HEGSfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OmJyaqjxeujsgloqzHhUYwACZQCiA8YERn8y/sOTeeJfIz6ZhPvTO4dAtcRI6G0JQ
         MAKpkxMjtBr3BFW7DjIk/Haa+Jlw/A6SCmEHvzdSW3po8yeZg1m7UgPEYFHf+AXGwW
         wf3snpIUytWg9xy117Ha/WfhHFiX2U7IGDwWF6y8=
Date:   Wed, 25 Nov 2020 07:38:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org
Subject: Re: [PATCH net-next v2] net/nfc/nci: Support NCI 2.x initial
 sequence
Message-ID: <20201125073809.2116872e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACwDmQAZ48JrM3AuiKwuSdhcpfo_d2_P0B+mtd4Mshfa3WUVpA@mail.gmail.com>
References: <CGME20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
        <20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
        <20201124144353.7c759cae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACwDmQAZ48JrM3AuiKwuSdhcpfo_d2_P0B+mtd4Mshfa3WUVpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 21:33:48 +0900 Bongsu Jeon wrote:
> > > +     } else {
> > > +             /* if nci version is 2.0, then use the feature parameters */
> > > +             nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, sizeof(struct nci_core_init_v2_cmd), cmd);  
> >
> > Please wrap this line.

This line is 100 characters long, prefer wrapping at 80 wherever
possible. Makes the code more readable (for me at least).
