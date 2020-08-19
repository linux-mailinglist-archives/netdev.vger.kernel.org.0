Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5289B24A848
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgHSVOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgHSVOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 17:14:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074BA207FF;
        Wed, 19 Aug 2020 21:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597871670;
        bh=GwJox8iQtaPpA4wNpdiBxpnarhMZ2ZhAnnKnBftUkAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qHBa+0QELEbyQu0ed6ff4UMPpvi0rBONHgCg6EHNLzmGHTx9G18o5C1yXolSbiEss
         a7WdMa6VMLTmCa+n/gDULglQEqtVRNRWNen9TjZvVutdQKZqweuW1YCUF9oq9PYgMj
         Um5bnvv8Rv+3IPWbsKzxbl6rnPegxlIdHst0EcFA=
Date:   Wed, 19 Aug 2020 14:14:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Message-ID: <20200819141428.24e5183a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819202223.GA179529@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
        <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
        <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200819202223.GA179529@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 22:22:23 +0200 Lorenzo Bianconi wrote:
> > On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote:  
> > > Enable the capability to receive jumbo frames even if the interface is
> > > running in XDP mode
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> > 
> > Hm, already? Is all the infra in place? Or does it not imply
> > multi-buffer.
> 
> with this series mvneta supports xdp multi-buff on both rx and tx sides (XDP_TX
> and ndo_xpd_xmit()) so we can remove MTU limitation.

Is there an API for programs to access the multi-buf frames?
