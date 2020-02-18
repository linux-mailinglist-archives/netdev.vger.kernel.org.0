Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258A416207B
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgBRFjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:39:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40274 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBRFjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:39:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id z7so10371440pgk.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 21:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pwdHtct+ptWRstDho1dMID8mXrS9C7Qu6D06pETqF6Q=;
        b=Ioao8a/g8USaL/zyqY08bbAeVre83jcbw/+NCZYCRYpgCYU/Nb0m67k8KQjnM/yX6t
         64peoCkk758RxmzjVU1Jqdn1hw4FDRSy8npreb9tUhx9E/7MWFGG80g7KsVl65a3oyfh
         yy07IZwcJzXpKLLe6zGtOajnEX7bm02PUzJPSCe4q+9meXSKP1XFfnDRkb4lRY16ALvC
         zmX9mkW3gDIir3/v0YrvmxGyFxAYHA8/4Kf6ZV3kCCHi9nrI9QfGzS89EaL+G29yYCZC
         nrYGn2OgFB2VRNJxSpnbgLTWZ39mjxpxK96qeI8Ul+vnPbzY0cixekdJoiYHhlM6QhC1
         ClZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pwdHtct+ptWRstDho1dMID8mXrS9C7Qu6D06pETqF6Q=;
        b=eccidR7UDvMaJWy69L2dPQSbuX36LVl0MnhbAh5JfR07iRSaw/Mf9/vJkVnL6Nhv15
         Dkulaeip7HQpdHglH4qy8F05JhH18LoLsqdTrP6SDt7WzW+rdmefBNVUHFE+M99si4Z4
         nnmi1kcgFpoyUl3kWMxTztiS4oLynuNNZc8+/UDXjRPFi2v9qoRC1MgfzK9/Iz9VQ+OD
         G6h9ImU2QJ0sZ1q4A3PQ0AW071Lwnez+Q+mfNSEq5WyKMJdxjEw3zWwD4UEvSUhqGshs
         7xNknVIxk9hnxCKMfTLns0Qd8xmA9VGt8MX+5vZNBcjNhvDC9bMovoRcdesgZFYhCCAV
         +DxQ==
X-Gm-Message-State: APjAAAU/UWQCRjSt6oB7poHfW/IS26UGHnXomi+EJCGlxyrjpeHG21xV
        MayJBKNzVRHcajUNMTWEKF4XoJTXMRE=
X-Google-Smtp-Source: APXvYqz1B/EZyS/ngYSY6tnuD/1sIIbaAaQKEYFTOz50WiKkUvwQ52fwm9gBlrZqPH+NLBPGpzR6JA==
X-Received: by 2002:a63:d441:: with SMTP id i1mr22067410pgj.426.1582004370884;
        Mon, 17 Feb 2020 21:39:30 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z10sm1030937pgj.73.2020.02.17.21.39.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 21:39:30 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:39:22 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206583] New: Aquantia NIC Suspend regression
Message-ID: <20200217213922.0ebd7b77@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 18 Feb 2020 05:13:38 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206583] New: Aquantia NIC Suspend regression


https://bugzilla.kernel.org/show_bug.cgi?id=206583

            Bug ID: 206583
           Summary: Aquantia NIC Suspend regression
           Product: Networking
           Version: 2.5
    Kernel Version: 5.5.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: silvaesilva@gmail.com
        Regression: No

Created attachment 287451
  --> https://bugzilla.kernel.org/attachment.cgi?id=287451&action=edit  
Kernel Config

When using 5.5 branch kernel my computer wouldn't go into the sleep state any
longer.

Trying to sleep would almost work but the computer never really "turned off",
keeping fans running. Trying to resume from that state was also absolutely
impossible, as it seems the computer didn't get to sleep, hence it was not
possible to wake it.

Bisecting identified 8aaa112a57c1d725c92dfad32c0694bd21b374d0 as the offending
commit, which makes sense as this is "net: atlantic: refactoring pm logic".
This was done directly on vanilla kernel tree.

Not sure how to exactly debug where the issue is in the code, but I can run
other tests as needed.

CPU: ThreadRipper 2950x
MB: Asrock X399 Fatal1ty

possibly relevant boot params
amd_iommu=on iommu=pt nohpet tsc=reliable

config attached if needed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
