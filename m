Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AD03034DB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbhAZF3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:29:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731281AbhAYTCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611601228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEmsde5lZb1KcUwAlCNpaJ8Mn2kB6IknUcw0j1rrmEc=;
        b=PJFSDBAM3JZWU/FJmO8wgt9/6LUzNeBmA1R50uZwaYuDv7nQcHT8D1E9TmdK6uie014RCc
        jm1gDcu7ODQGUxZ9GkEpEV5JGneozFHCUhDuu43+kYzag7tu6RU3rTbSI4OHjcHfU7eF22
        dUHwJNwkRkFczKZVSFFnE2QSeHy8x0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-WiTWk2C7PHS4Xt_6cKSSPg-1; Mon, 25 Jan 2021 14:00:25 -0500
X-MC-Unique: WiTWk2C7PHS4Xt_6cKSSPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA383806674;
        Mon, 25 Jan 2021 19:00:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0210810013C1;
        Mon, 25 Jan 2021 19:00:21 +0000 (UTC)
Message-ID: <dd8fd0162cd56d44a56fd389339ec3e6e4b65bd8.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
From:   Dan Williams <dcbw@redhat.com>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, stephan@gerhold.net, ejcaruso@google.com,
        andrewlassalle@google.com
Date:   Mon, 25 Jan 2021 13:00:21 -0600
In-Reply-To: <8735ypgg6b.fsf@miraculix.mork.no>
References: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
         <9c4aa5531548bf4a2e8b060b724a341476780b5d.camel@redhat.com>
         <8735ypgg6b.fsf@miraculix.mork.no>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-25 at 17:00 +0100, Bjørn Mork wrote:
> Dan Williams <dcbw@redhat.com> writes:
> > On Mon, 2021-01-25 at 00:33 -0700, Subash Abhinov Kasiviswanathan
> > wrote:
> > > Pass through mode is to allow packets in MAP format to be passed
> > > on to the stack. rmnet driver can be used to process and
> > > demultiplex
> > > these packets.
> > > 
> > > Pass through mode can be enabled when the device is in raw ip
> > > mode
> > > only.
> > > Conversely, raw ip mode cannot be disabled when pass through mode
> > > is
> > > enabled.
> > > 
> > > Userspace can use pass through mode in conjunction with rmnet
> > > driver
> > > through the following steps-
> > > 
> > > 1. Enable raw ip mode on qmi_wwan device
> > > 2. Enable pass through mode on qmi_wwan device
> > > 3. Create a rmnet device with qmi_wwan device as real device
> > > using
> > > netlink
> > 
> > This option is module-wide, right?
> > 
> > eg, if there are multiple qmi_wwan-driven devices on the system,
> > *all*
> > of them must use MAP + passthrough, or none of them can, right?
> 
> No, this is a per-netdev setting, just like the raw-ip flag.

Thanks for setting me straight. Glad to hear it.
Dan

