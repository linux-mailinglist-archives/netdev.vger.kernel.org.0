Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57D19FD20
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDFS05 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 14:26:57 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52013 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgDFS05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:26:57 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id C97B5CECCA;
        Mon,  6 Apr 2020 20:36:29 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAOxioNneH_wieg39xLyBHb_E12LXiAm-uZBqvt3brdoQr0c7XQ@mail.gmail.com>
Date:   Mon, 6 Apr 2020 20:26:55 +0200
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Alain Michaud <alainmichaud@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <40C87EEE-BE73-4B32-91AD-480112B9A2F4@holtmann.org>
References: <20200403150236.74232-1-linux@roeck-us.net>
 <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
 <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net>
 <6456552C-5910-4D77-9607-14D9D1FA38FD@holtmann.org>
 <CAOxioNneH_wieg39xLyBHb_E12LXiAm-uZBqvt3brdoQr0c7XQ@mail.gmail.com>
To:     Sonny Sasaka <sonnysasaka@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sonny,

> Can this patch be merged? Or do you prefer reverting the original
> patch and relanding it together with the fix?

since the original patch is already upstream, I need a patch with Fixes etc. And a Reviewed-By from you preferably.

Regards

Marcel

