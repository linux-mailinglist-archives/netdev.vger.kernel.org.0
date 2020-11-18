Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59292B82B0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgKRRIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:08:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726209AbgKRRIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+We5DT3DIYspAu6AjdscRcy5WSeVgwTavbc2vWmcyKQ=;
        b=EZkneONxaQD0hmTRM6486mEIMOCS8WL+JtYoGqEHGVs94MLRoLExSyrVCkcR6FFVoG+itT
        E2C0GqVy8zj5NlIzodPc6p3w6ddLkK92/CqXvDty/czR0vz7PnlPNe41TL2uddaHZa3OGb
        WPFHQOktmqegAmBRJ79YWup8K2wgOiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-jDP4CS_pNt2N66zWLKBbiA-1; Wed, 18 Nov 2020 12:08:26 -0500
X-MC-Unique: jDP4CS_pNt2N66zWLKBbiA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06FD5100F7A5;
        Wed, 18 Nov 2020 17:08:25 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEB4A1964A;
        Wed, 18 Nov 2020 17:08:23 +0000 (UTC)
Date:   Wed, 18 Nov 2020 18:08:20 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 5/6] selftests: refactor get_netdev_name
 function
Message-ID: <20201118170820.ppdflbw76ko2tzui@yoda.fritz.box>
References: <20201117152015.142089-1-acardace@redhat.com>
 <20201117152015.142089-6-acardace@redhat.com>
 <20201117173520.bix4wdfy6u3mapjl@lion.mk-sys.cz>
 <20201118090320.wdth32bkz3ro6mbc@yoda.fritz.box>
 <20201118085610.038b5ae4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118085610.038b5ae4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 08:56:10AM -0800, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 10:03:20 +0100 Antonio Cardace wrote:
> > Do I have to resend the whole serie as a new version or is there a
> > quicker way to just resend a single patch?
> 
> Just repost the series as v5, it's the least confusing way.
> Changelog from version to version would be good. You can put
> it in the cover letter.
> 
Ok thanks, will do.

Antonio

