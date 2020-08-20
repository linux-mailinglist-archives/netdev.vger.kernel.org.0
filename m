Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC3F24C194
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgHTPLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgHTPKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 11:10:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C4512086A;
        Thu, 20 Aug 2020 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597936255;
        bh=KhPY2b6Onj95xntb/nheHowGIC/aHgYDgTmgTg3CpG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcJzmf+Y0xCNGjFbgMmzL8DCJwpYpBoMl/cqsueuTbWRuxtBblqCdmjWSWn5qahXM
         CnxM2SEFq1pvsiKbc5MvsL71a/dx6qM7PyDvTP1FMDMlIqqkJEH1dLRaUJjMuMYDFC
         16/G28VoI9H3mng0OPilOAQ/6uG/1uBT0qYYJIR0=
Date:   Thu, 20 Aug 2020 08:10:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        Antony Antony <antony@phenome.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH ipsec-next v2] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
Message-ID: <20200820081053.7aba989a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200820120453.GA18322@moon.secunet.de>
References: <20200728154342.GA31835@moon.secunet.de>
        <20200820120453.GA18322@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 14:04:53 +0200 Antony Antony wrote:
> ---
> 
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

A warning here - anything after --- will be cut off by git when
applying the patch. Perhaps you could resend the patch without it 
to save Steffen manual work?
