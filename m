Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20DD1943A1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgCZPyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:54:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34556 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgCZPyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:54:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id 65so8476901wrl.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 08:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qivbuD1I15yUFqD9pKw/fJo/zrUz/8AP+MvKncHNu4g=;
        b=DiHUdmzc3T+R5aZkb4AhfR+PtUj6NYPuwcIUYWpXOEGbBvBjLG/nikfwzEpNksK24J
         Hfb3PqpOgC3b7sn4euKx9jF8tAmwLzy6AHolLqzXUYxfJLElKFTDSRYeBV5HNv2j1w0V
         HeaeRHcxbFWOaDtzstOviOvcHR+G8tXTF06WReAhwnEd3GzA+2HBYa7EC8RVfYjay/O9
         sbTVqEleBQGoqCx702RyUCVOPIBdoXFAp1AmYZmNBdQuq5Rg/gROQbYWLTSz/7rYeK1t
         Maq1T90wBdBe8/lPpOPHon3ITK4qHYW7TmaFQwH+Vfy8W8nAS5j7herqWvuta9urAaFE
         5bBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qivbuD1I15yUFqD9pKw/fJo/zrUz/8AP+MvKncHNu4g=;
        b=U8Qz1jdu5C+OC37uURlxWp1TF1GQpSEw+/GYkdysf766bpKwHIbkPWGdl0/N5N+GN9
         z/c9iru0pCXbFtJtH7n8evsq+66ao1AQCFTgc8GRYG9OfqhlPwdK7zlEgUybkYCLYT8y
         eQ+WebXfVRTnQkE8tqi4PQHCoIR6nQRZBXJ86/Vlf66ajwJRtzLk3I2GCpL+dIH/Lab9
         m3N2vx//CAWrLf1xr/GDrFfwJ6saMw4UMDGgzSSLT4BkZlbdxce7PVAUKw29Odb4Jbfv
         HlfA/9StO4/xAIXkSgSlV1PEcWahY6NBuEXM8PDt/Pg8oYxGyqL+gq3CPqX2T253+Mvo
         FXkA==
X-Gm-Message-State: ANhLgQ0bR1XKRs+gifSaHQZnzKEeiQq8hbekZE/BwWQaMorL1qjtKHkQ
        asy5QxyKUbxefXaMvE59ckAFdg==
X-Google-Smtp-Source: ADFU+vugXbwXQvc7HEFNP8VxxkCiKmZP3jq/lu56jjDO3+UMJbE9BJYyMJRj7bk6VABzYH2tgCsPRA==
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr1422946wrr.204.1585238070471;
        Thu, 26 Mar 2020 08:54:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i19sm4153946wmb.44.2020.03.26.08.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:54:29 -0700 (PDT)
Date:   Thu, 26 Mar 2020 16:54:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 3/7] devlink: Add macro for "hw.addr" to
 info_get cb.
Message-ID: <20200326155429.GZ11304@nanopsycho.orion>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200326092648.GR11304@nanopsycho.orion>
 <CAACQVJoA5EpB1CQUHvzDgYS0O7XLZ4vNbVvGALqc8nkf4-+VgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJoA5EpB1CQUHvzDgYS0O7XLZ4vNbVvGALqc8nkf4-+VgA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 12:02:43PM CET, vasundhara-v.volam@broadcom.com wrote:
>On Thu, Mar 26, 2020 at 2:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Thu, Mar 26, 2020 at 07:27:00AM CET, vasundhara-v.volam@broadcom.com wrote:
>> >Add definition and documentation for the new generic info "hw.addr".
>> >"hw.addr" displays the hardware address of the interface.
>> >
>> >Cc: Jiri Pirko <jiri@mellanox.com>
>> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>> >---
>> > Documentation/networking/devlink/devlink-info.rst | 5 +++++
>> > include/net/devlink.h                             | 3 +++
>> > 2 files changed, 8 insertions(+)
>> >
>> >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
>> >index 650e2c0e3..56d13c5 100644
>> >--- a/Documentation/networking/devlink/devlink-info.rst
>> >+++ b/Documentation/networking/devlink/devlink-info.rst
>> >@@ -144,6 +144,11 @@ board.manufacture
>> >
>> > An identifier of the company or the facility which produced the part.
>> >
>> >+hw.addr
>> >+-------
>> >+
>> >+Hardware address of the interface.
>> >+
>> > fw
>> > --
>> >
>> >diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >index d51482f..c9383f4 100644
>> >--- a/include/net/devlink.h
>> >+++ b/include/net/devlink.h
>> >@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
>> > /* Revision of asic design */
>> > #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV "asic.rev"
>> >
>> >+/* Hardware address */
>> >+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR  "hw.addr"
>>
>> Wait a second. Is this a MAC. I don't understand why MAC would be here.
>Yes, this is MAC address. Since, most of the information is displayed
>via info_get
>as one place. Would like to display MAC address as well under info_get.

No, I don't want to display mac here. It is a netdevice attribute. Leave
it there.


>
>Thanks,
>Vasundhara
>
>
>> If not MAC, what is exactly this address about?
>>
>>
>> >+
>> > /* Overall FW version */
>> > #define DEVLINK_INFO_VERSION_GENERIC_FW               "fw"
>> > /* Overall FW interface specification version */
>> >--
>> >1.8.3.1
>> >
