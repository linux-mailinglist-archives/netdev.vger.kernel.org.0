Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B12A1B07F3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgDTLpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:45:54 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39992 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgDTLpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 07:45:54 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2D95620080;
        Mon, 20 Apr 2020 11:45:53 +0000 (UTC)
Received: from us4-mdac16-26.at1.mdlocal (unknown [10.110.49.208])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2C9916009B;
        Mon, 20 Apr 2020 11:45:53 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6D3F2220073;
        Mon, 20 Apr 2020 11:45:52 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DD455B80070;
        Mon, 20 Apr 2020 11:45:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 Apr
 2020 12:45:40 +0100
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
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <779d89c8-1e49-fbb6-8b4f-824767d70cc2@solarflare.com>
 <20200416184924.GN1068@sasha-vm>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c9496a54-1b68-5d49-6866-d357c75f7a82@solarflare.com>
Date:   Mon, 20 Apr 2020 12:45:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200416184924.GN1068@sasha-vm>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.003
X-TM-AS-Result: No-7.370000-8.000000-10
X-TMASE-MatchedRID: H0/uSqZo4D7mLzc6AOD8DfHkpkyUphL9Ub4EdIZGxuDAsKkWkV1ld/kL
        zwTSn30ZLUxCQCxJptI/YDXXti+DZFTNH/IEdCNmxkszn8tNF/+++wkLapadd7SpaOfa5zPmZVh
        gLjSOksabc2U22TB+JZJlFV21jmV2XrN2rV89UfvwoYkKJX7f8n4JYJwdJw4TH8jJDe3vPQObor
        tksfZq1uisj1kjegzMWR+qPiBvoN5UdrkDHQOEiMYDNOU/d4P2pzsKV7qLLnTLkl8e9W70iyXi8
        Z7hCx0oHTYNsAglOq2JbGpevc40sqGOAgjGU3P9qJSK+HSPY+/CthCERUQ3nIZAAKka4fu36p9l
        GNhZOEz6RF5WZHJ6wYVrK6o/wOE5NefBHcmLEmP/Te3t5cJMG6m9/6ObPjnDSX8n1Gj4wAGP9wm
        HFkioWL8iK7rf+I9qoMQE2LWV7E3PvZCJ3jmZYUlR2DE0NRda4Py96iZzfOCMhntK59B0m7sjFJ
        j2Pyy4dUwW5kacshebcmvGyWIYfhalyx9bRjlmqhL21Dav1428xE2H2EuMWfA56pGWxGWYfdxEy
        QF1pLbKcczIzww8nYQFpIuHG2SBI00+pPWZi3FR5q8plSdLkE321hqbKUOvmyiLZetSf8mZMPCn
        TMzfOiq2rl3dzGQ18OzqAwhIneV02OXU91WpfN88V0EYpKvReP+orbDzgVlGpufdImFA2sC+ksT
        6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.370000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.003
X-MDID: 1587383152-5sHz4b8wxici
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2020 19:49, Sasha Levin wrote:
> Just a question while I process your explanation (thanks for doing it!):
> wouldn't this be done by the neural network?
Yes, in the basic case.  (Hopefully we're agreed that this is a long way
 from "I'm not sure what a fixes tag has to do with inclusion in a stable
 tree.", which is how this whole brouhaha started.)
> It learns what a stable worthy commit is (and what isn't), and applies
> weights based on these findings, right? So if it learns that most
> non-stable commits don't have a fixes tag, it's likely to use that and
> "require" other inputs to have enough weight to compensate over a
> missing fixes tag so that it'll pass the threshold, no?
Yes.  The problem comes when there are other inputs the NN doesn't have,
 that ought to screen off some of the information it's using.  This is
 probably best illustrated by an unrealistic extreme case...
Let's imagine hypothetically that the maintainer of drivers/blub is an
 absolutely perfect judge of which patches should go to -stable, and
 that the transmission path from him to the stable trees never loses a
 patch.  This would mean that every autosel patch in drivers/blub is
 necessarily a false positive, because all the 'true positives' it might
 have found have already been taken out of the pool, so to speak.  But
 if the NN is just trained to discriminate patches on whether they end
 up going to stable, it won't see any difference between a drivers/blub
 patch that the maintainer sent to stable straight away and a
 drivers/wibble patch that the latter's less diligent maintainer didn't
 forward and that only got picked up later when a stable kernel user
 encountered the bug it was fixing.
As long as the NN doesn't have that piece of information, it's going to
 either generate lots of false positives in drivers/blub or lots of
 false negatives in drivers/wibble.
Now obviously drivers/blub doesn't exist, no maintainer is 100% perfect
 at -stable submissions; but any difference will produce the same
 effect on a smaller scale, with the 'blubbish' maintainers seeing a
 high false positive fraction while from the 'wibblesome' maintainer's
 point of view autosel is working great.  And since the 'blubs' are the
 ones who're putting effort of their own into stable selection already,
 they get aggrieved at having to also put effort into catching the
 false positives from a system that doesn't seem to be doing much for
 them, and everyone ends up shouting at each other as we're seeing here.

(Do you want me to do another worked numerical example demonstrating the
 above, or does it make enough sense in words not to need one?)

-ed
