Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6626946F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgINSIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:08:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:65483 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgINSIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:08:07 -0400
IronPort-SDR: ilo3HgEGUBa9S+g/heh2RFjWLkmeM1zYO4eBDjB7AHhOKtQz91H/8A1qqzG0DHj1Udt9XQzGNw
 BwB2vECKYRNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="156569355"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="156569355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:07 -0700
IronPort-SDR: uZ4U8Nxb5AcODeAuxs9DVhUNJKn/V+INaRemY00xbyozaNoP7/znziFjdFhGiPDP6VaDdXRYIg
 CjepmG11szxw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482445994"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:06 -0700
Date:   Mon, 14 Sep 2020 11:08:06 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 08/13] mptcp: add OoO related mibs
In-Reply-To: <a968da10355e303d483a9d12409930e80ab7fccd.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141107500.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <a968da10355e303d483a9d12409930e80ab7fccd.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Add a bunch of MPTCP mibs related to MPTCP OoO data
> processing.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/mib.c      |  5 +++++
> net/mptcp/mib.h      |  5 +++++
> net/mptcp/protocol.c | 24 +++++++++++++++++++++++-
> net/mptcp/subflow.c  |  1 +
> 4 files changed, 34 insertions(+), 1 deletion(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
