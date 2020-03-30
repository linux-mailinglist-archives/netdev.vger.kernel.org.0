Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CA51987B0
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgC3XBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgC3XBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:01:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C3B020774;
        Mon, 30 Mar 2020 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585609265;
        bh=PMcSpMSrh+QaPdoPZWe8F9uIXn8MkSDSvzap7PmTtVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6GUsh59LJf7L1Fy5vObqc4IOVu6YntWvUwkqMRpyOF3KfJK/S3WPG5JHc2O81AO+
         Gblh5Uazytei5XLlT0wVsgM/NtkvSryDDhtmn7HGOFY6zNqrNBta3NHSGX2SzNqujs
         AZRp0YhiwrkOdc9P6X11Z1iXya2gfh1hl3996ypU=
Date:   Mon, 30 Mar 2020 16:01:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: ingress rate limiting on mv88e6xxx
Message-ID: <20200330160103.22755244@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
References: <056a0c42-3831-9ecb-a455-637c8ea13516@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 15:22:44 +0200 Rasmus Villemoes wrote:
> I'm trying to figure out what the proper way is to expose the ingress
> rate limiting knobs of the mv88e6250 (and related) to userspace. The
> simpest seems to be a set of sysfs files for each port, but I'm assuming
> that's a no-go (?)

Out of curiosity - is this policing (i.e. dropping)?  Are there any
switches out there which would generate pause frames if port / priority
is above a certain threshold?

