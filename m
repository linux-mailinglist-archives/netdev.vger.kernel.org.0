Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC2920B627
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgFZQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:47:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55589 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727906AbgFZQq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593190018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TbtqCTBnLl6HwE/S5vT3VHYEx+0+qx5nsEmfrkk4L+A=;
        b=Qw/lc6tUJ6egDnqaNZhIyJxrPZ8iJQQ8/dqBaghsxJOZX7AR5fJkxvm91zoLWD6/BCgZa8
        wyXd3YI16ui0BtmEuf1Vz2ELV19j8hY1x8mJRuekFOC3/6oJbEp2O/NZo50tOQukpQlMrZ
        yvNQlDtb1yewovEYU2GNG0IggwpmST4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-scNw31akNuip67tRaNSHvQ-1; Fri, 26 Jun 2020 12:46:54 -0400
X-MC-Unique: scNw31akNuip67tRaNSHvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F37DC100A8E8;
        Fri, 26 Jun 2020 16:46:52 +0000 (UTC)
Received: from ovpn-114-92.ams2.redhat.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6366D7FEAD;
        Fri, 26 Jun 2020 16:46:51 +0000 (UTC)
Message-ID: <20013c7fa42802ec9029a05cdc59dca7bcb51c59.camel@redhat.com>
Subject: Re: [PATCH net-next 4/4] mptcp: introduce token KUNIT self-tests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Jun 2020 18:46:50 +0200
In-Reply-To: <20200626090238.6914222a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1593159603.git.pabeni@redhat.com>
         <848d6611c87790a6e4028b856e7c3323a53f2679.1593159603.git.pabeni@redhat.com>
         <20200626090238.6914222a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2020-06-26 at 09:02 -0700, Jakub Kicinski wrote:
> On Fri, 26 Jun 2020 12:12:49 +0200 Paolo Abeni wrote:
> > Unit tests for the internal MPTCP token APIs, using KUNIT
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> Greetings! W=1 C=1 sayeth:
> 
> net/mptcp/token.c:318:6: warning: no newline at end of file
> net/mptcp/token_test.c:139:22: warning: no newline at end of file
> net/mptcp/token_test.c:68:29: warning: incorrect type in assignment (different address spaces)
> net/mptcp/token_test.c:68:29:    expected void [noderef] __rcu *icsk_ulp_data
> net/mptcp/token_test.c:68:29:    got struct mptcp_subflow_context *ctx

Thank you for checking! 

v2 is coming.

Cheers,

Paolo

