Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5C023B184
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgHCX73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:59:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgHCX72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 19:59:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2kMZ-0088ms-2e; Tue, 04 Aug 2020 01:59:27 +0200
Date:   Tue, 4 Aug 2020 01:59:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/7] cable_test: clean up unused parameters
Message-ID: <20200803235927.GO1862409@lunn.ch>
References: <cover.1596451857.git.mkubecek@suse.cz>
 <4e6a60bf95b819912eb08cb13276791d8ec9feac.1596451857.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e6a60bf95b819912eb08cb13276791d8ec9feac.1596451857.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 01:57:09PM +0200, Michal Kubecek wrote:
> Functions nl_cable_test_ntf_attr() and nl_cable_test_tdr_ntf_attr() do not
> use nlctx parameter and as they are not callbacks with fixed signature, we
> can simply drop it. Once we do, the same is true for cable_test_ntf_nest()
> and cable_test_tdr_ntf_nest().
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
