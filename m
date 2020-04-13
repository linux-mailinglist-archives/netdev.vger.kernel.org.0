Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC90B1A6D60
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbgDMUjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:39:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727877AbgDMUjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586810354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f51PNmBYbtbloXAW1XP9YIZMd0h1/w12eoHfrs8nGCM=;
        b=MKzmP+yF9Uper8CDDUGN9TKftRVEKqVxmwpw1SPx7DYGnQL35Z15xy1EanszSqzb3yeDiO
        DXseK4en4jdsNc7SkYmLsXpYXYURJFtdgGn6w6gHjV77vHXx2r8R4ZaGs3J45K/cdf2hh1
        fWjmkQNsKGM31PeId13zgIePYIkD16Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-rWXY1eKsMbuGiddBbRRTdA-1; Mon, 13 Apr 2020 16:39:10 -0400
X-MC-Unique: rWXY1eKsMbuGiddBbRRTdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A5301137840;
        Mon, 13 Apr 2020 20:39:09 +0000 (UTC)
Received: from localhost (unknown [10.36.110.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C06C19F998;
        Mon, 13 Apr 2020 20:39:05 +0000 (UTC)
Date:   Mon, 13 Apr 2020 22:38:58 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200413223858.17b0f487@redhat.com>
In-Reply-To: <20200413163900.GO27528@sasha-vm>
References: <20200407000058.16423-1-sashal@kernel.org>
        <20200407000058.16423-27-sashal@kernel.org>
        <20200407021848.626df832@redhat.com>
        <20200413163900.GO27528@sasha-vm>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Apr 2020 12:39:00 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Tue, Apr 07, 2020 at 02:18:48AM +0200, Stefano Brivio wrote:
>
> >I'm used to not Cc: stable on networking patches (Dave's net.git),
> >but I guess I should instead if they go through nf.git (Pablo's tree),
> >right?  
> 
> Yup, this confusion has caused for quite a few netfilter fixes to not
> land in -stable. If it goes through Pablo's tree (and unless he intructs
> otherwise), you should Cc stable.

Hah, thanks for clarifying.

What do you think I should do specifically with 72239f2795fa
("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection
on insertion")?

I haven't Cc'ed stable on that one. Can I expect AUTOSEL to pick it up
anyway?

-- 
Stefano

