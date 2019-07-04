Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096D75F4B1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfGDIkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4037 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfGDIku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 04:40:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E8EA356D2;
        Thu,  4 Jul 2019 08:40:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B83E1001B19;
        Thu,  4 Jul 2019 08:40:48 +0000 (UTC)
Message-ID: <0130c56ef79f8bf360ddb0b01db5e7684f0bf62a.camel@redhat.com>
Subject: Re: [PATCH net-next v5 5/5] selftests: tc-tests: actions: add MPLS
 tests
From:   Davide Caratti <dcaratti@redhat.com>
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
In-Reply-To: <1562113531-29296-6-git-send-email-john.hurley@netronome.com>
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
         <1562113531-29296-6-git-send-email-john.hurley@netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 04 Jul 2019 10:40:47 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 04 Jul 2019 08:40:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-03 at 01:25 +0100, John Hurley wrote:
> Add a new series of selftests to verify the functionality of act_mpls in
> TC.
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
>  1 file changed, 812 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
> 

hello John,

(sorry for noticing this late). some scripts use 

tools/testing/selftests/tc-testing/config

to rebuild vmlinux before running TDC. I think you should add a line
there that sets CONFIG_NET_ACT_MPLS=y.

WDYT?

thanks!
-- 
davide

