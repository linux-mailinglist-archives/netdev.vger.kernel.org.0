Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90683269482
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgINSKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:10:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:1483 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgINSIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:08:53 -0400
IronPort-SDR: hWQ77apaUJwkBvIMqgsAS3cuol/GFPLT7/EGthS+ghlQBa3MdLprZpNumXSP6dfChEzCWO6In0
 ZdHJuHm+8J5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160067851"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160067851"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:53 -0700
IronPort-SDR: eUkFzXKVqf7eQedYcVUCUU4e6OoJldUFz0t+hp5R8s7X8cKllhSQper019MedJvP9xYwG/NpaH
 6ml/ybE4hZ8g==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482446293"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:52 -0700
Date:   Mon, 14 Sep 2020 11:08:52 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 10/13] mptcp: allow creating non-backup
 subflows
In-Reply-To: <263d1338783f1995a46f13fbae804568ee18cb0d.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141108400.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <263d1338783f1995a46f13fbae804568ee18cb0d.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Currently the 'backup' attribute of local endpoint
> is ignored. Let's use it for the MP_JOIN handshake
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/subflow.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
