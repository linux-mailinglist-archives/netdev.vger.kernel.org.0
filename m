Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A285D1761
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 20:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJISNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 14:13:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35074 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfJISNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 14:13:19 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iIGSY-0007jV-Qa; Wed, 09 Oct 2019 14:13:16 -0400
Date:   Wed, 9 Oct 2019 14:13:09 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net
Subject: Re: [PATCH net-next 0/4] sctp: add some missing events from rfc5061
Message-ID: <20191009181309.GC25555@hmswarspite.think-freely.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 07:27:32PM +0800, Xin Long wrote:
> There are 4 events defined in rfc5061 missed in linux sctp:
> SCTP_ADDR_ADDED, SCTP_ADDR_REMOVED, SCTP_ADDR_MADE_PRIM and
> SCTP_SEND_FAILED_EVENT.
> 
> This patchset is to add them up.
> 
> Xin Long (4):
>   sctp: add SCTP_ADDR_ADDED event
>   sctp: add SCTP_ADDR_REMOVED event
>   sctp: add SCTP_ADDR_MADE_PRIM event
>   sctp: add SCTP_SEND_FAILED_EVENT event
> 
>  include/net/sctp/ulpevent.h | 16 +++++++------
>  include/uapi/linux/sctp.h   | 16 ++++++++++++-
>  net/sctp/associola.c        | 22 +++++++----------
>  net/sctp/chunk.c            | 40 +++++++++++++++----------------
>  net/sctp/ulpevent.c         | 57 ++++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 108 insertions(+), 43 deletions(-)
> 
> -- 
> 2.1.0
> 
> 

Series
Acked-by: Neil Horman <nhorman@tuxdriver.com>

