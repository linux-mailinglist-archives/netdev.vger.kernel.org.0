Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE919C8D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 13:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfEJL14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 07:27:56 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40044 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfEJL14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 07:27:56 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hP3gn-0004bW-QQ; Fri, 10 May 2019 07:27:51 -0400
Date:   Fri, 10 May 2019 07:27:18 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     David Miller <davem@davemloft.net>
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Message-ID: <20190510112718.GA4902@hmswarspite.think-freely.org>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
 <20190509113235.GA12387@hmswarspite.think-freely.org>
 <20190509.093913.1261211226773919507.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509.093913.1261211226773919507.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 09:39:13AM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Thu, 9 May 2019 07:32:35 -0400
> 
> > This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> > instead of removing it, to use it.  We have 2 locations where we actually call
> > sctp_make_init_ack, and then have to check the return code and abort the
> > operation if we get a NULL return.  Would it be a better solution (in the sense
> > of keeping our control flow in line with how the rest of the state machine is
> > supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> > the state machine queue in the locations where we otherwise would call
> > sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?
> 
> Also, net-next is closed 8-)
> 
Details, details :)

