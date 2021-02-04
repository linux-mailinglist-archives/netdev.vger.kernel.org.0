Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7CE30FC67
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbhBDTQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:16:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:56900 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239697AbhBDTPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:15:09 -0500
IronPort-SDR: hOrtUvbYDXUK9qcHYFrJYEkYg22IDabd0vZIjo4Zc+20FVs65zJAKgFUtfT2vzhIVKaCwn2WJQ
 VZYxTdzEa7AA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="180536554"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="180536554"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:14:27 -0800
IronPort-SDR: VzWfKZDXr+dg50STTy+StVAYb7JNjC42vWasa5Fg1uqgp9yBQMK29R72QK6mYCipNB6L3iIeQN
 0c6b2dxjuh+w==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393330204"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:14:27 -0800
Date:   Thu, 4 Feb 2021 11:14:26 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-decnet-user@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: Return the correct errno code
Message-ID: <20210204111426.00001bba@intel.com>
In-Reply-To: <20210204085630.19452-1-zhengyongjun3@huawei.com>
References: <20210204085630.19452-1-zhengyongjun3@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun wrote:

> When kzalloc failed, should return ENOMEM rather than ENOBUFS.

All these patches have the same subject and description, couldn't they
just be part of a single series with a good cover letter?

I'm not saying make them a single patch, because that is bad for
bisection, but having them as a single series means we review related
changes at one time, and can comment on them as a group.

