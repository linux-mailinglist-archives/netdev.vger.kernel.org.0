Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7995F248390
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgHRLHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgHRLHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 07:07:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83061C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 04:07:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a5so17855778wrm.6
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 04:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=drdVPSYgqMc7dqGMBgLAeet5Si+cNYzh0V7KAWM73y4=;
        b=HbnpJ5QNoEXhYruLjRRBC3XSjw1narQot9FBjqwrfyfJOd7RbgzX0VasnZdNCDoWeV
         gLhK/sAiwxiehQ71zp6iPywxGgBdD/qQb6NJkt00/PeHH1vGHPd5EtZHY+5VFJzBRFP/
         ZFIK9iMao5tEkWVUPxh+t6vFlIhKs0baoLd+pSKdl5PVbi6k1G4r7A1RZ3VEzaP4TCqD
         0rX7x/8pmBFoLwsyaH8AvLudI0FYnuRHRRkxzDhga7fLqyv0KgFKO+l8yfZkEZyhhdr+
         o5d04kpj8IOBpHvPVj5fKxojGOymyLBgh6ZpBOd3zF0hOjjcGVPifMFCW8hwv0K0lnUp
         JHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=drdVPSYgqMc7dqGMBgLAeet5Si+cNYzh0V7KAWM73y4=;
        b=ApcPivQr0sMiME3IVpemL0cZaMguqsUztFHXsy3YdLQgwWvzPK5qt9xXnN6V4ecFcP
         mNv3Kexk0+pfRko9xaVhr0AS14iV7dnw6Wx2lFOOBHiXNjET3e8A5wbMKhYxckYIdEe8
         TFWgGo/Yco9NCEhE2+lEI06+e/q2V16uiHHhuU53kFVsg5qDlGnr0Zoz+Zuy4SF6I+CT
         1Kt0v+ubTSTXpQ8s/zZJZkSEcw5eNgCdLieJUDmTDT+ja2B+4oQpZvsX4L8ep2Lps91F
         BRPcPLKhN0ufQQIl3+VMmnNJfDfjqxNlCPZDwj6JUgE+bPm/d1zXt6jM8CfayhDjKuyV
         BSUQ==
X-Gm-Message-State: AOAM53389cX/RyeVl3u9IGQlVohAFn4Fi+iR2OHvkkKXb2hb6rCnF0uI
        AEkzi3U5a8Qqu6J46nuWJ0FJGQ==
X-Google-Smtp-Source: ABdhPJxUcNMbG61CAzv1+ghtKHABVOnJMu095E+/m535tDRmxABwZXq/VtYImGvD4hfex35L1/o3Hw==
X-Received: by 2002:adf:ed85:: with SMTP id c5mr19775656wro.307.1597748861915;
        Tue, 18 Aug 2020 04:07:41 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d14sm35403359wre.44.2020.08.18.04.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 04:07:41 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:07:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 13/13] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
Message-ID: <20200818110740.GC2627@nanopsycho>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-14-git-send-email-moshe@mellanox.com>
 <20200817163933.GB2627@nanopsycho>
 <a786a68d-df60-cae3-5fb1-3648ca1c69d8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a786a68d-df60-cae3-5fb1-3648ca1c69d8@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 18, 2020 at 11:14:16AM CEST, moshe@nvidia.com wrote:
>
>On 8/17/2020 7:39 PM, Jiri Pirko wrote:
>> Mon, Aug 17, 2020 at 11:37:52AM CEST, moshe@mellanox.com wrote:
>> > Add devlink reload rst documentation file.
>> > Update index file to include it.
>> > 
>> > Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> > ---
>> > - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>> >   actions driver_reinit,fw_activate,fw_live_patch
>> > ---
>> > .../networking/devlink/devlink-reload.rst     | 54 +++++++++++++++++++
>> > Documentation/networking/devlink/index.rst    |  1 +
>> > 2 files changed, 55 insertions(+)
>> > create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>> > 
>> > diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>> > new file mode 100644
>> > index 000000000000..9846ea727f3b
>> > --- /dev/null
>> > +++ b/Documentation/networking/devlink/devlink-reload.rst
>> > @@ -0,0 +1,54 @@
>> > +.. SPDX-License-Identifier: GPL-2.0
>> > +
>> > +==============
>> > +Devlink Reload
>> > +==============
>> > +
>> > +``devlink-reload`` provides mechanism to either reload driver entities,
>> > +applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>> > +activation depends on reload action selected.
>> > +
>> > +Reload actions
>> > +=============
>> > +
>> > +User may select a reload action.
>> > +By default ``driver_reinit`` action is done.
>> > +
>> > +.. list-table:: Possible reload actions
>> > +   :widths: 5 90
>> > +
>> > +   * - Name
>> > +     - Description
>> > +   * - ``driver-reinit``
>> > +     - Driver entities re-initialization, including applying
>> > +       new values to devlink entities which are used during driver
>> > +       load such as ``devlink-params`` in configuration mode
>> > +       ``driverinit`` or ``devlink-resources``
>> > +   * - ``fw_activate``
>> > +     - Firmware activate. Can be used for firmware reload or firmware
>> > +       upgrade if new firmware is stored and driver supports such
>> > +       firmware upgrade.
>> Does this do the same as "driver-reinit" + fw activation? If yes, it
>> should be written here. If no, it should be written here as well.
>> 
>
>No, The only thing required here is the action of firmware activation. If a
>driver needs to do reload to make that happen and do reinit that's ok, but
>not required.

What does the "FW activation" mean? I believe that this needs explicit
documentation here.


>
>> > +   * - ``fw_live_patch``
>> > +     - Firmware live patch, applies firmware changes without reset.
>> > +
>> > +Change namespace
>> > +================
>> > +
>> > +All devlink instances are created in init_net and stay there for a
>> > +lifetime. Allow user to be able to move devlink instances into
>> > +namespaces during devlink reload operation. That ensures proper
>> > +re-instantiation of driver objects, including netdevices.
>> > +
>> > +example usage
>> > +-------------
>> > +
>> > +.. code:: shell
>> > +
>> > +    $ devlink dev reload help
>> > +    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { fw_live_patch | driver_reinit | fw_activate } ]
>> > +
>> > +    # Run reload command for devlink driver entities re-initialization:
>> > +    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>> > +
>> > +    # Run reload command to activate firmware:
>> > +    $ devlink dev reload pci/0000:82:00.0 action fw_activate
>> > diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
>> > index 7684ae5c4a4a..d82874760ae2 100644
>> > --- a/Documentation/networking/devlink/index.rst
>> > +++ b/Documentation/networking/devlink/index.rst
>> > @@ -20,6 +20,7 @@ general.
>> >     devlink-params
>> >     devlink-region
>> >     devlink-resource
>> > +   devlink-reload
>> >     devlink-trap
>> > 
>> > Driver-specific documentation
>> > -- 
>> > 2.17.1
>> > 
