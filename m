Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480584239D5
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhJFIhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:37:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47226 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbhJFIhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:37:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 24BF6224C3;
        Wed,  6 Oct 2021 08:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633509325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pez/+piuch8kbWdQV5I4r6fnzwH9k8+e7QdywTt8Oag=;
        b=jKQBP3ggclxftJkALlr3JxGeKUgiXzlGvtm7zC6npYBTEwjzYQZpOXYigWdYn11L52yHW5
        3H/MnrWtZCetXS/xQmCFMfhIYARi+NqkZhHVV5BUifADCdahVpxO35uCkrowklYqllpi57
        7oYuTCkNw9CYe6ho0mqfRDRHIRAfcvo=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9ABB4A3B8D;
        Wed,  6 Oct 2021 08:35:22 +0000 (UTC)
Date:   Wed, 6 Oct 2021 10:35:21 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>
Subject: Re: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
Message-ID: <YV1fyechiyvREmt4@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org>
 <YV1EO9dsVSwWW7ua@dhcp22.suse.cz>
 <163350719413.4226.2526174755566600987@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163350719413.4226.2526174755566600987@kwain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 06-10-21 09:59:54, Antoine Tenart wrote:
[...]
> Nice to see this can help others.

I find the timing amusing because this behavior was there for years just
hitting us really hard just recently.

> Any help on (extensively) testing is welcomed :-)

We can help with that for sure.
-- 
Michal Hocko
SUSE Labs
