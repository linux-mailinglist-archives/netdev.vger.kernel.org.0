Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82D311E9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfEaQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:04:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfEaQER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 12:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=phpxpkgLhwrmvrm93IZTqVz0bp7GNYg5AmBa1efA9PE=; b=u9ozawRBbaxvA9ej/S/15pgrKO
        XuFmXBMunYcQ/O1s4Pnt/970mK7LcPRosQZYLA5jCMVtbWgHF8DXwQcnKOmAOC98oX9ylQFlBfYkL
        XPRbQUypRCWVrYUvCPnDYyqO4KxMRpuFlBq18vSovFxsBcNHPaSR+AO5alLwgYDVUHXw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWk0t-0007KK-OH; Fri, 31 May 2019 18:04:15 +0200
Date:   Fri, 31 May 2019 18:04:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linville@redhat.com
Subject: Re: [PATCH v2 1/2] ethtool: sync ethtool-copy.h with linux-next from
 30/05/2019
Message-ID: <20190531160415.GC23821@lunn.ch>
References: <20190531135748.23740-1-andrew@lunn.ch>
 <20190531135748.23740-2-andrew@lunn.ch>
 <20190531155355.GG15954@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531155355.GG15954@unicorn.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> BtW, this differs from the file "make headers_install" produces in
> net-next but only in white space so that it doesn't really matter and it
> gets sorted in a future sync.

Yes, there is something odd going on. It looks like two tabs have been
converted to spaces in the ethtool copy. I left them alone, since i
did not add them.

    Andrew
