Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F6B25C920
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgICTMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICTMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:12:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BE7C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 12:12:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14D0E15C8688F;
        Thu,  3 Sep 2020 11:55:44 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:12:30 -0700 (PDT)
Message-Id: <20200903.121230.1868771576600220065.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, vadimp@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/3] mlxsw: Expose critical and emergency
 module alarms
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903134146.2166437-1-idosch@idosch.org>
References: <20200903134146.2166437-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 11:55:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  3 Sep 2020 16:41:43 +0300

> Amit says:
> 
> Extend hwmon interface with critical and emergency module alarms.
 ...

Looks good, series applied, thanks.
