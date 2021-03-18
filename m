Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF7E33FDB0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhCRDT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:19:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60064 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhCRDTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:19:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BF2964D31C508;
        Wed, 17 Mar 2021 20:19:52 -0700 (PDT)
Date:   Wed, 17 Mar 2021 20:19:48 -0700 (PDT)
Message-Id: <20210317.201948.1069484608502867994.davem@davemloft.net>
To:     andreas.a.roeseler@gmail.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dsahern@kernel.org
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
References: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
        <202103150433.OwOTmI15-lkp@intel.com>
        <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 17 Mar 2021 20:19:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Roeseler <andreas.a.roeseler@gmail.com>
Date: Wed, 17 Mar 2021 22:11:47 -0500

> On Mon, 2021-03-15 at 04:35 +0800, kernel test robot wrote:
> Is there something that I'm not understanding about compiling kernel
> components modularly? How do I avoid this error?

> 
You cannot reference module exported symbols from statically linked code.
y
