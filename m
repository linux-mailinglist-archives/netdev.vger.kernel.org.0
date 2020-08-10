Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC6A240760
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHJOUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:20:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHJOUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:20:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k58ej-008xEP-Kd; Mon, 10 Aug 2020 16:20:05 +0200
Date:   Mon, 10 Aug 2020 16:20:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 4/7] get rid of signed/unsigned comparison
 warnings in register dump parsers
Message-ID: <20200810142005.GG2123435@lunn.ch>
References: <cover.1597007532.git.mkubecek@suse.cz>
 <e135e814d434e58579969b838c3fc6bd9192f59b.1597007533.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e135e814d434e58579969b838c3fc6bd9192f59b.1597007533.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:24:29PM +0200, Michal Kubecek wrote:
> All of these are avoided by declaring a variable (mostly loop iterators)
> holding only unsigned values as unsigned.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
