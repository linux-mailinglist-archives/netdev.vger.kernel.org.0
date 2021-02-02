Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E2A30C5EC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhBBQdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236490AbhBBQbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:31:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1EB64F76;
        Tue,  2 Feb 2021 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612283436;
        bh=EOFLd7vbQ+FnaMhBVXwbgYDWvwXBhfJGeCLSW6NeLIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pnig1wqYRjDib4fWzLrwXEQeHfIIMTtSybvfOO7ePAPNj2K9GxRinvj5uTyQDKIbg
         vGpAnDP6ap+SRjfplJBC6HO0AmoOtbtYEa+y58oweD8Ym/AOlWGgcX7WTx9H5JIvE8
         /EdyDxz+9Hk6oilFG2XZ/uXyW+Z7WbzYu54hSfnJqdfmLw3beZMYEbxWey0NHDCXv1
         MDI8nud91izBjUPZxstzYNxP6LS08AMav7VLdog8xEUZoS2xxcee4W2kDaMkJDJtLl
         hBtzXo5DWjCBYVatxU5N35MwZ/h0SfiH/wcUX7WVfJ7vibUKudeFTXNSuhWA0WVt2f
         XDnmZRE1Kz0xw==
Date:   Tue, 2 Feb 2021 08:30:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pierre Cheynier <p.cheynier@criteo.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [5.10] i40e/udp_tunnel: RTNL: assertion failed at
 net/ipv4/udp_tunnel_nic.c
Message-ID: <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 09:59:56 +0000 Pierre Cheynier wrote:
> On Sat, 30 Jan 2021 04:27:00 +0100 Jakub Kicinski wrote:
> 
> > I must have missed that i40e_setup_pf_switch() is called from the probe
> > path.  
> 
> Do you want me to apply these patches, rebuild and tell you what's the
> outcome?

I was hoping someone from Intel would step in and help.
