Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397F21848DA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgCMOJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:09:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726779AbgCMOJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584108571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMbHA5mlPT4RSAzs8+5ZWsqxmQpReOgUiSSuJcuDpuc=;
        b=ihKndUTOPxkAFr1aspuMkznp9e+jvTEvruEfztFbhzzwnBEhj0jVLlw/0bc2kZTQg7gTcH
        3bEKClplqzLOM9l/zwLk2bTeDEuBXbYzaq77P8zBiKgtI3Ih7vyhPcraUQ2GeZ01Vg8a7y
        kQpAEt5rzlbCigcSLCHuIYn4FhnBXqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-YAznXJodN-2_yTJRYhAXtw-1; Fri, 13 Mar 2020 10:09:29 -0400
X-MC-Unique: YAznXJodN-2_yTJRYhAXtw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FAE6DB6B;
        Fri, 13 Mar 2020 14:09:28 +0000 (UTC)
Received: from ovpn-116-114.ams2.redhat.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6023A91D61;
        Fri, 13 Mar 2020 14:09:27 +0000 (UTC)
Message-ID: <336de7971bfcc0c41b229bc3f5533f805d1511ba.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] mptcp: simplify mptcp_accept()
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Date:   Fri, 13 Mar 2020 15:09:26 +0100
In-Reply-To: <cover.1584006115.git.pabeni@redhat.com>
References: <cover.1584006115.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-12 at 16:13 +0100, Paolo Abeni wrote:
> Currently we allocate the MPTCP master socket at accept time.
> 
> The above makes mptcp_accept() quite complex, and requires checks is several
> places for NULL MPTCP master socket.
> 
> These series simplify the MPTCP accept implementation, moving the master socket
> allocation at syn-ack time, so that we drop unneeded checks with the follow-up
> patch.
> 
> Note: patch 2/2 will conflict with net commit 2398e3991bda ("mptcp: always 
> include dack if possible."). If the following will help, I can send a rebased
> version of the series after that net is merged back into net-next.

Since the above commit is now on net-next I'll rebase and submit a v2.

Thanks,

Paolo

