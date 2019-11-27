Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA6D10A989
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 05:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfK0E6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 23:58:07 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:36832 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfK0E6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 23:58:07 -0500
Received: by mail-il1-f195.google.com with SMTP id s75so19883591ilc.3
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 20:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=hbTa4dDpVRcmH+86jgilAN4FABFPjPKgE94nTjec2xg=;
        b=JARBdIE9TCAJ/YybKemAthSrzfcTH0QwQsESRbFIdAcu4R+8wYZ1AOu9+SdTMSmhBf
         SkJ03Wd78qRVre4Zl0CuuEPzKfXaZLV6b57qTuR4mvq4lxHV4quEiSDjaFDLibgGByHp
         jXsBEtBJQ5DDFp12BCynz1ZRQ1zAaJOyYOM+01twoyM5gUBMKftI0xtQQC06SVIRAjSq
         S11cJUNDaPRFO2nGvkTKxkP+eRp6cmfzQ1RRuvUadO/+RSmHPqcpHoof+e8hGGMyCdLM
         zJcYp2IY/s9FxoYM9xk4WINp5Qa00B/8VKViu8yWvK3u6g+GuAouoXrh0f4TBdk7DMNe
         sBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=hbTa4dDpVRcmH+86jgilAN4FABFPjPKgE94nTjec2xg=;
        b=iGLkPXU2o0TITIPZaE9bANcXRbZBVxQm8V/KNbml5jcqGNqc742YaPjXRQD8I9A+BH
         1jF7f3ob7W4xJuP7YNOL00/gjm5w1K95Rs/p67Pr3Ep80PdHNP23TlBwup3Ho03aAAUI
         M5K0sIkhUqixIu24LA5kzbRlyTz2ODRIdVLb5R9Kb/GXrqMCydqZ0atJ5u3vy9qa4RR7
         neg5SffJ8lpxpKd3TDSVQirgP5IouW7xLMUtaMZnf9Qdp40BoJ4HmGda5xzGzq8AUVB2
         UwVEOkVSD9KPF4xpD81UupBcFsVvHtG2b6jK6gwsl62Eb/mL+tiLNm5FHSpcamcaHZ5s
         p5qw==
X-Gm-Message-State: APjAAAXMJ6NUVjbFx8Yt6qZDcyjW2oxYilXSL+/3CZGef9h7Np1VjIGf
        PLK7FS56PaG4Mb96CAvxGX70f9yRE4bDcL7vYP2DGA==
X-Google-Smtp-Source: APXvYqydvyq5QeffWSYDr842HeZr1MNLkHAujL9FXfE5q1LHdlU927Z9NWSjSxfmRZoUQw/pTaZD1d2MicepEYsL0CY=
X-Received: by 2002:a92:8b4e:: with SMTP id i75mr40452296ild.5.1574830684728;
 Tue, 26 Nov 2019 20:58:04 -0800 (PST)
MIME-Version: 1.0
References: <20191001171028.23356-1-pc@cjr.nz>
In-Reply-To: <20191001171028.23356-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Nov 2019 22:57:53 -0600
Message-ID: <CAH2r5mua0TiqAUVPu-h6hAnDnUYp90jfAC3QFFAT1aEku8AP3A@mail.gmail.com>
Subject: Fwd: [PATCH net-next 0/2] Experimental SMB rootfs support
To:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The coreq patches (network filesystem, cifs.ko) for this were merged
in 5.4.  Are the net part of the patches (two small patches sent last
a few months ago) queued for 5.5?

---------- Forwarded message ---------
From: Paulo Alcantara (SUSE) <pc@cjr.nz>
Date: Tue, Oct 1, 2019 at 12:10 PM
Subject: [PATCH net-next 0/2] Experimental SMB rootfs support
To: <netdev@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
<samba-technical@lists.samba.org>, <davem@davemloft.net>,
<smfrench@gmail.com>
Cc: Paulo Alcantara (SUSE) <pc@cjr.nz>


Hi,

This patch series enables Linux to mount root file systems over the
network by utilizing SMB protocol.

Upstream commit 8eecd1c2e5bc ("cifs: Add support for root file
systems") introduced a new CONFIG_CIFS_ROOT option, a virtual device
(Root_CIFS) and a kernel cmdline parameter "cifsroot=" which tells the
kernel to actually mount the root filesystem over a SMB share.

The feature relies on ipconfig to set up the network prior to mounting
the rootfs, so when it is set along with "cifsroot=" parameter:

    (1) cifs_root_setup() parses all necessary data out of "cifsroot="
    parameter for the init process know how to mount the SMB rootfs
    (e.g. SMB server address, mount options).

    (2) If DHCP failed for some reason in ipconfig, we keep retrying
    forever as we have nowhere to go for NFS or SMB root
    filesystems (see PATCH 2/2). Otherwise go to (3).

    (3) mount_cifs_root() is then called by mount_root() (ROOT_DEV ==
    Root_CIFS), retrieves early parsed data from (1), then attempt to
    mount SMB rootfs by CIFSROOT_RETRY_MAX times at most (see PATCH
    1/2).

    (4) If all attempts failed, fall back to floppy drive, otherwise
    continue the boot process with rootfs mounted over a SMB share.

My idea was to keep the same behavior of nfsroot - as it seems to work
for most users so far.

For more information on how this feature works, see
Documentation/filesystems/cifs/cifsroot.txt.

Paulo Alcantara (SUSE) (2):
  init: Support mounting root file systems over SMB
  ipconfig: Handle CONFIG_CIFS_ROOT option

 init/do_mounts.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/ipconfig.c | 10 +++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

--
2.23.0



-- 
Thanks,

Steve
