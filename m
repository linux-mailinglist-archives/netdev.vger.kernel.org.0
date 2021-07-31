Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD793DC6F0
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGaQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 12:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhGaQd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 12:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DC3E60F13;
        Sat, 31 Jul 2021 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627749232;
        bh=BOPpUSjxDz00r/FRJaG8mxlK8DItXDs1H8BlKV/FtI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cOI+2RsrQQS4FyIwRgtRa9xBkb/42RdGz4DeY59M3GPww/TjftQ6LEIBBdENRiIxB
         uMZXCwrJZCoAbV39tXQHD7dlgkojYZJpW0gKWvDEFmVIbamuqD2YoF4WVan8kYapWh
         ar5/meLJYdjFWPfDL5ebMx9/D2CaVt3WTqDVwBYSO1Nle2/03d4y7JN1uJ/JF7U5YS
         c4Tc4vSEdc2ZYFM2PfQ6Xl/ieqbTJTsf+kLUie9mTSrUoHJ0oRJfiCMHmKfeU8MHLv
         3n8KOev3mYGpr+JtmGMz98p1dWOBO8eulPM1yBWFibsQh0NcqvzBT4f8a/yyMeJ39S
         b9LUcta5G14Uw==
Date:   Sat, 31 Jul 2021 09:33:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: [nicstar] make drain_scq explicitly unsigned
Message-ID: <20210731093351.39c0e305@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210731085429.510245-1-jordy@pwning.systems>
References: <20210731085429.510245-1-jordy@pwning.systems>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Jul 2021 10:54:28 +0200 Jordy Zomer wrote:
> The drain_scq function used to take a signed integer as a pos parameter.
> The only caller of this function passes an unsigned integer to it.
> Therefore to make it obviously safe, let's just make this an unsgined
> integer as this is used in pointer arithmetics.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>

Does not build.
