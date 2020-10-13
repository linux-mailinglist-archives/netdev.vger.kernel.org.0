Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2261428D2A4
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgJMQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:52:58 -0400
Received: from mail.adapt-ip.com ([173.164.178.19]:60192 "EHLO
        web.adapt-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727696AbgJMQw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 12:52:58 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 12:52:58 EDT
Received: from localhost (localhost [127.0.0.1])
        by web.adapt-ip.com (Postfix) with ESMTP id 46B8A4FA377;
        Tue, 13 Oct 2020 16:45:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at web.adapt-ip.com
Received: from web.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RRucx4ImxBfd; Tue, 13 Oct 2020 16:45:51 +0000 (UTC)
Received: from mail.ibsgaard.io (c-73-223-60-234.hsd1.ca.comcast.net [73.223.60.234])
        (Authenticated sender: thomas@adapt-ip.com)
        by web.adapt-ip.com (Postfix) with ESMTPSA id 5EC344FA372;
        Tue, 13 Oct 2020 16:45:50 +0000 (UTC)
MIME-Version: 1.0
Date:   Tue, 13 Oct 2020 09:45:49 -0700
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 68/80] nl80211: docs: add a description for s1g_cap
 parameter
In-Reply-To: <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
 <9633ea7d9b0cb2f997d784df86ba92e67659f29b.1602589096.git.mchehab+huawei@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <53bc6de4ee69b43236866a4355859e2a@adapt-ip.com>
X-Sender: thomas@adapt-ip.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-13 04:54, Mauro Carvalho Chehab wrote:
> Changeset df78a0c0b67d ("nl80211: S1G band and channel definitions")
> added a new parameter, but didn't add the corresponding kernel-doc
> markup, as repoted when doing "make htmldocs":
> 
> 	./include/net/cfg80211.h:471: warning: Function parameter or member
> 's1g_cap' not described in 'ieee80211_supported_band'
> 
> Add a documentation for it.

Sorry about that. Patch looks good.

> Fixes: df78a0c0b67d ("nl80211: S1G band and channel definitions")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>

-- 
thomas
