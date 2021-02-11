Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593531928B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBKSxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:53:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbhBKSx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 13:53:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613069524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=KFDhFysxPMcyoBrVewrQDpjGYjhvY8fZt5BKPXL+3Dg=;
        b=Oxiu77k8+uQ1F878bNyd6GG3A9/RBykJQcbKiuO6+ATI7GgMYyW6oByoSnmyM3sGExozAj
        WCji4YEdt/ApSp3J1Jn5cKzudbZg3VRGEeWvCAKR5jkw0spUqhKOBDBmn5k/eK2A/cgXBW
        KjSLVsFXVQ4dZ2KfnJ2vQazHfScHsA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-LTrm1xXCOkKelTEhO0GHHA-1; Thu, 11 Feb 2021 13:52:00 -0500
X-MC-Unique: LTrm1xXCOkKelTEhO0GHHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75EBA803F74;
        Thu, 11 Feb 2021 18:51:58 +0000 (UTC)
Received: from horizon.localdomain (ovpn-120-104.rdu2.redhat.com [10.10.120.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3827679F2;
        Thu, 11 Feb 2021 18:51:57 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id A0973C13A9; Thu, 11 Feb 2021 15:51:55 -0300 (-03)
Date:   Thu, 11 Feb 2021 15:51:55 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Briana Oursler <briana.oursler@gmail.com>,
        netdev@vger.kernel.org
Subject: [ANNOUNCE] tc monthly meetup
Message-ID: <20210211185155.GD2954@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Since NetdevConf 0x12 some of us have been meeting to talk about tc
testing. We're taking a next step on that and a) expanding the scope,
so that general development on tc is also welcomed, and b) making it
more public.

The idea is for it to be an open place for brainstorming and
synchronization around tc. It doesn't aim to replace email
discussions. Low overhead, very informal.

All welcome.

When: every 2nd Monday, monthly, 16:00 UTC, for 50 mins.
Where: https://meet.kernel.social/tc-meetup

If you prefer to receiver a calendar invite, please let me
know.

Thank you.

