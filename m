Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1119FC6E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgDFSE5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 14:04:57 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:58428 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDFSE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:04:57 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 37C06CECC9;
        Mon,  6 Apr 2020 20:14:30 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 1/1] Bluetooth: Update add_device with wakeable actions
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200325224500.v2.1.I196e4af9cde6c6e6aa7102906722cb9df8c80a7b@changeid>
Date:   Mon, 6 Apr 2020 20:04:55 +0200
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DEFFA6AD-01A6-49B7-AB76-4F763A46981D@holtmann.org>
References: <20200326054517.71462-1-abhishekpandit@chromium.org>
 <20200325224500.v2.1.I196e4af9cde6c6e6aa7102906722cb9df8c80a7b@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Add new actions to add_device to allow it to set or unset a device as
> wakeable. When the set wakeable and unset wakeable actions are used, the
> autoconnect property is not updated and the device is not added to the
> whitelist (if BR/EDR).

I am currently preferring to go with Device Flags for this. See my mgmt-api.txt proposal that I just send a few minutes ago.

Regards

Marcel

