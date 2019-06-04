Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692CD34CDC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfFDQIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:08:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:25369 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbfFDQIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 12:08:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 09:08:42 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.241.225.31])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jun 2019 09:08:41 -0700
Date:   Tue, 4 Jun 2019 09:08:41 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Xue Chaojing <xuechaojing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoshaokai@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: Re: [PATCH net-next v4] hinic: add LRO support
Message-ID: <20190604090841.00007d28@intel.com>
In-Reply-To: <20190604011608.26485-1-xuechaojing@huawei.com>
References: <20190604011608.26485-1-xuechaojing@huawei.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 01:16:08 +0000 Xue wrote:
> This patch adds LRO support for the HiNIC driver.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>

Hm, you added my reviewed-by tag, but I didn't add it myself, I
only commented on your code.  This is a no-no. You don't add tags with
other people's names just because you think you can/should.

If someone EXPLICITLY says: "go ahead and add my reviewed-by after these
changes" then you can add it yourself.

Also, what did you change in v1:v4? There should be a summary somewhere
in the commit log (usually after a ---)

FWIW, I looked over the code and my concerns were addressed.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
