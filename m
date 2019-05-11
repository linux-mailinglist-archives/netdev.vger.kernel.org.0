Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D64C1A5C0
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 02:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfEKASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 20:18:36 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:46646 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfEKASg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 20:18:36 -0400
Received: by mail.osadl.at (Postfix, from userid 1001)
        id A17EE5C05AC; Sat, 11 May 2019 02:17:39 +0200 (CEST)
Date:   Sat, 11 May 2019 02:17:39 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     David Miller <davem@davemloft.net>
Cc:     hofrat@osadl.org, aneela@codeaurora.org,
        gregkh@linuxfoundation.org, anshuman.khandual@arm.com,
        david@redhat.com, arnd@arndb.de, johannes.berg@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: use protocol endiannes variable
Message-ID: <20190511001739.GA6185@osadl.at>
References: <1557450533-9321-1-git-send-email-hofrat@osadl.org>
 <20190510.132800.1971158293891484440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510.132800.1971158293891484440.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 01:28:00PM -0700, David Miller wrote:
> From: Nicholas Mc Guire <hofrat@osadl.org>
> Date: Fri, 10 May 2019 03:08:53 +0200
> 
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index dd0e97f..c90edaa 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -733,7 +733,8 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> >  	struct qrtr_node *node;
> >  	struct sk_buff *skb;
> >  	size_t plen;
> > -	u32 type = QRTR_TYPE_DATA;
> > +	u32 type = 0;
> > +	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
> >  	int rc;
> 
> Please try to preserve as much of the reverse chrimstas tree here rather
> than making it worse.
>
sorry - did not really think about that at all  - will re-order the declarations and resend

thx!
hofrat 
