Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE18A14A202
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgA0Kc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:32:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26230 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727985AbgA0Kc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:32:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580121175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=soDlykxoKL+jvpEFJIbGP8m2LcnZcRwleRT2GQ1f240=;
        b=IvCNgDD0eBpVBo+aRwjG0fR6X3vLH3ahnc8V71kV0iDmomOYi+a9Qn/t4uNKe3zCsVnV3Z
        DAhICmd575N00WV+L0tT78jwEE5zyGeTCdflQQgSYc+RQQYCLl/HpSFhRm0Jn7cjC2UoLf
        MJia3NUz7/PsvJdWR3O8LyjZj3uBoYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-rGwk10ADPAamTUxbxaCdcw-1; Mon, 27 Jan 2020 05:32:51 -0500
X-MC-Unique: rGwk10ADPAamTUxbxaCdcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1278C803C04;
        Mon, 27 Jan 2020 10:32:48 +0000 (UTC)
Received: from localhost (ovpn-112-13.phx2.redhat.com [10.3.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F10D05C1D6;
        Mon, 27 Jan 2020 10:32:41 +0000 (UTC)
Date:   Mon, 27 Jan 2020 11:32:39 +0100 (CET)
Message-Id: <20200127.113239.1283544245838356770.davem@redhat.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us,
        andrew@lunn.ch, f.fainelli@gmail.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] ethtool netlink interface, part 2
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200127095744.GG570@unicorn.suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
        <20200127.104049.2252228859572866640.davem@davemloft.net>
        <20200127095744.GG570@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 27 Jan 2020 10:57:44 +0100

> On Mon, Jan 27, 2020 at 10:40:49AM +0100, David Miller wrote:
>> From: Michal Kubecek <mkubecek@suse.cz>
>> Date: Sun, 26 Jan 2020 23:10:58 +0100 (CET)
>> 
>> > This shorter series adds support for getting and setting of wake-on-lan
>> > settings and message mask (originally message level). Together with the
>> > code already in net-next, this will allow full implementation of
>> > "ethtool <dev>" and "ethtool -s <dev> ...".
>> > 
>> > Older versions of the ethtool netlink series allowed getting WoL settings
>> > by unprivileged users and only filtered out the password but this was
>> > a source of controversy so for now, ETHTOOL_MSG_WOL_GET request always
>> > requires CAP_NET_ADMIN as ETHTOOL_GWOL ioctl request does.
>> 
>> It looks like this will need to be respun at least once, and net-next
>> is closing today so....
> 
> The problem with ethnl_parse_header() name not making it obvious that it
> takes a reference is not introduced in this series, the function is
> already in net-next so that it does not matter if this series is merged
> or not. Other than that, there is only the missing "the" in
> documentation.

Ok, looks good, series applied.

Thanky you.

