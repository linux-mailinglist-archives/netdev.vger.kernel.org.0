Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DCD41FB76
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 14:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhJBMFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 08:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhJBMF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 08:05:27 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41C3C061570;
        Sat,  2 Oct 2021 05:03:41 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z184so1532206iof.5;
        Sat, 02 Oct 2021 05:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=nsZbpm1YBoHMpWTnzHLuE/zYZ0yg4jBiKD5Q7oCTPBE=;
        b=YxWIlaBSYFvjD6wxI3Im7HD0DUa8SKawF0d7t45AEzKjL6m83eOsT6rgZdQRGCng74
         6RLcJMZhzHbNym1o2udNgSV2epSTH0qAv/gDWDsxACfpBL7vOUGDwWmGmUaO2SE5P8uY
         T63X4axLx9vlrJbw970R//6K5CXkIsOYNNanoWJo6B81ZE00DEyRoVjZrAUA3RQ+9ju3
         SZYoVWN+Ed+cukZyyntSGlKOmbEpXAJVn5nVjU9PttbC0fy1k1kkmOWz1VvVx3VvX7FT
         7VoKZi/ug9VIcJXMy54+WPXzQ6H5V7BFKbJ6aHn+8SZElmbcl8wcN4j53q3jHLdvow5u
         jyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=nsZbpm1YBoHMpWTnzHLuE/zYZ0yg4jBiKD5Q7oCTPBE=;
        b=LmOqDwxqDDyQv8S5r8mgiOrkAdVuYjTHRPeL3SEcVCmf7iltEE+9E/WZ/p4a/Rn6OK
         r3NIfiwPWf7KMH2N8E7aj9oaEc65LBtP0zvNSXYapgvfoiGp/gn4pQr6YnnJ321thhXg
         UPVYssUs2StzWAD4Fo7masaaFkiOnbLL5nVv/dCZJIbtpy0aOis4w8Sq2+zDrQJpYgJ2
         BgAockzdWQXrw276F+kR1NCbmuusK8c+G5aTErF1zxB/C4qJBdeiCmLoNqfxrhcADHs1
         C+A9TlKq/pvb05UIgyvRzQeVCHUz2Vc2jXMdDry12eLQagUSqyM6oyQG9mzJutcKherx
         5Ckw==
X-Gm-Message-State: AOAM531n/GcSWL+Qoyf2OX/kqSmiAkrV6zyLjg67Vu5E6w2n/478Pi66
        /U4B72F0Qpia4whCxpJUMQqm5jkVFMT4Yf+6K6E=
X-Google-Smtp-Source: ABdhPJz2q09A+517W2EVe9dbDivdnk3AEH6BZaUlyYLwJiT4IN/1ySl0KWhD1PmrDJ75/9gz6SNXe4y+mLeDTP26TSo=
X-Received: by 2002:a05:6638:104:: with SMTP id x4mr2547380jao.145.1633176221400;
 Sat, 02 Oct 2021 05:03:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:f90d:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 05:03:41 -0700 (PDT)
Reply-To: unitednnation0@gmail.com
From:   "U.n" <wadebaye33@gmail.com>
Date:   Sat, 2 Oct 2021 00:03:41 -1200
Message-ID: <CACE0T5XLJ2ZM5W28B0Dyv4Rc8vqA8pN78J4Aso6XvTW_kxoNmQ@mail.gmail.com>
Subject: Attention
To:     unitednnation0@gmail.com
Cc:     pberger@brimson.com, alborchers@steinerpoint.com,
        xavyer@ix.netcom.com, support@connecttech.com,
        steve.glendinning@shawell.net, luca.risolia@studio.unibo.it,
        stern@rowland.harvard.edu, oneukum@suse.de,
        linux-uvc-devel@lists.sourceforge.net,
        laurent.pinchart@ideasonboard.com, jussi.kivilinna@mbnet.fi,
        sarah.a.sharp@linux.intel.com, royale@zerezo.com,
        jdike@addtoit.com, richard@nod.at,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, hjk@hansjkoch.de,
        kzak@redhat.com, util-linux@vger.kernel.org, spock@gentoo.org,
        hirofumi@mail.parknet.co.jp, alex.williamson@redhat.com,
        pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, amit.shah@redhat.com,
        rusty@rustcorp.com.au, mst@redhat.com, kvm@vger.kernel.org,
        rl@hellgate.ch, brucechang@via.com.tw, HaraldWelte@viatech.com,
        FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        romieu@fr.zoreil.com, kaber@trash.net, florian@openwrt.org,
        openwrt-devel@lists.openwrt.org, martyn.welch@ge.com,
        manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, sbhatewara@vmware.com,
        arvindkumar@vmware.com, pv-drivers@vmware.com, lrg@ti.com,
        juergh@gmail.com, vt8231@hiddenengine.co.uk,
        tony.olech@elandigitalsystems.com, linux-mmc@vger.kernel.org,
        linux-usb@vger.kernel.org, zbr@ioremap.net, m.hulsman@tudelft.nl,
        r.marek@assembler.cz, khali@linux-fr.org,
        lm-sensors@lm-sensors.org, pierre@ossman.eu, wim@iguana.be,
        linux-watchdog@vger.kernel.org, zaga@fly.cc.fer.hr,
        linux-scsi@vger.kernel.org, dh.herrmann@googlemail.com,
        david@hardeman.nu, inaky.perez-gonzalez@intel.com,
        linux-wimax@intel.com, wimax@linuxwimax.org, mitr@volny.cz,
        acme@ghostprotocols.net, lrg@slimlogic.co.uk,
        linux-input@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        patches@opensource.wolfsonmicro.com, tj@kernel.org,
        andrew.hendry@gmail.com, linux-x25@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org, tony.luck@intel.com,
        bp@alien8.de, linux-edac@vger.kernel.org, mchehab@redhat.com,
        jeremy@goop.org, virtualization@lists.linux-foundation.org,
        stefano.stabellini@eu.citrix.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, konrad.wilk@oracle.com,
        xen-devel@lists.xensource.com, bpm@sgi.com, elder@kernel.org,
        xfs@oss.sgi.com, anirudh@xilinx.com, John.Linn@xilinx.com,
        grant.likely@secretlab.ca, jacmet@sunsite.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20


Attention Sir/Madam
This is the United Nation (UN). We the United Nations (UN) Globally
has approved (US$2.500,000)( two Million Five hundred thousand
dollars) compensation as part of our responsibilities for humanitarian
Aid for fighting against CoronaVirus and you are among the lucky ones.


This compensation is for the most affected countries, communities and
families across the global. Your funds were deposited with Bank in USA
to transfer your funds to you via Internet Banking. You have to send
your full details as state below:with this email Address
  ( unitednnation0@gmail.com )
Your full names:
Address:
Telephone:
Occupation:



Yours Sincerely
Mr. Ant=C3=B3nio Guterres
United Nations (UN).
