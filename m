Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A741474FF4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390375AbfGYNqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390232AbfGYNqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:46:03 -0400
Received: from localhost (unknown [106.200.241.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5404922C7B;
        Thu, 25 Jul 2019 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564062363;
        bh=jeED7CtcQhma9mVbZ3E+h3KI2qfv68gcleUFtKH45OI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kb/LkOg3viPhg32zGvoKWgihzMOwDt3EygkY5JRqNCLz2ZAFJZDq+CBxRqrJMFsiO
         C1eDv4ZV0cdeFjlVRU9GUmddb0pCMA908qr8UIfKuRUjY4CBTsyDBGbeO9tGAy5o+x
         M2UpRKOFE8EAFkSCeJ2MHl/EoEyAnDcHN3yuBOgA=
Date:   Thu, 25 Jul 2019 19:14:49 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-doc@vger.kernel.org,
        dmaengine@vger.kernel.org, alsa-devel@alsa-project.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 15/22] docs: index.rst: don't use genindex for pdf output
Message-ID: <20190725134449.GY12733@vkoul-mobl.Dlink>
References: <cover.1563792333.git.mchehab+samsung@kernel.org>
 <45d57666e5738a0b85e948b0e94151fe1b1f9274.1563792334.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45d57666e5738a0b85e948b0e94151fe1b1f9274.1563792334.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-07-19, 08:07, Mauro Carvalho Chehab wrote:
> The genindex logic is meant to be used only for html output, as
> pdf build has its own way to generate indexes.


>  Documentation/driver-api/dmaengine/index.rst      | 2 +-
>  Documentation/driver-api/soundwire/index.rst      | 2 +-

For dmaengine and soundwire:

Acked-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
