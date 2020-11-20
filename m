Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B01D2BBA6B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgKTX4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbgKTX4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:56:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A9C223B0;
        Fri, 20 Nov 2020 23:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605916598;
        bh=Ar7jfRIwyvlS8JFQ4Z8QxItcibMLIRuRFg/GfBbojhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uB5x7td2syoJ37gB0OdPmU74R0RzWIKpoY5w1fb00TRRocUuLSz8GGwZ6/xEzNoFg
         vLCWrl5rtpol4SGQF3l+JRyQihLGhWBFnynIIc9LseiRX9Uk3YJsjDZn7m7vAgAPVR
         E4nN7sru95qQzBu9M+wupxIVfSGynZi4HNvF7DQo=
Date:   Fri, 20 Nov 2020 15:56:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ion Badulescu <ionut@badula.org>
Cc:     xiakaixu1987@gmail.com, leon@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net: adaptec: remove dead code in set_vlan_mode
Message-ID: <20201120155637.78f47bc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fe835089-3499-0d70-304e-cc3d2e58a8d8@badula.org>
References: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
        <20201120151714.0cc2f00b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fe835089-3499-0d70-304e-cc3d2e58a8d8@badula.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 18:41:03 -0500 Ion Badulescu wrote:
> Frankly, no, I don't know of any users, and that unfortunately includes 
> myself. I still have two cards in my stash, but they're 64-bit PCI-X, so 
> plugging them in would likely require taking a dremel to a 32-bit PCI 
> slot to make it open-ended. (They do work in a 32-bit slot.)
> 
> Anyway, that filter code could use some fixing in other regards. So 
> either we fix it properly (which I can submit a patch for), or clean it 
> out for good.

Entirely up to you.
