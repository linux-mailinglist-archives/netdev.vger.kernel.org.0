Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20421736E7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbfGXSsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:48:01 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54546 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfGXSsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:48:00 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hqMIu-0002FF-UV; Wed, 24 Jul 2019 14:47:58 -0400
Date:   Wed, 24 Jul 2019 14:47:29 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 0/4] sctp: clean up __sctp_connect function
Message-ID: <20190724184729.GD7212@hmswarspite.think-freely.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <20190724142512.GG6204@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724142512.GG6204@localhost.localdomain>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:25:12AM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Jul 23, 2019 at 01:37:56AM +0800, Xin Long wrote:
> > This patchset is to factor out some common code for
> > sctp_sendmsg_new_asoc() and __sctp_connect() into 2
> > new functioins.
> > 
> > Xin Long (4):
> >   sctp: check addr_size with sa_family_t size in
> >     __sctp_setsockopt_connectx
> >   sctp: clean up __sctp_connect
> >   sctp: factor out sctp_connect_new_asoc
> >   sctp: factor out sctp_connect_add_peer
> 
> Nice cleanup! These patches LGTM. Hopefully for Neil as well.
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 

Yes, agreed, this all looks good, but I would like to resolve the addr_length
check issue before I ack it.
Neil

