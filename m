Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5932777B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhCAGW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhCAGV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 01:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EE1264DF1;
        Mon,  1 Mar 2021 06:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614579638;
        bh=zE4SqWLJ0AIr/RrwUjNXM2IbzMt5gqooV6qcmdqYiUk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=a+9qs6DFQFKaKn1jEtezoVllCR3cGdM1Tnso6s0wMv5e6XUyavfJYTaR4NC/OzznV
         KmRvhEdws4ALI8sze/K5OrFgpCqXwbJsQ/uHQfuZEM6Dz4wKP6ycvYIUVOjw6KupWz
         TC5T45Lm3sIRbrP+8l6Uf/I8TMiVBU89ooI/j1iSy6PHCvKOWwVgZoG1htgdIdO7Kr
         p47va7fv4/sJc1woX3veHxNDoPbJer7x7oAA9L+lTlnzWfGpvtgleuEcVlmMVoKcPE
         5g0PiSM6PFxp5uH6ebXHpcQnmrq1eTwYVn5Y64WdUPzkVKQUFtgffrjAu2lok+9/6L
         90evajUdZPHow==
Date:   Mon, 1 Mar 2021 08:20:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Phil Sutter <phil@nwl.cc>,
        William Chen <williamchen32335@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: rename the command ip
Message-ID: <YDyHsSuZ+pegMf3P@unreal>
References: <6039381f.1c69fb81.45e6d.4dea@mx.google.com>
 <20210228213914.GS22016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228213914.GS22016@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 10:39:14PM +0100, Phil Sutter wrote:
> William,
>
> [Cc'ing netdev list as that's the place to discuss iproute2
> development.]

<...>

> > IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
>
> Luckily I'm the intended recipient so I may choose to disclose the
> content (e.g. to a mailing list).

It is OK, he sent the same letter to many of us.

Thanks

>
> Cheers, Phil
