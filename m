Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4901E1334E2
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgAGVay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:30:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgAGVay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:30:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7096F15A17077;
        Tue,  7 Jan 2020 13:30:53 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:30:52 -0800 (PST)
Message-Id: <20200107.133052.439656166097762856.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 0/2] net: ch9200: code cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107092856.97742-1-chenzhou10@huawei.com>
References: <20200107092856.97742-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:30:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Tue, 7 Jan 2020 17:28:54 +0800

> patch 1 introduce __func__ in debug message.
> patch 2 remove unnecessary return.

Series applied, thanks.
