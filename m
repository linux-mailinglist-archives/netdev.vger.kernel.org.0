Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D7146FFA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAWRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:46:14 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:47367 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbgAWRqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:46:13 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id A11B2CED02;
        Thu, 23 Jan 2020 18:55:31 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [Bluez PATCH v1] bluetooth: secure bluetooth stack from bluedump
 attack
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CALWDO_VUckYfEbh8RC=X2zqWKd5+2qOEux2ctdpo_Jfwkt_V9g@mail.gmail.com>
Date:   Thu, 23 Jan 2020 18:46:12 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Yun-hao Chung <howardchung@google.com>,
        BlueZ devel list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <C926F619-C47A-433C-9DA7-4E3F8C49FC8C@holtmann.org>
References: <20200106181425.Bluez.v1.1.I5ee1ea8e19d41c5bdffb4211aeb9cd9efa5e0a4a@changeid>
 <CD07E771-6F40-4158-A0F9-03FC128CDCD3@holtmann.org>
 <CALWDO_VUckYfEbh8RC=X2zqWKd5+2qOEux2ctdpo_Jfwkt_V9g@mail.gmail.com>
To:     Alain Michaud <alainmichaud@google.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alain,

> Did you have additional feedback on this before we can send a new
> version to address Marcel's comments?
> 
> Marcel, you are right, LE likely will need a similar fix.  Given we
> currently have SC disabled on chromium, we can probably submit this as
> a separate patch unless someone else would like to contribute it
> sooner.

I would prefer if we get BR/EDR and LE fixed in the same kernel release.

Regards

Marcel

