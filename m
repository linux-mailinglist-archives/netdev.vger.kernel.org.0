Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B9D152720
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBEHmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:42:01 -0500
Received: from nautica.notk.org ([91.121.71.147]:46353 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgBEHmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 02:42:01 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2020 02:42:00 EST
Received: by nautica.notk.org (Postfix, from userid 1001)
        id AAAD2C01B; Wed,  5 Feb 2020 08:41:59 +0100 (CET)
Date:   Wed, 5 Feb 2020 08:41:44 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Sergey Alirzaev <l29ah@cock.li>
Cc:     v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] 9p: read only once on O_NONBLOCK
Message-ID: <20200205074144.GB16626@nautica>
References: <20200205003457.24340-1-l29ah@cock.li>
 <20200205003457.24340-2-l29ah@cock.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205003457.24340-2-l29ah@cock.li>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergey Alirzaev wrote on Wed, Feb 05, 2020:
> A proper way to handle O_NONBLOCK would be making the requests and
> responses happen asynchronously, but this would require serious code
> refactoring.

FWIW I do have some async 9p code waiting (it's been sent to the list
ages ago but I never took the time to properly test it due to lack of
interest manifested), the problem here is more the caching model than a
synchronous issue, since in nocache mode (where this is used) there is
nowhere to fetch the data ahead of time.

If you're interested in that then please have a look at
https://lore.kernel.org/lkml/1544532108-21689-1-git-send-email-asmadeus@codewreck.org/

> Signed-off-by: Sergey Alirzaev <l29ah@cock.li>

That aside, I guess, why not?
Will take when other patch gets addressed.

Thanks,
-- 
Dominique
