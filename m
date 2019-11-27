Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9E710B6A7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfK0TYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:24:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfK0TYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:24:02 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9057F14A6F7E7;
        Wed, 27 Nov 2019 11:24:01 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:24:01 -0800 (PST)
Message-Id: <20191127.112401.1924842050321978996.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH v3 net-next] Enhanced skb_mpls_pop to update ethertype
 of the packet in all the cases when an ethernet header is present is the
 packet.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 11:24:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, please resubmit this when net-next opens back up.

Thank you.
