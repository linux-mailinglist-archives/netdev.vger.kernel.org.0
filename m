Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC832EE72B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbhAGUtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGUtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:49:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEEA82343B;
        Thu,  7 Jan 2021 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610052508;
        bh=gTToTgtzJwu6dILhUp01eNoOHIo3R7gTvPzbhkyLT5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l6vDPCsgNuBgu5m501/gqwtWAtoUbOcDWI5wBhGCZ0zWu44JYuAhOlmWzzevwSS2y
         XNWAv0VXvVTx/ESAkr/fp5df2h6ViOocku6MFJV+XXlvOHazy8x7KIo+l3aKhrr1ad
         VMr5HuSVbVvamiiiwzaJCGnS4PjW4i91kUzYP3X8buNrb3gDjtNhinPNTfhHOm3qlx
         B7COXx0aOtSu+/BJbM4ukcbL7ZbmR2XsKbSzq27GP41R7i+KAz3CPHCbOtEERTjJ/K
         5TPsmjmA76mYRXYp63NEE0wLNWwlR5aJCKpK5lAH1uihpo9J1+yTEcVhf9Jd4KTTRF
         F6a0ewgXTRYYg==
Date:   Thu, 7 Jan 2021 12:48:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs: octeontx2: tune rst markup
Message-ID: <20210107124826.6cb90423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
References: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 17:17:35 +0100 Lukas Bulwahn wrote:
> Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
> reporters") added new documentation with improper formatting for rst, and
> caused a few new warnings for make htmldocs in octeontx2.rst:169--202.
> 
> Tune markup and formatting for better presentation in the HTML view.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied to net, thanks everyone!
