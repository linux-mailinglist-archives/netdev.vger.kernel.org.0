Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16124A30E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfFRN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:58:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbfFRN6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3u1T598CsM8u4R2gZtMhFj9NuAaqaJhlE6GdTppi4nk=; b=vZs4hCUzcCwimk0bivuFBiZos/
        Ol9pTpCRcs1I+K1UT0aO73Ruho5RNdJ5B7S82/aUzmihXenb3DhOeBj1/9b+21U+4L+EGlSUd2BFY
        r19y7ZzrGPTvFKjMbHp5XBhSJlEmtijAY4KjBKEsGS1JMm7vare79exvVzqcjWlQymXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hdEcz-0000h4-OY; Tue, 18 Jun 2019 15:58:25 +0200
Date:   Tue, 18 Jun 2019 15:58:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Artem Bityutskiy <dedekind1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Todd Fujinaka <todd.fujinaka@intel.com>
Subject: Re: [PATCH 1/2] net: intel: igb: minor ethool regdump amendment
Message-ID: <20190618135825.GC18088@lunn.ch>
References: <20190618115513.99661-1-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618115513.99661-1-dedekind1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 02:55:12PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Hi Artem.

The subject line is missing a t in ethtool.

> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
