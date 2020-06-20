Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085272023E3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgFTNHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 09:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgFTNHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 09:07:02 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C3C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 06:07:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so12188254wrs.11
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 06:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+z9Rfuog/6M7p7IQGZWdouSSPp/rCnHt+ygTNBUd1jc=;
        b=wkb+Ac+7Dw0GSobClIo59D78cehdCYYCTm+JwPuuk6zA9fmgY4gJrX9Ht4ZbeRTXPF
         3WQJ03prxUsLGMDtly5IJJE5lplwQQ3/MsUKUu3nZNzW3z5ZyvuHOTmCSe8arLqT4IFp
         fb7PJ6cFBQokE97bM0NKF2gh0S+qKvZLlv/kw+bVRLSroIJj29Pkj0o93K5PYl604+LU
         WtJnRgG8JZhZo4H6/Jw2ZhA4t07uiSbmO1wJCg95fcNZ+0uK/JI3nMkbZY4REmHPrq73
         TJLL9V3sbQhRTysJnicbUoIAqMAouhL/zy5Q5VaBEQyXxtmXmEVwJOAboR5MCxGWSdsQ
         IOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+z9Rfuog/6M7p7IQGZWdouSSPp/rCnHt+ygTNBUd1jc=;
        b=WR5LxSqpPT9ziQuvPapcsYfPvqXAl8/NJXsHJk4nmHL5r502H48xHLnhkbLQD7UOYZ
         Qe5UposTiccNuqZAeqCkDtU9z+NZwSsBW48MUD9x2kKT4g6ODxoJfcHQ6MRXORk0435D
         zk0zdkOY2AMd4tythIp2SdMIXXNMXBEwTdh5vDzntfaCbSQILkUwBbMED5pUXz7VXinY
         3wW9+ZFApWLvI78ZoJvcVfYYx4FbPu6+HY6WIY3mpLAE+NiXft9kJNl8igP2NuTIS492
         MuaOylsO9/yWqMDImMTJBF6xNTWnAyAmar2WBx0/Xq8y7NzT4EOW+AyPd/B8YnC3kuBu
         UdPg==
X-Gm-Message-State: AOAM531TMZJ7O649qqhcYGWv8oY1Zv6ZFA0Tf0W/SkAEXtaxA51cCDFq
        D8oAqXh+HeEAMA6o0ZMVAmBP4w==
X-Google-Smtp-Source: ABdhPJy3gMyGF/iG5zKQiAgHFzi5khOaQsfheAgfHcw64VcYRqKZbHCxKdDFfGyPcUd8YBdoHZ5d3A==
X-Received: by 2002:adf:de12:: with SMTP id b18mr308573wrm.390.1592658420415;
        Sat, 20 Jun 2020 06:07:00 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id b18sm10394380wrn.88.2020.06.20.06.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 06:06:59 -0700 (PDT)
Date:   Sat, 20 Jun 2020 15:06:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 1/2] devlink: Add support for
 board_serial_number to info_get cb.
Message-ID: <20200620130658.GB2748@nanopsycho>
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1592640947-10421-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592640947-10421-2-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jun 20, 2020 at 10:15:46AM CEST, vasundhara-v.volam@broadcom.com wrote:
>Board serial number is a serial number, often available in PCI
>*Vital Product Data*.
>
>Also, update devlink-info.rst documentation file.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
