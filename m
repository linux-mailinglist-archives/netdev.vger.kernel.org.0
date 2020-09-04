Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5B25D432
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIDJE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729887AbgIDJEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:04:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C7C061245
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 02:04:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so5902029wrn.13
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 02:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QQlbI4/cVI7lV7hmpd49lUjhwmM3E62iOV4cqjNwGn0=;
        b=uvIZzRIZ8Ta/evq70yFiIpea3is+5U8CJ9nTtuEUUcNENV0B9KxuB/r2ZQ8NyWo8Ec
         02jJ3Qv5D6JKzGhTt5xChE6RF7NmW0gbkNqfmNgaaatMC9v6cSuahhJ+KUByWXJoi6X+
         hy5LGjlqanMviM0eDBl7WqEtsKlayZcsMZnqsGhW4I/5t+b4k8yEiLfqanmtau4RacOc
         J8390HGbRm2BMU9cFF2CYt17O2lVTL2qGz6IcPXtxwIfj1mng/lyZSKPEsWr2CPva9AS
         Y5URDvdDivRXJmBwgwlxj3h73VteTp/0Qw+WcLChhLx0qDWo8SgDKSDx6kBApp1FcF6v
         Kv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QQlbI4/cVI7lV7hmpd49lUjhwmM3E62iOV4cqjNwGn0=;
        b=XaQXpBROl4+y0To/o1ZLiiiwRpbh5iz8B3AJdUAZv0h+FODltPxt5kTb7CKKXvTJhv
         vhSarbzgY+pfwdvcZdsmTN+PVYx1C0SLSMxTXF2QSaAVSs1byZH8aWujxQ1tpKcQYGgA
         9iVp2SRQ6sqZUdvjGNMsKWHfTV9Le1HHaGg6swHupIdlbvYMDzt9XLxEgAXNzBO8b1Of
         702C+gx+Rhmwwt7tPJ35vfnyfZkkiXc12W3xAGCbN4ftIpWZ+ZL4e3qWWxBG9jtZCIaZ
         wShSx3RYDcEoN7alWbYyXVgjSD+dCDS5Q/kIbxQ3DWyLr73ySIbo2Gi155aBX41CeDbh
         j6lQ==
X-Gm-Message-State: AOAM533LcNFT0EksyzkCihlneFcUpvMOsSvUzfs2x5w7sIk7Y7C4+LnN
        4wdTZJ4hr2rihH1J0LA5qhGrjA==
X-Google-Smtp-Source: ABdhPJxfyoJZKVMcXhqJqChAKVrrr3Jvl4NNXruYQrn2aqulkTGhG/b+BXeWgex+ilGgkjRTgn29nw==
X-Received: by 2002:a5d:518b:: with SMTP id k11mr6387051wrv.369.1599210292051;
        Fri, 04 Sep 2020 02:04:52 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f17sm10323532wru.13.2020.09.04.02.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 02:04:51 -0700 (PDT)
Date:   Fri, 4 Sep 2020 11:04:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200904090450.GH2997@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-2-git-send-email-moshe@mellanox.com>
 <20200831121501.GD3794@nanopsycho.orion>
 <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
 <20200902094627.GB2568@nanopsycho>
 <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200903055729.GB2997@nanopsycho.orion>
 <20200903124719.75325f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903124719.75325f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 03, 2020 at 09:47:19PM CEST, kuba@kernel.org wrote:
>On Thu, 3 Sep 2020 07:57:29 +0200 Jiri Pirko wrote:
>> Wed, Sep 02, 2020 at 05:30:25PM CEST, kuba@kernel.org wrote:
>> >On Wed, 2 Sep 2020 11:46:27 +0200 Jiri Pirko wrote:  
>> >> >? Do we need such change there too or keep it as is, each action by itself
>> >> >and return what was performed ?    
>> >> 
>> >> Well, I don't know. User asks for X, X should be performed, not Y or Z.
>> >> So perhaps the return value is not needed.
>> >> Just driver advertizes it supports X, Y, Z and the users says:
>> >> 1) do X, driver does X
>> >> 2) do Y, driver does Y
>> >> 3) do Z, driver does Z
>> >> [
>> >> I think this kindof circles back to the original proposal...  
>> >
>> >Why? User does not care if you activate new devlink params when
>> >activating new firmware. Trust me. So why make the user figure out
>> >which of all possible reset option they should select? If there is 
>> >a legitimate use case to limit what is reset - it should be handled
>> >by a separate negative attribute, like --live which says don't reset
>> >anything.  
>> 
>> I see. Okay. Could you please sum-up the interface as you propose it?
>
>What I proposed on v1, pass requested actions as a bitfield, driver may
>perform more actions, we can return performed actions in the response.

Okay. So for example for mlxsw, user might say:
1) I want driver reinit
    kernel reports: fw reset and driver reinit was done
2) I want fw reset
    kernel reports: fw reset and driver reinit was done
3) I want fw reset and driver reinit
    kernel reports: fw reset and driver reinit was done

>
>Then separate attribute to carry constraints for the request, like
>--live.

Hmm, this is a bit unclear how it is supposed to work. The constraints
apply for all? I mean, the actions are requested by a bitfield.
So the user can say:
I want fw reset and driver reinit --live. "--live" applies to both fw
reset and driver reinit? That is odd.

>
>I'd think the supported actions in devlink_ops would be fine as a
>bitfield, too. Combinations are often hard to capture in static data.
