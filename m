Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E651943F4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgCZQDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 12:03:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40750 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgCZQDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 12:03:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so5292157lfe.7
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QG3ouz6ORFeqDNmtp4i3YMM1Ofd2sLdAsf2ZZXYAIGw=;
        b=Me/lmt5lMW143w6fwsQYN5uQAfgZOwmcFm0KQQQnR/S8gXmn7WIH9XfGKw58M/5Nby
         NQnv4eycMKgNbcqGrgbxnxhmeO0bmvPCE6EilY2uk5P1lBdWn0wpUCK6x6iU9b/Zky4+
         mxMDUfuBSLonnASGVMCj69ABzCAH0sg6URMlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QG3ouz6ORFeqDNmtp4i3YMM1Ofd2sLdAsf2ZZXYAIGw=;
        b=Mwg2ZcTeGrprWzhQK9xIsFA777aKZVLrB3S97B/PBYUE8k8+mxl14ZU0UHf2pg7BEG
         jekY4aqv8Cnm3R/dFjpKcy18GaB99skPBz3HzdbQTMB65+cLT/cHNdH5CdUwRdmLi8u1
         OeLNC5pvUuLx0+6RFVg6iS/PMY1H06xG46jzHYismCOgNDmxwq5eZ/fSm0OowU7sO4In
         zhuChjlGMJDIT/I/rAKwFNu8NDIZ7D0Uk0JHNiqWTB/wjjNTTCjgOwxJ5fzrTN1LE54m
         VEnwtImeMkafVwsujf8eQWk47TrVPsxOzz5T+/nzawfeTpEKf7gwCvq4PZ+LltWTznrT
         PwUQ==
X-Gm-Message-State: ANhLgQ3XhL+2lryx4wVtG7/PAIKtqiOUC6I45ksqVWFyBV/2FE6uXLpL
        BZwiBNEM31UXCTTYjU6otAjIYARhT34SgFcMWbMqJg==
X-Google-Smtp-Source: ADFU+vt9We4DhFMwyTGpDy3WfouzGVy7kbBr9jnDvg5LnhtmYydha9ls9iG7MBKacq8GptWr1JizWjErahLfkqDI0d0=
X-Received: by 2002:a19:ccd3:: with SMTP id c202mr6113167lfg.103.1585238611786;
 Thu, 26 Mar 2020 09:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585204021-10317-4-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200326092648.GR11304@nanopsycho.orion> <CAACQVJoA5EpB1CQUHvzDgYS0O7XLZ4vNbVvGALqc8nkf4-+VgA@mail.gmail.com>
 <20200326155429.GZ11304@nanopsycho.orion>
In-Reply-To: <20200326155429.GZ11304@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Thu, 26 Mar 2020 21:33:20 +0530
Message-ID: <CAACQVJrw5n5pcKP0ZoqqxgooiuR8r4HrP87bNskx2Sn=Bhrx7A@mail.gmail.com>
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

On Thu, Mar 26, 2020 at 9:24 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Thu, Mar 26, 2020 at 12:02:43PM CET, vasundhara-v.volam@broadcom.com wrote:
> >On Thu, Mar 26, 2020 at 2:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Thu, Mar 26, 2020 at 07:27:00AM CET, vasundhara-v.volam@broadcom.com wrote:
> >> >Add definition and documentation for the new generic info "hw.addr".
> >> >"hw.addr" displays the hardware address of the interface.
> >> >
> >> >Cc: Jiri Pirko <jiri@mellanox.com>
> >> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >> >---
> >> > Documentation/networking/devlink/devlink-info.rst | 5 +++++
> >> > include/net/devlink.h                             | 3 +++
> >> > 2 files changed, 8 insertions(+)
> >> >
> >> >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> >> >index 650e2c0e3..56d13c5 100644
> >> >--- a/Documentation/networking/devlink/devlink-info.rst
> >> >+++ b/Documentation/networking/devlink/devlink-info.rst
> >> >@@ -144,6 +144,11 @@ board.manufacture
> >> >
> >> > An identifier of the company or the facility which produced the part.
> >> >
> >> >+hw.addr
> >> >+-------
> >> >+
> >> >+Hardware address of the interface.
> >> >+
> >> > fw
> >> > --
> >> >
> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >> >index d51482f..c9383f4 100644
> >> >--- a/include/net/devlink.h
> >> >+++ b/include/net/devlink.h
> >> >@@ -476,6 +476,9 @@ enum devlink_param_generic_id {
> >> > /* Revision of asic design */
> >> > #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV "asic.rev"
> >> >
> >> >+/* Hardware address */
> >> >+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR  "hw.addr"
> >>
> >> Wait a second. Is this a MAC. I don't understand why MAC would be here.
> >Yes, this is MAC address. Since, most of the information is displayed
> >via info_get
> >as one place. Would like to display MAC address as well under info_get.
>
> No, I don't want to display mac here. It is a netdevice attribute. Leave
> it there.
>
Yes, realised it and sent a v3 patchset already, removing the MAC
address. Thanks.
>
> >
> >Thanks,
> >Vasundhara
> >
> >
> >> If not MAC, what is exactly this address about?
> >>
> >>
> >> >+
> >> > /* Overall FW version */
> >> > #define DEVLINK_INFO_VERSION_GENERIC_FW               "fw"
> >> > /* Overall FW interface specification version */
> >> >--
> >> >1.8.3.1
> >> >
