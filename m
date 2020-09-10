Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080662654D5
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgIJWHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgIJWHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:07:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A9FC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 15:07:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31160135A93F0;
        Thu, 10 Sep 2020 14:50:58 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:07:44 -0700 (PDT)
Message-Id: <20200910.150744.1498111800255613368.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        nikolay@nvidia.com, roopa@nvidia.com,
        vasundhara-v.volam@broadcom.com, jtoppins@redhat.com,
        michael.chan@broadcom.com, andrew@lunn.ch, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net 0/2] net: Fix bridge enslavement failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910110127.3113683-1-idosch@idosch.org>
References: <20200910110127.3113683-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:50:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 10 Sep 2020 14:01:25 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes an issue in which an upper netdev cannot be enslaved to a
> bridge when it has multiple netdevs with different parent identifiers
> beneath it.
> 
> Patch #2 adds a test case using two netdevsim instances.

Series applied and patch #1 queued up for -stable, thank you.
