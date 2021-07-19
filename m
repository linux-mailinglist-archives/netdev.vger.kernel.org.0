Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45923CD699
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbhGSNsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:48:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231618AbhGSNsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 09:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xte//GgrLPWmYfZguSht4iKWCHZCn7j35lUKR3v9z4A=; b=BmlyxX675rfYX3sfAczkHfECKM
        v29sxxEvCKllI/njJPFsXrmH8wzCoOJlS5lWGSSHYX/dwPnni+U6fwzKjpgVzf+hmEDoJG0+lWwiz
        6/gV4zOAvTzdXHEzRi230TKVEjxrF/BBYttyO0VdKLmcckiww1MvamvW9WNKwoA7n+c0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5UGD-00DuKP-B5; Mon, 19 Jul 2021 16:28:45 +0200
Date:   Mon, 19 Jul 2021 16:28:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Message-ID: <YPWMHagXlVCgpYqN@lunn.ch>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 11:33:11AM +0000, Ruud Bos wrote:
> The igb driver provides support for PEROUT and EXTTS pin functions that
> allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
> are using the PEROUT function to feed a PTP corrected 1pps signal into an
> FPGA as cross system synchronized time source.

Please always Cc: The PTP maintainer for PTP patches.
Richard Cochran <richardcochran@gmail.com>

       Andrew
