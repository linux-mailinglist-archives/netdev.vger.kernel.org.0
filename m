Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6520A8A1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407711AbgFYXNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403984AbgFYXNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:13:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54FC08C5DB
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:13:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C50E7153D87EF;
        Thu, 25 Jun 2020 16:13:00 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:13:00 -0700 (PDT)
Message-Id: <20200625.161300.966816418534612119.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, julien@cumulusnetworks.com
Subject: Re: [PATCH net] vxlan: fix last fdb index during dump of fdb with
 nhid 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593032556-40360-1-git-send-email-roopa@cumulusnetworks.com>
References: <1593032556-40360-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:13:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Wed, 24 Jun 2020 14:02:36 -0700

> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This patch fixes last saved fdb index in fdb dump handler when
> handling fdb's with nhid.
> 
> Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Applied, thanks Roopa.
