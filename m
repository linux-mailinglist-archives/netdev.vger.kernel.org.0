Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99615DB75E
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503449AbfJQTWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:22:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfJQTWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:22:02 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6ACC914047CFA;
        Thu, 17 Oct 2019 12:22:01 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:22:00 -0400 (EDT)
Message-Id: <20191017.152200.1589061319789109083.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v4 00/10] optimize openvswitch flow looking up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:22:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Tue, 15 Oct 2019 18:30:30 +0800

> This series patch optimize openvswitch for performance or simplify
> codes.
 ...

Pravin and company, please review!
