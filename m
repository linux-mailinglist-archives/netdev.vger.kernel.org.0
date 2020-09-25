Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6214277CBC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIYARO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:17:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:58852 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIYARH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:17:07 -0400
IronPort-SDR: pPGwPLlIYbkNAv2KU1093WAWSWr7XnwEGWFoLYimeDK90BUFh7cZlg57UykKe7s666BYHMSZKH
 kZhZJmLS2Eig==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222979884"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222979884"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:17:07 -0700
IronPort-SDR: LTTCmJlt6Cj5rR7JUyFckU4Luzk5z0LZJynV203mZP124MzczaoZsM1WpZ7u3YvdVbN6bPh/n6
 VVrIjUrxcWUg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455582952"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:17:07 -0700
Date:   Thu, 24 Sep 2020 17:17:06 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 01/16] mptcp: rename addr_signal and the
 related functions
In-Reply-To: <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241716300.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch renamed addr_signal and the related functions with the explicit
> word "add".
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/options.c  | 14 +++++++-------
> net/mptcp/pm.c       | 12 ++++++------
> net/mptcp/protocol.h | 10 +++++-----
> 3 files changed, 18 insertions(+), 18 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
