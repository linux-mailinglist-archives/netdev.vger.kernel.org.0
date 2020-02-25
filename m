Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4316BE21
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgBYKBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:01:11 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35744 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgBYKBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:01:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6X1R-009J5d-Rp; Tue, 25 Feb 2020 11:01:01 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, Alex Elder <elder@linaro.org>,
        m.chetan.kumar@intel.com, Dan Williams <dcbw@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [RFC] wwan subsystem
Date:   Tue, 25 Feb 2020 11:00:52 +0100
Message-Id: <20200225100053.16385-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

So I figured it's better to finally send this out rather than think
more about polishing the details or fill in the blanks.

Clearly, there are a lot of blanks, and while today we can identify
netdevs that belong to WWAN devices (for the most part) using the
"wwan" device_type, this isn't really possible with any of the other
bits.

In the first (and only, for now) patch I describe more as to what
this really does and why I think it's needed. Despite being small and
simple for now, I think it presents a step forward over the status
quo.

For the netlink interfaces here, I suppose we need to write a small
library or tool to manage things, though I'm not sure if that perhaps
should be part libmbim or such.

Clearly, however, more communication channels than just netdevs will
be necessary, most devices at least also have a number of TTYs (or
similar) for commands, and many will offer some kind of debug/trace
channel, where I'm not sure how it should be exposed by default
(perhaps a debugfs/relayfs file/channel?)


Some have said I shouldn't work on this because I haven't bothered to
read all of the 3GPP specs, but I think that's a distraction; we clearly
need a way to manage these things, if the 3GPP specs were actually
saying something useful, we wouldn't have ended up with at least three
different ways in the kernel already.

johannes


