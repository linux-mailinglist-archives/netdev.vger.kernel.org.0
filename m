Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1251A7B7C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502410AbgDNMz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 08:55:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502397AbgDNMzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 08:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586868951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9SNKfZgTrlGM6IU32reUMzHydagk4F1uZYHWoMs+JY=;
        b=F04jVhAp59g1JKR7dMG3Xbn/wuEvGlkYY4WdVRoII88xcxil9Cs4y+Ky1es1nrENqNdKs7
        4sDpyrAl3usHRQJksYwsgNhwxi8aMFeexx7W9Y5JRTxi5Uj1NJ5A9ZNGB8GfqVdKrSG5CG
        wbWdYG9iraoT7lFjiQk5cihwumyZis4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-vjzEu9A8OqS2YhspOZHYNw-1; Tue, 14 Apr 2020 08:55:49 -0400
X-MC-Unique: vjzEu9A8OqS2YhspOZHYNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8F9E149C8;
        Tue, 14 Apr 2020 12:55:47 +0000 (UTC)
Received: from ovpn-113-222.ams2.redhat.com (ovpn-113-222.ams2.redhat.com [10.36.113.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27F76272D3;
        Tue, 14 Apr 2020 12:55:44 +0000 (UTC)
Message-ID: <43fe63365483cceb4dd181b642e29e6fa647cdd2.camel@redhat.com>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   Paolo Abeni <pabeni@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 14 Apr 2020 14:55:43 +0200
In-Reply-To: <e118e8790a7706253b94a1b181547f4841af64ce.camel@sipsolutions.net>
References: <000000000000bb471d05a2f246d7@google.com>
         <66c3db9b1978a384246c729034a934cc558b75a6.camel@redhat.com>
         <e118e8790a7706253b94a1b181547f4841af64ce.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-04-14 at 13:11 +0200, Johannes Berg wrote:
> On Tue, 2020-04-14 at 12:42 +0200, Paolo Abeni wrote:
> > #syz test git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> > 
> > I don't see why the bisection pointed to the MPTCP commit ?!?
> 
> I just sent an explanation for that :)

Thanks, I did not thought about hard-coded ids!

> Good fix too, I already applied another one just now for an earlier, but
> really mostly identical, syzbot warning (and yes, tagged it with both).

Nice! I saw the fix you mentioned after reading your email. I'm fine
with that.

Cheers,

Paolo

