Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BB1ACCB2
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgDPQHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 12:07:10 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:40010 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728114AbgDPQHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 12:07:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 61F27600DD;
        Thu, 16 Apr 2020 16:07:03 +0000 (UTC)
Received: from us4-mdac16-6.ut7.mdlocal (unknown [10.7.65.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5FBB38009E;
        Thu, 16 Apr 2020 16:07:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B376380051;
        Thu, 16 Apr 2020 16:07:02 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2765FA80061;
        Thu, 16 Apr 2020 16:07:02 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 16 Apr
 2020 17:06:55 +0100
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
To:     Sasha Levin <sashal@kernel.org>
CC:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Linux Netdev List" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
References: <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <779d89c8-1e49-fbb6-8b4f-824767d70cc2@solarflare.com>
Date:   Thu, 16 Apr 2020 17:06:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200416000009.GL1068@sasha-vm>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25358.003
X-TM-AS-Result: No-7.422500-8.000000-10
X-TMASE-MatchedRID: HLMPCFyIyBPmLzc6AOD8DfHkpkyUphL9HkWa9nMURC4W6M2A15L1QP1b
        Ocztcrfi9y0si6rTiya4qyXQiR53STrl7gPhTJMPGiSKwLJUJ7Eb3zyRU6EBvh//bz4/xYKAIKR
        piQCnYZveFNYjNC5x4tmXlTv6s91ssu1e6zO/XBC1GgeTcvlUnPic6Ma13+ufTGgmdNvqkl+4KN
        oeDfLV7LlqiBHCCaa6mfHUPwJ5HXNRnOaI8J4pLzfu+RTlciXgDvc/j9oMIgUuZSs9lcBqfnEMX
        oluwlO2jqQ82yy1I7Rb0BCI7wdwwLX1vo7+rLqGRXdiukZQCgE0aXTlOdj8kw5SzgJNSArLnCWT
        aXAK9QNtL2HUCgveD+DcAHv31uCXCXUTYBf5b3ssYOarN8c4H1eOOwzb8N/GpjfLp08U3/W7LAA
        thI3XRnk37+FwjZVfNaqAmzMMlzil+yWhjYUl7edNi+0D4LmKei6Cy+4dr9oS39b8+3nDx9skxt
        NP0r9NEIy8vMxarTM2EqJn2nY8hoxpy4UOhqKrIv/tYKD045LFdEMoTK7bMYIXP2KSJplGxYQsK
        eG/kyWDenTS3qzbzVgbYesIPWtSKgDmz5EUYuXBe89zsi5D0AKflB9+9kWVIyM6bqaAlyvwtZWt
        kkk1NKsguwzsfUr7Gc7zSgqFEWC4vpKu9/6gMW6HurDH4PpPAZNQS8fWdZ12AfDzADsQvLJnPh8
        w+R5o8WYhJSDf+eQvbO9ImVjdWC7bvTtKtQVC8KGJCiV+3/JGggmPZz/QYZsoi2XrUn/JmTDwp0
        zM3zoqtq5d3cxkNQwWxr7XDKH8sV0ftnDC/TUiiictwS4K0+CplgVSWiDCBdhMlQAcDqXa0fdaV
        0MQGUMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.422500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25358.003
X-MDID: 1587053223-mSobTtx7W0UE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2020 01:00, Sasha Levin wrote:
> I'd maybe point out that the selection process is based on a neural
> network which knows about the existence of a Fixes tag in a commit.
>
> It does exactly what you're describing, but also taking a bunch more
> factors into it's desicion process ("panic"? "oops"? "overflow"? etc).
Yeah, that's why I found it odd that you were responding in a way that
 _looked like_ classic confusion of P(A|B) and P(B|A).  I just wanted
 to make sure we had that common ground before launching into a long
 Bayesian explanation.

So, let's go:
Let's imagine that 10% of all commits are stable-worthy, and we have a
 threshold that says we autosel a patch if we think there's better than
 50% chance that it's stable-worthy.  Then 50% of stable-worthy commits
 have a Fixes: tag (whose referent exists in the stable tree already),
 whereas some unknown fraction, let's say 5%, of non-stable-worthy
 commits have a Fixes: tag.
Then P(S|F) = P(F|S)P(S) / (P(F|S)P(S) + P(F|¬S)P(¬S))
            = 0.05 / (0.05 + 0.045) = 0.526...
That is, a patch with a Fixes: tag is 52.6% likely to be stable-worthy,
 *not* 50%.  (The disparity would be bigger if P(F|¬S) were smaller;
 conversely, if P(F|¬S) were larger, P(S|F) could be _less than_ 50%.)
But also, P(S|¬F) = P(¬F|S)P(S) / (P(¬F|S)P(S) + P(¬F|¬S)P(¬S))
                  = 0.05 / (0.05 + 0.855) = 0.055...
That is, a patch without a Fixes: tag is only 5.5% likely to be stable-
 worthy, which is *less* than the 10% base rate for all patches.  So
 now you need to get *more* of the positive evidence (panic/oops/overflow
 etc.) before you get pushed over the 40% threshold.
Thus "increase the amount of countervailing evidence needed".

> most fixes in -stable *don't* have a fixes tag. Shouldn't
> your argument be the opposite? If a patch has a fixes tag, it's probably
> not a fix?
I hope it's now clear that this statement confuses P(S|F) with P(F|S).

> Let me put my Microsoft employee hat on here. We have driver/net/hyperv/
> which definitely wasn't getting all the fixes it should have been
> getting without AUTOSEL.
>
> While net/ is doing great, drivers/net/ is not. If it's indeed following
> the same rules then we need to talk about how we get done right.
>
> I really have no objection to not looking in drivers/net/, it's just
> that the experience I had with the process suggests that it's not
> following the same process as net/.
Again, I'm not saying "don't look in drivers/net/", I'm saying increase
 the probability threshold there: because _some_ of the stable candidates
 have already been picked up by our process, the pickings in what's left
 are thinner, i.e. the base rate P(S) is lower, so you need _more_
 evidence before deciding to autosel something.  (I don't know exactly
 how your NN is set up; is it able to use information like "is in
 drivers/net/" as an input node?)  Part of the trouble is that the NN is
 trained on "did this go to stable eventually", whereas being in
 drivers/net/ is (on this theory) only a signal in the case where it
 didn't go to stable _initially_ and had to be caught later; is that
 information also present in your training data?  The NN would only be
 expected to learn about drivers/net/ for itself if that were the case,
 otherwise it would have no way of knowing about the lowered base rate.
Conversely, if it *did* have that information (was this sent to stable
 by maintainer's own processes, or was it found later to have been
 missed) in the training data, it could learn these things by itself and
 there'd be no need to do anything special for drivers/net/ (or, arguably,
 even for net/).

> How come? DaveM is specifically asking not to add stable tags because he
> will do the selection himself, right?
Driver maintainers sending patch series to Dave often include in the
 cover letter "please consider patches 4, 7, 8 for stable".  It's *directly*
 CCing stable on patch submissions that Dave asks people not to do.
And it sounds from your Microsoft-hat like the HyperV maintainers might be
 under that same misapprehension, if their stuff isn't making it to stable
 as much as it should be.  But I haven't checked.

-ed
