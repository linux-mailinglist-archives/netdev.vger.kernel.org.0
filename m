Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8133C355413
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344130AbhDFMko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:40:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35704 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242201AbhDFMkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 08:40:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTl0U-00F72j-Cf; Tue, 06 Apr 2021 14:40:34 +0200
Date:   Tue, 6 Apr 2021 14:40:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA
 nodes
Message-ID: <YGxWwhUYutuN8QJT@lunn.ch>
References: <20210405164643.21130-1-michael@walle.cc>
 <20210405164643.21130-3-michael@walle.cc>
 <YGuCblk9vvmD0NiH@lunn.ch>
 <2d6eef78762562bcbb732179b32f0fd9@walle.cc>
 <YGuLjiozGIxsGYQy@lunn.ch>
 <1b7e58ba2ec798ddda77a9a3ab72338c@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b7e58ba2ec798ddda77a9a3ab72338c@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But then pdev will be NULL and nvmem_get_mac_address() won't be called
> at all, no?

Forget it, it can be added later if there is a real use case.

       Andrew
