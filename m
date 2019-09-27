Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA0C0BCF
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfI0S4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:56:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfI0S4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:56:14 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3520153F4373;
        Fri, 27 Sep 2019 11:56:11 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:56:10 +0200 (CEST)
Message-Id: <20190927.205610.405337847364577843.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     jakub.kicinski@netronome.com, emamd001@umn.edu, smccaman@umn.edu,
        kjlu@umn.edu, pablo@netfilter.org, john.hurley@netronome.com,
        colin.king@canonical.com, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: abm: fix memory leak in
 nfp_abm_u32_knode_replace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190927015157.20070-1-navid.emamdoost@gmail.com>
References: <20190925215314.10cf291d@cakuba.netronome.com>
        <20190927015157.20070-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:56:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Thu, 26 Sep 2019 20:51:46 -0500

> In nfp_abm_u32_knode_replace if the allocation for match fails it should
> go to the error handling instead of returning. Updated other gotos to
> have correct errno returned, too.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied.
