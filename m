Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A6E12BBFE
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfL1Ae2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:34:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1Ae2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:34:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5388154D115C;
        Fri, 27 Dec 2019 16:34:27 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:34:27 -0800 (PST)
Message-Id: <20191227.163427.23695455695969544.davem@davemloft.net>
To:     nikita.yoush@cogentembedded.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cphealy@gmail.com, l.stach@pengutronix.de
Subject: Re: [PATCH v2] mv88e6xxx: Add serdes Rx statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191225052238.23334-1-nikita.yoush@cogentembedded.com>
References: <20191225052238.23334-1-nikita.yoush@cogentembedded.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:34:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Date: Wed, 25 Dec 2019 08:22:38 +0300

> If packet checker is enabled in the serdes, then Rx counter registers
> start working, and no side effects have been detected.
> 
> This patch enables packet checker automatically when powering serdes on,
> and exposes Rx counter registers via ethtool statistics interface.
> 
> Code partially basded by older attempt by Andrew Lunn.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
> ---
> Changes from v1:
> - added missing break statement (thanks kbuild test robot <lkp@intel.com>)
> - renamed variable ret -> err to follow the rest of the file

Applied, thanks Nikita.
