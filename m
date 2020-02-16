Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73572160529
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgBPRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:43:16 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38471 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgBPRnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 12:43:16 -0500
Received: by mail-pj1-f65.google.com with SMTP id j17so6165531pjz.3
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 09:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=MFSwZodgDo38vB2tJltuq7c8nMLmxTmr/Vm2jQyAZV0=;
        b=JKHMI7ZoXPhvlUq+KrFwJ9NR8VOkbnv57L8/wkeHQ2omb7tSG6WB/oqGpljnJMJA4J
         i4pz24MZXBE3IicWISrm4fN0dCs0+FOmURD6blS5eYEd6WmwZAbM1dY80yup3pQn6kJc
         ac6aM7lLp8mWtA9RlfdVH4bkDv9Icd1ijdYCdC8VK6rKLpPBlzB5dl0gxkQCmoZ2GhDs
         g/hTOHwNw2hdapQmORXA0Ao7bD/QSn5/XFGAOcNLqSONhKwM/N+DGzvxXBvBFVQHndot
         /tKpAPmf0Bjjzu9pDBB3TWSgxua5sxtoUIXNToMSqnQl5j4xL+PVpGfO7ahvq8ID3Vc3
         72/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=MFSwZodgDo38vB2tJltuq7c8nMLmxTmr/Vm2jQyAZV0=;
        b=lt4hY9PaDZnyX1cG7uXzPJF7ZdalgemF19p/vtXQ53yG0PoIQaiL+8I1FK0oE0nTuB
         iHrCThmgcM/SaQF7BDKwA6OLjFanels39M0JG2Ymlvju8/3NZCY+8tPiOeLfNfA5jKQ+
         QB/hSDsAN3wkrsdr+61k5fWhPtsVPq1KolnYhzARLbrq6y+CjsXHhXjf1kanTOBg+HjW
         1DS4KKyxDuyZGx5WoISmDuv60sIDZmliLmJi2DvKPOpDPof6ZpIeegBQ8hTIS18nd8hY
         NGE7G+buXdu1Ca8dqXGln30eqeA5NtAUg1Ob5WVGeOdHkbrwhgEJfJhRhHZU6YV/stlP
         dL+Q==
X-Gm-Message-State: APjAAAW22QHwXgnFZ+EBUQpUdRt/D6WLg+mm1eIuJmXCJDrCnEdlA2vO
        OGWVy7QO5JES+L+b5BPXbOwKTujA36Q=
X-Google-Smtp-Source: APXvYqzjdm/6/AxB2UwpzrxE07UupxSGM7tPnGr4C4KEGGnZwD80isxt63YPZSfvqPnysmjy+Kv3CQ==
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr12708984pls.127.1581874995216;
        Sun, 16 Feb 2020 09:43:15 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d26sm13860517pgv.66.2020.02.16.09.43.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 09:43:14 -0800 (PST)
Date:   Sun, 16 Feb 2020 09:43:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206523] New: Can no longer add routes while the link is
 down, RTNETLINK answers: Network is down
Message-ID: <20200216094307.55a66c52@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 13 Feb 2020 18:04:40 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206523] New: Can no longer add routes while the link is down, RTNETLINK answers: Network is down


https://bugzilla.kernel.org/show_bug.cgi?id=206523

            Bug ID: 206523
           Summary: Can no longer add routes while the link is down,
                    RTNETLINK answers: Network is down
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.19
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: rm+bko@romanrm.net
        Regression: No

Hello,

I'm upgrading my machines from kernel 4.14 to the 5.4 series, and noticed quite
a significant behavior change, so I was wondering if this was intentional or a
side effect of something, or a bug. It already broke my network connectivity
for a while and required troubleshooting, to figure out that a certain script
that I had, used to set up all routes before, and only then putting the
interface up.

On 4.14.170 this works:

# ip link add dummy100 type dummy
# ip route add fd99::/128 dev dummy100
# ip -6 route | grep dummy
fd99:: dev dummy100 metric 1024 linkdown  pref medium
#

On 5.4.19 however:

# ip link add dummy100 type dummy
# ip route add fd99::/128 dev dummy100
RTNETLINK answers: Network is down
# ip -6 route | grep dummy
#

Sorry for not narrowing it down more precisely between 4.14 and 5.4, but I'm
sure for the right people this will be easily either an "oh shit" or "yeah,
that", even without any more precise version information :)

-- 
You are receiving this mail because:
You are the assignee for the bug.
