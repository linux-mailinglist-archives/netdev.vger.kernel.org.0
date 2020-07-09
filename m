Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20C021ABA7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGIXa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgGIXaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 19:30:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC99C08C5CE;
        Thu,  9 Jul 2020 16:30:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1EBD120F93FA;
        Thu,  9 Jul 2020 16:30:54 -0700 (PDT)
Date:   Thu, 09 Jul 2020 16:30:54 -0700 (PDT)
Message-Id: <20200709.163054.1621115392152399823.davem@davemloft.net>
To:     mark.tomlinson@alliedtelesis.co.nz
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Support more than 32 MIFS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709232734.12814-1-mark.tomlinson@alliedtelesis.co.nz>
References: <20200709232734.12814-1-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 16:30:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Date: Fri, 10 Jul 2020 11:27:34 +1200

> As background to this patch, we have MAXMIFS set to 1025 in our kernel.

This patch is pointless without that adjustment, so it really doesn't
belong upstream until you tackle the whole entire problem and therefore
make the limit able to be set higher or at run time.

I'm not applying this.
