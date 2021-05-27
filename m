Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88D393422
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhE0QkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:40:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhE0QkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 12:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/RL/1s3O66zhYqE74abFOjwVN39mighO3LWKsR5YvoY=; b=JJ
        2ASZC7BPRP6Iblv7RNabzlKWPZF+2+TFjPjSstI7KiaxVn0VYoGarcdtOROZZMA9mofc+Py2I/eEE
        CmzqWVnBS3ijJdBaVJIEqlhWnFi3zkKzoB3aiGq1PiCo2m1MQUk4hB1hMAicwg/RN3yR+qEN6EyJe
        RArafmjkcVIN94A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmJ1q-006ZpY-Tl; Thu, 27 May 2021 18:38:38 +0200
Date:   Thu, 27 May 2021 18:38:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v1 1/5] leds: trigger: netdev: don't explicitly zero
 kzalloced data
Message-ID: <YK/LDj3BE8r9riw3@lunn.ch>
References: <20210526180020.13557-1-kabel@kernel.org>
 <20210526180020.13557-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210526180020.13557-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 08:00:16PM +0200, Marek Behún wrote:
> The trigger_data struct is allocated with kzalloc, so we do not need to
> explicitly set members to zero.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
