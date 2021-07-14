Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA8B3C8B47
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 20:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGNSxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 14:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhGNSxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 14:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626288655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uawq7i4wr3uf8dMXAurcCXmjcPh0OTYXck77ZBYBePM=;
        b=duyotgPastQzpgaH7nSCkV1K+/s1mOfT5xhWfFm50yanun4USNovtnT2OzQl7jy96+J8iO
        TacXew9YwTgyeH33PBXcS3X/PKN5GsEJZhgtqMfvTndhCCXu7y/ST6N9NnHmtMpI9LmoDx
        fRKKlIzaDAk+RWlaBXtk2+FpK/U+8tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-7RxMfpD4NOSGZV3IeB_aNw-1; Wed, 14 Jul 2021 14:50:51 -0400
X-MC-Unique: 7RxMfpD4NOSGZV3IeB_aNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C2AF192FDA0;
        Wed, 14 Jul 2021 18:50:50 +0000 (UTC)
Received: from horizon.localdomain (ovpn-116-106.rdu2.redhat.com [10.10.116.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8805526E40;
        Wed, 14 Jul 2021 18:50:49 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 93F7EC7566; Wed, 14 Jul 2021 15:50:47 -0300 (-03)
Date:   Wed, 14 Jul 2021 15:50:47 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Briana Oursler <briana.oursler@gmail.com>
Subject: Re: [ANNOUNCE] tc monthly meetup
Message-ID: <YO8yB9BiNiX87qoT@horizon.localdomain>
References: <20210211185155.GD2954@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211185155.GD2954@horizon.localdomain>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 03:51:55PM -0300, Marcelo Ricardo Leitner wrote:
> Hi everyone,
> 
> Since NetdevConf 0x12 some of us have been meeting to talk about tc
> testing. We're taking a next step on that and a) expanding the scope,
> so that general development on tc is also welcomed, and b) making it
> more public.
> 
> The idea is for it to be an open place for brainstorming and
> synchronization around tc. It doesn't aim to replace email
> discussions. Low overhead, very informal.
> 
> All welcome.

Just a refresher, as this got mentioned on NetdevConf today.

> 
> When: every 2nd Monday, monthly, 16:00 UTC, for 50 mins.
> Where: https://meet.kernel.social/tc-meetup

Agenda: https://docs.google.com/document/d/1uUm_o7lR9jCAH0bqZ1dyscXZbIF4GN3mh1FwwIuePcM/edit

> 
> If you prefer to receiver a calendar invite, please let me
> know.
> 
> Thank you.
> 

