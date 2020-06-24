Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04DA207C4D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391354AbgFXTkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:40:07 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:58971 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391239AbgFXTkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:40:06 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id C34A3CECDB;
        Wed, 24 Jun 2020 21:49:56 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Don't restart scanning if paused
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200624113351.1.Ic6b1fca2b1b3fe989db21ceae76bab80bd87d387@changeid>
Date:   Wed, 24 Jun 2020 21:40:03 +0200
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <EAEF89F3-8F6B-49AE-95B4-E6A961C6474D@holtmann.org>
References: <20200624113351.1.Ic6b1fca2b1b3fe989db21ceae76bab80bd87d387@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> When restarting LE scanning, check if it's currently paused before
> enabling passive scanning.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> When running suspend stress tests on Chromebooks, we discovered
> instances where the Chromebook didn't enter the deepest idle states
> (i.e. S0ix). After some debugging, we found that passive scanning was
> being enabled AFTER the suspend notifier had run (and disabled all
> scanning).
> 
> For this fix, I simply looked at all the places where we call
> HCI_OP_LE_SET_SCAN_ENABLE and added a guard clause for suspend. With
> this fix, we were able to get through 100+ iterations of the suspend
> stress test without any problems entering S0ix.
> 
> 
> net/bluetooth/hci_request.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

