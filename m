Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F142EE73F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAGUww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbhAGUwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:52:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F5F2343B;
        Thu,  7 Jan 2021 20:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610052731;
        bh=Y1eXbjVUzmHn21+EildtKnAEgbsJhjMeO4FPVukvLnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I8+BAuCHTZJBx07MeS3cR2qJ0oEELQ7Yzb4kWD9/53z1/tjIdlx7RzwKJT9yvHyGA
         KRkbLCxxcUAx6cfVKRqO6wtBoR/jUe8yaLf1dWW50YjDyPhENU3xmr9m3KrA0R89x0
         Eo/TQGpBvAijkKGpS2F7sz89GAu05x81e30B3B/rq6aBh7ILPNMcFPHn/DUG5bqd0f
         03N6UJV8qKWI0K6zwkDHPh/yHLgc3LyfMRfaCNH5zuKlYfiIR+B+zzbWjQJ7kPMYt2
         AhUKVkiacxBQ7Cir03h1Z48GDjuG9+vBYjrmkMIeeKQFCZpaXf4LGpzn74JSvqxvce
         6odo5WdO4GgAQ==
Date:   Thu, 7 Jan 2021 12:52:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: broadcom: Drop OF dependency from
 BGMAC_PLATFORM
Message-ID: <20210107125209.04659db8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <90e88bac-9ed3-4a96-605e-b4457b3103d2@infradead.org>
References: <20210106191546.1358324-1-f.fainelli@gmail.com>
        <90e88bac-9ed3-4a96-605e-b4457b3103d2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 11:27:29 -0800 Randy Dunlap wrote:
> On 1/6/21 11:15 AM, Florian Fainelli wrote:
> > All of the OF code that is used has stubbed and will compile and link
> > just fine, keeping COMPILE_TEST is enough.  
> 
> Yes, that matches my understanding.
> 
> I wish we had a list of which API families have full stub support...
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks!
