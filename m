Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E0927A91
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfEWKcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:32:50 -0400
Received: from mail5.windriver.com ([192.103.53.11]:57282 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfEWKcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 06:32:50 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x4NAUiWV008275
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Thu, 23 May 2019 03:30:55 -0700
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 23 May
 2019 03:30:34 -0700
Subject: Re: [PATCH v2] tipc: Avoid copying bytes beyond the supplied data
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "niveditas98@gmail.com" <niveditas98@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190520034536.22782-1-chris.packham@alliedtelesis.co.nz>
 <2830aab3-3fa9-36d2-5646-d5e4672ae263@windriver.com>
 <00ce1b1e52ac4b729d982c86127334aa@svr-chch-ex1.atlnz.lc>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <11c81207-54dd-16d5-3f33-1ccf45a06dac@windriver.com>
Date:   Thu, 23 May 2019 18:20:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <00ce1b1e52ac4b729d982c86127334aa@svr-chch-ex1.atlnz.lc>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 4:46 AM, Chris Packham wrote:
> On most distros that is generated from include/uapi in the kernel source 
> and packaged as part of libc or a kernel-headers package. So once this 
> patch is accepted and makes it into the distros 
> /usr/include/linux/tipc_config.h will have this fix.

Thanks for the clarification. You are right, so it's unnecessary to make
any change.
