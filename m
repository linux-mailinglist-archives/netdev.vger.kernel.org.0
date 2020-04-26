Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E53C1B8BC6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDZDsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgDZDsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:48:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737CAC061A0C;
        Sat, 25 Apr 2020 20:48:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDC49159FFC4A;
        Sat, 25 Apr 2020 20:48:36 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:48:36 -0700 (PDT)
Message-Id: <20200425.204836.2190122326484289412.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     eric.dumazet@gmail.com, geert@linux-m68k.org, pshelar@ovn.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: openvswitch: suitable access to the dp_meters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:48:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sat, 25 Apr 2020 11:39:47 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> To fix the following sparse warning:
> | net/openvswitch/meter.c:109:38: sparse: sparse: incorrect type
> | in assignment (different address spaces) ...
> | net/openvswitch/meter.c:720:45: sparse: sparse: incorrect type
> | in argument 1 (different address spaces) ...
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied.
