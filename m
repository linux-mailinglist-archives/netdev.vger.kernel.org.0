Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59101D99A5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436663AbfJPTCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:02:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46762 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436617AbfJPTCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:02:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so15272777pfg.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 12:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Qr0t+NTcC5sxoHGmto32SX9UNDxE8l9O7OidTB5u+Lg=;
        b=QENq0Y8+Ks31dL7ms3qQNiOgv1VmwCbKTmjVoxC6Lgs6JnRhTvhe/jIkoHauloii3D
         8DeRt1rXnBvxdMc8ai/VjKTCEeXm2w83RaB9Be1oN5UkUWko5Ysttz/a73qOkFf6JVDj
         8X8LNDx6lHufaMMbm+LY+G7jZ+zgARmOaSElwsNr7EJESpt1fMiIJ7vV3lhlptpLy5IZ
         Sc0HbpyT1vU3uJ1TSzXEvVsmb4+i7Evo1dfX9E5KZyOogWIFSQVZ9qOZRXtDJVv0aqIm
         QFaOgS02AKg53/p0/coNc60dv4NbfGLlIK48ejnidCDsCUdzn4MArN87qlTikJvILZo1
         lk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Qr0t+NTcC5sxoHGmto32SX9UNDxE8l9O7OidTB5u+Lg=;
        b=qBduGkKwWUQCbkxqEhuEmHZUtpLTgU9IJrnHrozy1eORDJ6fMCQaEJUew5dx6Slmfj
         wDqcISSOxmEgX+roHUk9DGVLveE79RUR7PoSqinNwIMwiOJ4mI3EIBsv/iPAoraoy9ZK
         /BLCbz3yG3GQ4r5jdkzQ6/N4KNEuExzYfQ/qLz0jxnJvCm0VTWTNxl4GSxLb4jq6C4su
         lWOe/48dcrvFF6SJWRrb/RlGEAfPERXaQ20mOEFnY7Qw1s0CKxkPgisV/8mj0wxbjquU
         NpS+HjyJAJMeRT8gJXOO6gUpD+gqH0a8wy8us2ptuJ6n2YYyXPvmdyq4lOH6ivZOVlcK
         9m9A==
X-Gm-Message-State: APjAAAUYU2cobDlQ3X6A5L8t9N6/xWxvzAJ7yYM3EqlGBi1Vw8Pv3Em5
        XY3hKlHw8TC58KQemPeL9sxxsZ/W/yBkIw==
X-Google-Smtp-Source: APXvYqxlHdw/EBVSDg1Wsp/QHAEfl2Or5AucAa5oqWJ6ZHUXHZSeKytmxXbbSznNbYLKnlJ9DD2amg==
X-Received: by 2002:a63:4b0f:: with SMTP id y15mr47771236pga.161.1571252525464;
        Wed, 16 Oct 2019 12:02:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c62sm33923248pfa.92.2019.10.16.12.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 12:02:05 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:01:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network driver
 issue
Message-ID: <20191016120158.718e4c25@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 16 Oct 2019 18:57:44 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network driver issue


https://bugzilla.kernel.org/show_bug.cgi?id=205215

            Bug ID: 205215
           Summary: Amiga X5000 Cyrus board DPAA network driver issue
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4
          Hardware: PPC-32
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: madskateman@gmail.com
        Regression: No

Hi all,

It might or might not be a bug, but help would be very welcome. 

Me and all other AmigaOne X5000 users (Cyrus mainboard with Freescale P5020
cpu) are not able to use the DPAA onboard Ethernet adapter with the linux
kernels since the last two years (AFAIK)
(link to the board: http://wiki.amiga.org/index.php?title=X5000 )

So what is happening,

First of all the hardware is functional. When using AmigaOS4.1FE the Ethernet
adapter is fine. When using the adapter within U-boot (ping for example) it is
also working as expected.

When booted into linux the ethernet adapter does not get up. 
The output of DMESG is:

skateman@X5000LNX:~$ dmesg | grep eth
[ 4.740603] fsl_dpaa_mac ffe4e6000.ethernet: FMan dTSEC version: 0x08240101
[ 4.741026] fsl_dpaa_mac ffe4e6000.ethernet: FMan MAC address:
00:04:a3:6b:41:7c
[ 4.741387] fsl_dpaa_mac ffe4e8000.ethernet: FMan dTSEC version: 0x08240101
[ 4.741740] fsl_dpaa_mac ffe4e8000.ethernet: FMan MAC address:
00:1e:c0:f8:31:b5
[ 4.742001] fsl_dpaa_mac ffe4e0000.ethernet:
of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e0000) failed
[ 4.742203] fsl_dpaa_mac: probe of ffe4e0000.ethernet failed with error -22
[ 4.742382] fsl_dpaa_mac ffe4e2000.ethernet:
of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e2000) failed
[ 4.742568] fsl_dpaa_mac: probe of ffe4e2000.ethernet failed with error -22
[ 4.742749] fsl_dpaa_mac ffe4e4000.ethernet:
of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e4000) failed
[ 4.747328] fsl_dpaa_mac: probe of ffe4e4000.ethernet failed with error -22
[ 4.751918] fsl_dpaa_mac ffe4f0000.ethernet:
of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@f0000) failed
[ 4.756660] fsl_dpaa_mac: probe of ffe4f0000.ethernet failed with error -22
[ 4.763988] fsl_dpaa_mac ffe4e6000.ethernet eth0: Probed interface eth0
[ 4.771622] fsl_dpaa_mac ffe4e8000.ethernet eth1: Probed interface eth1

There has been already spend time and effort but the issues still remains..
(
http://linuxppc.10917.n7.nabble.com/DPAA-Ethernet-traffice-troubles-with-Linux-kernel-td132277.html
)

I might have found something that could point into the right direction.

The last few days regarding another issue i stumbled upon this post from Russel
King. It had to do with coherent DMA
(http://forum.hyperion-entertainment.com/viewtopic.php?f=58&t=4349&start=70)

"Hmm, so it looks like PowerPC doesn't mark devices that are dma
coherent with a property that describes them as such.

I think this opens a wider question - what should of_dma_is_coherent()
return for PowerPC? It seems right now that it returns false for
devices that are DMA coherent, which seems to me to be a recipe for
future mistakes.

Any ideas from the PPC maintainers?"

I started to dig around regarding DPAA ethernet and Coherent DMA and stumbled
upon this document. 

http://cache.freescale.com/files/training/doc/ftf/2014/FTF-NET-F0246.pdf

In this troubleshooting document similar issues and errors are being shown with
possible troubleshooting steps. 

It would be great if someone could point us into the right direction and has a
clue what could be changed within the kernel to get the Ethernet adapter
working.

Dave

-- 
You are receiving this mail because:
You are the assignee for the bug.
