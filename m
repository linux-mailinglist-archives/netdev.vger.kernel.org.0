Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C926CE8EE3
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfJ2SAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:00:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40657 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727379AbfJ2SAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:00:16 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1iPVmv-0002zc-0B; Tue, 29 Oct 2019 14:00:13 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x9THtPY8024938;
        Tue, 29 Oct 2019 13:55:25 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x9THtOBv024937;
        Tue, 29 Oct 2019 13:55:24 -0400
Date:   Tue, 29 Oct 2019 13:55:24 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Russell King <rmk@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
Message-ID: <20191029175524.GB8296@tuxdriver.com>
References: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:31:13PM +0100, Russell King wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> A bitrate of 255 is special, it means the bitrate is encoded in
> byte 66 in units of 250MBaud.  Add support for parsing these bit
> rates.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks -- series (1/3 - 3/3) queued for next release...


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
