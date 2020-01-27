Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46214A563
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgA0Nse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:48:34 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:33378 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA0Nse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:48:34 -0500
Received: by mail-pg1-f174.google.com with SMTP id 6so5197073pgk.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoaWgFtYMoaRQSl5S0bnZtKcySZ6Lf8iycKLLFT9xEQ=;
        b=PXFenjatoZXrZ+evz8As05GYsNZnpCzjnU4Df0WkZuSrId9J18vqPnrEOt/yj4vrsI
         hFLnJ/ZC1fDz8yA2Kg3MSD/28m3lUWXD64onrTXwvAxHkq7c8r74ubaclg9/vdm+PIb3
         KRNfMZf/vEqvHzvzvEwaNEFJ3b7G5SoSAhcjaR45w+UsUgD24x6mIzEFrZs4o/qZKATU
         6lh4Vm6tswosXbq4Uq5kHkEMv+ujy1WbOJ9oOqkVoUeUuiWbiw1GkPX7UVlF0DZnzVYR
         dcEps+pZspdG4vIXxP9q2JbdF5sE2Pb2NODQC400Y7k2cC0gIOI6Ol6E6HO+zA45luqR
         ugPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoaWgFtYMoaRQSl5S0bnZtKcySZ6Lf8iycKLLFT9xEQ=;
        b=MNEkU+cyo+hI+KWIvp80deibZmgjrsMRUGO3v9Hm/FaERUZj0jHH1CXa5jMmepj0CO
         UPCB9NekQKysEIiIBOLhQm/DvhElMkH+m2v0OJHRDy/wCoTb4rXD145n12Tg6XoepEne
         8xcX1VDL/thRiQ5ihhkbFn9Z3mA57uEjwmSCbNLXCxrqXzWfGT7T+kiiYMUZqSe8CKuN
         3qvH9j2s0aW3nzdxcpZ0WZHCUeQxGVCD25zUDUpT735PkH21yLpWuqUsxC6e1Ap2CwKW
         UCCmutay5rGvULOJML3zbxWcP3PSX79j8mHXBIOtpHemtS0wB0AHVwhkd4WCt3sXSrQo
         /uIA==
X-Gm-Message-State: APjAAAWG8xDvxHw8F8V28up68odcsEUEB492QGF9PqxDJNnsZEtPCcmq
        tV2CBmfLFXRup4veSdcHKo5GEJv9x40=
X-Google-Smtp-Source: APXvYqwSmLg/BTEy4Dn8qLAcAaVyeOvTx3qkXTr8t1RNwt7Ywkk3vQJ9xF+NTL7sxi6XoecSU4gnqA==
X-Received: by 2002:a65:680f:: with SMTP id l15mr20361258pgt.307.1580132913301;
        Mon, 27 Jan 2020 05:48:33 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l14sm16242248pgt.42.2020.01.27.05.48.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:48:33 -0800 (PST)
Date:   Mon, 27 Jan 2020 05:48:30 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206319] New: ECN header flag processing overly restrictive
 in TCP
Message-ID: <20200127054830.53973d51@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 27 Jan 2020 08:15:36 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206319] New: ECN header flag processing overly restrictive in TCP


https://bugzilla.kernel.org/show_bug.cgi?id=206319

            Bug ID: 206319
           Summary: ECN header flag processing overly restrictive in TCP
           Product: Networking
           Version: 2.5
    Kernel Version: HEAD
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: rscheff@gmx.at
        Regression: No

RFC3168 states, that a CWR flag "SHOULD" be *sent* together with a new data
segment.

However, linux is processing the CWR flag as data receiver ONLY when it arrives
together with some data (but apparently does accept it on retransmissions).

This has been found to be an interoperability issue with *BSD, where the CWR is
sent as quickly as possible, including on pure ACKs (or retransmissions) so
far. That deviation from RFC3168 there is reported at
https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=243231

Nevertheless, CWR processing as receiver should be less restrictive, to meet
the sprit of Postels Law: "Be liberal in what you accept, and conservative in
what you send."


This has been demonstrated to be a dramatic performance impediment, as the data
receiver (linux) keeps the ECE latched, while *BSD interprets the additional
ECE flags as another round of congestion. To which the data sender reacts by
continous reductions of the congestion window until extremely low packet
transmission rates (1 packet per delayed ACK timeout, or even persist timeout
(5s) are hit, and kept at that level for extensive periods of time.

Discussed this issue with Neal and Yuchung already, this bug report is to track
the issue in the field (impacted environments).

-- 
You are receiving this mail because:
You are the assignee for the bug.
