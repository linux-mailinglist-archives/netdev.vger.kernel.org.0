Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2710547A71A
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhLTJdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:33:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229513AbhLTJdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 04:33:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jySBOz6rFMfrLbqsSW79w7an4bctSYxUq7g2gQMmaXs=; b=IbQ1Sl2GOrfXkTDaltIy8PFkhE
        YFQB3BmnLIEaUK5bnawZohheFFcQj0BeYPEp3vEQsGroiRu9B7CoqBuLLQcZyZtqBJB8wMZL+lCuQ
        GSquNKK7LgDKoDg5V2MO15Yf2VO9xw5hw0RsCZcv0NYO3EcthlTTCUe7gH18oudmryTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzF2e-00H2DV-Fy; Mon, 20 Dec 2021 10:33:12 +0100
Date:   Mon, 20 Dec 2021 10:33:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lucian <l@vectormail.xyz>
Cc:     netdev@vger.kernel.org
Subject: Re: Maintainer Application
Message-ID: <YcBN2BPMidu/Zkso@lunn.ch>
References: <79e151cd-0527-ba56-a41a-7fe00e206558@vectormail.xyz>
 <97c5cf1d-be9f-0cf0-cd4d-9e04aa46294a@vectormail.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97c5cf1d-be9f-0cf0-cd4d-9e04aa46294a@vectormail.xyz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 05:14:45PM +0800, Lucian wrote:
> Hi,
> 
> Sorry to bother you guys again but I am still awaiting a reply from someone
> regarding becoming a maintainer of the hsr network protocol in the linux
> kernel.

Hi Lucian

You become a maintainer by being a maintainer. Review other peoples
patches for HSR, test patches, give Reviewed-by, Tested-by etc. Show
you know the code and you know the Linux processes for getting patches
merged, dealing with regressions etc. Ideally you need other
maintainers to trust your judgement, and you gain that trust by doing
the job.

So rather than asking to become a maintainer, just show you can be a
maintainer.

       Andrew
