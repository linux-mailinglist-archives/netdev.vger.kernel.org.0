Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6569A1534A5
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBEPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:54:27 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33976 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgBEPy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:54:27 -0500
Received: by mail-pl1-f174.google.com with SMTP id j7so1051689plt.1
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=s16cKOha/WmNeVqgsvbjgtz46PQ9yGFvkksbjqo4wH4=;
        b=KThhVkJ0QZvS8MuxnbnPEL8FDWpr6HJ6vdEiJ3L0wteFBuF728uQdkaKhp3RA9mDO4
         CnmusEAXv2f89pUHN5gkc9Y/Jt72gjx8rRWmma9pHW/i/5Pyg96doOM9RspfKLI3+Kio
         uFNX2jnkwsSEgKUydbBpO+8/kv3K7Ve4gzxdBSMmJg8CGZxez0gZY9xUZ2u4eVbkaCIS
         1ijq7R2951WoDvjhwZv0u55tDRtTsUIWQusNID1b7w75i7tnrtitK8c+PM22AEoChZw1
         nm6ugt69iZteu+Sq++Gg240OyZup9/zKYSbJpQ7OfYfrRBRd/di99eKWgsRupJuwc8E8
         0AMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=s16cKOha/WmNeVqgsvbjgtz46PQ9yGFvkksbjqo4wH4=;
        b=YMjZoKO4OMqAdJWxKSy6jswtXuyyYzROi4zG7IwUr5O8+OZYdBIozq5/xKio6UvzaE
         ShQLiG7/urp5MFRIBmRRuqikzW73AHEdsHWHCKigN/JRQWH1BdvxnG/BjkfKugs7/iyq
         hCO8PpdNmZPN78bjHnuL+YIG7qqvLjV3htD13fnkGI/+gZXa2YxVyRYmPuRyU3+cWRpW
         Ppds8T9y3Fz8HbMwVQ80+PfhSHlWgacU3vtrFoYU6oOhUzbj0Nr8Hf9DP5qaJ9ivZp7k
         yTDVNWNEUUQNx0+0X4q4e1ToIL4p1QBD5BSOXW8MscjQYSpZH+Uo//ALSsLniqYPA8Tb
         5W+g==
X-Gm-Message-State: APjAAAU5DEZkiwJhO/LsjN4fORRQHxp8pAI3GWZvLUkj4uHnhx8s5xXw
        rze6fvmyVQtvwwZ8QA3q6UHCbYKQRE5SNumeNxWQG8IfcFs=
X-Google-Smtp-Source: APXvYqyQNFsBTh5FcRQDXjkbTWLmC146xDMJHwzLugnrp17XD3yw4BDj9NuT++T1yiEU36Wekr1xeuE8tiqAiH4pEIg=
X-Received: by 2002:a17:902:6a84:: with SMTP id n4mr35375445plk.294.1580918066636;
 Wed, 05 Feb 2020 07:54:26 -0800 (PST)
MIME-Version: 1.0
From:   Farhad Jahangirov <farhad.jahangirov@gmail.com>
Date:   Wed, 5 Feb 2020 15:53:56 +0000
Message-ID: <CAFJOEto0PBVe-c6w9wx8mNxjNy3=E_kU12Ej05c89VXi7ZKo2Q@mail.gmail.com>
Subject: AX88179 driver is appending a two-byte VSS Ethernet Monitoring
 trailer to every IP packet
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver for AX88179 USB 3.0 to Gigabit Ethernet adapter appends a
two-byte "VSS Ethernet Monitoring trailer" to every IP packet.

Issue observed on 4.15.0-76, 4.19.93, all the way up to
5.5.0-050500-generic #202001262030.

The manufacturer-supplied driver from
https://www.asix.com.tw/download.php?sub=driverdetail&PItemID=131 does
not have this issue.

This is the same issue as reported earlier here:
https://bugzilla.kernel.org/show_bug.cgi?id=121141

Please let me know if I can help with more information or anything else.

Kind regards,
Farhad
