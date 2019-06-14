Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EC6467CE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFNSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36368 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfFNSpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:45:14 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hbrCK-0002jl-NM; Fri, 14 Jun 2019 14:45:12 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x5EIdlis027736;
        Fri, 14 Jun 2019 14:39:47 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x5EIdlrr027735;
        Fri, 14 Jun 2019 14:39:47 -0400
Date:   Fri, 14 Jun 2019 14:39:47 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, Mikhael Goikhman <migo@mellanox.com>,
        Tzafrir Cohen <tzafrirc@mellanox.com>
Subject: Re: [PATCH ethtool] ethtool.spec: Use standard file location macros
Message-ID: <20190614183947.GC23700@tuxdriver.com>
References: <1558339780-8314-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558339780-8314-1-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 11:09:40AM +0300, Tariq Toukan wrote:
> From: Mikhael Goikhman <migo@mellanox.com>
> 
> Use _prefix and _sbindir macros to allow building the package under a
> different prefix.
> 
> Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
> Signed-off-by: Tzafrir Cohen <tzafrirc@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> ---
>  ethtool.spec.in | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks for the patch! Queued for next release...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
