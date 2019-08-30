Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51238A3F09
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfH3Udj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:33:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3Udi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:33:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04055154FB632;
        Fri, 30 Aug 2019 13:33:37 -0700 (PDT)
Date:   Fri, 30 Aug 2019 13:33:35 -0700 (PDT)
Message-Id: <20190830.133335.323827182628557013.davem@davemloft.net>
To:     zdai@linux.vnet.ibm.com
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zdai@us.ibm.com
Subject: Re: [v2] net_sched: act_police: add 2 new attributes to support
 police 64bit rate and peakrate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567195432.20025.18.camel@oc5348122405>
References: <1567191974-11578-1-git-send-email-zdai@linux.vnet.ibm.com>
        <CAM_iQpVMYQUdQN5L+ntXZTffZkW4q659bvXoZ8+Ar+zeud7Y4Q@mail.gmail.com>
        <1567195432.20025.18.camel@oc5348122405>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 13:33:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "David Z. Dai" <zdai@linux.vnet.ibm.com>
Date: Fri, 30 Aug 2019 15:03:52 -0500

> I have the impression that last parameter num value should be larger
> than the attribute num value in 2nd parameter (TC_POLICE_RATE64 in this
> case).

The argument in question is explicitly the "padding" value.

Please explain in detail where you got the impression that the
argument has to be larger?
