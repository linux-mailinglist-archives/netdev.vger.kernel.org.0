Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53326B7CC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgIPA3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgIONr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:47:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F11EC061A29
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:37:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so3421893wmi.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yqLuuHaDPyMZVYvimcEZ7loynWyyZ/gx/ESoc2H8RgI=;
        b=NbFFa/sH+YSHIMHYgG6y+VP6Rtaq7brZnnEH5p9fkhvhHrS70345ou7fSALoGVmJEb
         iQR1crdjRF9adAfUXYlZKFmFpZjm/TLUNapOr1q+jc33+3mA78YJimFt/qtHQApbP1PZ
         9CAZ24egKoDdBnVZZUhuPJEvgfIiddMReF+1fH0bc7AlJ463gjh2JJRTc83/KpgHbOul
         X/S5BuThOTrRcMsLAaU9EHU9bRZesA0P1e4zVmVc081PywUpFB64hrQaqBKCWFACJbO+
         giZQQ00zWCI2DPoERJCzyZ3YpiEfxgko1GnPxi7xJF7mu+bYmjNK/pBgGAmCwkO+Jq++
         uW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yqLuuHaDPyMZVYvimcEZ7loynWyyZ/gx/ESoc2H8RgI=;
        b=U2hU/XsCDdA53AUiAO9CNU1hxSIqwOAsXCQdUPF2WvZ8+NedsTHpn8TUnj+2fRxGJm
         BgUojXB0L59tVye9EAnz53dXKbUBa7egYtmMnVQqALMpXt3R4jLoKaVZeTYCs4d6giVk
         ymiFP0hTKkLlOnmtiMT7qL4pMAFAc3DJ0HH31adR5JtXD6H2h3ULQ/RhMIr5D3gpfTAZ
         7319lm1sO/3RIFtgXn/SaTFX8ozybvWDjvnc/zI2CnE2/KfXxQMbKs3/ZzP0PY/K8hZA
         H0OXw+z38LrVdWz/xwu+FegNjVVthlDMN35izVooz+9UyAiLTrKvEQItzQsWb2K4PWJx
         d6rA==
X-Gm-Message-State: AOAM5310EZK5NQS7yEnhJPiZAiitsm025vo6G7bpeh5QCdaK5q0wXra/
        c0ekQdEFipHTP+e6DscW/ephfg==
X-Google-Smtp-Source: ABdhPJwDuI1DT+CUN2L98nHfTizNA421ofnREorseq+7fgmsW7YGpQnQiJxwQHh+JLrZGtgnQVxmqQ==
X-Received: by 2002:a05:600c:4104:: with SMTP id j4mr4669381wmi.36.1600177026314;
        Tue, 15 Sep 2020 06:37:06 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d18sm27231619wrm.10.2020.09.15.06.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 06:37:05 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:37:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 10/15] net/mlx5: Add support for devlink
 reload action fw activate
Message-ID: <20200915133705.GR2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-11-git-send-email-moshe@mellanox.com>
 <20200914135442.GJ2236@nanopsycho.orion>
 <565e63b3-2a01-4eba-42d3-f5abc6794ee8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565e63b3-2a01-4eba-42d3-f5abc6794ee8@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 02:44:02PM CEST, moshe@nvidia.com wrote:
>
>On 9/14/2020 4:54 PM, Jiri Pirko wrote:
>> Mon, Sep 14, 2020 at 08:07:57AM CEST, moshe@mellanox.com wrote:
>> 
>> [..]
>> 
>> > +static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
>> > +{
>> > +	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>> > +
>> > +	/* if this is the driver that initiated the fw reset, devlink completed the reload */
>> > +	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
>> > +		complete(&fw_reset->done);
>> > +	} else {
>> > +		mlx5_load_one(dev, false);
>> > +		devlink_reload_implicit_actions_performed(priv_to_devlink(dev),
>> > +							  DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>> > +							  BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> > +							  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
>> Hmm, who originated the reset? Devlink_reload of the same devlink
>> instance?
>
>
>Not the same devlink instance for sure. I defer it by the flag above
>MLX5_FW_RESET_FLAG_PENDING_COMP. If the flag set, I set complete to the
>reload_down() waiting for it.

Hmm, thinking about the stats, as
devlink_reload_implicit_actions_performed() is called only in case
another instance does the reload, shouldn't it be a separate set of
stats? I think that the user would like to distinguish local and remote
reload, don't you think?


>
>
>> [..]
