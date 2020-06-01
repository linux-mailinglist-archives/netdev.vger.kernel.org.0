Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC791EA187
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgFAKFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgFAKFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:05:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A86C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:05:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h5so4936289wrc.7
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TdhmXba773baCIUQ+26PD1+RamVAxSzeBPzXrmkTViQ=;
        b=ueh4cTY1jcW4+zC3sGKPTGe9NvzZTEBM4RpuL0Dgc7oyAuyQsFX2wLCQKFNzhEggf1
         3nU6SjceNIkEJZG2AD/r7BclfNGtFKqvZMzStyTvto5wCtIaEXdiQJyumOv9ylYvWFPK
         Ionznfdw9Ms6BiuonQUyhe620cCoK8Y7W7HfaVkLF2XnI9EhzTrEQ9P6fi6PonopCNPH
         yRZvUnxo9FVF+1n28t2uHvE0ndIaOvj/NMoCcxccKShTf1hQCTz3gnuemxEEz83I3Kil
         AeT+8hWCJocDVzaWQGqQTZRH1x34Ax9Q4fsqPZIrpkukH/hKBBNGuRrhQoPVoalT6E75
         Z1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TdhmXba773baCIUQ+26PD1+RamVAxSzeBPzXrmkTViQ=;
        b=S2PDhqFvuJVKGk5bpJyMF2fOt3aguJnZugf6fiKGf2B+bx6YiyPbMaSvd08url1HPd
         YkweDVShS9+EeLnyYZ9UUA7YYfIdhZTzhtym3A9vxHVvLpWKHJNZYcG+TlgXrtIgyeLO
         CcMkkSuxAD3T2WXs5POwSBzB8m45cMlzv4V+1oTUeVL/N15WKARYzwvIceOutO/CB4N+
         zUZXPTFURPcuV8wucz0o9kX8VTnO7zzS1T8AZeOnJc1K7nQpvwE5Qb2nEJ1bbu8NflZb
         sg+1n6xQWcCAImp44mtHxTXpEh1ktESeXvUlvpQiKkXuOwhXImDRIdK+WKLodY8WxZIm
         6Tpg==
X-Gm-Message-State: AOAM533UX9Mz9an/IqcKcutae3oGJyABI0eew8T+JtLl8yqi5bsZIbLr
        v4oG2g1jjlr2tQBPAhD8NLPZHQ==
X-Google-Smtp-Source: ABdhPJxvrkKSqcOEyMhCfW0Ft+ckMyvz8ifZ/aDCR5uyVGnFvqUOhtJJ8jo6jau+Y1iukukPj32MrQ==
X-Received: by 2002:a5d:500d:: with SMTP id e13mr22627260wrt.150.1591005912585;
        Mon, 01 Jun 2020 03:05:12 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id d4sm19628577wre.22.2020.06.01.03.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:05:12 -0700 (PDT)
Date:   Mon, 1 Jun 2020 12:05:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200601100511.GM2282@nanopsycho>
References: <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho>
 <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
 <20200601063918.GD2282@nanopsycho>
 <CAACQVJqvEmvrFywLP+67W0vLVJqgtuynUxvtfrSbUc8_mHkCUQ@mail.gmail.com>
 <20200601094935.GH2282@nanopsycho>
 <CAACQVJrhEoi__t+HtC1sx0SJF50QmiF8CqbyexEjFhi=Jnqt1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJrhEoi__t+HtC1sx0SJF50QmiF8CqbyexEjFhi=Jnqt1w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 11:57:28AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Jun 1, 2020 at 3:19 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 01, 2020 at 10:50:50AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Mon, Jun 1, 2020 at 12:09 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Wed, May 27, 2020 at 10:57:11PM CEST, michael.chan@broadcom.com wrote:
>> >> >On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> >> >>
>> >> >> On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
>> >> >> > Here is a sample sequence of commands to do a "live reset" to get some
>> >> >> > clear idea.
>> >> >> > Note that I am providing the examples based on the current patchset.
>> >> >> >
>> >> >> > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
>> >> >> > physical ports.
>> >> >> >
>> >> >> > $ devlink dev
>> >> >> > pci/0000:3b:00.0
>> >> >> > pci/0000:3b:00.1
>> >> >> > pci/0000:af:00.0
>> >> >> > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
>> >> >> > pci/0000:3b:00.0:
>> >> >> >   name allow_fw_live_reset type generic
>> >> >> >     values:
>> >> >> >       cmode runtime value false
>> >> >> >       cmode permanent value false
>> >> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> >> >> > pci/0000:3b:00.1:
>> >> >> >   name allow_fw_live_reset type generic
>> >> >> >     values:
>> >> >> >       cmode runtime value false
>> >> >> >       cmode permanent value false
>> >> >>
>> >> >> What's the permanent value? What if after reboot the driver is too old
>> >> >> to change this, is the reset still allowed?
>> >> >
>> >> >The permanent value should be the NVRAM value.  If the NVRAM value is
>> >> >false, the feature is always and unconditionally disabled.  If the
>> >> >permanent value is true, the feature will only be available when all
>> >> >loaded drivers indicate support for it and set the runtime value to
>> >> >true.  If an old driver is loaded afterwards, it wouldn't indicate
>> >> >support for this feature and it wouldn't set the runtime value to
>> >> >true.  So the feature will not be available until the old driver is
>> >> >unloaded or upgraded.
>> >> >
>> >> >>
>> >> >> > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
>> >> >> > perform "live reset" as capability is not enabled.
>> >> >> >
>> >> >> > User needs to do a driver reload, for firmware to undergo reset.
>> >> >>
>> >> >> Why does driver reload have anything to do with resetting a potentially
>> >> >> MH device?
>> >> >
>> >> >I think she meant that all drivers have to be unloaded before the
>> >> >reset would take place in case it's a MH device since live reset is
>> >> >not supported.  If it's a single function device, unloading this
>> >> >driver is sufficient.
>> >> >
>> >> >>
>> >> >> > $ ethtool --reset p1p1 all
>> >> >>
>> >> >> Reset probably needs to be done via devlink. In any case you need a new
>> >> >> reset level for resetting MH devices and smartnics, because the current
>> >> >> reset mask covers port local, and host local cases, not any form of MH.
>> >> >
>> >> >RIght.  This reset could be just a single function reset in this example.
>> >> >
>> >> >>
>> >> >> > ETHTOOL_RESET 0xffffffff
>> >> >> > Components reset:     0xff0000
>> >> >> > Components not reset: 0xff00ffff
>> >> >> > $ dmesg
>> >> >> > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
>> >> >> > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
>> >> >>
>> >> >> You said the reset was not performed, yet there is no information to
>> >> >> that effect in the log?!
>> >> >
>> >> >The firmware has been requested to reset, but the reset hasn't taken
>> >> >place yet because live reset cannot be done.  We can make the logs
>> >> >more clear.
>> >> >
>> >> >>
>> >> >> > 3. Now enable the capability in the device and reboot for device to
>> >> >> > enable the capability. Firmware does not get reset just by setting the
>> >> >> > param to true.
>> >> >> >
>> >> >> > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
>> >> >> > value true cmode permanent
>> >> >> >
>> >> >> > 4. After reboot, values of param.
>> >> >>
>> >> >> Is the reboot required here?
>> >> >>
>> >> >
>> >> >In general, our new NVRAM permanent parameters will take effect after
>> >> >reset (or reboot).
>> >>
>> >> Ah, you need a reboot. I was not expecting that :/ So the "devlink dev
>> >> reload" attr would not work for you. MLNX hardware can change this on
>> >> runtime.
>> >
>> >NVRAM parameter configuration will take effect only on reboot or on
>> >"live reset" (except few). But to enable "live reset", system needs a
>> >reboot.
>> >>
>> >>
>> >> >
>> >> >> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> >> >> > pci/0000:3b:00.1:
>> >> >> >   name allow_fw_live_reset type generic
>> >> >> >     values:
>> >> >> >       cmode runtime value true
>> >> >>
>> >> >> Why is runtime value true now?
>> >> >>
>> >> >
>> >> >If the permanent (NVRAM) parameter is true, all loaded new drivers
>> >> >will indicate support for this feature and set the runtime value to
>> >> >true by default.  The runtime value would not be true if any loaded
>> >> >driver is too old or has set the runtime value to false.
>> >>
>> >> This is a bit odd. It is a configuration, not an indication. When you
>> >> want to indicate what you support something, I think it should be done
>> >> in a different place. I think that "devlink dev info" is the place to
>> >> put it, I think that we need "capabilities" there.
>> >>
>> >Indication can be shown in 'devlink dev info', but users can configure
>> >this parameter also to control the 'live reset' at runtime.
>>
>> I'm totally confused. You wrote above that you need reboot (cmode
>> permanent) for that. What is the usecase for cmode runtime?
>>
>
>Okay let me brief it completely, probably some repetition.
>
>Permanent cmode, is to enable the "live reset" feature in the device,
>which takes effect after reboot, as it is configuration the parameter
>in NVRAM configuration. After reboot, if the parameter is enabled,
>user can initiate the live reset from a separate command.
>
>Runtime cmode, default value is true and available only when permanent
>cmode is true. This allows the user to temporarily disallow the "live
>reset", if the host is running any mission critical application.

Okay. I understand now. Thanks.
