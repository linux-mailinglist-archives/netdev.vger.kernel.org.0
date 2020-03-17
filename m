Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEF188766
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCQOYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:24:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgCQOYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QqvvrmXpnKXQ1ab6Kx0r+TdrHnYQf4gBf8GHV4uqfJw=; b=0kFAx45h60mQxVpDJyndWRiy6r
        BrIv61JpTNhkfrXurbW3J9mlWIJJJM5yHHJvmzXYqkihUrUBbh1xhMM4wk1LF/5/+rfHx6EOPpdHS
        k2e5FjZLlYM11fUToB9lh/U7WeO4L+7jo6AZnzM+20biFdU6jb+pUktgc9sDnvC/a+2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jED8t-0006ud-NO; Tue, 17 Mar 2020 15:24:27 +0100
Date:   Tue, 17 Mar 2020 15:24:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, josua@solid-run.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: mvmdio: avoid error message for optional IRQ
Message-ID: <20200317142427.GU24270@lunn.ch>
References: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 08:49:05PM +1300, Chris Packham wrote:
> I've gone ahead an sent a revert. This is the same as the original v1 except
> I've added Andrew's review to the commit message.

Hi Chris

Thanks for keeping at this.

I took a look at the core code. It would of been better to call this
_nowarn, not _optional :-(

	 Andrew
