Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D116175F
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfGGTzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:55:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGGTzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:55:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31CEF1527BF08;
        Sun,  7 Jul 2019 12:55:06 -0700 (PDT)
Date:   Sun, 07 Jul 2019 12:55:05 -0700 (PDT)
Message-Id: <20190707.125505.687465639567831845.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-07-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707080749.GA26799@lazarenk-mobl.amr.corp.intel.com>
References: <20190707080749.GA26799@lazarenk-mobl.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 12:55:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Sun, 7 Jul 2019 11:07:49 +0300

> Here's the main bluetooth-next pull request for 5.3:
> 
>  - Added support for new devices from Qualcomm, Realtek and Broadcom and
>    MediaTek
>  - Various fixes to 6LoWPAN
>  - Fix L2CAP PSM namespace separation for LE & BR/EDR
>  - Fix behavior with Microsoft Surface Precision Mouse
>  - Added support for LE Ping feature
>  - Fix L2CAP Disconnect response handling if received in wrong state
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks.
