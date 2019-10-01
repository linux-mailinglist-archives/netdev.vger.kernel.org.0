Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7585C434D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfJAV6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:58:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJAV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:58:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79D561264C669;
        Tue,  1 Oct 2019 14:58:12 -0700 (PDT)
Date:   Tue, 01 Oct 2019 14:58:11 -0700 (PDT)
Message-Id: <20191001.145811.1299440084723321216.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] optimize openvswitch flow looking up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 14:58:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Mon, 30 Sep 2019 01:09:57 +0800

> This series patch optimize openvswitch.

Someone please review this series.

Thank you.
