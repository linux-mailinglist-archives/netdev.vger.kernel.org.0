Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506BB3B2288
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFWVia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:38:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52544 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWVi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JtGYd2CbnyZHUnhcura8ytby55+LDpWyZudxq9IXkBk=; b=P4iJol+QvuF3JOdzzQd/OVd5VB
        1ETDOXkX3XDnE8WYBENBUdCSkAD+CiZj4fyui6Bl/zsBGyk9Or6wVFumtBERcqoX/QuJxbY4EehhD
        bPumyOFp2CJBQIAZ+uRe9tvz8Fo1Fs8hVrWoCCLB11wKbl1o8N+stXRxn4lOEReeUpfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwAXY-00AtjQ-Pt; Wed, 23 Jun 2021 23:36:08 +0200
Date:   Wed, 23 Jun 2021 23:36:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v3 1/6] Documentation: ACPI: DSD: describe
 additional MAC configuration
Message-ID: <YNOpSER3lUSvwqkV@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-2-mw@semihalf.com>
 <YNOW+mQNEmSRx/6V@lunn.ch>
 <CAPv3WKctVLzTZxH2gc-M_ZT7T-i6OmwSQk30AQ4oHEm8BUrpiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKctVLzTZxH2gc-M_ZT7T-i6OmwSQk30AQ4oHEm8BUrpiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyway - all above is a bit side discussion to the actual DSDT
> description and how the fixed-link subnode looks like. I think
> phy-mode set to "sgmii" is not incorrect, but we can change it to
> whatever other type of your preference, as well.

rgmii would be better, so we side step the whole auto-neg discussion.

      Andrew
