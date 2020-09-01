Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF0A25A12A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgIAWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:06:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgIAWGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 18:06:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDEQC-00CovL-9y; Wed, 02 Sep 2020 00:06:32 +0200
Date:   Wed, 2 Sep 2020 00:06:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 1/9] gve: Get and set Rx copybreak via ethtool
Message-ID: <20200901220632.GC3050651@lunn.ch>
References: <20200901215149.2685117-1-awogbemila@google.com>
 <20200901215149.2685117-2-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901215149.2685117-2-awogbemila@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 02:51:41PM -0700, David Awogbemila wrote:
> From: Kuo Zhao <kuozhao@google.com>
> 
> This adds support for getting and setting the RX copybreak
> value via ethtool.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Kuo Zhao <kuozhao@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
