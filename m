Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841B1180569
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgCJRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:48:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58918 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgCJRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:48:05 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EC5988008D;
        Tue, 10 Mar 2020 17:48:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 10 Mar
 2020 17:47:59 +0000
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@mellanox.com>,
        <pablo@netfilter.org>
References: <20200310154909.3970-1-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e932060b-6a5d-57f7-3e11-51a437b9e23f@solarflare.com>
Date:   Tue, 10 Mar 2020 17:47:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25280.003
X-TM-AS-Result: No-3.439000-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjGgvXRQfjH9PZvT2zYoYOwC/ExpXrHizzlfy382QpXGUYj
        NK+Q6GZAEIp3psuvfKhEKy+CDOrUrZzNs/5KQtdlSHCU59h5KrHkY10aGY0Q4d9RlPzeVuQQCh5
        FGEJlYgGe8FYbkZPwlyqrdhRtfw3QTX7PJ/OU3vKDGx/OQ1GV8mMVPzx/r2cb+gtHj7OwNO2Ohz
        Oa6g8KrUaNByScOb99C+K2EMhCdFFvxJ1Tlg/lHxLVe/AV7kzip2ydyDig2gH0NrSi46pN5iDz4
        QXADArdtlLrlqDjGXOCPZcbkTcNs+L59MzH0po2K2yzo9Rrj9wPoYC35RuihKPUI7hfQSp5eCBc
        UCG1aJiUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.439000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25280.003
X-MDID: 1583862485-MNT1I5C-xN8U
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2020 15:49, Jiri Pirko wrote:
> This patchset includes couple of patches in reaction to the discussions
> to the original HW stats patchset. The first patch is a fix,
> the other two patches are basically cosmetics.
>
> Jiri Pirko (3):
>   flow_offload: fix allowed types check
>   flow_offload: turn hw_stats_type into dedicated enum
>   flow_offload: restrict driver to pass one allowed bit to
>     flow_action_hw_stats_types_check()
>
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +-
>  include/net/flow_offload.h                    | 46 +++++++++++++------
>  2 files changed, 35 insertions(+), 15 deletions(-)
>
Acked-by: Edward Cree <ecree@solarflare.com>
