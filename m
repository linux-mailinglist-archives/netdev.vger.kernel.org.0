Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346363C9211
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 22:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhGNU3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 16:29:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230314AbhGNU3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 16:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RJX5MkYYxa5x+XDN3B7Fffz0vmZrTXCXZXE3bdoR+hs=; b=BkU6f3p+HGW/uMmhDapfTbMjQR
        90FJj7qBL96fHychYwKTzkfq6brFpqxESZCxLRRxBdYq+pm/L6RpDKjmAxZ0iBIhBP8ln/LRHLSsp
        1Peg6Q4osHE/VOCXbe2KKssge+Bd9ujaNb/JWe2EF8FIb3sBC+A5jXhexKNc4i9d62JU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3lS1-00DOaq-C6; Wed, 14 Jul 2021 22:25:49 +0200
Date:   Wed, 14 Jul 2021 22:25:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next RFC] devlink: add commands to query flash and
 reload support
Message-ID: <YO9ITZknrXte6jpB@lunn.ch>
References: <20210714193918.1151083-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714193918.1151083-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not sure if this is the best direction to go for implementing this.

Hi Jacob

Maybe add a --dry-run option? That would allow the driver to also read
the firmware file, make sure it can parse it, it fits the actual
hardware, and the CRC is O.K, etc.

We just need to make sure that if it fails with -EOPNOTSUPP, is it
clear if --dry-run itself is not supported, or the operation is not
supported. extack should help with that.

	   Andrew
