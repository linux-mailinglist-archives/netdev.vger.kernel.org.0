Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BAE194BF3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgCZXJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:09:55 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41958 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:09:55 -0400
Received: by mail-qv1-f67.google.com with SMTP id o7so4039357qvq.8
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/PG24kosaCHluYAzuNMxZFblTvwyMUr1IrVugyzol8=;
        b=fglaG6cIXZHhfmh1FfoYQlVy/DZtZeXlV5648UrbnqgSyjetLdKojSSZrffd5TIcd2
         skA0kgQ03sRBiU0sn44MBMcvWoT7C2sp6CRmsSJZa8qJnFPzVLO+wd2HswnoCkbhWIMb
         QfyS+QuvpCSNw5r/IP6tDIWcIm5bQ388G2Gxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/PG24kosaCHluYAzuNMxZFblTvwyMUr1IrVugyzol8=;
        b=gdSME3uUaZP38ygLZU2AGhAmWUysHSW8FQzeTujVWg4eT8ai893fzE2hV9SWP9uI2B
         5xC00mw+/AzRlAuwcap7n/310ai0th2M4Hs5RUo5cZmC13rKZuPJ1uDLvqLu9A0sc/L+
         hzpAh2xMnGidB/kIci21wF6/Umi8H4d4A64C2FyqQ/9ES9+K/UEXF1anN3jrjK810IEp
         /i4Nyi0kvxy6sn64S9JgjJbOOA9FZd3osdGhA2Q/Ke+5hcsuDDAdWVhUi5v/7oV3e+T6
         0crfxvqW9zadZh8HcT7tLptyDy3j8IghfZleKO5RTyEhUlVohz5kdWS/i0Z+ABk6KbTc
         CFGQ==
X-Gm-Message-State: ANhLgQ2CEkSI/f54vjtbdbbf5ymZ21Rbmy6l9DpAbGDoyYv17RgJBYSY
        7jMw4lrYsQa215/YeGJu+wjkU0VpXb1TTsET5RXWeE9y
X-Google-Smtp-Source: ADFU+vszg2fmO0FliX0zgvF06+f2vgRn/JQWF5U8wocCgpo5kvpTITli2zRwiml/hrSuZoX48rHkiLgLxrCYzONcI9c=
X-Received: by 2002:a0c:ee28:: with SMTP id l8mr11084956qvs.196.1585264194402;
 Thu, 26 Mar 2020 16:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com> <20200326134025.2c2c94f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326134025.2c2c94f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 26 Mar 2020 16:09:43 -0700
Message-ID: <CACKFLimJORgp2kmRLgZHWLY9E1DsbD8CSf+=9A-_DQhQG8kbqg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/5] devlink: Add macro for "fw.api" to
 info_get cb.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 1:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 26 Mar 2020 17:32:34 +0530 Vasundhara Volam wrote:
> > Add definition and documentation for the new generic info "fw.api".
> > "fw.api" specifies the version of the software interfaces between
> > driver and overall firmware.
> >
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Jacob Keller <jacob.e.keller@intel.com>
> > Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > ---
> > v1->v2: Rename macro to "fw.api" from "drv.spec".
>
> I suggested "fw.mgmt.api", like Intel has. What else those this API
> number covers beyond management? Do you negotiated descriptor formats
> for the datapath?

To us, "management" firmware usually means firmware such as IPMI that
interfaces with the BMC.  Here, we're trying to convey the API between
the driver and the main firmware.  Yes, this main firmware also
"manages" things such as rings, MAC, the physical port, etc.  But
again, we want to distinguish it from the platform management type of
firmware.
