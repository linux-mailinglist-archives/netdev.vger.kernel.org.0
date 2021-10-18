Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA84431ECC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhJROFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235090AbhJRODz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F3D7603E9;
        Mon, 18 Oct 2021 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634565646;
        bh=df/VM27id6HY4TMsmx3NZHuA7LEh65SuO0efTK5oa30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KHmLSO8HNk+zXzKArjtfKCVd81q2kupVbr9EPT8rGbIaigVeGmmN1e4LBbGbBdX0n
         U2HRJFJYdvb85+2tDhrXxaWEOmC1IXK2OtEh+DK8Xtk6H3ij3VgnC8JN3I11gBDu5A
         NfNu8LoQRmmhROe9kNlsuI8FfQXoMMsH3H/lnvxUjsSrzqPUTN3VAcAFKzRE3+A1T5
         oFFAJaeKLWNH6Z6wtK1B/+Wjc+8/n0mmiY1/QisEnYKqnediuDQz44Eakrva5Ks3hM
         7uLSH30KyMwQYShBAaAYBuwGzobj3vlpf2ZbSxYsv+eRbljubYZX8DgLwMEPnFscsh
         CetKh8Cf6lspg==
Date:   Mon, 18 Oct 2021 07:00:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
Message-ID: <20211018070045.231d6575@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHapkUjr1K4RKQoJDGbzVHHyZnV9-9pMv949t9x9WuSZCCY_vg@mail.gmail.com>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
        <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
        <20211015022241.GA3405@ICIPI.localdomain>
        <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
        <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <372a0b95-7ec4-fcd9-564e-cb898c4fe90a@gmail.com>
        <20211015162953.6fefeb4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHapkUjr1K4RKQoJDGbzVHHyZnV9-9pMv949t9x9WuSZCCY_vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 09:24:21 -0400 Stephen Suryaputra wrote:
> Could this patch be queued for -stable?

It will happen automatically based on the Fixes tag.
