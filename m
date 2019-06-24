Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0910351DEF
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFXWI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:08:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfFXWI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 18:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TPL/HHzsXJVdvdFTFnRDjeDTgL/wb5f00+LLpLFSJX4=; b=v+AaN1a72Gf25vaExqLJo9bg7v
        k0hQpYAQdTHcwGMHPsRdnxaazdUE9xkNwi6Vep+I0RrlyWnOmaCyO1iWcrMsE+N7ZTxgzcHrlbbbH
        W4Amw+coJuG60MlNHr6xTV40+gpR8MG6sro8Yht12Ij/uNsDc7EsuO5fKLPYU7pe5tSU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfX8Q-0000wJ-7j; Tue, 25 Jun 2019 00:08:22 +0200
Date:   Tue, 25 Jun 2019 00:08:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/8] net: aquantia: replace internal driver
 version code with uts
Message-ID: <20190624220822.GD31306@lunn.ch>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
 <bb06ad821aeb27c31d1370fe7ca4ebdf73d45a06.1561388549.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb06ad821aeb27c31d1370fe7ca4ebdf73d45a06.1561388549.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 03:10:45PM +0000, Igor Russkikh wrote:
> As it was discussed some time previously, driver is better to
> report kernel version string, as it in a best way identifies
> the codebase.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Hi Igor

You should add any reviewed-by, or acked-by tags you received for
previous versions.
