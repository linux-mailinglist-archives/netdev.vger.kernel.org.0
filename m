Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84238490C2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfFQUEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:04:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFQUEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:04:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9F60150FB19B;
        Mon, 17 Jun 2019 13:04:12 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:04:10 -0700 (PDT)
Message-Id: <20190617.130410.2107901726761819200.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     decui@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MW2PR2101MB11168BA3D46BEC843D694E04C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <MW2PR2101MB111697FDA0BEDA81237FECB3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
        <20190617.115615.91633577273679753.davem@davemloft.net>
        <MW2PR2101MB11168BA3D46BEC843D694E04C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 13:04:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Mon, 17 Jun 2019 19:27:45 +0000

> The patch does not change at all. So, I was hoping we could reapply
> it. But, I have resubmitted the patch. Thanks.

It's easy for me to track things if you just resubmit the patch.

That's why I ask for things to be done this way, it helps my workflow
a lot.

Thank you.
