Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE271AB4C8
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404027AbgDPAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:30:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50007 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403977AbgDPAab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 20:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586997027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4rkdFZCt+CYPzp3/Qg70/GCXwWzZ5opTjJmcpHVXJY=;
        b=RnwO9osy7m0802mDJB/mLOcITZoZbaq0b6cQ3EsjH1IPjDNHomwAqWlsQ+qdIa5ncG0fS2
        I0uAfJ0g9BeJC6izuPQ/ct7yMpqqk6NlP97BVBiU8NKt9O3XzX3AMK++mcPgoTTffFdXBu
        nSmFbKxYvYnaIzL4G08360NGkH3T60Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-u5im1Xo4PlegAf8ewrePhg-1; Wed, 15 Apr 2020 20:30:25 -0400
X-MC-Unique: u5im1Xo4PlegAf8ewrePhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4F9C107ACC9;
        Thu, 16 Apr 2020 00:30:21 +0000 (UTC)
Received: from llong.remote.csb (ovpn-113-213.rdu2.redhat.com [10.10.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 041D15DA66;
        Thu, 16 Apr 2020 00:30:09 +0000 (UTC)
Subject: Re: WARNING in kernfs_create_dir_ns
To:     syzbot <syzbot+38f5d5cf7ae88c46b11a@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, hdanton@sina.com,
        hongjiefang@asrmicro.com, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, mareklindner@neomailbox.ch,
        mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, ulf.hansson@linaro.org
References: <000000000000ba8e5605a35d4465@google.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <894635f4-772e-a28c-1078-be8a5093e351@redhat.com>
Date:   Wed, 15 Apr 2020 20:30:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000ba8e5605a35d4465@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: locking/lockdep: Reuse freed chain_hlocks entries

