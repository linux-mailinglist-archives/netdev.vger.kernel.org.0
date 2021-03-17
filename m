Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A833EA04
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCQGoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCQGnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 02:43:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9B1664E41;
        Wed, 17 Mar 2021 06:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615963430;
        bh=iH8Ve2p8zpUYfjNYH7sqjyMrbwB/8XRj3S+UrLJdl/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rbYf0LrBh9t2c+fWBoVZjVVfhu9bbqf/+JW632isYl29N1IWLdHcIF9KqAxU+xk+E
         ushv7wjZFePrNMu+xj+UEPnBsgitoYmI35w0z3N5h5Xv0XZxups6KT+6SPdWm+JkcM
         5Eeh04kVQLwFPQb4UpVJs7rzhd56qdsozNZ2kfQaAyBZbspIvmVLzMJaQE5InCL5+O
         47lLeVf/4VvtEbLR3IjQAatknyvvWjay9KxpmeeRk0Hj8Epi7ySgYv4vY4rfpPJAJq
         TgkbAvNmKUINISsggC94RN9sTvDRwYA7m9FWCSdVRGVZUoRFgQKf9w/mwhFg/A4a3p
         OVRWNL7NOEN/Q==
Date:   Wed, 17 Mar 2021 12:13:46 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/4] Adding the Sparx5 Serdes driver
Message-ID: <YFGlIuKahuFePpY0@vkoul-mobl.Dlink>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218161451.3489955-1-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18-02-21, 17:14, Steen Hegelund wrote:
> Adding the Sparx5 Serdes driver
> 
> This series of patches provides the serdes driver for the Microchip Sparx5
> ethernet switch.
> 
> The serdes driver supports the 10G and 25G serdes instances available in the
> Sparx5.
> 
> The Sparx5 serdes support several interface modes with several speeds and also
> allows the client to change the mode and the speed according to changing in the
> environment such as changing cables from DAC to fiber.

Applied patch 1 thru 3... thanks

-- 
~Vinod
