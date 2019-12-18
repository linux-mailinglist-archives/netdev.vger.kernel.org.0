Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA3B1253C1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLRUsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:48:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:47133 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfLRUsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 15:48:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 12:48:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="365856127"
Received: from unknown (HELO [10.241.98.36]) ([10.241.98.36])
  by orsmga004.jf.intel.com with ESMTP; 18 Dec 2019 12:48:23 -0800
Date:   Wed, 18 Dec 2019 12:48:23 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     David Miller <davem@davemloft.net>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
In-Reply-To: <20191218.124244.864160487872326152.davem@davemloft.net>
Message-ID: <alpine.OSX.2.21.1912181244270.32925@mjmartin-mac01.local>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com> <20191218.124244.864160487872326152.davem@davemloft.net>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 18 Dec 2019, David Miller wrote:

> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Date: Wed, 18 Dec 2019 11:54:55 -0800
>
>> v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series
>
> This really can't proceed in this manner.
>
> Wait until one patch series is fully reviewed and integrated before
> trying to build things on top of it, ok?
>
> Nobody is going to review this second series in any reasonable manner
> while the prerequisites are not upstream yet.
>
> Thank you.

Will do. Thank you for the process feedback.


--
Mat Martineau
Intel
