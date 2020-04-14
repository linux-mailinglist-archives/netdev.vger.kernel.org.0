Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9406E1A83C5
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440880AbgDNPtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:49:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36726 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440940AbgDNPth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:49:37 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 37931600CC;
        Tue, 14 Apr 2020 15:49:31 +0000 (UTC)
Received: from us4-mdac16-7.ut7.mdlocal (unknown [10.7.65.75])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 352738009E;
        Tue, 14 Apr 2020 15:49:31 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 857B1280083;
        Tue, 14 Apr 2020 15:49:30 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0E2C51C0068;
        Tue, 14 Apr 2020 15:49:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Apr
 2020 16:49:23 +0100
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
To:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Sasha Levin <sashal@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
Date:   Tue, 14 Apr 2020 16:49:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25354.003
X-TM-AS-Result: No-3.159800-8.000000-10
X-TMASE-MatchedRID: Jm7Yxmmj9OnmLzc6AOD8DfHkpkyUphL9Jih/yo+OvlXM/0sSqPZieDd3
        6q149aCOnuioHfxUT32wLL+LiBpIw7lY5jX45jtYj0drvddoWEQCn5QffvZFldz0oTaLCDAekg9
        yfc05j7brcIiTNuYqnH+sec6FjbRI8pujRPSgdnZl2ityh8f8aYqR2bc/pdXeWoQBC/aPk1uVxR
        16rhfaxfoDLnvcJOKYbu2iKolbWxNYwMQSR3qB3RbwCXv1ucAPAPiR4btCEeabfl4zSTpLtZobi
        OH3ZSQzlRT3kcg2hsTKdb9l0KlIQkutpzAV/3cDKZ73BulBsrkYgyDj5TiRtRVaOcw/ySt60blg
        MMBZJCymxi7p1Fdje7e9oArc/WZW64BFqPOpM5Tqqtf1X6QWU4hQfPD8Hiq12MwxXd5kM2H3rwe
        QC0JUYIhvevwvJ+Rk+YgjZ3hX4Jd7tqWcLS4LDdo7/ilns/t209pJeIuOy7scNByoSo036VM0ZX
        irJNGHmtuYdeFfdLQt+loHtjgzw7emfKB9bRjvngIgpj8eDcByZ8zcONpAscRB0bsfrpPInxMye
        YT53RlBMu2yWsfzn0iU2Vva57EVxCYwgXEe8WMzkfypgOFnunaQcl6BKclPpawMH0Y35Lp5sC+1
        CydRiqvfKuNGff5S+s05E9DcTmPUNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8cbbCVMcs1jUlZca9R
        SYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.159800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25354.003
X-MDID: 1586879371-VDtBqPPld0bo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 16:16, Sasha Levin wrote:
> Are you suggesting that a commit without a fixes tag is never a fix? 
Because fixes are much more likely than non-fixes to have a Fixes tag,
 the absence of a fixes tag is Bayesian evidence that a commit is not
 a fix.  It's of course not incontrovertible evidence, since (as you
 note) some fixes do not have a Fixes tag, but it does increase the
 amount of countervailing evidence needed to conclude a commit is a fix.
In this case it looks as if the only such evidence was that the commit
 message included the phrase "NULL pointer dereference".

> Fixes can (and should) come in during a merge window as well. They are
> not put on hold until the -rc releases.
In networking-land, fixes generally go through David's 'net' tree, rather
 than 'net-next'; the only times a fix goes to net-next are when
a) the code it's fixing is only in net-next; i.e. it's a fix to a previous
 patch from the same merge window.  In this case the fix should not be
 backported, since the code it's fixing will not appear in stable kernels.
b) the code has changed enough between net and net-next that different
 fixes are appropriate for the two trees.  In this case, only the fix that
 went to 'net' should be backported (since it's the one that's appropriate
 for net, it's probably more appropriate for stable trees too); the fix
 that went to 'net-next' should not.
Or's original phrasing was that this patch "was pushed to net-next", which
 is not quite exactly the same thing as -next vs. -rc (though it's similar
 because of David's system of closing net-next for the duration of the
 merge window).  And this, again, is quite strong Bayesian evidence that
 the patch should not be selected for stable.

To be honest, that this needs to be explained to you does not inspire
 confidence in the quality of your autoselection process...

GregKH wrote:
> we can't get make this a "only take if I agree" as there are _many_
> subsystem maintainers who today never mark anything for stable trees
The complaint seems to be that Sasha's threshold for "this looks stable-
 worthy" is too low; maybe setting it that low should be opt-in, while
 patches for subsystems that haven't opted in should need to be
 "obviously" fixes for them to get autoselected, on the grounds that
 having to watch the autosel messages and pounce on the ones to which
 the answer is "no no no, applying that to stable kernels will break
 them horribly" is _also_ extra work for a maintainer.  (Especially if,
 a month after NACKing them, the same patch shows up again in another
 autosel batch, which — unless my memory is playing tricks on me — has
 happened to me at least once.)

-ed
