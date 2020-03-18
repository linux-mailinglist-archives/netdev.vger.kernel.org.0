Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6943D1894D4
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCREVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:21:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45310 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgCREVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:21:44 -0400
Received: by mail-lj1-f196.google.com with SMTP id y17so4215562ljk.12
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 21:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Hu2R+wLoSSq0h2E7HUnYY0OrcWwX2UR0hKYVP4hoqE=;
        b=Gyh02HpXko932g7tromRI7TP2BoqztpoKH3mUxajoUWTFKyf/3RmvTolRjSiJgBISR
         e15P3ZCcks89wO7Eg/63Ahq4GbohO6kVUZwZOqk3EJpO19477v53fSYzurDgHgscZZaW
         Cn1ILtH3Xmsu90l8V8bUIoKYstZwj1fXQbCKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Hu2R+wLoSSq0h2E7HUnYY0OrcWwX2UR0hKYVP4hoqE=;
        b=A4vmCtE4GXTY7Wsfm+K71ky31FJj89FT5TPQHPWbQKqL16LzLYCoXT5TnBh+HQJo0L
         IPu5r9XIZQFZ55IFrktNF0BHZfXNPwNxydvMXcMOHNBlnz3eu+B56ytSbg1PSbmaPqM1
         nw0Gw8vUfFpUbiyOgNuOudw/RSOq89Z8uBNapdOJosAvbADNJt/toIMOD4vIAXOnX6NK
         Td7ls6z5aZR3Y7iXCfrnuq8FQ8QqwMu1vOIyUdTJ+UvTtMpsrRAW5NTCLCrw1R9lFriU
         qTuU6lsFOBOZK7ETTZ/Q7cHaEOkaz9jENH0ScLiaVk0PtuQJZNr1/LGYjL/3GFI5rZjY
         SJww==
X-Gm-Message-State: ANhLgQ22JfR0OU6tQZ53hZ4nuOLpxIkAaBVGUE0W6a6tTPZ9xuIurDbe
        cA05DfLY04ikb+racV+lIz8iIZtlKZC5gjjmnavzXQ==
X-Google-Smtp-Source: ADFU+vu4PC19CR4q7C7RIvAr+Vs2SI1MVh8uGvaEKN35ne5a6icC/Nn/O9F/TRRuTfkTLaashhrE6Pa1s6OiOywWzmU=
X-Received: by 2002:a05:651c:1047:: with SMTP id x7mr1182798ljm.246.1584505301328;
 Tue, 17 Mar 2020 21:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com> <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 18 Mar 2020 09:51:29 +0530
Message-ID: <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 11:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Mar 2020 20:44:38 +0530 Vasundhara Volam wrote:
> > Add definition and documentation for the new generic info "drv.spec".
> > "drv.spec" specifies the version of the software interfaces between
> > driver and firmware.
> >
> > Cc: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > ---
> >  Documentation/networking/devlink/devlink-info.rst | 6 ++++++
> >  include/net/devlink.h                             | 3 +++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> > index 70981dd..0765a48 100644
> > --- a/Documentation/networking/devlink/devlink-info.rst
> > +++ b/Documentation/networking/devlink/devlink-info.rst
> > @@ -59,6 +59,12 @@ board.manufacture
> >
> >  An identifier of the company or the facility which produced the part.
> >
> > +drv.spec
> > +--------
> > +
> > +Firmware interface specification version of the software interfaces between
>
> Why did you call this "drv" if the first sentence of the description
> says it's a property of the firmware?
Since it is a version of interface between driver and firmware. Both
driver and firmware
can support different versions. I intend to display the version
implemented in the driver.

I can probably add for both driver and firmware. Add it is as drv.spec
and fw.spec.

Thanks,
Vasundhara
>
> Upcoming Intel patches call this "fw.mgmt.api". Please use that name,
> it makes far more sense.
>
> > +driver and firmware. This tag displays spec version implemented by driver.
> > +
> >  fw
> >  --
> >
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index c9ca86b..9c4d889 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -476,6 +476,9 @@ enum devlink_param_generic_id {
> >  /* Revision of asic design */
> >  #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV        "asic.rev"
> >
> > +/* FW interface specification version implemented by driver */
> > +#define DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC        "drv.spec"
> > +
> >  /* Overall FW version */
> >  #define DEVLINK_INFO_VERSION_GENERIC_FW              "fw"
> >  /* Control processor FW version */
>
