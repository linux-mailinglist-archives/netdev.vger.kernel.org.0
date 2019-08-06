Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4968F833FD
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 16:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbfHFOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 10:31:54 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45243 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbfHFOby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 10:31:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so66880322oib.12;
        Tue, 06 Aug 2019 07:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=mRsJuqvbI6SyoD25uf83ShcXx0a/DNaI7q9ymEAEVyc=;
        b=eU6JjZPN1qTreBUTPlh7utNRgqNJcNAfmsqAMjcaVswhhVuAN6s/UGkd+x5kwUoD9h
         UlbiZXKMyloARs+IKU5gcXgSiICSh2w3SB3LALeyOWlha27iqcqvxxyujOhkOTsqJa83
         DBj1be/Qd/EP4lj51ZqZ+OC/lAfT1URgVGIsNXGsntOyd1kbVQ9AyRR9jiXWHKIn7DYv
         UaIqX/MuXROM+O1qRCcVgMh+ULM2Ffx+rGUNBL5kNcucBOTu8XORiOHd/A+k+YosfAQ0
         vtBoGn81r2iB34cYZ6MpF34C9Ul+JlXqYmSsqzqq6QUHCR1qEf5UpRtI52225CVpq7N8
         OjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mRsJuqvbI6SyoD25uf83ShcXx0a/DNaI7q9ymEAEVyc=;
        b=H3X/F79nnMfB7PY+Mg/m2oUzmq+/+H9GkjLpDyoBWS5S4FRYpzM8nWaEZAvNtkqlhe
         SPDaMqqQMnP+Z7jxtb+ISLYlJxb0wbX5pozk6H2zhrO8JGg+FYXhb3JNA7GH3ATZM441
         7agOSVy/WZ4uZuITgvkeJM/voGKjYUQCiz32aSP/hnl4cXTiNc4mLB+EiKY36hgwQhfq
         JdyWSUeDMMGhNz8ra3no/gQHjAWs5AEJjfj8c3W4EKjKPQD57Kit6XtbHiE6bm6xmrFR
         SO/UY0hkasgqdZcjgE2rDVwoDfZcvE9ftRlVxvlWj/15LWHp9K4vfvs0oUo0ECdFvKi0
         AbXQ==
X-Gm-Message-State: APjAAAWltDbi7VTjj09A9Tvt7pMQGRMxhPiqC8eccjwD7l4+I0QZnN9a
        1ODZXLEXq726/rc5rq9G/JTOPJGPuYxANdVqBxJJ9t4=
X-Google-Smtp-Source: APXvYqzfN5wxo8W3llD9Sh1nlweb/1gOpvvOG7t5gCQ4mAbIK8hvP+7dFRao/uXZoKHdgajaZrhWCLZhA99OmSMBg40=
X-Received: by 2002:aca:dd04:: with SMTP id u4mr1154017oig.152.1565101912904;
 Tue, 06 Aug 2019 07:31:52 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6rOg7KSA?= <gojun077@gmail.com>
Date:   Tue, 6 Aug 2019 23:31:41 +0900
Message-ID: <CAH040W7fdd-ND4-QG3DwGpFAPTMGB4zzuXYohMdfoSejV6XE_Q@mail.gmail.com>
Subject: Realtek r8822be wireless card fails to work with new rtw88 kernel module
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I recently reported a bug to Ubuntu regarding a regression in wireless
driver support for the Realtek r8822be wireless chipset. The issue
link on launchpad is:

https://bugs.launchpad.net/bugs/1838133

After Canonical developers triaged the bug they determined that the
problem lies upstream, and instructed me to send mails to the relevant
kernel module maintainers at Realtek and to the general kernel.org
mailing list.

I built kernel 5.3.0-rc1+ with the latest realtek drivers from
wireless-drivers-next but my Realtek r8822be doesn't work with
rtw88/rtwpci kernel modules.

Please let me know if there is any additional information I can
provide that would help in debugging this issue.

Best regards,
Jun


Link to GPG Public Key:
https://keybase.io/gojun077#show-public

Backup link:
https://keys.openpgp.org/vks/v1/by-fingerprint/79F173A93EB3623D32F86309A56930CF7235138D
