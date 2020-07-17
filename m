Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A44B224004
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGQP6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGQP6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:58:39 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D42C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:58:39 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id g37so7196739otb.9
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=+X2fBFm7EKPHv9ldvbj4jWNT1jxd0TKQ3j84DfPBXGI=;
        b=MRYsF2hAblnKzKefmIq/897AZMLmW+iaBPtoF3ui+JeadHE5Vtjb4fK7Kd78wEMW3K
         ia7Nf5omcSjTnowvtjynawX5enbsOZj8Gk8fAwyQU9EiIDj+dIU25FYRIcZvzftpCIF+
         dTaZOBy/Zz+DcmM3DAQ6FM1LfqPM/JTWe74vgenk8N3mObz07N2sJ5nPWRa6ZS3zguNM
         ADq+VuSOvrtzzaAPkQz3kPNiqiBFFIHgWIILVWgXs72ymWVOoyWm7nvzwq+rq0OUUCSF
         +cu4/zmEvDjhfOs1riXdQJTFHZlbBVSu3cvZF6DiQlu8U3PEwcJLTQmHxspdTa4I3NMR
         e2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+X2fBFm7EKPHv9ldvbj4jWNT1jxd0TKQ3j84DfPBXGI=;
        b=B/aRE11TSGQgGacKC/YLvj4YSEeF6DXHOI78ria8Ooh/burDdAeu13AQucY1ZlllnA
         988CByjTqbFQ4jNFjTF4fQQAToWMHUdbOqVFM4SkhX3e+VuTWGrs+VQONxGigwxINjiZ
         v5cLZTCJSAfLL8nsuqInIpDbjkjQ8NTGlvjWStWdkjL1Z2qpvglL+abJ7Fm995Tr1i5I
         TZtrIYe4lP+gUCGreEz99fpS41Mb//vuEwCgKbAVwwUP0Aj1SwHDPXHsgCBupvB/UarO
         grVL0ypMkNPHF162oITKSgVw1c4Utx/kadzMEflb/FStP9FzROAtY9+5ecqOVABlvaWo
         CZgg==
X-Gm-Message-State: AOAM531xPN0dSM1iZ9DVuwJevgzijPU69mCZe0P2TSgJitfAPwDgD9uT
        fexHX/1kSZeFe9xUy2Rz1hLezyZ6xEDq5DUilMbtJYaoIow=
X-Google-Smtp-Source: ABdhPJwiHl5Hhzgd5mpORZjPrZNMZ+sWTdg8cWCYXjwlQ26iVA9y1IoTO8KKoWm6XimzuTpTGav/hLlIOO2A4vXhMfU=
X-Received: by 2002:a05:6830:45a:: with SMTP id d26mr8767758otc.252.1595001518238;
 Fri, 17 Jul 2020 08:58:38 -0700 (PDT)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 17 Jul 2020 08:58:26 -0700
Message-ID: <CAJ+vNU30cU36bvgoyKFMzB4z3PAhEPB7OX_ikRQeCZPhSCZztQ@mail.gmail.com>
Subject: Assigning MAC addrs to PCI based NIC's
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

We make embedded boards that often have on-board PCIe based NIC's that
have MAC addresses stored in an EEPROM (not within NIC's NVRAM). I've
struggled with a way to have boot firmware assign the mac's via
device-tree and I find that only some drivers support getting the MAC
from device-tree anyway.

What is the appropriate way to assign vendor MAC's to a NIC from boot
firmware, or even in userspace?

Best regards,

Tim
