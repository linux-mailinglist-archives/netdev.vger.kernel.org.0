Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EB9365993
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhDTNMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:12:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:52398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhDTNMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:12:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618924334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vykaM9tEUkeV2xKObiXIhcw191WRtCqc+lXXd12ZJPc=;
        b=QuT3uYFy6+F+ujFCMb8AcOqOw4g+MbeHpFir5leS0ICaMCKOk+Po3wtSNBLPoDv7diIP9W
        4YLZERO3q3I5xBbXL3ZrezFJLasYEy2hO3lwgwopX6jYHmO4fieBKBtrIbNm2ZFzTfKswE
        QzNP6R1vlI5MfHRITEySf4d8edS1j/Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7676FAF65;
        Tue, 20 Apr 2021 13:12:14 +0000 (UTC)
Date:   Tue, 20 Apr 2021 15:12:13 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH7TLRgKLwp73oWG@dhcp22.suse.cz>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <YH7HNHJLZyQKqmir@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH7HNHJLZyQKqmir@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 20-04-21 15:21:08, Mike Rapoport wrote:
> On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Add a paragraph that explains that it may happen that the counters in
> > /proc/meminfo do not add up to the overall memory usage.
> > 
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> 
> Ooops, forgot to add Michal's Ack, sorry.

Let's make it more explicit
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs
