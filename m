Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C13A4594
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhFKPka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:40:30 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38850 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhFKPk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:40:29 -0400
Received: by mail-pf1-f179.google.com with SMTP id z26so4745676pfj.5
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g8dDWunaUSKQOObSPJAwbVnmqMcEhQq7B4KapBMwpCY=;
        b=wBf7jlCY4Ggr+SGALhRoegHaO1WmqZ+1GQuc4S/xQgYgfpriHjZAETgnxZJBwM+PiN
         3HU3a4B/0qUUwYQPzuXYVT8xxZD53lBMvzgR3wt6srJH1ktT/Ub+oXE8oTUVRNnyysy5
         ficb4IJ6LOV5eMfAw+1wnvwJV+I7js2VsQ5LSigVPDrQCnaGznLi9T90VsF8EMzcwUJb
         cN3hhaDZUb4XURv2HEG+W8zJdVaS/TDTeU9IVdMVNlVIIMvdhxN5vLhr7MiMP8Ynl/95
         S2KLRFM7ZF/roFwB+VyGBbXqWH+NoNFNgzRYIEpomYfMv50Tncz+L0wuTu1p9KHVTpll
         aBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8dDWunaUSKQOObSPJAwbVnmqMcEhQq7B4KapBMwpCY=;
        b=dhLLJ3IuCmcmT4hZ8U51LEkdE3YV3q1Zc8GXOpIqNZKz9DbWzE306/qsHIH9KQkuJ7
         u0Ly/CP5qVpRTyspxilAv7/i+IAvg5nVqinkkDJKl8MT88f+hhgy+93q930ZNq3OoqEK
         lbO70CLx+VCyKxl/U35x58t8hB9xAMS4IYB9BMkvVSAIZ2GJmcR3l9brO00+Ss+MeT/b
         gt5DxKAFD6baf6ex7oxRdDhzvuhFeC8Bs49k7tDCzjv0zSEJwEmaPnH63ki3uPazGmEc
         GGGfgBdg9osPNk4a2QroiTzBpUPdaYXh+dIK/48MbCFmm/2bdThUKdFZux+MKR6nHaS5
         7iLw==
X-Gm-Message-State: AOAM533vqCtETA0AVABwHtF5URA4A7+6oXhmsNk053ByshOP2dd0r+Su
        kP3mNbqWv9Mi5RltbPsfI2sWU/lPJlIerzzH+1AuAg==
X-Google-Smtp-Source: ABdhPJwOQHj3cORTd8YIewMyHkpuV2qb/+/sthPMLc4fdtDx7nlGLyiuad13cqUAHObFGoqaxGCl3tB59MVBNEtLDNs=
X-Received: by 2002:a62:5c1:0:b029:2a9:7589:dd30 with SMTP id
 184-20020a6205c10000b02902a97589dd30mr8875491pff.66.1623425836517; Fri, 11
 Jun 2021 08:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org> <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Jun 2021 17:46:22 +0200
Message-ID: <CAMZdPi9HhO9Z0W9hDLgNaj6jwiofVyQEp6pAwAO1Z8zqFGmGCA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
To:     Parav Pandit <parav@nvidia.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav,

On Fri, 11 Jun 2021 at 15:01, Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Loic Poulain <loic.poulain@linaro.org>
> > Sent: Thursday, June 10, 2021 11:15 PM
> >
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > In some cases, for example in the upcoming WWAN framework changes,
> > there's no natural "parent netdev", so sometimes dummy netdevs are
> > created or similar. IFLA_PARENT_DEV_NAME is a new attribute intended to
> > contain a device (sysfs, struct device) name that can be used instead when
> > creating a new netdev, if the rtnetlink family implements it.
> >
> > As suggested by Parav Pandit, we also introduce
> > IFLA_PARENT_DEV_BUS_NAME attribute in order to uniquely identify a
> > device on the system (with bus/name pair).

[...]

> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h index
> > a5a7f0e..4882e81 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -341,6 +341,13 @@ enum {
> >       IFLA_ALT_IFNAME, /* Alternative ifname */
> >       IFLA_PERM_ADDRESS,
> >       IFLA_PROTO_DOWN_REASON,
> > +
> > +     /* device (sysfs) name as parent, used instead
> > +      * of IFLA_LINK where there's no parent netdev
> > +      */
> > +     IFLA_PARENT_DEV_NAME,
> > +     IFLA_PARENT_DEV_BUS_NAME,
> > +
> >       __IFLA_MAX
> >  };
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index 92c3e43..32599f3
> > 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
> >       if (rtnl_fill_prop_list(skb, dev))
> >               goto nla_put_failure;
> >
> > +     if (dev->dev.parent &&
> > +         nla_put_string(skb, IFLA_PARENT_DEV_NAME,
> > +                        dev_name(dev->dev.parent)))
> > +             goto nla_put_failure;
> > +
> > +     if (dev->dev.parent && dev->dev.parent->bus &&
> > +         nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
> > +                        dev->dev.parent->bus->name))
> > +             goto nla_put_failure;
> > +
> >       nlmsg_end(skb, nlh);
> >       return 0;
> >
> > @@ -1880,6 +1890,8 @@ static const struct nla_policy
> > ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PERM_ADDRESS]     = { .type = NLA_REJECT },
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> > +     [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_PARENT_DEV_BUS_NAME] = { .type = NLA_NUL_STRING },
> >  };
> >
> This hunk should go in the patch that enables users to use these fields to specify it for new link creation.

Don't get it, the previous changes I see in the tree change both
if_link.h and rtnetlink.c for new atributes (e.g. f74877a5457d). Can
you elaborate on what you expect here?

Thanks,
Loic
