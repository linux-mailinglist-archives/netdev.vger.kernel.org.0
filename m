Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C1E1306F2
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 10:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgAEJfA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 5 Jan 2020 04:35:00 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45899 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAEJfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 04:35:00 -0500
Received: from marcel-macbook.fritz.box (p4FD195C7.dip0.t-ipconnect.de [79.209.149.199])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1ADF5CED23;
        Sun,  5 Jan 2020 10:44:13 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH 5/8] net: bluetooth: remove unneeded MODULE_VERSION()
 usage
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200104195131.16577-5-info@metux.net>
Date:   Sun, 5 Jan 2020 10:34:56 +0100
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, Johan Hedberg <johan.hedberg@gmail.com>,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev <netdev@vger.kernel.org>,
        BlueZ devel list <linux-bluetooth@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <22BD3D36-DE54-4062-B3A1-15D9E0E256A8@holtmann.org>
References: <20200104195131.16577-1-info@metux.net>
 <20200104195131.16577-5-info@metux.net>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Enrico,

> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.

I prefer to keep the MODULE_VERSION info since it provides this information via modinfo.

Unless there is a kernel wide consent to remove MODULE_VERSION altogether, the Bluetooth subsystem is keeping it.

Regards

Marcel

