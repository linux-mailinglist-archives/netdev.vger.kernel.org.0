Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D81254F1B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgH0Tr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgH0Tr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 15:47:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C0D207DF;
        Thu, 27 Aug 2020 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598557646;
        bh=KpLe1vg8oEg36UMFWYfJE2Ed3AvRcEvpPEW2/sE9GSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mm/mtA/a/Px5yHxzdoWVK0aqmchSsmc+T7P+O4tqEqe3aKVDCCGDAcf7jhzhVeaDn
         J5SWWzNhsQbTJeKa/ZFzIbxyBk8ycuGDpTJZvBi1Txw75tZEvmu5jW5vF30Pt0xvWQ
         Fp1LIc9R78TMmki07sleuXXbYkihsoe9PaMYn4B4=
Date:   Thu, 27 Aug 2020 12:47:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
Message-ID: <20200827124724.61b9904e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200827180735.38166-8-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
        <20200827180735.38166-8-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 11:07:30 -0700 Shannon Nelson wrote:
> Authored-by: Neel Patel <neel@pensando.io>

Also - what's Authored-by? :S Do we need a sign-off for this?
Perhaps Co-developed-by, which is more standard?
