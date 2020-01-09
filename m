Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C203C135B93
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 15:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbgAIOlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 09:41:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIOlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 09:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fSQ8A1qrQK8Io1guGl8tcCPFtG7/+pLIZjl76B8LEoQ=; b=W2e0V9NqMEMFvBqHAnLZNuTiJG
        qyU1FglOV613xWLTDsf+jmJ5COHrwIggNCqQMXBe+LkgJnB089laCxOKmcsNS38kZEluDygvKjPQs
        ezwDsDb7Sw1dvmDMJV9FuenYcIWqKhK2CNg3eZ9DVACMYbTGSBCd8gejkKKeV3W5mNSQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipYzi-0006WA-CI; Thu, 09 Jan 2020 15:41:06 +0100
Date:   Thu, 9 Jan 2020 15:41:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109144106.GA24459@lunn.ch>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 01:47:31PM +0000, ѽ҉ᶬḳ℠ wrote:
> On node with 4.19.93 and a SFP module (specs at the bottom) the following is
> intermittently observed:

Please make sure Russell King is in Cc: for SFP issues.

The state machine has been reworked recently. Please could you try
net-next, or 5.5-rc5.

Thanks
	Andrew
