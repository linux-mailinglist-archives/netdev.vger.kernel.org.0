Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB705398E8D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhFBP2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhFBP2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 11:28:51 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AF1C061574;
        Wed,  2 Jun 2021 08:27:08 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c31-20020a056830349fb02903a5bfa6138bso2757862otu.7;
        Wed, 02 Jun 2021 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Oel2AIfoplUN3vjr9wygiwoq8rRP3en7fVOdLxkzQIw=;
        b=cJN69XtpqYGMEZHQ6FGu6q4EJw0heA0mgQf1tBaYdeufDcjKZQocLLSQP/QSGMb5eo
         lAp7W6lmk/TCpH0Mn8dsxRiK8jgVdcCtoj1PUjyOU4Nue2068tXH+3euiT7Z2R0FbmEO
         i8Sli+9cjExzv469aERRyEvFBVTMAqtE/eTmEjERVcN9KNmg3CgG5MEx1piEn9I3Gw6G
         1IZybTf4b6regeGB6e+moBP5S89MN48GxMq3jB9UZ3f1tadM7VHRzyHbUpWKUAPALh4b
         i6zUgaljuJiideRv8JmnRQN/BW3H+Z5H1xBwrJtFbnCzjXrjQOydwJlFsSMYXUWzHOdt
         LpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Oel2AIfoplUN3vjr9wygiwoq8rRP3en7fVOdLxkzQIw=;
        b=WKmkNLxA9RNeTIkehp/3JtDA611bHJvpArAa3qz+O3rBuKshocPa2yeHvLMzbMuebJ
         9OPfE+QT6fKm2eY05kcQhVti8OkVDaaNwQ5yChaZQtrY2qvGclfVfvT2aCaDF/86403c
         WJiD9LnHT8n7215eMBMrwoBqrQPrNmHjdconUXbmlGpl2vdr4gxEmPzFZ7slkB+Mf97x
         C3W8roA3DxJq3mwfJpRgKNntI5uMzwIeu5usDxlzXinKtuh3UTIgrowNq0/M04tsOkv5
         7jJrx4riXcAVt76Rdbv3OMiWRdDU+ro26S+ymuRMOt2b4HoqfD2W+PULCZQuyYfh8uCi
         XqPw==
X-Gm-Message-State: AOAM530Ll7PTFGckOb2LIikq/J+LKI4e64VtOQ8238gS5ksBEY8qT13F
        b/87WJmzfxz+nNgGDjXJh6ZgjVcrJIsUP6gZOmOTs3dV8nw=
X-Google-Smtp-Source: ABdhPJxbDNbSYJLvYvPC0BA+blK2IFsMtdxezo/79YLWxNZIG84hNt36vcT4hACAdKEQ0aS31DIOOo41QFkxu944iwc=
X-Received: by 2002:a9d:4e88:: with SMTP id v8mr25358700otk.110.1622647626639;
 Wed, 02 Jun 2021 08:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210602082840.85828-1-johannes@sipsolutions.net> <20210602102653.9d5c4789824f.Ia98e333bba58bc6a0b1c8fa28ad0964fb9c918d6@changeid>
In-Reply-To: <20210602102653.9d5c4789824f.Ia98e333bba58bc6a0b1c8fa28ad0964fb9c918d6@changeid>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 2 Jun 2021 18:26:55 +0300
Message-ID: <CAHNKnsTKfFF9EckwSnLrwaPdH_tkjvdB3PVraMD-OLqFdLmp_Q@mail.gmail.com>
Subject: Re: [RFC v2 3/5] rtnetlink: add IFLA_PARENT_DEV_NAME
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 11:28 AM Johannes Berg <johannes@sipsolutions.net> w=
rote:
> In some cases, for example in the upcoming WWAN framework
> changes, there's no natural "parent netdev", so sometimes
> dummy netdevs are created or similar. IFLA_PARENT_DEV_NAME
> is a new attribute intended to contain a device (sysfs,
> struct device) name that can be used instead when creating
> a new netdev, if the rtnetlink family implements it.
>
> Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2:
>  * new patch
> ---
>  include/uapi/linux/if_link.h | 6 ++++++
>  net/core/rtnetlink.c         | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index f7c3beebb074..3455780193a4 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -341,6 +341,12 @@ enum {
>         IFLA_ALT_IFNAME, /* Alternative ifname */
>         IFLA_PERM_ADDRESS,
>         IFLA_PROTO_DOWN_REASON,
> +
> +       /* device (sysfs) name as parent, used instead
> +        * of IFLA_LINK where there's no parent netdev
> +        */
> +       IFLA_PARENT_DEV_NAME,
> +
>         __IFLA_MAX
>  };
>
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 4975dd91407d..49a27bf6e4a7 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1878,6 +1878,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX=
+1] =3D {
>         [IFLA_PERM_ADDRESS]     =3D { .type =3D NLA_REJECT },
>         [IFLA_PROTO_DOWN_REASON] =3D { .type =3D NLA_NESTED },
>         [IFLA_NEW_IFINDEX]      =3D NLA_POLICY_MIN(NLA_S32, 1),
> +       [IFLA_PARENT_DEV_NAME]  =3D { .type =3D NLA_NUL_STRING },
>  };
>
>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =3D {

I would like to clarify this proposal more broadly. There are some
devices that implement multiple data channels and require several
netdev for traffic separation. The most notable class of such devices
is WWAN modems.

At the moment, a common way to manage these multiple interfaces is to
create a master netdev per each HW instance and reuse IFLA_LINK
attribute to create all subsequent data channel netdevs as
subinterfaces of the master (see MBIM and RMNET drivers). But in fact
all these netdev do not have the master-subinterface relationship.
They are equal. The only reason to implement such a complex scheme is
the absen=D1=81e of an attribute that can indicate a parent device. So, in
some sense, driver developers were forced to abuse IFLA_LINK to avoid
a complete per-driver private API creation.

It was Johannes finding that we can greatly simplify the management
API for the WWAN subsystem by specifying a sysfs device name as a
parent for the data channel netdev creation procedure. The first RFC
introduces a private attribute to indicate a parent device. My
suggestion was only to make this attribute generic as it seems to be
generic. The parent device indication attribute should help us avoid
further IFLA_LINK abuse and perhaps even make it easier to rework
existing drivers. Moreover, we have the parent device pointer directly
in the netdev structure, so after applying this patch, we will be able
to export the parent device name using the netdev dump operation and
even filter its results.

ip-link(8) support for the generic parent device attribute will help
us avoid code duplication, so no other link type will require a custom
code to handle the parent name attribute. E.g. the WWAN interface
creation command will looks like this:

# ip link add wwan0-1 parent-dev wwan0 type wwan channel-id 1

So, some future subsystem (or driver) FOO will have an interface
creation command that looks like this:

# ip link add foo1-3 parent-dev foo1 type foo bar-id 3 baz-type Y

As suggested by Johannes, I will soon send a small series with
examples of using the suggested parent device name attribute.

--=20
Sergey
