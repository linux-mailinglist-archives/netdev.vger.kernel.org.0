Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5977314FF0D
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgBBUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 15:13:55 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37579 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgBBUNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 15:13:55 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B39D523066;
        Sun,  2 Feb 2020 21:13:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1580674433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+kwvUZfyXy9xx4NkIPffxHzaYe/o80Lsj0pOFvilpQ=;
        b=Pjo9ZU0/q7GGJEvtY0o8DmyFEUsrHpjpxT/wSNJMCLgvFNJBXvKvaqm/wz7Oo9hG8xa50s
        8kFTnFyLqJcfev4wex7K275D+OMWq4MMrYjY/WTmqtCGwdWsXhDze8gjUaNTHupQKlngm1
        PGqedCTSFUkj3MPNWAwf81P5ruLpoEI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 02 Feb 2020 21:13:53 +0100
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: mdio: of: fix potential NULL pointer
 derefernce
In-Reply-To: <20200131074912.2218d30d@cakuba.hsd1.ca.comcast.net>
References: <20200130174451.17951-1-michael@walle.cc>
 <20200131074912.2218d30d@cakuba.hsd1.ca.comcast.net>
Message-ID: <71c69df848b37e3cc3db43fc27598484@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.8
X-Spamd-Bar: /
X-Spam-Status: No, score=-0.10
X-Rspamd-Server: web
X-Spam-Score: -0.10
X-Rspamd-Queue-Id: B39D523066
X-Spamd-Result: default: False [-0.10 / 15.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWO(0.00)[2];
         NEURAL_HAM(-0.00)[-0.636];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_MATCH_FROM(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Am 2020-01-31 16:49, schrieb Jakub Kicinski:
> On Thu, 30 Jan 2020 18:44:50 +0100, Michael Walle wrote:
>> of_find_mii_timestamper() returns NULL if no timestamper is found.
>> Therefore, guard the unregister_mii_timestamper() calls.
>> 
>> Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time 
>> stampers.")
>> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> Applied both, thank you.

Just for completeness, the subject should have to be [PATCH net], 
because its a fix, correct?

-michael
