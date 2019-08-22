Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86819995D9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbfHVOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:06:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfHVOGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 10:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1Lk6vpvXEnqyBIiF7mfosTDxjQHB/xspWO9Lu1M6UoE=; b=SYHDb2AMXYKCedEm6oL6F8881D
        Myw8GGHu+VRMM0ooZwWvUSN8DLSJWjAb5MhofINo3qOLQaLj/4WdWZtvUCwSPaqX7bXjMvZPXhBDR
        xhbtyeM836pJvFfOpwg/61bxyzxrewNQyul6M4JdG82AF+HOMA9+QMnm396ONYAbDDYY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0njX-0004VA-A1; Thu, 22 Aug 2019 16:06:35 +0200
Date:   Thu, 22 Aug 2019 16:06:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aya Levin <ayal@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net] devlink: Add method for time-stamp on reporter's dump
Message-ID: <20190822140635.GH13020@lunn.ch>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 11:17:51AM +0300, Aya Levin wrote:
> When setting the dump's time-stamp, use ktime_get_real in addition to
> jiffies. This simplifies the user space implementation and bypasses
> some inconsistent behavior with translating jiffies to current time.

Hi Aya

Is this year 2038 safe? I don't know enough about this to answer the
question myself.

Thanks
	Andrew
