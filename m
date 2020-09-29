Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8052A27D96F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgI2U66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgI2U6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:58:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5552AC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:58:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 352CC13B70115;
        Tue, 29 Sep 2020 13:42:05 -0700 (PDT)
Date:   Tue, 29 Sep 2020 13:58:52 -0700 (PDT)
Message-Id: <20200929.135852.912893435073339349.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [net-next] devlink: include <linux/const.h> for _BITUL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929180859.3477990-1-jacob.e.keller@intel.com>
References: <20200929180859.3477990-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 13:42:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 29 Sep 2020 11:08:59 -0700

> Commit 5d5b4128c4ca ("devlink: introduce flash update overwrite mask")
> added a usage of _BITUL to the UAPI <linux/devlink.h> header, but failed
> to include the header file where it was defined. It happens that this
> does not break any existing kernel include chains because it gets
> included through other sources. However, when including the UAPI headers
> in a userspace application (such as devlink in iproute2), _BITUL is not
> defined.
> 
> Fixes: 5d5b4128c4ca ("devlink: introduce flash update overwrite mask")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied.
