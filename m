Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FCA47B111
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhLTQ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:27:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbhLTQ1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 11:27:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA266122A
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 16:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E96C36AE7;
        Mon, 20 Dec 2021 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640017621;
        bh=15B6B5FNhSnuNwXDzc/r0BOk2NebEF71bksg83jLBmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICQtYbKNbW4Yb5zgBQtazCg6XJQewZfl04T1awqhjvEg+g8bMcMRyolz1BSwdEzUT
         6qwMvrqf1ZZtm56glMY392LUcFyaXLymXI+hXdh/17PEAyUuHnS6X6CQIh+ENVdJCI
         eNourDOFaHvL+PUNX2HNXK5xwZAWOZz1ddrpBPJnOtOLinCQeXNeATMUfjPVwbUpVH
         T6W+F69/YxU6e4jbZMKlPBztwQWHdJ+Y1Hr4yEEHsm1QbUofUKFIAtXxO+SiUeCtBI
         Rd8NyOOCDf/P+YLI/TsPcqqj8N2cnMBQEnOeT8gAtds18AaKC5hm5DsPV514w+JpSs
         NV+licvFEoy7g==
Date:   Mon, 20 Dec 2021 08:27:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Fernando F. Mancera" <ffmancera@riseup.net>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] bonding: fix ad_actor_system option setting to
 default
Message-ID: <20211220082700.4fd5b84f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <43648ff4-90f0-37d8-24c9-50f9b198a3bd@riseup.net>
References: <20211218015001.1740-1-ffmancera@riseup.net>
        <1323.1639794889@famine>
        <43648ff4-90f0-37d8-24c9-50f9b198a3bd@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Dec 2021 15:53:27 +0100 Fernando F. Mancera wrote:
> I noticed this patch state in patchwork is "changes requested"[1]. But I 
> didn't get any reply or request. Is the state wrong? Should I ignore it? 

Hm, unclear why. Could you send a v4 with a Fixes tag included and CCing
all the maintainers suggested by get_maintainer.pl?
