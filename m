Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68123A47FB
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfIAGzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:55:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfIAGzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:55:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8519514CDD095;
        Sat, 31 Aug 2019 23:46:26 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:46:26 -0700 (PDT)
Message-Id: <20190831.234626.1237775551092229590.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     parav@mellanox.com, netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/2] Minor cleanup in devlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830231436.34f221b2@cakuba.netronome.com>
References: <20190830103945.18097-1-parav@mellanox.com>
        <20190830231436.34f221b2@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:46:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 30 Aug 2019 23:14:36 -0700

> On Fri, 30 Aug 2019 05:39:43 -0500, Parav Pandit wrote:
>> Two minor cleanup in devlink.
>> 
>> Patch-1 Explicitly defines devlink port index as unsigned int
>> Patch-2 Uses switch-case to handle different port flavours attributes
> 
> Always nice to see one's comment addressed, even if it takes a while :)
> 
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Series applied.
