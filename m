Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90403FAF29
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfKMK6H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 Nov 2019 05:58:07 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42519 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbfKMK6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 05:58:07 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-jeJlDL0GMZqBGojpjIXSDg-1; Wed, 13 Nov 2019 05:58:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73686911E9;
        Wed, 13 Nov 2019 10:58:01 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.36.118.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 181981891F;
        Wed, 13 Nov 2019 10:57:58 +0000 (UTC)
Date:   Wed, 13 Nov 2019 11:57:57 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next v5 1/6] net: add queue argument to
 __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
Message-ID: <20191113105757.GA2855442@bistromath.localdomain>
References: <cover.1573487190.git.sd@queasysnail.net>
 <0398d7e97db25019dcd32bbce4beba2bd1de27a7.1573487190.git.sd@queasysnail.net>
 <7c3de99a-4810-8a3b-72d4-04e72c47537b@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7c3de99a-4810-8a3b-72d4-04e72c47537b@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jeJlDL0GMZqBGojpjIXSDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-11-12, 09:54:50 -0800, Eric Dumazet wrote:
> 
> 
> On 11/12/19 7:18 AM, Sabrina Dubroca wrote:
> > This will be used by ESP over TCP to handle the queue of IKE messages.
> > 
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > ---
> > v2: document the new argument to __skb_try_recv_datagram
> > 
> >
> 
> Please rebase your tree Sabrina. Some READ_ONCE() have been added lately/

Sorry, I messed up the subject tag, this series targets
ipsec-next. The READ_ONCE() are missing there.

-- 
Sabrina

