Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B3628279F
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgJDAdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgJDAdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:33:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317F3C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 17:33:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 671C711E3E4CA;
        Sat,  3 Oct 2020 17:16:24 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:33:11 -0700 (PDT)
Message-Id: <20201003.173311.397891743703742478.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 0/2] net/sched: Add actions for MPLS L2 VPNs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1601673174.git.gnault@redhat.com>
References: <cover.1601673174.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:16:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Sat, 3 Oct 2020 00:44:25 +0200

> This patch series adds the necessary TC actions for supporting layer 2
> MPLS VPNs (VPLS).
 ...

Series applied, thank you.
