Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AFC29DBB9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390773AbgJ2ANP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390767AbgJ2ANM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXa8t-003uJw-QE; Wed, 28 Oct 2020 02:20:47 +0100
Date:   Wed, 28 Oct 2020 02:20:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "Alexander A . Klimov" <grandmaster@al2klimov.de>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        dccp@vger.kernel.org
Subject: Re: [PATCH net-next] net: dccp: Fix most of the kerneldoc warnings
Message-ID: <20201028012047.GB931318@lunn.ch>
References: <20201028011412.931250-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028011412.931250-1-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two W=1 warnings left after this patch is applied:

net/dccp/ccids/ccid2.c:365: warning: Function parameter or member 'mrtt' not described in 'ccid2_rtt_estimator'
net/dccp/ccids/lib/tfrc_equation.c:695: warning: Function parameter or member 'loss_event_rate' not described in 'tfrc_invert_loss_event_rate'

It would be nice is somebody could fix those as well.

   Andrew
