Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517542B1405
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgKMBvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:51:43 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21371 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKMBvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:51:43 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605232265; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cBvKcBMM/njmNYSGfQhrlVdRm/9nvY1EkaAYn7+vIXYUklR6PVd5RkRpKTJdVt7q7OhwNND7g3VL8yU0TjyLGLIeNvsdffJc7Ged7qiDvzC4P2TTNH5i2QeLXS4UWXMJ4Mc3zu74ixQB5xPI18A4HP32kWCvqrvkndaDbXRNOQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605232265; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gEngQWGy289WgIOsFRNzQyvfCUzrxtfgSSenRYNqNts=; 
        b=TKT9xr9QglCsYM7RDMA4UOViWqyFyQ98rFxD48ji+3BgufvnH3FHgiunAkgqx7jkolj2/jef0zr++/SRxhpahJCyMv9KnH3fJyXH2c4iMphgawnMHpVmhStZOiv26zgv89A481QPmjEolnhArbP6CbdmtWs42ZMpxaPSwGQt6YM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605232265;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=gEngQWGy289WgIOsFRNzQyvfCUzrxtfgSSenRYNqNts=;
        b=P54G9w/lj4jiY0p+9OpCbe3ZbEjC6XpaJNDYCYfcNyNqd0+qCK0OkJDQCJ5YdSlZ
        b7xFR2eKTx5U9To0lkq8uLw8gtRN72w1I1ptYLi99Z4IdTq1WDwrYPCmIbjKYj3G3Oy
        qaxPIqyYAofuPvAPRp8AKtQYhpQYCAyk7Zs/hLJ8=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605232258219691.6899643912467; Fri, 13 Nov 2020 02:50:58 +0100 (CET)
Date:   Fri, 13 Nov 2020 02:50:58 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175bf4c6caa.ba8cba7c131155.80422714589772777@shytyi.net>
In-Reply-To: <20201112162156.211cad4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net> <20201112162156.211cad4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next V3] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
          
---- On Fri, 13 Nov 2020 01:21:56 +0100 Jakub Kicinski <kuba@kernel.org> wrote ----

 > On Thu, 12 Nov 2020 16:44:54 +0100 Dmytro Shytyi wrote: 
 > > Reported-by: kernel test robot <lkp@intel.com> 
 >  
 > You don't have to add the reported by tag just because the bot pointed 
 > out issues in the previous version. 
 > 
[Dmytro] Understood. Thank you for the comment.
                    
Dmytro SHYTYI

