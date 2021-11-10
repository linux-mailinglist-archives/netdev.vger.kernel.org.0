Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD6844C2BB
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhKJOKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhKJOKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D91610F7;
        Wed, 10 Nov 2021 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636553255;
        bh=jrHUhq19zAR9v46glltclIDHhstwVM3+6kJ1Gx8cjMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B7gJIn8QAwDXwcrTDlSIl4HLTxFjsu+CUzhNnUeF5uoyDuDHnmojgLXjIKJYmJ9O4
         pXKtl1lzk1VMJu2sdnz7kiffM+GbWAFRhZ0R6PoTxAyn5VsLSdpQc+XYyBymA1PD+x
         3P33RJKHmzavBaICC90ZUTlvHIKyqElbO66CZBYnvutCCpKq0QnGSaDjbButTnAr6b
         2jsVnGYUc2fccdUjTWy8iYFq4I2GCSy3U5sxBXYBU67mrn/oH1ZiRWQTtYek79vySx
         gLYrSYIUjX02paDvtsPlzqgCCXlk0RQRTa4JlCZsodyEdy2wqqYiCn6X7tHucPkI2X
         cTsyfYkSWnJhw==
Date:   Wed, 10 Nov 2021 15:07:31 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net 1/3] net: dsa: mv88e6xxx: Fix forcing speed & duplex
 when changing to 2500base-x mode
Message-ID: <20211110150731.34ec35cb@thinkpad>
In-Reply-To: <YYvGkogCe0XyFFjc@lunn.ch>
References: <20211110041010.2402-1-kabel@kernel.org>
        <YYvGkogCe0XyFFjc@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 14:18:10 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> Hi Marek
> 
> Please always include a patch 0/X for a patchset explaining what the
> patches as a whole do. The text should then be used as the merge
> commit for the patchset.
> 
>     Andrew

OK, but in this case I will wait till Russell gives his comments before
sending v2.

Marek
