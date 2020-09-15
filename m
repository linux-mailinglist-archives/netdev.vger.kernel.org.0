Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FAF26B81D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIPAgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgION1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:27:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC52C0611BC
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:26:51 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x23so3370714wmi.3
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2AzBYLhEtS2P6fcBoO+d1UipgtAgkG/Sw1GDkWlDdZY=;
        b=s6zHIO8W3MlZAtsztq2A0WykjjjQ/qRzOjhzbehHnjHUPUJ+ZOWy/Nxrz8U56S712U
         xXo8LMCaGOrhbb6oO3YjKFBAR1Pa35n4VgKl2TiAxWeIVKQK2BsdoBYIaLxhREHXeh8g
         NuWwzDxitLE7yYaed0SbPNo3x52FO+RUxkR+x9e+/g+b/+AyPknj2zKU7vIdzwF8fbKN
         ZX3f4di93i6DxMUghbDSnE1k69xCF1FuA+byk4+54zxRnZhcnZ3CYEt7Qe3cOiiSY358
         VkMYCck8CUHgoBrlP2yZKQiwZMofjyrLreuE4V7RB0ux1F3K+lbSxNXijfBtIGrf/0/k
         xwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2AzBYLhEtS2P6fcBoO+d1UipgtAgkG/Sw1GDkWlDdZY=;
        b=ZTffltBKWqz3nGwbvHxyKsfngPMe8kyIudXdXs6xnHmbfCFUD6UEF5ZK59cK15RgrK
         e96r2JxiCWcXnqcCvxcYGiyoBWsMO0gd3jc9qz5sjyYCIcdrph/W27K09Sme0WL0s542
         7VfaFVdZNv+usT/pX9EmnG8jurSobyGM90AGgPETdkjEOCEjwEOFgLwEa4NCOP58Ez5v
         rqcw1sUdv1kfJSyvxpiRKkHDYYU+fNVz7d4+6+RqVXz00SlP5us3AwIXAq3AhzApcq+s
         DCIsJOZO72SVsdzAh312t5dvftPkcxrLk75tSDFZ4MmJgcVCoT0jFGfHLh0SkYEfacud
         UVZw==
X-Gm-Message-State: AOAM532VB+OkMtOU0OX9ExCWzIHGtlgn81tiFkk0iCiKf0wSiWroxGOg
        D0/k7caoDNLaGSPsJWlEIvFlZw==
X-Google-Smtp-Source: ABdhPJyJAYJbdgSzg7qz4jZgXvVAK0DSvc1GSLpLKiUZ+tnkoR/XfxxP5krr5Wcsy5DvgCksu8Xe4g==
X-Received: by 2002:a1c:9c4b:: with SMTP id f72mr4692488wme.188.1600176409854;
        Tue, 15 Sep 2020 06:26:49 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h4sm25019281wrm.54.2020.09.15.06.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 06:26:49 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:26:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200915132648.GO2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <20200914143306.4ab0f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <777fd1b8-1262-160e-a711-31e5f6e2c37c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777fd1b8-1262-160e-a711-31e5f6e2c37c@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 02:56:48PM CEST, moshe@nvidia.com wrote:
>
>On 9/15/2020 12:33 AM, Jakub Kicinski wrote:
>> External email: Use caution opening links or attachments
>> 
>> 
>> On Mon, 14 Sep 2020 09:07:48 +0300 Moshe Shemesh wrote:
>> > @@ -3011,12 +3060,41 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> >                        return PTR_ERR(dest_net);
>> >        }
>> > 
>> > -     err = devlink_reload(devlink, dest_net, info->extack);
>> > +     if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> > +             action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
>> > +     else
>> > +             action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
>> > +
>> > +     if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
>> > +             NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
>> > +             return -EINVAL;
>> > +     } else if (!devlink_reload_action_is_supported(devlink, action)) {
>> > +             NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
>> > +             return -EOPNOTSUPP;
>> > +     }
>> > +
>> > +     err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>> > 
>> >        if (dest_net)
>> >                put_net(dest_net);
>> > 
>> > -     return err;
>> > +     if (err)
>> > +             return err;
>> > +
>> > +     WARN_ON(!actions_performed);
>> > +     msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> > +     if (!msg)
>> > +             return -ENOMEM;
>> > +
>> > +     err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
>> > +                                                    DEVLINK_CMD_RELOAD, info->snd_portid,
>> > +                                                    info->snd_seq, 0);
>> > +     if (err) {
>> > +             nlmsg_free(msg);
>> > +             return err;
>> > +     }
>> > +
>> > +     return genlmsg_reply(msg, info);
>> I think generating the reply may break existing users. Only generate
>> the reply if request contained DEVLINK_ATTR_RELOAD_ACTION (or any other
>> new attribute which existing users can't pass).
>
>
>OK, I can do that. But I update stats and generate devlink notification
>anyway, that should fine, right ?

Yes.

>
