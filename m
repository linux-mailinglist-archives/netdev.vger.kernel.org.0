Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19318D8D7
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCTUIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTUIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 16:08:31 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5BBE20409;
        Fri, 20 Mar 2020 20:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584734911;
        bh=FZedNL8Cl/bgJh41b12pTNuCgSwVdFCY5IHluLIq2Lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pS9Qq/TLQWRbo9N4/CGYW8h5Y0OOWC82+h9f+zUFgNWKnuaUQBgCh38rx/Pd/42oF
         7A7+RHbhxxfXoiyQ4oPJmRWV47qCuj6o/Yt27D9Mlma8L227MhURhFBiQfuH9ovrUz
         KNTI95v30cd2ah6MnzP/p8ydW+A6XqWWkl+Z4QDs=
Date:   Fri, 20 Mar 2020 13:08:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next v5] tc: m_action: introduce support
 for hw stats type
Message-ID: <20200320130829.54233457@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ef67d2db-47a0-a725-5a9a-33986bcc07b4@gmail.com>
References: <20200314092548.27793-1-jiri@resnulli.us>
        <ef67d2db-47a0-a725-5a9a-33986bcc07b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 10:34:04 -0600 David Ahern wrote:
> On 3/14/20 3:25 AM, Jiri Pirko wrote:
> > @@ -200,6 +208,29 @@ which indicates that action is expected to have minimal software data-path
> >  traffic and doesn't need to allocate stat counters with percpu allocator.
> >  This option is intended to be used by hardware-offloaded actions.
> >  
> > +.TP
> > +.BI hw_stats " HW_STATS"
> > +Speficies the type of HW stats of new action. If omitted, any stats counter type  
> 
> Fixed the spelling and applied to iproute2-next.

Just a heads up that the kernel uAPI is getting slightly renamed, you'll
need to do a s/HW_STATS_TYPE/HW_STATS/ the rename lands. Do you want me
to send a patch for that?
