Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA4547E8AF
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 21:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245017AbhLWUUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 15:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240669AbhLWUUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 15:20:17 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4788C061401;
        Thu, 23 Dec 2021 12:20:16 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id n16so5185041plc.2;
        Thu, 23 Dec 2021 12:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sPet+PosrSBCRJEihC0HmK7vZBPa14bsj7rvb5v/vls=;
        b=l3zYg8UDeQw6kYJsmbP/vjwyyaWs1rQswzSzermkW7GrdfZPHK5tD5Yx/OFXxej2ME
         5Zk5QLvPd0km1Lz6TXcRupA1uEeK1Ojg0Z5qQ8DtEHIBngeABlWSKn/Cd8N5T7LmQGet
         7dD78dzoPR9qupqnap+TJExI0SHK7+y8I/r29gbWvpWI8TNaHdPkBragRoDJKJ7BHIFX
         VFETQnKh3wXkPudq9/6kdbAhrYj8e5Rpce/PHky9AomTaAhRhMpPMAdeiRmFhI56ZRxm
         SnSsCspsVBoAalLsaf0HI0YNsTLpys402Btp4yZ2oxBXraVv1SPyUjlijBHsPQLWew/S
         degw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sPet+PosrSBCRJEihC0HmK7vZBPa14bsj7rvb5v/vls=;
        b=oiGTgvXancD5wwTBtHuCI43CDm0eHqjIvKz3Js7YgEZV+1LuCkYvuz6oes+xb7D6gs
         QZiefZDjUQJMBeAGfIhMroi8J4w74gPMRZn1PXPRhQsKnkxnDSHcE9wD6/5J9GVK0FPH
         WJ6gd7mxbS+StEAzPlVbieOnDhzMXmogNPtpt0ARSARpGMIRsmRhPDR4OxVywymTpVHf
         BKY0O5Vrqe/rpBYiVdxhPV90YGlcIdZT70+NblGd45WlXnLtX40gXAi/R3mj3mQNQzch
         6Ri1eX0tFLNLKilRSIuJQ6HPIrsqPYF7RA5Yc0pwFEv/1tjw1CMCSJ+VvRioTCEo41L/
         r8iQ==
X-Gm-Message-State: AOAM531dylSzcg9x4bpMah+2fXp9h2k3C8lpUvwmOQQ3QKKowAw4Y5ba
        NcfyQxrgH/JGFrF8zj1VSXw=
X-Google-Smtp-Source: ABdhPJx18sRdTtsBYIbSQV1tyTmrbn8WfeyWExkKM4G7ftOW8/7rlt/sIYdb5vpx/hlN8MyNJBlhZQ==
X-Received: by 2002:a17:902:9b86:b0:148:c86b:5090 with SMTP id y6-20020a1709029b8600b00148c86b5090mr3759826plp.89.1640290815945;
        Thu, 23 Dec 2021 12:20:15 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 22sm6977862pfv.173.2021.12.23.12.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 12:20:15 -0800 (PST)
Date:   Thu, 23 Dec 2021 12:20:13 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2 0/2] TJA1103 perout and extts
Message-ID: <20211223202013.GB29492@hoboy.vegasvil.org>
References: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 11:34:51PM +0200, Radu Pirea (NXP OSS) wrote:
> Hi,
> 
> This is the PEROUT and EXTTS implementation for TJA1103 and a small locking
> improvement.
> 
> Changes in v2:
> - removed the patch that implemented PTP_PEROUT_REVERSE_POLARITY and
> reimplemented the functionality with PTP_PEROUT_PHASE
> - call ptp_clock_event if the new timestamp is different than the old one,
> not just greater
> - improved description of mutex lock changes
> 
> Cheers,
> Radu P.
> 
> Radu Pirea (NXP OSS) (2):
>   phy: nxp-c45-tja11xx: add extts and perout support
>   phy: nxp-c45-tja11xx: read the tx timestamp without lock
> 
>  drivers/net/phy/nxp-c45-tja11xx.c | 224 +++++++++++++++++++++++++++++-
>  1 file changed, 221 insertions(+), 3 deletions(-)

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
