Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C79274DE8
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgIWAjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgIWAjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:39:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071EEC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:39:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47A2713C05422;
        Tue, 22 Sep 2020 17:22:31 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:39:17 -0700 (PDT)
Message-Id: <20200922.173917.520628776028462701.davem@davemloft.net>
To:     parav@nvidia.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] devlink: Use nla_policy to validate range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921164130.83720-1-parav@nvidia.com>
References: <20200921164130.83720-1-parav@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 17:22:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>
Date: Mon, 21 Sep 2020 19:41:28 +0300

> This two small patches uses nla_policy to validate user specified
> fields are in valid range or not.
> 
> Patch summary:
> Patch-1 checks the range of eswitch mode field
> Patch-2 checks for the port type field. It eliminates a check in
> code by using nla policy infrastructure.

Series applied, thanks.
