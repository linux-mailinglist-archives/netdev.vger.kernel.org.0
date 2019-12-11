Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963D311A083
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfLKBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:31:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51112 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfLKBba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:31:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB39615038ABC;
        Tue, 10 Dec 2019 17:31:29 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:31:29 -0800 (PST)
Message-Id: <20191210.173129.1090510183877704403.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, lxin@redhat.com, shuali@redhat.com,
        ying.xue@windriver.com, edumazet@google.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 0/3] tipc: introduce variable window congestion
 control
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
References: <1575935566-18786-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:31:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Tue, 10 Dec 2019 00:52:43 +0100

> We improve thoughput greatly by introducing a variety of the Reno 
> congestion control algorithm at the link level.

Series applied, thanks Jon.
