Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8FB2246D
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 20:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfERSOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 14:14:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfERSOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 14:14:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A90314DE0A2B;
        Sat, 18 May 2019 11:14:29 -0700 (PDT)
Date:   Sat, 18 May 2019 11:14:27 -0700 (PDT)
Message-Id: <20190518.111427.1027480799644374908.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv_sock: perf: Allow the socket buffer size options to
 influence the actual socket buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN6PR21MB046528E2099CDE2C6C2200A7C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB046528E2099CDE2C6C2200A7C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 11:14:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


These two changes really look like net-next material, and net-next is
closed at the moment.

Please resubmit these when net-next opens back up.

Thank you.
