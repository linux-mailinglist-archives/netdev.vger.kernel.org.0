Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4D23B01D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgHCWSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgHCWSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:18:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE7C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:18:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EA6E12771D86;
        Mon,  3 Aug 2020 15:01:19 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:18:03 -0700 (PDT)
Message-Id: <20200803.151803.1395573516468811018.davem@davemloft.net>
To:     echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de,
        xiangxia.m.yue@gmail.com
Subject: Re: [PATCH net-next v4 0/2] net: openvswitch: masks cache
 enhancements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159619801209.973760.834607259658375498.stgit@ebuild>
References: <159619801209.973760.834607259658375498.stgit@ebuild>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:01:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>
Date: Fri, 31 Jul 2020 14:20:34 +0200

> This patchset adds two enhancements to the Open vSwitch masks cache.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Series applied, thank you.
