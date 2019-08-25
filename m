Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E3D9C4ED
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfHYQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:46:27 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:57133 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbfHYQq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:46:27 -0400
X-Originating-IP: 209.85.222.54
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id F12B21BF205
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 16:46:24 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id m8so2129150uap.2
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:46:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXs9YgE+xgmrgP1aLRr5IN5vF4AmcICYc0VrPy/W02+KTeSqdy0
        /MNgaYHenfUlnUWK+6Ndoz9b9rFIepspvFIl42Y=
X-Google-Smtp-Source: APXvYqzJkrxPDnCRkU4w+5bRB+Vd80blEYozknxCzHK/ff6a0DxKb3TyhTxFaJ15IP7kHtJMML4TkFAL/FL+G8ys6g8=
X-Received: by 2002:ab0:a8a:: with SMTP id d10mr6899436uak.64.1566751583607;
 Sun, 25 Aug 2019 09:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <1566432970-13377-1-git-send-email-yihung.wei@gmail.com>
In-Reply-To: <1566432970-13377-1-git-send-email-yihung.wei@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 25 Aug 2019 09:48:27 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Cy2xuG87jcabsnTF_ttCcbt3E8tCrj7SqRWhu19-PkLA@mail.gmail.com>
Message-ID: <CAOrHB_Cy2xuG87jcabsnTF_ttCcbt3E8tCrj7SqRWhu19-PkLA@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: Fix log message in ovs conntrack
To:     Yi-Hung Wei <yihung.wei@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 5:27 PM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
>
> Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> ---
>  net/openvswitch/conntrack.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 45498fcf540d..0d5ab4957ec0 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -1574,7 +1574,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
>                 case OVS_CT_ATTR_TIMEOUT:
>                         memcpy(info->timeout, nla_data(a), nla_len(a));
>                         if (!memchr(info->timeout, '\0', nla_len(a))) {
> -                               OVS_NLERR(log, "Invalid conntrack helper");
> +                               OVS_NLERR(log, "Invalid conntrack timeout");
>                                 return -EINVAL;
>                         }
>                         break;
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
