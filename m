Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FDB399276
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFBSWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:22:38 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:29967 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhFBSWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:22:37 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622658046; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Dnv6Zd0x2O+zPySRXL8hN8477p3a+5eqapxvRGGy9zYNo5BL3g5uUm4r652p//tTHX
    Gv4wcmi6HsQp38oM19v/Ca3S7GIw1ssO6JkNSs1N5X5O/c5fJXioTxdgrJQbImsFofqU
    EzXmrvzt4SjvbJwfoPTRyUKfynfjMRDCCyUZ58r0+i1Y11QtT7FxKLOcbHRNo2xYDYrd
    8xu93fdfEyS4TAkChOMdvf+2mFyHa1VfIODuc835vLLdRA4rz4p42tdgUmNtLbOkt8u1
    5IYH4TXQ0Qj/XCsdw0t4gtR9NI4q2eMVsmRGFtxHBuWCy8HFtEFBnuVvxIQYgxim5/lx
    KvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622658046;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Subject:Cc:To:From:Date:Cc:Date:From:Subject:Sender;
    bh=X+Gz72sgyUdYPaoqa1CcfhpaKdASKYvgVweEbD/2rEw=;
    b=ABVo8KGP+ByL6zZC9faDRz40GGDSUlzQwxJt00eGSclMK4kRKWkOH3zBVzE2BzTd0J
    ovh87wTDnq0uHy/5hY2E8RHcXVqDDTyha75fFgVVvD2ItHHSVbbfRXDhRmsAeoZudiEx
    iM4vj5aPLMul7bpitJ3l/EThVHpYmngBX1ksHyh81o+PIpPAsfbvanvC9YHUP1Ni/UTw
    wJK6MXITQjokpJxn1s9qYMqDjv6SeosqmIrvZ5yrBjD8FjkNXyRl1XRMlxgrGi2/8uzC
    xvOvvCzIdgr5+Tru9mz9dg5FEDVNmJqWbrrIFjpTk+0Wb3ctjSJLxQHeoQMOffDlqpT3
    vQyg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622658046;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-ID:Subject:Cc:To:From:Date:Cc:Date:From:Subject:Sender;
    bh=X+Gz72sgyUdYPaoqa1CcfhpaKdASKYvgVweEbD/2rEw=;
    b=MyiTl0g5NWm6kfklxZLwobNyst69dNgzGnvltjMS2Tv8LnTS/yg0E+MLDYJ0+tvg1/
    lsKSTjj9cV89+33Ol5Ura8xnSUCdc2g9Lvmyt+JTlMSK0iwL7ztySy15g9uRw4aH+vpA
    3ydQXwQ3BE2fZjop0u3Cc0PctoM36iTmNZfeoXT+SUr0sNjTDMDCp4nnz66UrIEBitcW
    VFAfn2HWQ2HoXRKJJDWidYCVQCFHAfiRcgXGhxEes4ydiqL56+NmVwRY7sb+VND88mUH
    VOprifhXNb/DJjXC+rIi36nYS+tr6xUpb9YyGhxbEn9oGDdxFjJx4NiBeihZ12A4eO/o
    tetQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6IcjHBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x52IKj3vC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 2 Jun 2021 20:20:45 +0200 (CEST)
Date:   Wed, 2 Jun 2021 20:20:37 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [RFC] Integrate RPMSG/SMD into WWAN subsystem
Message-ID: <YLfL9Q+4860uqS8f@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic, Hi Bjorn,

I've been thinking about creating some sort of "RPMSG" driver for the
new WWAN subsystem; this would be used as a QMI/AT channel to the
integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.

It's easy to confuse all the different approaches that Qualcomm has to
talk to their modems, so I will first try to briefly give an overview
about those that I'm familiar with:

---
There is USB and MHI that are mainly used to talk to "external" modems.

For the integrated modems in many Qualcomm SoCs there is typically
a separate control and data path. They are not really related to each
other (e.g. currently no common parent device in sysfs).

For the data path (network interface) there is "IPA" (drivers/net/ipa)
on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
I have a driver for BAM-DMUX that I hope to finish up and submit soon.

The connection is set up via QMI. The messages are either sent via
a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).

This gives a lot of possible combinations like BAM-DMUX+RPMSG
(MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).

Simply put, supporting all these in userspace like ModemManager
is a mess (Aleksander can probably confirm).
It would be nice if this could be simplified through the WWAN subsystem.

It's not clear to me if or how well QRTR sockets can be mapped to a char
device for the WWAN subsystem, so for now I'm trying to focus on the
standalone RPMSG approach (for MSM8916, MSM8974, ...).
---

Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
(drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
I just took that over from someone else. Realistically speaking, the
current approach isn't too different from the UCI "backdoor interface"
approach that was rejected for MHI...

I kind of expected that I can just trivially copy some code from
rpmsg_char.c into a WWAN driver since they both end up as a simple char
device. But it looks like the abstractions in wwan_core are kind of
getting in the way here... As far as I can tell, they don't really fit
together with the RPMSG interface.

For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
(non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
get notified when the TX queue is full or no longer full so I can call
wwan_port_txon/off().

Any suggestions or other thoughts?

Thanks in advance!
Stephan

[1]: https://elixir.bootlin.com/linux/latest/source/drivers/rpmsg/rpmsg_core.c#L151
