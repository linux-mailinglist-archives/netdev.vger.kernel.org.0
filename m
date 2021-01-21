Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26B12FEAFE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbhAUND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:03:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729271AbhAUKbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611224984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2LGdnSWHc2gn4AxaB+RCLXPLSLYvew6PYHbqTYJTq0=;
        b=bthhDvBY7myYz6IOS85rpjFm9cV1XGXWmeOcI+5rqf+bmuYeA9nf7RGUkpAg1crv6vc4xt
        HZuIlt0o46MtfsqtqotTTtlzrVIWhR+p+wA+r6a3OeymKA8HKU556QeM56AVA98DfNTrkm
        YqVUzvzDgtTXjTbgwDEMlDmrt9vpZNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-itS9oH-bOmemR1gMvJh82Q-1; Thu, 21 Jan 2021 05:29:41 -0500
X-MC-Unique: itS9oH-bOmemR1gMvJh82Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D07CF1800D41;
        Thu, 21 Jan 2021 10:29:39 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BDF06F95B;
        Thu, 21 Jan 2021 10:29:37 +0000 (UTC)
Date:   Thu, 21 Jan 2021 11:29:37 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeed@kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] team: postpone features update to avoid deadlock
Message-ID: <20210121112937.11b72ea6@ceranb>
In-Reply-To: <CAM_iQpUqdm-mpSUdsxEtLnq6GwhN=YL+ub--8N0aGxtM+PRfAQ@mail.gmail.com>
References: <20210120122354.3687556-1-ivecera@redhat.com>
        <CAM_iQpUqdm-mpSUdsxEtLnq6GwhN=YL+ub--8N0aGxtM+PRfAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 15:18:20 -0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jan 20, 2021 at 4:56 AM Ivan Vecera <ivecera@redhat.com> wrote:
> >
> > To fix the problem __team_compute_features() needs to be postponed
> > for these cases.  
> 
> Is there any user-visible effect after deferring this feature change?
> 
An user should not notice this change.

I.

