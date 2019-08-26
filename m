Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A649CDB0
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfHZLC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 07:02:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51655 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfHZLC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 07:02:58 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:43ee::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1i2Cls-0001ER-Id; Mon, 26 Aug 2019 07:02:54 -0400
Date:   Mon, 26 Aug 2019 07:02:21 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net
Subject: Re: [PATCH net-next 0/3] sctp: add SCTP_ECN_SUPPORTED sockopt
Message-ID: <20190826110221.GA7831@hmswarspite.think-freely.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1566807985.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 04:30:01PM +0800, Xin Long wrote:
> This patchset is to make ecn flag per netns and endpoint and then
> add SCTP_ECN_SUPPORTED sockopt, as does for other feature flags.
> 
> Xin Long (3):
>   sctp: make ecn flag per netns and endpoint
>   sctp: allow users to set netns ecn flag with sysctl
>   sctp: allow users to set ep ecn flag by sockopt
> 
>  include/net/netns/sctp.h   |  3 ++
>  include/net/sctp/structs.h |  3 +-
>  include/uapi/linux/sctp.h  |  1 +
>  net/sctp/endpointola.c     |  1 +
>  net/sctp/protocol.c        |  3 ++
>  net/sctp/sm_make_chunk.c   | 16 +++++++---
>  net/sctp/socket.c          | 73 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/sctp/sysctl.c          |  7 +++++
>  8 files changed, 102 insertions(+), 5 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>
