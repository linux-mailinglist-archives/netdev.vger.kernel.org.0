Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5EF273B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfKGFqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:46:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfKGFqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:46:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 809EC151226CB;
        Wed,  6 Nov 2019 21:46:10 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:46:10 -0800 (PST)
Message-Id: <20191106.214610.1534756587605126490.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v3 00/13][pull request] 100GbE Intel Wired LAN
 Driver Updates 2019-11-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
References: <20191107005220.1039-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:46:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed,  6 Nov 2019 16:52:07 -0800

> This series contains updates to ice driver only.

Pulled, thanks Jeff.
