Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663A5193BCD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgCZJ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:26:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50657 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbgCZJ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:26:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id d198so5685942wmd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L84m54ZYjAEDRRGXL/i2LXv4b8FpwS6ZP/nazqJWMxE=;
        b=Cnj4NCt2Vk0aYifQE92oEvz3k4bMxEsmuEjrsucYbL5UmM/ljxqBVzpWymmX1uofqG
         9o1Ugb14LR42oyIjSHkrvr8vXXlX18uKqDOjoxfXcz6RHr8ovAZngYuBK3af6Mwu8Cov
         hDLwoFgllcGbkcFTml1yhBvTFZjpE8+9KPmXsBy9Hpg8X5aKQRoaI8zsATqAWyhoCVuK
         cLHD1DPAUQ4WCp4gdSThN2HeAR30A7QCRB7Dw6pdYA1nvpyG13xGjRIlZVR5pL7A3g+b
         K9A9FHK5YUxYtv68Lfl+J8xY+YG8Ez/9xecOTjnB53RwUIZgR+fFSecpvUHqWnykcw4Q
         zdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L84m54ZYjAEDRRGXL/i2LXv4b8FpwS6ZP/nazqJWMxE=;
        b=N32b2ddembpwFT8aq0I/QPdumfXPrCJtXGySoTCx1GdR/pgE0i3KOB+aVjzZXeriMd
         4B7+Ay4eZJgsUXcts5/q5krBOoSv5PH6Zwz3TbIunUwutz/V/05iMQf8ZnHBLFHASBNG
         7NPAONp9GZ8rdEK9VY6ccEhJvIBJww2i0XAa+EsD19iU3begibjyBzut58rveLH1Dfvi
         c9WCuJ5JNaxC6TZ+/ke4VQvd93rd5cmnSKWf3RntGjDvVyfsEML3KvdIun1bddCAkCKY
         Fi0S6xqr+tLAoZwNQ2j1ejND/yVd7XOiPFx3WFvC0R0jJ/GQGgFN5PT6ulR2MNAFR4uT
         Xh7A==
X-Gm-Message-State: ANhLgQ0hJdFKEJi9/c8rWxTCwfffnWO3ViHNJCdTnP16iyADrT5mRvrU
        /GEG6SA8q5kI3USGpnh8y54YQQ==
X-Google-Smtp-Source: ADFU+vuNNKqYa3zcfCW5J5PJaitV+evvliy+SDcNo5uxtWfnJ8fjSo8p+HaGzfH3D3EiXLSPxUyD3A==
X-Received: by 2002:a1c:1dd8:: with SMTP id d207mr2265582wmd.90.1585214809657;
        Thu, 26 Mar 2020 02:26:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 127sm2772450wmd.38.2020.03.26.02.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 02:26:48 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:26:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 3/7] devlink: Add macro for "hw.addr" to
 info_get cb.
Message-ID: <20200326092648.GR11304@nanopsycho.orion>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:27:00AM CET, vasundhara-v.volam@broadcom.com wrote:
>Add definition and documentation for the new generic info "hw.addr".
>"hw.addr" displays the hardware address of the interface.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>---
> Documentation/networking/devlink/devlink-info.rst | 5 +++++
> include/net/devlink.h                             | 3 +++
> 2 files changed, 8 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
>index 650e2c0e3..56d13c5 100644
>--- a/Documentation/networking/devlink/devlink-info.rst
>+++ b/Documentation/networking/devlink/devlink-info.rst
>@@ -144,6 +144,11 @@ board.manufacture
> 
> An identifier of the company or the facility which produced the part.
> 
>+hw.addr
>+-------
>+
>+Hardware address of the interface.
>+
> fw
> --
> 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index d51482f..c9383f4 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
> /* Revision of asic design */
> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
> 
>+/* Hardware address */
>+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR	"hw.addr"

Wait a second. Is this a MAC. I don't understand why MAC would be here.
If not MAC, what is exactly this address about?


>+
> /* Overall FW version */
> #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
> /* Overall FW interface specification version */
>-- 
>1.8.3.1
>
