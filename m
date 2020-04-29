Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736FF1BDD39
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgD2NNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:13:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59272 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgD2NNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 09:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C8ezmPqc8mLwz2mRYgsvFKiaM+YzdWhzTZK3aopDLwg=; b=sEFUygc8dh/HDJfyiHG9ul6wJp
        Xtyp0oGIBel+2RN8v2Xv014F0J9ZYLPGfiiKQW1JASZ2pmIPFMwb6pLpt6z/piMPjz42s0PVjXOE8
        DNYu5qkm3yXJrWtlyG7yxqMtKXychZsnPCOJASoFZRqyEVYTI0hDImfwwAOYhL4KS1t4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTmWD-000G5a-Qc; Wed, 29 Apr 2020 15:12:53 +0200
Date:   Wed, 29 Apr 2020 15:12:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Zigotzky <chzigotzky@xenosoft.de>
Cc:     Darren Stevens <darren@stevens-zone.net>, madalin.bacur@nxp.com,
        netdev@vger.kernel.org, mad skateman <madskateman@gmail.com>,
        oss@buserror.net, linuxppc-dev@lists.ozlabs.org,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        "contact@a-eon.com" <contact@a-eon.com>
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
Message-ID: <20200429131253.GG30459@lunn.ch>
References: <20200424232938.1a85d353@Cyrus.lan>
 <ca95a1b2-1b16-008c-18ba-2cbd79f240e6@xenosoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca95a1b2-1b16-008c-18ba-2cbd79f240e6@xenosoft.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Maybe we have to modify the dtb file.

Hi Christian

Could you point me at the DT file.

      Thanks
	Andrew
