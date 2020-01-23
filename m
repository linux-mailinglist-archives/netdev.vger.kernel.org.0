Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBA14658D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:21:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:21:27 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78A1A153DBDB8;
        Thu, 23 Jan 2020 02:21:21 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:21:15 +0100 (CET)
Message-Id: <20200123.112115.1188930223656280023.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pmalani@chromium.org, grundler@chromium.org
Subject: Re: [PATCH net v3 0/9] r8152: serial fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-358-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
        <1394712342-15778-358-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:21:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 22 Jan 2020 16:02:04 +0800

> v3:
> 1. Fix the typos for patch #5 and #6.
> 2. Modify the commit message of patch #9.
> 
> v2:
> For patch #2, move declaring the variable "ocp_data".
> 
> v1:
> These patches are used to fix some issues for RTL8153.

Series applied, thank you.
