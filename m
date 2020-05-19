Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA41D8F33
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgESF1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgESF1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:27:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C0FC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:27:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z72so1914634wmc.2
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LzWhAE6ZmiwxBtLnsbXMaC6Duret3m6KxoryoU3LrcQ=;
        b=x/VJfviDMvJYoIPrK7oB+DfGkjsLw6N62oFSllGUCZkyeKTYTcOlW5r686/C+8KWkT
         FsBNmlmf6/06wP88+8LmrXY4Yi/kUQJ3/XRJMOtf4iQZIyPZAPk5GE7ZRJ7caqAh54HQ
         NNRRTQ2CLv7VWijEu/UsyO6Bc1vH+dmXGka3bY5U1zNSxGPaAFhU3aYwuqVgt4OKHV7A
         BdWCuTFusOsIusYfrQJClINoaVzmkJMCdT3ICACVmIKoHUdWCE907RQQd/EBj1w0T3Uz
         vFNrqGLo3I49n+Cgo5B4DbaZnjcqheamTOQGsqgs5FJkw50WQnpXxlv2O2D/OJziUR9t
         JtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LzWhAE6ZmiwxBtLnsbXMaC6Duret3m6KxoryoU3LrcQ=;
        b=GzWLcS1JkEt4AQSXP/pNiwJzUNKyfmH701GtlQyD0X3r0JRQN7zK2uJLD2XSebz6iC
         BBECj7htZQ8RVUvM99Junb5LoKS/pgHcuvyze/OF8uS+V6U3NjjH+QhBQ18QOzVzdljQ
         MYAYnra1JgdcaMrxctJ+zF3axviEiqjfU7i9rGQ8Ig2Hzzeu+wimN3I5/ln5S25ait05
         6UsRd5cp+On6NMtjXZtG+cpZqMhuIrKE4XVGpLgyJ4yiMxi2Duy5/oRlYuFvZ6ZWp9v/
         yjYQFZSwoJLJ126PtLfj5czKNHbzUJ3ekVhvRpR7Cx51uKpV9hTbG/NPAsLHpqqBudWO
         6meg==
X-Gm-Message-State: AOAM531SvXcex8nb+Bbb+UQXehA765t1sG4Dccrn5hiE55R8OK7esng6
        /Jmq7cqYNDcPmsyfz4+KA1r7hQ==
X-Google-Smtp-Source: ABdhPJyvz5GFu8q8Ujgcd3XkqTtuMWNVesupm//Fh99MdFZwwv5hLr6tb1HicKrMr+W6XS0mF9FX1A==
X-Received: by 2002:a1c:444:: with SMTP id 65mr3340878wme.21.1589866066592;
        Mon, 18 May 2020 22:27:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b14sm2427082wmb.18.2020.05.18.22.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 22:27:46 -0700 (PDT)
Date:   Tue, 19 May 2020 07:27:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519052745.GC4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 06:31:27AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, May 18, 2020 at 4:31 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
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
>Jiri,
>
>I am adding this param to control the fw hot reset capability of the device.

I don't follow, sorry. Could you be more verbose about what you are
trying to achieve here?


>Permanent configuration mode will toggle the NVM config space which is
>very similar to enable_roce/enable_sriov param and runtime configuration
>mode will toggle the driver level knob to avoid/allow fw-live-reset.
>
>From above. I see that you are suggesting how to trigger the fw hot reset.
>This is good to have, but does not serve the purpose of enabling or disabling
>of the feature. Our driver is currently using "ethtool --reset" for
>triggering fw-reset
>or fw-live-patch.
>
>Thanks,
>Vasundhara
