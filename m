Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF123D62DA
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbfJNMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:43:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42149 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbfJNMnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 08:43:03 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iJzga-0004y4-EO; Mon, 14 Oct 2019 08:42:58 -0400
Date:   Mon, 14 Oct 2019 08:42:49 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, David Laight <david.laight@aculab.com>
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Message-ID: <20191014124249.GB11844@hmswarspite.think-freely.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 02:14:43PM +0800, Xin Long wrote:
> SCTP-PF was implemented based on a Internet-Draft in 2012:
> 
>   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> 
> It's been updated quite a few by rfc7829 in 2016.
> 
> This patchset adds the following features:
> 
>   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
>   2. add pf_expose per netns/sock/asoc
>   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
>   4. add ps_retrans per netns/sock/asoc/transport
>      (Primary Path Switchover)
>   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt
> 
> v1->v2:
>   - See Patch 2/5 and Patch 5/5.
> v2->v3:
>   - See Patch 1/5, 2/5 and 3/5.
> 
> Xin Long (5):
>   sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
>   sctp: add pf_expose per netns and sock and asoc
>   sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
>   sctp: add support for Primary Path Switchover
>   sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt
> 
>  include/net/netns/sctp.h     |  14 +++++
>  include/net/sctp/constants.h |  10 +++
>  include/net/sctp/structs.h   |  13 +++-
>  include/uapi/linux/sctp.h    |  15 +++++
>  net/sctp/associola.c         |  31 ++++-----
>  net/sctp/protocol.c          |   6 ++
>  net/sctp/sm_sideeffect.c     |   5 ++
>  net/sctp/socket.c            | 147 ++++++++++++++++++++++++++++++++++++++-----
>  net/sctp/sysctl.c            |  19 ++++++
>  9 files changed, 226 insertions(+), 34 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
