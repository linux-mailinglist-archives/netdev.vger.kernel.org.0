Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4C42CF11
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhJMXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhJMXTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CDF2610CE;
        Wed, 13 Oct 2021 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634167035;
        bh=Ptyt9UJNndgSBk3QrI5KaQyVP/3Uk80I7Jpreh1Idn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oLP1H82CeBuk7jE3wzU+wOX+l6sO7z/aSQN7m+k7jKCp30l7D0zRVv1EnyZY7Hzjs
         irbFHbnWJbb02YwJgXF69kFnE2DenHoUq8BQNq87pUpJLOqSYhe6NNy6dtG5I5awTK
         K4idjeHs7nDONrIsTNYr4DdoIwBUCLeY5wv5I/pJr1pxU26ywB+AeT0XU6QzRUjT0q
         BJzdFNgf5YVCvD+icRRpj0iLkcDmeMWTUMQswXo7a4v8eEVAh4KIBBjYyADIHCfba8
         A2Dk7WRovc9A9EQFXlNYyMUvutf4ynuRSeBHErS7qvy2Ja/IQr6XGt28EVn9XalwVx
         S9/X5MUUM2Ofw==
Date:   Wed, 13 Oct 2021 16:17:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net-next 4/4] ice: Implement support for SMA and U.FL on
 E810-T
Message-ID: <20211013161714.00b332b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012163153.2104212-5-anthony.l.nguyen@intel.com>
References: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
        <20211012163153.2104212-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 09:31:53 -0700 Tony Nguyen wrote:
> +	data &= (~ICE_SMA2_MASK_E810T);

Odd bracketing.
