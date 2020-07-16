Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E964B222801
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgGPQHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:07:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E37C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:07:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so7575322wrw.12
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CeJugqCvkOwbo8fdyAIcbK1pDrDIJnQ8DStY11i7bX4=;
        b=wzRg4D6NAO690PAnKMXNolDgcAakHD3SiKM9LXMt6jN+fgWM23NGHhcD4x0813Oh7+
         fvtRygpvrXJiqs9LHoaA+jxuOLyP41jm7FtCCm9rVl/RgPCbLt9VABmPQNIKGsc4EJCd
         7UaFzRK2KQ3EpSJxWUoQFHFpIDpqYFg+4PshmQuCaFJ/FVer2PieZfRupQSs6vNPpbtZ
         ttiq0SLfpGOL2UAfjkC8UYPY8u6GRcPBeHRfOyAXsx7BZFoC5iBSd5AVcfzbhU/6/rIS
         1vON+40wT4/cu0Yy08sndAbs35ZNVG0hJTwLELsK0F68tL65l+u/31cYviGquIo2MXif
         xLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CeJugqCvkOwbo8fdyAIcbK1pDrDIJnQ8DStY11i7bX4=;
        b=h9cITeflebJYrS5dHrZ930BqyxMC8ZjYQXif0XDk7fhdSuAvIshzAwbUuBM1trghzk
         rWbnoj08XXUSmuEiu2qI0LfwH7lXFDvoQNXckWhbU95KVdCzFF/bk9Lh5KrRX1I49iLq
         qiXAA7SjIcsOpz3aMkMXUviZKGp6YyZE5FcyPD0aslcbmYjcEs/EfbGu3Uep9x8nAnU6
         ig0ruHMzL2IU7igqXWdS5V8c+RBSx8ZPflD9buin+NULfu4BwbBJ+nv08stzFPt98Jps
         g9+ulrHsiBIxy6ZAzJIC+siZdRBcWcypu0zIvxnO1uN15OF8so1cyaVE1WYZOzB3B1z+
         +Ywg==
X-Gm-Message-State: AOAM530D5hVPiN331/FhEQtMquqLbFZesAvGmP4fjyqOC3D3Yg10+NPw
        yTP3xaBPRcdYGtvHjjLhAQpoWA==
X-Google-Smtp-Source: ABdhPJwiRLfRbO0Uzp2CWhbDwUS4FfDQFQcaAMWXg5XvIh5Csh0j4xnSGKdGgpQjPH1RMU8rUWnCYw==
X-Received: by 2002:adf:db86:: with SMTP id u6mr5928752wri.27.1594915651000;
        Thu, 16 Jul 2020 09:07:31 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l8sm9667924wrq.15.2020.07.16.09.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 09:07:30 -0700 (PDT)
Date:   Thu, 16 Jul 2020 18:07:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: q_red: Implement has_block for
 RED
Message-ID: <20200716160729.GC23663@nanopsycho.orion>
References: <cover.1594914405.git.petrm@mellanox.com>
 <18f80c432a0d278d32711bdafdd9d2376028ad50.1594914405.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18f80c432a0d278d32711bdafdd9d2376028ad50.1594914405.git.petrm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 16, 2020 at 05:49:46PM CEST, petrm@mellanox.com wrote:
>In order for "tc filter show block X" to find a given block, implement the
>has_block callback.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
