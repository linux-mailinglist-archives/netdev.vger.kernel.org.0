Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D311524714C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbgHQSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731045AbgHQQDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 12:03:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5296B207FB;
        Mon, 17 Aug 2020 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680187;
        bh=hhXBbQYM4Hvef25g7EmRTCKKtQvAfaMA37aQTdjUNW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQ5xWMHf3YobUekVnFbqau5awKWxCcyLa8U6Iui/3eih7P2XQmUtjgi96GIbBFBIy
         8gjd3tYdohAQEIrwEJUpNFCwcN0ixgefrDsaaY42DH1WVTDDIP4/vET5O76YICDbHY
         Xb5nX4rhTxTNNhq5RDRiBmI6YVFOxx7c0c+U85GY=
Date:   Mon, 17 Aug 2020 09:03:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 7/7] net: dsa: mv88e6xxx: Implement devlink
 info get callback
Message-ID: <20200817090305.03230c16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200816194316.2291489-8-andrew@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
        <20200816194316.2291489-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Aug 2020 21:43:16 +0200 Andrew Lunn wrote:
> Return the driver name and the asic.id with the switch name.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
