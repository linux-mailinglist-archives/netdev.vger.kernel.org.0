Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AB01C282D
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 22:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgEBUKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 16:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728484AbgEBUKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 16:10:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C397AC061A0C;
        Sat,  2 May 2020 13:10:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s10so5086541plr.1;
        Sat, 02 May 2020 13:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NNYnyHd7wPwHHcfClp0Z4S4fofjD7iMF04FKC5dbzIU=;
        b=HUflaO23p62DZdDEeTCccMuKW1xuIrzTP24VJ00PZ0iI3A3degj7m9NeCg2Lhd9+iu
         5WVff+AD4yrXEIcO/YF308KK83gm43pkWA2/Zt91mNvSDmTfAyRRqQgxaIpCTsPMxrjH
         6OzYNiFJV/y1aZoA2AmaQBZpuOsM0spnViMRrBKzYBilrS4WTR9uGJlZmt1z9/ZDWp6Q
         ki+14BLS0swWqhJk9MWHifGDpJrEYReuUM43hRWT6DFJ80GjcK7UeCjmrlcV0gYwUXGx
         co1aVM6/bvXIckKBo2tqYFUOv4Piff4/jmn7f96xEm8WmMe4WzQ6k8zTHICRUnPbwus/
         ghCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NNYnyHd7wPwHHcfClp0Z4S4fofjD7iMF04FKC5dbzIU=;
        b=G9T+jJbjXac1MufkVNToBA8+HGdFtsBe5Fr3W3LQK8YoAKtnor73hfETwshE46DMyi
         M4FZRF1QmIN5t/uKHNrl583JbB3tT7YTtl0+4Usc8m9LYH/1b6KOsManaK1wPnq8i2qR
         QsMF2CuN6ds19XUuKy8JCefPZLMbD9F4lyA/ZR/rOLsVsHim+ziPk/WtUiUtryg/YM0U
         LJMzIBaNwN/zR4K1E2/SjSVTA22WVhs4iVLLIFlBaoVBd3GAOB4zJdZlB/j3fZZTYu+F
         1D/PRRFT0Hvm7Do6aYh7fOOty/jKzGlMlrfxIi77epEDwCcco5NEZS2Pza+08ChVY1s7
         pnLw==
X-Gm-Message-State: AGi0PubK8tyWc9MtxGp/RNuvp5iFvfDSX04WUjkOCln2o3ZUnglvAAL6
        f2S7NulRJ4Q5h84m1w02OEhu/cs+
X-Google-Smtp-Source: APiQypLQCn9ULLnHMXJdtOgn4OPohL36oTa6V/KLfBWO3qMDtEuBRGy6K++hW2E1tPCRZ0WoWPz23w==
X-Received: by 2002:a17:902:bd02:: with SMTP id p2mr10639006pls.72.1588450200432;
        Sat, 02 May 2020 13:10:00 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c4sm2836084pjs.0.2020.05.02.13.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 13:09:59 -0700 (PDT)
Date:   Sat, 2 May 2020 13:09:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/3] ptp: ptp_clockmatrix: Add adjphase() to
 support PHC write phase mode.
Message-ID: <20200502200958.GB30104@localhost>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588390538-24589-4-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588390538-24589-4-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 11:35:38PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add idtcm_adjphase() to support PHC write phase mode.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
