Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D244AAA2C
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 17:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380457AbiBEQcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 11:32:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbiBEQcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 11:32:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=85nV+OR0IWhIcdUxt/+ioXn6stmP/R1xrr3eIx5sxoQ=; b=OX
        xqvsSoNhRyeZUEbjsvR/AVa/78K9licg4rWWPfizENnYxvJEJu4ao63F2b+GeiBIfPu7SrWJkyWBF
        Eb7517S1zTjRIKViR+zNdYjg9EVh3UjbTm89mtl8jK8JGeIJEKoBjFzhPzS86Vt7MN2/pwm0nmfBq
        StquJBjjLInSjtA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGNza-004PXa-7K; Sat, 05 Feb 2022 17:32:54 +0100
Date:   Sat, 5 Feb 2022 17:32:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct
 ethtool_drvinfo
Message-ID: <Yf6mtvA1zO7cdzr7@lunn.ch>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <5538622.DvuYhMxLoT@eto.sf-tec.de>
 <Yf6OSc78JScHNgag@lunn.ch>
 <2227796.ElGaqSPkdT@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2227796.ElGaqSPkdT@eto.sf-tec.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If it is not used anywhere else, yes, you can remove it.
> 
> Of course it prints the number on module load… but otherwise it does nothing 
> with it.

You could remove that as well.

The basic problem is, the version string does not identify the sources
with enough accuracy. It says nothing about back ported fixes in
stable kernels. It tells you nothing about vendor patches to the
network core, etc.

	Andrew


