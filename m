Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C7731272
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfEaQdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:33:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfEaQdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WTUY7NBoeWu3HANU6zgkoF6y+9haCI+guBTHb7hiLQ4=; b=kOSaHrM1/+3xoN7VP+2/XAyIb
        e2QtjGyy6cSvbl/o1vYjkLd9UlvTqQ3mm0osfb8rbpd5JocxX/TJ8slNK25rmAkmmpzM7HgwR2+eh
        WhiVeFQoAkEXli0htbkyT8C4xqyupYhtfraT2e/HuM2PihzxLv41Zp/zyI/Twlegfm0D7EkDYyPFc
        Urxd8U+ppSjxaKeq3usHNtKhUFV8ynCvX2UTJrF1qyctEahR+7/X5xVCn33Z77FGT0ffmDGH/67fg
        rnXrVyphgRP2hQou3fjvugCONiaJ4p08WN3boxSUPDHssbhRpPHHGrTaR8l/9CC6dZn1vzu17VZpc
        lgdC359cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hWkTW-00044S-Uo; Fri, 31 May 2019 16:33:50 +0000
Date:   Fri, 31 May 2019 09:33:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     laurentiu.tudor@nxp.com, madalin.bucur@nxp.com,
        netdev@vger.kernel.org, roy.pledge@nxp.com,
        linux-kernel@vger.kernel.org, leoyang.li@nxp.com,
        Joakim.Tjernlund@infinera.com, iommu@lists.linux-foundation.org,
        camelia.groza@nxp.com, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
Message-ID: <20190531163350.GB8708@infradead.org>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <20190530.150844.1826796344374758568.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530.150844.1826796344374758568.davem@davemloft.net>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 03:08:44PM -0700, David Miller wrote:
> From: laurentiu.tudor@nxp.com
> Date: Thu, 30 May 2019 17:19:45 +0300
> 
> > Depends on this pull request:
> > 
> >  http://lists.infradead.org/pipermail/linux-arm-kernel/2019-May/653554.html
> 
> I'm not sure how you want me to handle this.

The thing needs to be completely redone as it abuses parts of the
iommu API in a completely unacceptable way.
