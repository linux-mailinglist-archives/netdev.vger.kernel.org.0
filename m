Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08227310AF5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhBEMP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 07:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhBEMF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:05:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E8DC06178C
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 04:04:48 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m13so7372990wro.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 04:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=isg0DesRi/Hq2hLl7475jjCCpMIFm0fEZvxPt8FgJLo=;
        b=jpaHqKqw488gWf1n6/9/udYV2FiCAjfu+wJVkv7/nJWzRHiYYaJ1oybvNbMCKEWb5w
         rdSF7QAF8Rx9oEXs86EDbP8y4H0Mvh3KoWMEqQuiEiJ5Va0PiXsOYIe6bV5V+ue2sBu6
         HohRwGqHjPwQwe/SdxJIgQL2f1SZ5AAPGLWd3xwnDosnM0iWrrEWeStKmEBODxloI8sG
         OBOsWaKFLxk/J2tkylxu8kk7WVYwv/vmMlLTG6QB5Blrhiq3PWp/BA3MlwYFt8ycTbSp
         xMUVrTE5+QtvQ4cvPe5bz6HDyyaGXsOvkjokI3n31dwPl44EEFJYL9FLADnCyjGf28ih
         /NWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=isg0DesRi/Hq2hLl7475jjCCpMIFm0fEZvxPt8FgJLo=;
        b=UZQTy6Gjd5fx6fVXKviu4JfWcF5HYOwH9BsU/fx1wOOI9mAwRs646lKpaSp5JstNYf
         9VyM1I0VmdPLNN/miJPQbE3v32/uVFjRFO0UPuNwwPlK6h6AhdlJPl9HfMh7Y16zGJjg
         sAUuy7RgJ1An36BeKn3+nITpZJbNHTgGDVbgAtk9T9mNpEDEgXqqKxB/H2kKzRJ3B7BO
         wmNdjBGaemFXfwEtJSkpInluEz6XIwJocHKeoF97HIlZozSWHzje6jUmMxjUevcUPl3n
         7r3lmXcwy3VDgWccJBQiWJrbAcYhpWqq6KZG2g8Ect/ZZFG6L7GDbTCRLRsSPTbDiJza
         CRoA==
X-Gm-Message-State: AOAM533Kdz8PQAqr2qupn64BzF9fJ7uIJPnRNtZO+dsExhMNpnHsRcTo
        UACNoWl/nEsa2qiBC6GI1QXd/A==
X-Google-Smtp-Source: ABdhPJz85ZAdU8UaQR4yw4rp8r3Wg28lOdqcagt5/IEOF4rGJCE0fEmhemoSHOqR2Vs7mmnFNVSVAg==
X-Received: by 2002:adf:8464:: with SMTP id 91mr4577259wrf.188.1612526687361;
        Fri, 05 Feb 2021 04:04:47 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o12sm11814435wrx.82.2021.02.05.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 04:04:46 -0800 (PST)
Date:   Fri, 5 Feb 2021 13:04:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@nvidia.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH iproute2-next V3] devlink: add support for port params
 get/set
Message-ID: <20210205120445.GF4652@nanopsycho.orion>
References: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 02, 2021 at 02:04:45PM CET, oleksandr.mazur@plvision.eu wrote:
>Add implementation for the port parameters
>getting/setting.
>Add bash completion for port param.
>Add man description for port param.
>
>Example:
>$ devlink dev param set netdevsim/netdevsim0/0 name test_port_parameter value false cmode runtime
>
>$ devlink port param show netdevsim/netdevsim0/0 name test_port_parameter
>netdevsim/netdevsim0/0:
>  name test_port_parameter type driver-specific
>    values:
>      cmode runtime value false
>
>$ devlink port  -jp param show netdevsim/netdevsim0/0 name test_port_parameter
>{
>    "param": {
>        "netdevsim/netdevsim0/0": [ {
>                "name": "test_port_parameter",
>                "type": "driver-specific",
>                "values": [ {
>                        "cmode": "runtime",
>                        "value": false
>                    } ]
>            } ]
>    }
>}
>
>Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Looks fine.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
