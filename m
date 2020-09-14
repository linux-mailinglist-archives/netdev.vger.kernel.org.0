Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89839268CA1
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgINN5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgINNzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:55:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DC1C06178B
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:54:44 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b12so17662737edz.11
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8AJfHKAzjCxgeo3PXmZ2szS3Y6glsoeWl6fDHYFLX24=;
        b=LiV2AcUeQ2TYEanZF8/iA9sALELaaHgme8N5GZFA91RXFLXdvymQiFBCwCFL1HxMyD
         BweAkD8dum0EMG7YWqQ3jsa/gHQ89WamyRp+INvwWgbwo10JU1gjp2I6N+whFt6xHdv1
         XBFnXyO+TVR9HwVSRF0zCBI1CNIJ7A5uTfor/JGKyVyBMN/vS9X3jspMGE/0BzoCXPbI
         cuoIR/3DM4WLeFpb0n22QWjqKKJqRZAH2p5yZFa0A+AIJ1ISW1uNoqQrthWTDG84yD39
         KwNMOI+4HRoVqW5kg6AsjtfKIzrlElRN9hj2YJB1Zi7R0+w5Hy9UIfLQTE6oeV60JTFT
         aOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8AJfHKAzjCxgeo3PXmZ2szS3Y6glsoeWl6fDHYFLX24=;
        b=beJgFewGraqoKPHAK2y5aAL8Y0imBJq9FlgesfVI2ZkKe5AvVU2RlvE+hCpEai1cDq
         7Rp38KA9LObipmiVyYkXh9921R6m0qEysU18T8Bz04T9ozQN23gBhBuLgCjDC85lUAPG
         blbnVzr2zBuTBvMI8NFXLpHcizGlycDXCAAnegD3IArOBJdiZdhyhX/yNfCvcmbvTlx1
         nOXqSqTSMrT3jyg2Nsq/akf3uTV2TI+odARzBb45L7p62zNYWzZPfBxsMH6mgutfCw6v
         BiY6g55FP0yHVy+ZJPR7w+KxiJXXMW/gl6nqAzJNricPr3qtFMv913oBV57Kbv+p7UjE
         wZ3A==
X-Gm-Message-State: AOAM531E5ot3yJgSlxhxeniFqFB2wxaL8E2Gxjn8zvAOGBw2bFztTqE9
        RoUYKkwshodpYojtrH92drci33c5tek8nZlJ
X-Google-Smtp-Source: ABdhPJxLYQtHKzLeVEPxaKhDDKvLMieI/73OTgaMbgvtcIOyoWEvzSCSOBbQSGyhdsHnOvdLAO5buQ==
X-Received: by 2002:aa7:c6cf:: with SMTP id b15mr4047475eds.134.1600091683275;
        Mon, 14 Sep 2020 06:54:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n26sm7634282ejz.89.2020.09.14.06.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:54:42 -0700 (PDT)
Date:   Mon, 14 Sep 2020 15:54:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 10/15] net/mlx5: Add support for devlink
 reload action fw activate
Message-ID: <20200914135442.GJ2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-11-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600063682-17313-11-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 08:07:57AM CEST, moshe@mellanox.com wrote:

[..]

>+static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
>+{
>+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>+
>+	/* if this is the driver that initiated the fw reset, devlink completed the reload */
>+	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
>+		complete(&fw_reset->done);
>+	} else {
>+		mlx5_load_one(dev, false);
>+		devlink_reload_implicit_actions_performed(priv_to_devlink(dev),
>+							  DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>+							  BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>+							  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));

Hmm, who originated the reset? Devlink_reload of the same devlink
instance?

[..]
