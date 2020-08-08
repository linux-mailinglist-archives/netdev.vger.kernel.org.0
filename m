Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD99323F7F3
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHHOav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 10:30:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgHHOau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 10:30:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k4Prz-008juk-9C; Sat, 08 Aug 2020 16:30:47 +0200
Date:   Sat, 8 Aug 2020 16:30:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paul Schmidt <paschmidt@nvidia.com>
Subject: Re: [PATCH ethtool v2] Add QSFP-DD support
Message-ID: <20200808143047.GG2028541@lunn.ch>
References: <20200806145936.29169-1-popadrian1996@gmail.com>
 <20200806180759.GD2005851@lunn.ch>
 <CAL_jBfSZDGbKiKCjcdQ8uaHvtxxb0P4Rktw9TutWEGCfscJ=EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfSZDGbKiKCjcdQ8uaHvtxxb0P4Rktw9TutWEGCfscJ=EQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 07:21:21PM +0300, Adrian Pop wrote:
> Hi Andrew!
> 
> Should I resubmit v3 after I delete the code that has to do with page
> 0x10 and 0x11?

Yes please.

    Andrew
