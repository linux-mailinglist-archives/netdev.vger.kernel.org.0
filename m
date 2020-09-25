Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C867277CD5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgIYAZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:25:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:30770 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYAZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:25:18 -0400
IronPort-SDR: 8rI+TwbpJs7HwoLw4ysY00PexZ1YgNRcYFcGmfh3kW9KCFBeqQH6QPQpVCjIuAKScehMAu2Rk9
 yN1k9NoMU5Cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179478957"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="179478957"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:25:18 -0700
IronPort-SDR: y0yEtrg7FvxH5wwSySON8Lv9avR9VtfWWQCAItkbz8soPJpkT0K+cYLCWX89vJLQMxfD4OuxRw
 OHflerfHjf9w==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455589542"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:25:18 -0700
Date:   Thu, 24 Sep 2020 17:25:18 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 13/16] selftests: mptcp: add remove addr
 and subflow test cases
In-Reply-To: <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241724440.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added the remove addr and subflow test cases and two new
> functions.
>
> The first function run_remove_tests calls do_transfer with two new
> arguments, rm_nr_ns1 and rm_nr_ns2, for the numbers of addresses should be
> removed during the transfer process in namespace 1 and namespace 2.
>
> If both these two arguments are 0, we do the join test cases with
> "mptcp_connect -j" command. Otherwise, do the remove test cases with
> "mptcp_connect -r" command.
>
> The second function chk_rm_nr checks the RM_ADDR related mibs's counters.
>
> The output of the test cases looks like this:
>
> 11 remove single subflow           syn[ ok ] - synack[ ok ] - ack[ ok ]
>                                   rm [ ok ] - sf    [ ok ]
> 12 remove multiple subflows        syn[ ok ] - synack[ ok ] - ack[ ok ]
>                                   rm [ ok ] - sf    [ ok ]
> 13 remove single address           syn[ ok ] - synack[ ok ] - ack[ ok ]
>                                   add[ ok ] - echo  [ ok ]
>                                   rm [ ok ] - sf    [ ok ]
> 14 remove subflow and signal       syn[ ok ] - synack[ ok ] - ack[ ok ]
>                                   add[ ok ] - echo  [ ok ]
>                                   rm [ ok ] - sf    [ ok ]
> 15 remove subflows and signal      syn[ ok ] - synack[ ok ] - ack[ ok ]
>                                   add[ ok ] - echo  [ ok ]
>                                   rm [ ok ] - sf    [ ok ]
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> .../testing/selftests/net/mptcp/mptcp_join.sh | 145 +++++++++++++++++-
> 1 file changed, 142 insertions(+), 3 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
