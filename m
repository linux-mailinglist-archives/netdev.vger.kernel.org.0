Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB6A266A13
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIKVcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgIKVcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:32:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8CFC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:32:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6038136663E3;
        Fri, 11 Sep 2020 14:15:26 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:32:10 -0700 (PDT)
Message-Id: <20200911.143210.1194541030691809942.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     awogbemila@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/8] Add GVE Features.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911135533.5ec11992@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200911173851.2149095-1-awogbemila@google.com>
        <20200911135533.5ec11992@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:15:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 11 Sep 2020 13:55:33 -0700

> On Fri, 11 Sep 2020 10:38:43 -0700 David Awogbemila wrote:
>> Note: Patch 4 in v3 was dropped.
>> 
>> Patch 4 (patch 5 in v3): Start/stop timer only when report stats is
>> 				enabled/disabled.
>> Patch 7 (patch 8 in v3): Use netdev_info, not dev_info, to log
>> 				device link status.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
