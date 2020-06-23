Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B92052DE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbgFWMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:50:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgFWMuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 08:50:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jniNZ-001qaX-AH; Tue, 23 Jun 2020 14:50:21 +0200
Date:   Tue, 23 Jun 2020 14:50:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, jcobham@questertangent.com
Subject: Re: [PATCH v2] dsa: Allow forwarding of redirected IGMP traffic
Message-ID: <20200623125021.GC420019@lunn.ch>
References: <20200620193925.3166913-1-daniel@zonque.org>
 <649fde96-c017-9a6c-1e08-a602e317c60e@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <649fde96-c017-9a6c-1e08-a602e317c60e@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 09:55:09AM +0200, Daniel Mack wrote:
> Andrew,
> 
> This version should address the comments you had on my initial
> submission. Does this one look better now?

Hi Daniel

It does look better. I'm just trying to find some time to test it a
little.

	Andrew
