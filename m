Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1252914943A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYJnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:43:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgAYJnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:43:40 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81DB915A313CD;
        Sat, 25 Jan 2020 01:43:37 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:43:35 +0100 (CET)
Message-Id: <20200125.104335.691207335724358170.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4,net-next, 0/2] hv_netvsc: Add XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579816355-6933-1-git-send-email-haiyangz@microsoft.com>
References: <1579816355-6933-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:43:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 23 Jan 2020 13:52:33 -0800

> Add XDP support and update related document.

Series applied, thakns.
