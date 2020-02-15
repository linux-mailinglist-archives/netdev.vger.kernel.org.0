Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F8E15FEA7
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgBONrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:47:17 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:35389 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgBONrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:47:17 -0500
Received: by mail-wm1-f48.google.com with SMTP id b17so13876311wmb.0
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aZuwsziU1BWZjVTxrBGjU0NXmNvJEHSdMhVvgXbKnB4=;
        b=jCAHTb2vIPb8PJmi4fmIo4FJvYcxJ7t/dteVXLdWsHLVyc1koWw6etV4+u8kbCRNbW
         JUSwocbjq4Aoq71hRpbew8tIq/X64ga/lc9mu0RoGC2va45jDrDZtMAXg2xOaRTUhqcn
         XlpwujF+SVdVktpHbAWwg4SvdDrhFEfBjEMSTI4rJNKIa7YOT996YjJ0giR1bsJ3RmSc
         4CkpvaV0kad3+nnRqorZ7PVCbqYOghHwTlP/u23JUNWpsfkJsja7+kA4riJkR2+9tYYg
         gGvWKuxfd3WxYeCOlG8i1RVMVBOfytEgnC3eswpj5iM7TlszMo588OeRM+w/nzo4mbAU
         KEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aZuwsziU1BWZjVTxrBGjU0NXmNvJEHSdMhVvgXbKnB4=;
        b=hDBUHlTRA/i0rP5VcOyxXGsRi/OQWcJdGbevja+l+fF0m3+k0bNCYMuEMnF2VcKiYf
         2MUZ6OF9ckJKpqd6JDAjP72Jld8eS02iiaGjgLB1XKkUp8zqHhB9uSviAMnX7fgYibuM
         OQBqB/5WPRxjDhyFEr4WbANvxKlZAq4sH1nxeID+WADzLvWEu3vN1i4HvJ2mYgdfahaV
         np9utpkC4aom4vbHSCQrvi0Kj6Imp2NrZTW477XRqFCZTWjqvni32ui3VcG1BXK7d5t6
         kAXdl3u/s0hz/J46IEouGnQ/Wdn8eDSG7iGAfmAjT8rYQc0QDdWKT1KxPdV9ArLXOZKH
         UgxA==
X-Gm-Message-State: APjAAAXsnzdZiWV9ednX1sowB1rgMQ/wrMJsiQU0JaqosNtWB2n7qlTp
        eSkOW4HEJEqMNgYXJAYnsL1hFImj
X-Google-Smtp-Source: APXvYqzcjVsbsBFjKqM4ktbMjtbISs0pu84bH5wjoTuSXn7rva0MowvZkhRbjcTgw0LI/fLYbj5tEg==
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr11427923wmh.131.1581774434063;
        Sat, 15 Feb 2020 05:47:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id f65sm11481086wmf.29.2020.02.15.05.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:47:13 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/7] r8169: series with further smaller improvements
Message-ID: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Date:   Sat, 15 Feb 2020 14:47:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing too exciting. This series includes further smaller
improvements.

Heiner Kallweit (7):
  r8169: remove unneeded check from rtl_link_chg_patch
  r8169: remove setting PCI_CACHE_LINE_SIZE in rtl_hw_start_8169
  r8169: simplify setting netdev features
  r8169: add helper rtl_pci_commit
  r8169: improve rtl8169_get_mac_version
  r8169: improve rtl_jumbo_config
  r8169: improve statistics of missed rx packets

 drivers/net/ethernet/realtek/r8169_main.c | 187 +++++++++-------------
 1 file changed, 75 insertions(+), 112 deletions(-)

-- 
2.25.0

