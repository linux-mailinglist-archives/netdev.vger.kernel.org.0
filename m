Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B5D366DC0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbhDUOKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:10:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237040AbhDUOKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:10:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZDXq-000K1s-6o; Wed, 21 Apr 2021 16:09:34 +0200
Date:   Wed, 21 Apr 2021 16:09:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Mike Rapoport <rppt@kernel.org>,
        Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] net: korina: fix compile-testing on x86
Message-ID: <YIAyHq0Mzm/bfsNQ@lunn.ch>
References: <20210421140117.3745422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421140117.3745422-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:01:12PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The 'desc_empty' enum in this driver conflicts with a function
> of the same namem that is declared in an x86 header:

Hi Arnd

DaveM fixed this yesterday. It should be in net-next.

      Andrew
