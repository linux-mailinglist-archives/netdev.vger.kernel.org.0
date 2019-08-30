Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9CCA31E3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfH3IJ3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Aug 2019 04:09:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:60750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbfH3IJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 04:09:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8C2AAB69F;
        Fri, 30 Aug 2019 08:09:27 +0000 (UTC)
Date:   Fri, 30 Aug 2019 10:09:26 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 05/15] net: sgi: ioc3-eth: allocate space
 for desc rings only once
Message-Id: <20190830100926.343e7c2c7f3cd059c359bdd4@suse.de>
In-Reply-To: <20190829150504.68a04fe4@cakuba.netronome.com>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
        <20190829155014.9229-6-tbogendoerfer@suse.de>
        <20190829140537.68abfc9f@cakuba.netronome.com>
        <20190830000058.882feb357058437cddc71315@suse.de>
        <20190829150504.68a04fe4@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 15:05:04 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Fri, 30 Aug 2019 00:00:58 +0200, Thomas Bogendoerfer wrote:

> > Out of curiosity does kcalloc/kmalloc_array give me the same guarantees about
> > alignment ? rx ring needs to be 4KB aligned, tx ring 16KB aligned.
> 
> I don't think so, actually, I was mostly worried you are passing
> address from get_page() into kfree() here ;) But patch 11 cures that,
> so that's good, too.

I realized that after sending my last mail. I'll fix that in v3 even
it's just a transient bug.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
