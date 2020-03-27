Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1D195462
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgC0Jou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:44:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55041 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgC0Jot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:44:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so10709496wmd.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8lKNlMpFMNvla81GQR795Ns5/lczvRDq/J6TiZHdTj8=;
        b=g56CaV5+rca4ztT2A1NUAycMuHE0E1v2b7z0MBljTbWuhUU4nTSoevmrhQ3msWZWC2
         9ttbMiZD2yg/DPe5D+z6OCK87nMPIAWkOr5xcia/TQuKi5Bt2H5SgFdC5BOlE6Z2L2rq
         /ruLHYR7zdtNNBS6yDVfOI+kTkEipntSSUR0ZXcjo7SO7Mb06Fw2SqS1+n8/T4EvZdEW
         4T5JT/yyYr6AHdpuOZWNohR4lMVtoTbPR1gq527fBTpVfHHZiFTL35Qm9RIEH1dcnRp+
         J6Kg0Nsj1QnGO6ZN1/YlWbGM2OzTadxIF35Dh2yoZJ3Z5jwpfmPO/7LsSfdrKhDQPOt0
         X8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8lKNlMpFMNvla81GQR795Ns5/lczvRDq/J6TiZHdTj8=;
        b=uDhSaD1s2JoxB+hUyS4NTg81E0Ctv3du9L+FdahOjK8gRoLVpq5jHG70K3/oHJ3U74
         sAxLjac4k/JTL8Um3p2BXy3QmvfNTgJDhhf323QzCwVqnfiqyEODa6wlPdaDxY6BeEw3
         EI6Dme1PRkvX0CsYY9Net7BH0A8ZvCO3wvVVbaUBhR8xeYlHRwmiFKqsMXZtJvXTFNkW
         fI8YsQB+uLzQhmQiyQxAW/XmJox2uO8LpFpl/FYzvA0EJ4ScNrGR4BKqhq+Mw5YxU3hq
         5rqgwtKjCfj1emtkG7aGxL2XGZC7UdOhjAJRQuhYWwEJ6tt5AwtvKN67xhJov5caIeYV
         ca9g==
X-Gm-Message-State: ANhLgQ0X/oz4XQZeY15gxlvUID70LUD7gfwLI5171G0li+riNZ3dQ7pl
        0/Vh+fa9h98/hmKX1vMSExS2eA==
X-Google-Smtp-Source: ADFU+vsP5UKXTmI3Kp55e6+8L/Q0rKyma3hQFKHdYRyNjR91Yxav8WQf6n1LOqiugv2H11jcnNuaWA==
X-Received: by 2002:a1c:3dd7:: with SMTP id k206mr4582166wma.147.1585302287759;
        Fri, 27 Mar 2020 02:44:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k3sm7032610wmf.16.2020.03.27.02.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 02:44:47 -0700 (PDT)
Date:   Fri, 27 Mar 2020 10:44:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v4 net-next 1/6] devlink: Add macro for "fw.mgmt.api" to
 info_get cb.
Message-ID: <20200327094446.GL11304@nanopsycho.orion>
References: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585301692-25954-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585301692-25954-2-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 27, 2020 at 10:34:51AM CET, vasundhara-v.volam@broadcom.com wrote:
>Add definition and documentation for the new generic info
>"fw.mgmt.api". This macro specifies the version of the software
>interfaces between driver and firmware.
>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Jacob Keller <jacob.e.keller@intel.com>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>---
>v1->v2: Rename macro to "fw.api" from "drv.spec".
>---
>v3->v4: Rename "fw.api" to "fw.mgmt.api", to make it more common
>across all vendors.

Sounds fine.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
