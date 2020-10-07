Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63028622E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgJGPes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbgJGPer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:34:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84FDC0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 08:34:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k10so2712936wru.6
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+XHpDefsBIm2Wcc7l0A0wAeXuSoeHx4lJ/xyRHbCKCg=;
        b=MZIoX+EX3cuOi3WuU1lL5WA2iLCEE61m/usYjvBnstLFDugdB5GoFxTY2LbDmj8qiE
         rXP/I2ABb0GsBXR17uBboT/sAy6E94KRqoBI7M8B40plqBx5xfZR6CRTEoySO4pK0N0v
         29evrmQHFbqA47QyR9zimpyqpE1HjvRsisqmpfkyz/r54HJgJ8WaeQsoWu1qKQ2LNgGG
         7xFKt2Ag5gM08crdcyw4iN8LzXgwMAKCyim/AZMFW0BdnVXWuaN7IvvLcD8LXRBU88B6
         34eoL0KaR5G5Q17g+BfeklFJOFz2yFh6+28XzPwXwNw36aEEyb1/H191b27pax/hj0/2
         dMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+XHpDefsBIm2Wcc7l0A0wAeXuSoeHx4lJ/xyRHbCKCg=;
        b=kgPiCwArCD9Gb31tDMkC5fzHYlGxFK/LhUtdsC3WroO/OzHGx2oaj+knHoiBH4Enfe
         SZl8HESvkB17dBPgrgCFlJOD79rlY86huuzHc2EIU5EYbU1ZDXH46JuN9Q1Ziz7Rw4Ot
         pLC4/hN990gg8uhlYaoX7a8XBDX+qDxQK8478N/px1mIJ9dta2gy7QcbRVZpylcZLkeo
         iCrQIuI2rcjIPIZLGHGJr2owgSBXLMze9nlWrA5rgYHRbdxVSB9sr1vvKOhaXTjaeSdM
         DPHcUA7vAOtHGMproF/b3Ht9xllXdnK4PzQNeNuYS73rMO2Lir2p5VrWGXdSax+6CkDa
         h8LA==
X-Gm-Message-State: AOAM532Gfl7f2BcNdnn5rkPXqm3juwLCo1Q/DHaHGc/Z9qPz65qabv5i
        be/E+3iA+w6UVVjF5aeua177fg==
X-Google-Smtp-Source: ABdhPJx1DMuOtEbdBBSv/OykWRlla0M47n4Zd0oyrTdowQSBvswRHUyoxe6fBa5XHm1CDpATIXU2dw==
X-Received: by 2002:adf:fc0d:: with SMTP id i13mr4332489wrr.156.1602084885509;
        Wed, 07 Oct 2020 08:34:45 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t6sm3914101wre.30.2020.10.07.08.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 08:34:44 -0700 (PDT)
Date:   Wed, 7 Oct 2020 17:34:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/16] devlink: Add reload action option to
 devlink reload command
Message-ID: <20201007153443.GA3064@nanopsycho>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
 <1602050457-21700-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602050457-21700-3-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 07, 2020 at 08:00:43AM CEST, moshe@mellanox.com wrote:
>Add devlink reload action to allow the user to request a specific reload
>action. The action parameter is optional, if not specified then devlink
>driver re-init action is used (backward compatible).
>Note that when required to do firmware activation some drivers may need
>to reload the driver. On the other hand some drivers may need to reset
>the firmware to reinitialize the driver entities. Therefore, the devlink
>reload command returns the actions which were actually performed.
>Reload actions supported are:
>driver_reinit: driver entities re-initialization, applying devlink-param
>               and devlink-resource values.
>fw_activate: firmware activate.
>
>command examples:
>$devlink dev reload pci/0000:82:00.0 action driver_reinit
>reload_actions_performed:
>  driver_reinit
>
>$devlink dev reload pci/0000:82:00.0 action fw_activate
>reload_actions_performed:
>  driver_reinit fw_activate
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
