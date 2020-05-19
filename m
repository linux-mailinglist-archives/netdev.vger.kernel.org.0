Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE4B1D8F28
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgESFYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgESFYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:24:04 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC9C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:24:04 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l18so14334462wrn.6
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X+FLDdorLQO46OV637APXfw4qzvEWGK5z2jSLLwoK7Y=;
        b=Wt74CKu4XkAIyu1x7Fxqj05WDllZA+UzP+hYzkwogFFc++obfxdhQDLEtNvhP1oWo1
         F7Ub2wBNkmtX0xE2VrKhDFVFMP4utXNe3MhE/n2Vr/WvTB0FSpEW3tR8wz0DJqjun4u0
         /d2xUEAJjSzoZNfCn6H+ItbdGkA1XVkcjY1+R5Z5lJ9Ir/jita0UPTTCddVgENtJyGqB
         JWAvmCawSz1LMGeTzCEuCZvFvKJjDiKiqw3VtV0X4rsngP6X04iJ8lBzJsdmgDOc2Hse
         GhqGQi+FoGBwco5Mpz7TEDh7sgQbIkTF2Cz3i0mR+C8OAEzoxETi15hgTOD3INQGaNr7
         6spQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+FLDdorLQO46OV637APXfw4qzvEWGK5z2jSLLwoK7Y=;
        b=GIZbIl0M4TKWjmx4Y1BpPqKULJnnB+DirKL/JMgLxk/hHc6wqMu0zZ4kdwxd1+P4wZ
         Odar3dbXo+cRMeud85dBqKeXmNkKW29lDW7zFqekNvDvw3mH0yO2+EYmpn1K8rI9kNVW
         43+Z9mOiZy0QyJACAhqAR01POxyAwpkbucS28OUuJHDUSd0YbbXNRlE4sJPnrK6Px+Gz
         WruIu9gmKG6Ds8ETUi+hXOImRMtQRDmFlhbvkO4+sJu5uFDvgbnibge9kaUHcDaqSuV2
         ByNHjxK0Q9mEgjfb5K7Ih88w3eahnZJsc4NP0FpLpH8xO3XRj1vAOz5313X3pbWDLFHA
         ORSQ==
X-Gm-Message-State: AOAM532b/E1o6RdT2hK8G7v2ZBYHvStogFZdwKbojW4K+ZX68vKq/Rew
        Bu/WGcV12Qno9zSN+9MnKHIbQF40aA0=
X-Google-Smtp-Source: ABdhPJy8scqPPVsjPry1cTNeyxaEJ5DNtjp3D7yv04EhSFk0faOMqdW4OqQ1YYbgQs+J/L+WXffrPA==
X-Received: by 2002:adf:a51a:: with SMTP id i26mr22663879wrb.332.1589865842176;
        Mon, 18 May 2020 22:24:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s11sm18965668wrp.79.2020.05.18.22.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:24:01 -0700 (PDT)
Date:   Tue, 19 May 2020 07:24:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519052400.GB4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <20200518164309.2065f489@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518164309.2065f489@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 01:43:09AM CEST, kuba@kernel.org wrote:
>On Mon, 18 May 2020 13:01:52 +0200 Jiri Pirko wrote:
>> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
>> >parameter and use it in bnxt_en driver.
>> >
>> >Also, firmware spec. is updated to 1.10.1.40.  
>> 
>> Hi.
>> 
>> We've been discussing this internally for some time.
>> I don't like to use params for this purpose.
>> We already have "devlink dev flash" and "devlink dev reload" commands.
>> Combination of these two with appropriate attributes should provide what
>> you want. The "param" you are introducing is related to either "flash"
>> or "reload", so I don't think it is good to have separate param, when we
>> can extend the command attributes.
>> 
>> How does flash&reload work for mlxsw now:
>> 
>> # devlink flash
>> Now new version is pending, old FW is running
>> # devlink reload
>> Driver resets the device, new FW is loaded
>> 
>> I propose to extend reload like this:
>> 
>>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
>>    driver-default - means one of following to, according to what is
>>                     default for the driver
>>    fw-reset - does FW reset and driver entities re-instantiation
>>    driver-only - does driver entities re-instantiation only
>>    fw-live-patch - does only FW live patching - no effect on kernel
>> 
>> Could be an enum or bitfield. Does not matter. The point is to use
>> reload with attribute to achieve what user wants. In your usecase, user
>> would do:
>> 
>> # devlink flash
>> # devlink reload level fw-live-patch
>
>Unfortunately for SmartNICs and MultiHost systems the reset may not be
>initiated locally. I agree it'd be great to have a normal netlink knob

I don't follow. Locally initiated or not, why what I suggested is not
enough to cover that?


>for this instead of a param. But it has to be some form of a policy of
>allowing the reset to happen, rather than an action/trigger kind of
>thing.

The "host" allows to reset himself by the "smartnic", right? For that, I
can imagine a param. But that is not the case of this patchset.


>
>Also user space notification should be generated when reset happens,
>IMO. devlink dev info contents will likely change after reset, if
>nothing else.

I agree.


>
>Plus this functionality will need proper documentation.

Also agreed.


>
>FWIW - I am unconvinced that applications will be happy to experience
>network black outs, rather than being fully killed and re-spawned. For
>a micro-service worker shutdown + re-spawn should be bread and butter.
>But we already have ionic doing this, so seems like vendors are
>convinced otherwise, so a common interface is probably a good step.

Hmm, not sure I follow what you mean by this para in context of this
patchset. Could you please explain? Thanks!

