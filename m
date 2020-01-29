Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597D114CF4C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgA2RJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:09:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:36543 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgA2RJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 12:09:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 09:09:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,378,1574150400"; 
   d="scan'208";a="314882181"
Received: from cmossx-mobl1.amr.corp.intel.com ([10.251.7.89])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 09:09:13 -0800
Date:   Wed, 29 Jan 2020 09:09:12 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cmossx-mobl1.amr.corp.intel.com
To:     Randy Dunlap <rdunlap@infradead.org>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: mptcp@ mailing list is moderated
In-Reply-To: <0d3e4e6f-5437-ae85-f1f5-89971ea3423f@infradead.org>
Message-ID: <alpine.OSX.2.21.2001290857310.9282@cmossx-mobl1.amr.corp.intel.com>
References: <0d3e4e6f-5437-ae85-f1f5-89971ea3423f@infradead.org>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 28 Jan 2020, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
>
> Note that mptcp@lists.01.org is moderated, like we note for
> other mailing lists.

Hi Randy -

The mptcp@lists.01.org list is not moderated, but there's a server-wide 
default rule that holds messages with 10 or more recipients for any sender 
(list member or not). I've turned off those server-wide defaults for this 
list so it shouldn't be a problem in the future.

Thank you for your report on the build errors.


Mat


>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Cc: netdev@vger.kernel.org
> Cc: mptcp@lists.01.org
> ---
> MAINTAINERS |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- mmotm-2020-0128-2005.orig/MAINTAINERS
> +++ mmotm-2020-0128-2005/MAINTAINERS
> @@ -11718,7 +11718,7 @@ NETWORKING [MPTCP]
> M:	Mat Martineau <mathew.j.martineau@linux.intel.com>
> M:	Matthieu Baerts <matthieu.baerts@tessares.net>
> L:	netdev@vger.kernel.org
> -L:	mptcp@lists.01.org
> +L:	mptcp@lists.01.org (moderated for non-subscribers)
> W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
> B:	https://github.com/multipath-tcp/mptcp_net-next/issues
> S:	Maintained
>
>

--
Mat Martineau
Intel
