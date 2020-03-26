Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA4193D8A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgCZLC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:02:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33822 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgCZLC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:02:57 -0400
Received: by mail-lf1-f68.google.com with SMTP id e7so4435466lfq.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynpcR6n8vAPdutY7ywfm1ArJ7pQbC0NhZJIcycKZNpo=;
        b=BoPnx1beyl1c+JOCY9zAv6v8ZiWm67MUPmXOEVFSE20nPI13ub6IgDjNGpCeYCxSrr
         ZhQjOdFaI/9nvTFjc9g/6hJMBKLKfFnoVGLtHXw5Li3VWuUc0srEZyoYGnjSIM3IySg/
         5U99RkTHx9jzeh81huEVyGy5cPb26H+cB1ToQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynpcR6n8vAPdutY7ywfm1ArJ7pQbC0NhZJIcycKZNpo=;
        b=UujSiKv6TNvFqtXLQQrsWLT9I2Q8R61j9Didwnf7EomIJAriGyIYgxVDIhT2EhEhAW
         8XQ+iWZpatUlFvk+XZc9vnmA0b5q8QhX70erDmzaV+eQPaxlA8A+IAttgq/sdch02GIh
         vGodnhCABiGaXag/C4JJeFV7EMSeijByotDW2jzgxgbmIjm8i0iWOXMa1ypaCd48w/ZS
         lEOMK5mgbSKGZVRyRqVK87lLYWAfiAHPDS6poRE6kpWLLX3vkvAwjmV9Q9R62Nkno/sN
         dWeq9zb0RCvZTHZnGzVxfZI/5ZVSvCUN5I6vViMkXPTVsCZvjlJS73h+ujEjKjBaww2U
         jQ5A==
X-Gm-Message-State: ANhLgQ3LAAWqU4G5YwkiCerC7pdD2x4Gpb6B9GjXSjqiTrqW8BaFfpYx
        puumRrSD3ErmTKHH+Req7vRMGTKw8kn1wskmyzRJ/w==
X-Google-Smtp-Source: ADFU+vtxwdi0VstprpGXE8kIKWpqGLkTNFZAj2NaX9aV5blHmlg3b0E2DLEIHRTX7ErxOM+aCjkC3E82u9myffv+H2c=
X-Received: by 2002:a19:6144:: with SMTP id m4mr5251583lfk.192.1585220575274;
 Thu, 26 Mar 2020 04:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com> <20200326092648.GR11304@nanopsycho.orion>
In-Reply-To: <20200326092648.GR11304@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Thu, 26 Mar 2020 16:32:43 +0530
Message-ID: <CAACQVJoA5EpB1CQUHvzDgYS0O7XLZ4vNbVvGALqc8nkf4-+VgA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/7] devlink: Add macro for "hw.addr" to
 info_get cb.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 2:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Thu, Mar 26, 2020 at 07:27:00AM CET, vasundhara-v.volam@broadcom.com wrote:
> >Add definition and documentation for the new generic info "hw.addr".
> >"hw.addr" displays the hardware address of the interface.
> >
> >Cc: Jiri Pirko <jiri@mellanox.com>
> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >---
> > Documentation/networking/devlink/devlink-info.rst | 5 +++++
> > include/net/devlink.h                             | 3 +++
> > 2 files changed, 8 insertions(+)
> >
> >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> >index 650e2c0e3..56d13c5 100644
> >--- a/Documentation/networking/devlink/devlink-info.rst
> >+++ b/Documentation/networking/devlink/devlink-info.rst
> >@@ -144,6 +144,11 @@ board.manufacture
> >
> > An identifier of the company or the facility which produced the part.
> >
> >+hw.addr
> >+-------
> >+
> >+Hardware address of the interface.
> >+
> > fw
> > --
> >
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index d51482f..c9383f4 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
> > /* Revision of asic design */
> > #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV "asic.rev"
> >
> >+/* Hardware address */
> >+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR  "hw.addr"
>
> Wait a second. Is this a MAC. I don't understand why MAC would be here.
Yes, this is MAC address. Since, most of the information is displayed
via info_get
as one place. Would like to display MAC address as well under info_get.

Thanks,
Vasundhara


> If not MAC, what is exactly this address about?
>
>
> >+
> > /* Overall FW version */
> > #define DEVLINK_INFO_VERSION_GENERIC_FW               "fw"
> > /* Overall FW interface specification version */
> >--
> >1.8.3.1
> >
