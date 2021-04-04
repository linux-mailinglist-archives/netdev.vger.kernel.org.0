Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0053538C8
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhDDQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 12:07:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDQHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 12:07:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lT5HA-00EnAv-4r; Sun, 04 Apr 2021 18:07:00 +0200
Date:   Sun, 4 Apr 2021 18:07:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "acardace@redhat.com" <acardace@redhat.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Message-ID: <YGnkJIY6Dmk97w2b@lunn.ch>
References: <20210404081433.1260889-1-danieller@nvidia.com>
 <20210404081433.1260889-2-danieller@nvidia.com>
 <YGnKs/k0ed0NwTwe@lunn.ch>
 <DM6PR12MB45163C0617DC03F24E6CCEA0D8789@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB45163C0617DC03F24E6CCEA0D8789@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> First, it is not the API structure that is passed to user space. Please pay attention

Yes, sorry. Jumped to assumptions without checking.

Let me try again.

    Andrew
