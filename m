Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5304A277CDA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgIYA0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:26:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:9008 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYA0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:26:34 -0400
IronPort-SDR: WVNU9TBl5gdICLGJGyeFc79Tip34e5KT87t6C+CV8m2ZuXIETDYEUTb0GWhUXz17I0jndb5G5C
 J8ogTtgmA5hQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="246177108"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="246177108"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:26:34 -0700
IronPort-SDR: Addtap2QFWMo9qhWLVps4Tt+F9kcvyNqQcOyjGdADLfA9TfMtoiFUHKEkzxZwPMOcUVMSA1J/4
 qZBQur81IEjg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455590434"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:26:33 -0700
Date:   Thu, 24 Sep 2020 17:26:33 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 15/16] mptcp: add sk_stop_timer_sync
 helper
In-Reply-To: <31247220b62d6759de9eb91b841be449714b9d69.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241726230.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <31247220b62d6759de9eb91b841be449714b9d69.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added a new helper sk_stop_timer_sync, it deactivates a timer
> like sk_stop_timer, but waits for the handler to finish.
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> include/net/sock.h | 2 ++
> net/core/sock.c    | 7 +++++++
> 2 files changed, 9 insertions(+)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
