Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012CF20A77E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbgFYV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:29:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:44020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391179AbgFYV32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 17:29:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 24162AD5E;
        Thu, 25 Jun 2020 21:29:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 380AA60460; Thu, 25 Jun 2020 23:29:27 +0200 (CEST)
Date:   Thu, 25 Jun 2020 23:29:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v3 2/6] Add cable test TDR support
Message-ID: <20200625212927.7hyoa4dxcnviy2x3@lion.mk-sys.cz>
References: <20200625192446.535754-1-andrew@lunn.ch>
 <20200625192446.535754-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625192446.535754-3-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 09:24:42PM +0200, Andrew Lunn wrote:
> Add support for accessing the cable test time domain reflectromatry
> data. Add a new command --cable-test-tdr, and support for dumping the
> data which is returned.
> 
> signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Looks good to me, except for the use of global variable breakout that I
commented at patch 1/6.

Michal
