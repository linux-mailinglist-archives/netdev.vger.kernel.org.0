Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9873AA0EB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhFPQLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:11:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPQLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Hn1kvgbMJcOevRD2LEsAHQ5yvFfsrcWjmM7uTJN/OAQ=; b=0d80vr+ypaKQ2r5KwXAZj7c/f5
        yiHF6sR6WjYOy2WvqC4xT6+XjPjn2lWh9CqA0smViuk/sfTZ+lqgjqNlTHGU9w6TIppseUVtyn9DF
        WPfsKhZ8JhkcoKtiZbq6148W/pwbuG42hYWcjscXIpWYEgRlm9ikhnsNeEDfau0vRYEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltY6Y-009kjB-Rd; Wed, 16 Jun 2021 18:09:26 +0200
Date:   Wed, 16 Jun 2021 18:09:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH v2 net-next 7/8] net: phy: remove unnecessary line
 continuation
Message-ID: <YMoiNotfwbdyOI5D@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-8-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-8-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:25PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Avoid unnecessary line continuations, and put '|' at the end of line.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
