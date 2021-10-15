Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B0A42F985
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbhJORCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:02:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241902AbhJORCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634317230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TwZfwV80nspx2wv+KRPgPmK3Njg5hCNBz0hmPxtiEHQ=;
        b=DIOvbZNhZS4CChkzjf3HlvuX05v5AdWkj6l7aP7s6dPrEUWjQ5oXHnqI5DFL7oPz4PqEn1
        Ttqhrx+mqAL5J6rFT+4kxWfqKijoKRU9YcIJHsrhdv/sf2jKSPXspTa810y9Hq0rn+L6Qi
        uSvK9mRxcwRLyfzpDu+Nim5JjKZwblk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-VHgEQNACO5WxrCmgPhuovg-1; Fri, 15 Oct 2021 13:00:26 -0400
X-MC-Unique: VHgEQNACO5WxrCmgPhuovg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F64310A8E00;
        Fri, 15 Oct 2021 17:00:25 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3931260C05;
        Fri, 15 Oct 2021 17:00:22 +0000 (UTC)
Date:   Fri, 15 Oct 2021 19:00:20 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 04/15] mctp: Add sockaddr_mctp to uapi
Message-ID: <20211015170020.GB16157@asgard.redhat.com>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
 <20210729022053.134453-5-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729022053.134453-5-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 10:20:42AM +0800, Jeremy Kerr wrote:
>  struct sockaddr_mctp {
> +	unsigned short int	smctp_family;
> +	int			smctp_network;

struct mctp_skb_cb.net (as well as struct mctp_dev.net) are unsigned,
is it intentional that this field (along with struct mctp_sock.bind_net)
differs in signedness?

