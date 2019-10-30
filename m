Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3429E9598
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfJ3EMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:12:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfJ3EMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:12:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F9B414B7BF84;
        Tue, 29 Oct 2019 21:12:54 -0700 (PDT)
Date:   Tue, 29 Oct 2019 21:12:54 -0700 (PDT)
Message-Id: <20191029.211254.491916646468051672.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v5 00/10] optimize openvswitch flow looking up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 21:12:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Date: Sat, 19 Oct 2019 16:08:34 +0800

The date on your postings is in the past.
