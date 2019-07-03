Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7295E61E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGCOKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:10:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCOKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f6EkhFgDj5yNV/vCI0wtMQPeE4pwYm8OnUmJ/ES9SNk=; b=ZJsMtNKLwWz4HxFysQuizCRFHx
        uUVbL+SUaZeE7XUmuGSIVsCr74aJAsQAYhPcpDWs18Fros2e3mEH/T6mYgqil3qfaoNd8T8qC6/Nb
        KHKc4moBUYt5cIev2JfDm93JJHbVQ4hdyRygVKqn52HfN8V9sZQ3qEBoDtPPQRNArxts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hifxO-0004xj-Ir; Wed, 03 Jul 2019 16:09:58 +0200
Date:   Wed, 3 Jul 2019 16:09:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190703140958.GB18473@lunn.ch>
References: <20190701122734.18770-2-parav@mellanox.com>
 <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703103720.GU2250@nanopsycho>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
> Ccing Florian, Andrew and Vivien.
> What do you guys think?

Hi Jiri

DSA and CPU ports are physical ports of the switch. And there can be
multiple DSA ports, and maybe sometime real soon now, multiple CPU
ports. So having a number associated with them is useful.

       Andrew
