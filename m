Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43760469765
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244723AbhLFNst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:48:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244595AbhLFNsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:48:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3L+rqFDwWicWHLbO3b+awgcdCDlCw+EVkJCX3jomggY=; b=NyxQ1i1D+qMT7yEANfY2fn7hfM
        lab+FX1Y8Qp2Cs2ingEDX6Hw5QE9uhRi/ArtzaSjnjZcx2ibK/blMsuKbap0HScqiDho3FrWQV3kj
        P/YSQ3W3jyPEO+JP5NbY7GVkO2sskNhaMYot+9fsZrUK5ANynEcG2u9s9YKt2x3pM63g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muEIp-00FfGd-57; Mon, 06 Dec 2021 14:45:11 +0100
Date:   Mon, 6 Dec 2021 14:45:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     kabel@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: fix uninit-value err in
 mv88e6393x_serdes_power
Message-ID: <Ya4T5x0EOktaF2FU@lunn.ch>
References: <20211206101352.2713117-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206101352.2713117-1-liu.yun@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:13:52PM +0800, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> 'err' is not initialized. If the value of cmode is not in the switch case,
> it will cause a logic error and return early.

Same fix as: <20211206113219.17640-1-amhamza.mgc@gmail.com>

At least here some analysis has been done why there is a warning.

Should we add a default?

       Andrew
