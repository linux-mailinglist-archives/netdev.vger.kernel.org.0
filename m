Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41823428D82
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhJKNFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236762AbhJKNFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE3960F14;
        Mon, 11 Oct 2021 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633957433;
        bh=T1ec953CEWbRgaCdJ9R8TYZD4ho48T5YFzq/xN7tTwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqThtMfTdLI/pANRGgLmU6QUAkma2Zr/PqZfsbtjY0G96y0khPY1HieWeprC9DydW
         jI6/olf7MnmucWsvMd1HPsw26LSCj/tw+ygP9hD+umWaMFTDXqGON2LijU7RQjcQPD
         0RYDh0QXljJ/vjSLsjkHB+NJnHFOGbZdOMqd6s5F6bbVnVxLo4ifZVeS3UwBuoznPd
         9WBpTajDup8A/vJCvKFOHUpgWc34V6QPtZ+lpmuyAZ7GMuW3XNE2lQFwWlElPZVrNo
         ZhKQ0ako7LRH+ekOpwNLaaijX5tJdrc/Pt9JA3tIwu8TWnoOwr6yqSc3cxS9u7HzpA
         AAx1Dx4ODgKGA==
Date:   Mon, 11 Oct 2021 06:03:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     David Miller <davem@davemloft.net>, k.opasiak@samsung.com,
        mgreer@animalcreek.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/7] nfc: minor printk cleanup
Message-ID: <20211011060352.730763fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+Eumj65krM_LhEgbBe2hxAZhYZLmuo3zMoVcq6zp9xKa+n_Jg@mail.gmail.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
        <20211008.111646.1874039740182175606.davem@davemloft.net>
        <CA+Eumj5k9K9DUsPifDchNixj0QG5WrTJX+dzADmAgYSFe49+4g@mail.gmail.com>
        <CA+Eumj65krM_LhEgbBe2hxAZhYZLmuo3zMoVcq6zp9xKa+n_Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Oct 2021 13:36:59 +0200 Krzysztof Kozlowski wrote:
> On Fri, 8 Oct 2021 at 12:18, Krzysztof Kozlowski wrote:
> > On Fri, 8 Oct 2021 at 12:17, David Miller <davem@davemloft.net> wrote:  
> > > Please CC: netdev for nfc patches otherwise they will not get tracked
> > > and applied.  
> >
> > netdev@vger.kernel.org is here. Which address I missed?  
> 
> The patchset reached patchwork:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=559153&state=*
> although for some reason it is marked as "changes requested". Are
> there any other changes needed except Joe's comment for one patch?

I think it was just Joe's comment, nothing else here looks
objectionable.
