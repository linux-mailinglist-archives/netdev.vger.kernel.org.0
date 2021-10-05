Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402834229F2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhJEOEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236439AbhJEOER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:04:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2008761165;
        Tue,  5 Oct 2021 14:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633442546;
        bh=nZSWn8xN++BfadytUcz08RDgfDMR1W47HBlabr9TEfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hNQgiK4FGZhI10JNZYVYWjO+QRPLaEFGDmRwvJ9o3x1J8FZmi8fNmssq6/Y3dNvRB
         RqFV7AtmmbybHUDhi9tVU2C2D4lWscyC1lD8pP82dIUcaeCHpylIEgZjiYjhouauqb
         S5eXt8g+jV01OKZpF/PHUy4wP+xd/Nte615PrFsixhpzZ72yfFX/ca/UvftpyK75pF
         8BvMrkfJMNkMcbMMHwihr1jeVTj4Qsx1vA8lgMJ52ej2upTSL8YrksbYKiYPK1tuuX
         TAm4CRYcdPCnRUJrfe3d+juVa/Np+Bu07fmAKOsXzrh78OZQQcYH+k05G3pHdaLKbX
         jyrdGviqSBFiw==
Date:   Tue, 5 Oct 2021 07:02:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 13/24] wfx: add hif_tx*.c/hif_tx*.h
Message-ID: <20211005070225.4d5f038a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87tuhwf19w.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-14-Jerome.Pouiller@silabs.com>
        <87fstlkr1m.fsf@codeaurora.org>
        <2873071.CAOYYqaKbK@pc-42>
        <20211001161316.w3cwsigacznjbowl@pali>
        <87tuhwf19w.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Oct 2021 09:12:27 +0300 Kalle Valo wrote:
> >> I didn't know it was mandatory to prefix all the functions with the
> >> same prefix.  
> 
> I don't know either if this is mandatory or not, for example I do not
> have any recollection what Linus and other maintainers think of this. I
> just personally think it's good practise to use driver prefix ("wfx_")
> in all non-static functions.

I'd even say all functions. The prefixes are usually 3 chars, it's no
hassle to add and makes reading the code and looking at stack traces
much more intuitive for people who are not intimately familiar with 
the code.
