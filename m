Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A371D1FC7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbgEMUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733135AbgEMUAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:00:21 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE329C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:00:20 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYxY3-00022b-Gb; Wed, 13 May 2020 16:00:11 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04DJwd0g668302;
        Wed, 13 May 2020 15:58:39 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04DJwcR0668301;
        Wed, 13 May 2020 15:58:38 -0400
Date:   Wed, 13 May 2020 15:58:38 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, ivecera@redhat.com,
        idosch@mellanox.com, roopa@cumulusnetworks.com,
        pschmidt@cumulusnetworks.com
Subject: Re: [PATCH ethtool] ethtool: add support for newer SFF-8024
 compliance codes
Message-ID: <20200513195838.GI650568@tuxdriver.com>
References: <1588959847-46505-1-git-send-email-aroulin@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588959847-46505-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 10:44:07AM -0700, Andy Roulin wrote:
> From: Paul Schmidt <pschmidt@cumulusnetworks.com>
> 
> This change adds support for newer compliance codes defined in
> SFF-8024.
> 
> Standards for SFF-8024
> a) SFF_8024 Rev 4.9 dated Jan 8, 2020
> 
> Signed-off-by: Paul Schmidt <pschmidt@cumulusnetworks.com>
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>

Thanks (belatedly) -- queued for next release!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
