Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C21627FF78
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgJAMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731828AbgJAMtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 08:49:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DEEC0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 05:49:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so2792447wme.0
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yyLMfzb/o8hIuW//ZkJGu3fCQDP2gmFzEzNtOlSIXTw=;
        b=eIOBDhbGdlEbZpLsBoneOjisPLCLeYjAU+76GBWLWuJhWM3UaY95TH1BJdnWTPS54l
         2ljEs+FBQyNhjbZrcs7PPzaPSraFBgPIIBsYiFfgdp3EpbeBsNtJkb8IdHHm1fXoVvY4
         frmhF6dDyiSs9gITepGZqRuRV1n0Yp56JEMXOt1lgCfjARwerHW8TfuaDQQdu1eplysx
         psQhJgc2IITFwAm6ARiarxhOdenUY7/wJGtV/l4BY2MOGYIiD18CSuqT3GDaTc96HCFi
         6VPOTtTh7w7YPp4pXtfGmcnqHqZL7Vdt8EqaKRj2gpjymKlu2ZalJBS8TcdTyBWtQfFk
         oV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyLMfzb/o8hIuW//ZkJGu3fCQDP2gmFzEzNtOlSIXTw=;
        b=B2h0lN+2bSAmoo1UeMWasypDeSFflEAA/fA5zbUfJRrPNNQsN6WafuzcrYOVN9HqxN
         k6mIm2Z22DRXZ8b4DSnC7DYrpNR3lLo+DOl2Cw0uQQrsbmeDHZGO0vV8SYGlTsAKt2De
         WuyzFk35nICJpRFxD8IJhM62ZKGm2RorDeRnKovUk3XhcluA5DBv0YHdsID+XkIdVwfT
         +N38NYuxw1k/en7Xxk9N1RYNUsDDblcaU9mzsUMQfLNSLuhcO+uCOELZ1ah9f9slll/5
         N+kxNO4qOlCZtKwhyOIT85zpuRxSQlZrQ7iaAfXTUiAGriUlvemlK54/oI5tBvwAGDiq
         4S/w==
X-Gm-Message-State: AOAM532SkKSpxST47GEApajKb/xMIf59K7MyPPTYrxcVb/a57I7Vmd7A
        i4h1GAWcYxKqOfBblOOZHokSVg==
X-Google-Smtp-Source: ABdhPJztTyQtl0mkxwswpfNCf/7iCTP9fY6RM8UHr294gh0Wwi5PqNq1U6HZoJ576D9n0qQDBVzmFA==
X-Received: by 2002:a7b:c1c3:: with SMTP id a3mr9059114wmj.68.1601556571012;
        Thu, 01 Oct 2020 05:49:31 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t16sm3436694wmi.18.2020.10.01.05.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:49:30 -0700 (PDT)
Date:   Thu, 1 Oct 2020 14:49:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@mellanox.com, idosch@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface
 implementation
Message-ID: <20201001124929.GM8264@nanopsycho>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
 <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 12:30:18PM CEST, henrik.bjoernlund@microchip.com wrote:
>This is the definition of the CFM switchdev interface.
>
>The interface consist of these objects:
>    SWITCHDEV_OBJ_ID_MEP_CFM,
>    SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
>    SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
>    SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
>    SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
>    SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
>    SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM
>
>MEP instance add/del
>    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CFM)
>    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_MEP_CFM)
>
>MEP cofigure
>    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM)
>
>MEP CC cofigure
>    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CONFIG_CFM)
>
>Peer MEP add/del
>    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>
>Start/stop CCM transmission
>    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM)
>
>Get MEP status
>	switchdev_port_obj_get(SWITCHDEV_OBJ_ID_MEP_STATUS_CFM)
>
>Get Peer MEP status
>	switchdev_port_obj_get(SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM)
>
>Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
>Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>

You have to submit the driver parts as a part of this patchset.
Otherwise it is no good.

Thanks!
