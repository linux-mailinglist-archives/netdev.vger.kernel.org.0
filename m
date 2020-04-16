Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DEF1ACFF1
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 20:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgDPSt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 14:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgDPSt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 14:49:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5372087E;
        Thu, 16 Apr 2020 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587062966;
        bh=vlrBxtC81mYtlfOvLHcdhi5JQu5vHuYNv8+xnB3cZbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCioU/BvryGGP3PiZg9a5tIRMhGYnd2W6P7D+MFRtf1NQ8Fe3Os2NmZgBa+4un6a2
         jVNPRXbpNoRDXZXf/vm21HdpShgFohlgLLPN1kqDxTf0OcH+iTMKGigNWpOJtcSmzB
         Z0CvUgvIvhN+nN4gHFpLRxVaGKgO/uDqHozWXtak=
Date:   Thu, 16 Apr 2020 14:49:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200416184924.GN1068@sasha-vm>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <779d89c8-1e49-fbb6-8b4f-824767d70cc2@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:06:46PM +0100, Edward Cree wrote:
>On 16/04/2020 01:00, Sasha Levin wrote:
>> I'd maybe point out that the selection process is based on a neural
>> network which knows about the existence of a Fixes tag in a commit.
>>
>> It does exactly what you're describing, but also taking a bunch more
>> factors into it's desicion process ("panic"? "oops"? "overflow"? etc).
>Yeah, that's why I found it odd that you were responding in a way that
> _looked like_ classic confusion of P(A|B) and P(B|A).  I just wanted
> to make sure we had that common ground before launching into a long
> Bayesian explanation.

Just a question while I process your explanation (thanks for doing it!):
wouldn't this be done by the neural network?

It learns what a stable worthy commit is (and what isn't), and applies
weights based on these findings, right? So if it learns that most
non-stable commits don't have a fixes tag, it's likely to use that and
"require" other inputs to have enough weight to compensate over a
missing fixes tag so that it'll pass the threshold, no?

-- 
Thanks,
Sasha
