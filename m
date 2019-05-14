Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3342D1E52B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfENWcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:32:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:32:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 157AB14C02597;
        Tue, 14 May 2019 15:32:05 -0700 (PDT)
Date:   Tue, 14 May 2019 15:32:04 -0700 (PDT)
Message-Id: <20190514.153204.1765753959891355447.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH] NFC: Orphan the subsystem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190514090231.32414-1-johannes@sipsolutions.net>
References: <20190514090231.32414-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:32:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 14 May 2019 11:02:31 +0200

> Samuel clearly hasn't been working on this in many years and
> patches getting to the wireless list are just being ignored
> entirely now. Mark the subsystem as orphan to reflect the
> current state and revert back to the netdev list so at least
> some fixes can be picked up by Dave.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Applied.
