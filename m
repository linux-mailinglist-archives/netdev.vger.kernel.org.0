Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1A729D0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGXIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:20:16 -0400
Received: from mail-ua1-f50.google.com ([209.85.222.50]:47019 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGXIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:20:15 -0400
Received: by mail-ua1-f50.google.com with SMTP id o19so18126002uap.13
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 01:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=YEqWpjNET0V5X9YVQ/cJnPfqZ7GzgCUtsK0GmIEW0Ec=;
        b=ItJL3msNUi461yeuurCzcJ1c2T7u9TxKcr4DvEQwrTK+8vr/8iy18EXHA2k+e7CPFF
         xsglMV8aw4i8EJt7ioQNXHcm13YhDn0P5HOCm1oC92jHHb/SReNST7OvJ76jQMRyRMbv
         KZgO7CgDoM6Rci3Tmz7pDgloWEfLvikf7bFyfmhmThevt5KNfxWv4u81LsmOClbuKt0s
         55DLLe8ab2hLFvEiYeiA5MUliu8jQVwcVCcCacSrBFYCvzGwcpudaL/IXLaqhNaj0MyL
         2+xy7ktGE0jbIg9M8J0A148yB0S9I3O1QXMK30VqIvYUzfNZP22T+owdC+VBtdGFIz3j
         UiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=YEqWpjNET0V5X9YVQ/cJnPfqZ7GzgCUtsK0GmIEW0Ec=;
        b=HTZM4UJsGq+Ueg6I9QFX6CUo/bNmLd4eCsgxy4LRNmzgx4NoqC3DJ+/Xp5VZ8DCFvb
         YH0DW4ImUGg0RAO0wwd03xg3Q8ctzxQ6HjkVF4LRkx7Hgdf0SOT4Dv91p4v0niwPkC7t
         uiwiCTZJviMTVq+z58Av1J5fOqhgGiPBs3ItrCe/Ok+bVtq77+OhBugdOchPnRfN0Y9C
         IYA9d33dbj9S3gF7S75oHg8PcBZ54DG6GiXBf80u/bsiIlMrJphBkj+hA6SCc++09NHN
         NcwV3ZSrSGb2CqPfWMYpma62nfeQpxvdfeT4LZYWXRDDErU/QPEGUPXRepx9pY/Sq5/R
         q73A==
X-Gm-Message-State: APjAAAXbAZ/roLdQagJqs1rTMLLJiyqSykABQpfUJZqrnincZ4F1HxiQ
        UxCiQjKeMb3X1xtrSBVSdkObNLt6+T2L1Rslfil5FyjQ8uIINA==
X-Google-Smtp-Source: APXvYqzppGsQ5kwNO1GDs3wYVTG/dVh+vvpsUJVQpZtABup7arq64rR5o56ANlio55qKLhVZKYjwcGosBG003Y0TL/k=
X-Received: by 2002:ab0:544:: with SMTP id 62mr1174191uax.94.1563956414404;
 Wed, 24 Jul 2019 01:20:14 -0700 (PDT)
MIME-Version: 1.0
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Wed, 24 Jul 2019 16:19:38 +0800
Message-ID: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
Subject: Driver support for Realtek RTL8125 2.5GB Ethernet
To:     Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
Ethernet [1] recently.  But, there is no related driver in mainline
kernel yet.  So, we can only use the vendor driver [2] and customize
it [3] right now.

Is anyone working on an upstream driver for this hardware?

[1] https://www.realtek.com/en/press-room/news-releases/item/realtek-launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-applications-including-gaming-solution
[2] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
[3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571524ed71fd237d32b

Jian-Hong Pan
