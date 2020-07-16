Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9518221B0C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGPDui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGPDui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 23:50:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64692071B;
        Thu, 16 Jul 2020 03:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594871438;
        bh=0bDASk0781jq/cji5sUbOq/NcKI50JUK8aOvo76NM1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oogYGLGg0wKaXDpiEPMy1C41qPf1XwXf75ZyM6sPozBFOEfZLOmH1H3ACsugiBw4D
         xQmkE5O0d+/WUca5QU/EybTHyZ2vzR8gomP1mVuR2rWfVW4rg1PEi8y49sXdFPqxO9
         lNFpbIavUtYET351S/KiGjPIo8O5wj5qv5X6mchI=
Date:   Wed, 15 Jul 2020 20:50:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/9 v2 net-next] net: wimax: fix duplicate words in
 comments
Message-ID: <20200715205036.551e0486@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <50300854-3b28-3bab-dcf8-4dd49efebf86@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
        <20200715164246.9054-3-rdunlap@infradead.org>
        <20200715203453.4781ddee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50300854-3b28-3bab-dcf8-4dd49efebf86@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 20:35:34 -0700 Randy Dunlap wrote:
> On 7/15/20 8:34 PM, Jakub Kicinski wrote:
> > On Wed, 15 Jul 2020 09:42:40 -0700 Randy Dunlap wrote:  
> >>  /*
> >> - * CPP sintatic sugar to generate A_B like symbol names when one of
> >> - * the arguments is a a preprocessor #define.
> >> + * CPP syntatic sugar to generate A_B like symbol names when one of  
> > 
> > synta*c*tic
> > 
> > Let me fix that up before applying.  
> 
> eww. Thanks.

Applied, pushed. Thanks!
