Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8A859FB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbfHHFsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:48:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:58339 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfHHFsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:48:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="176415180"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2019 22:48:13 -0700
Date:   Wed, 7 Aug 2019 22:48:12 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <jiri@resnulli.us>,
        <jay.vosburgh@canonical.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] team: Add vlan tx offload to hw_enc_features
Message-ID: <20190807224812.00004e0f@intel.com>
In-Reply-To: <20190807023808.51976-1-yuehaibing@huawei.com>
References: <20190807023808.51976-1-yuehaibing@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 10:38:08 +0800
YueHaibing <yuehaibing@huawei.com> wrote:

> We should also enable bonding's vlan tx offload in hw_enc_features,

You mean team's vlan tx offload?

> pass the vlan packets to the slave devices with vlan tci, let them

s/let them to/let the slave/

> to handle vlan tunneling offload implementation.
> 
> Fixes: 3268e5cb494d ("team: Advertise tunneling offload features")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

