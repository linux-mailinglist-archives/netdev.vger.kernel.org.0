Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD135D1B9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhDLUGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:06:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46568 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237396AbhDLUGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:06:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW2p2-00GLNx-0K; Mon, 12 Apr 2021 22:06:12 +0200
Date:   Mon, 12 Apr 2021 22:06:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        johannes.berg@intel.com, danieller@nvidia.com
Subject: Re: [PATCH net resend] ethtool: fix kdoc attr name
Message-ID: <YHSoM+8tr6wdeIPt@lunn.ch>
References: <20210412184707.825656-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412184707.825656-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:47:07AM -0700, Jakub Kicinski wrote:
> Add missing 't' in attrtype.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
