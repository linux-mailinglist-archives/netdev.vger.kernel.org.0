Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B361B4BF9
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgDVRmL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 13:42:11 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34900 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDVRmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:42:11 -0400
Received: from [192.168.1.91] (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 46689CECFD;
        Wed, 22 Apr 2020 19:51:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v1] Bluetooth: L2CAP: add support for waiting
 disconnection resp
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200414160758.v1.1.Idab9dcdc7da549ed1fd5c66341fb8baffaee8d10@changeid>
Date:   Wed, 22 Apr 2020 19:41:39 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <84DFB53F-C60A-48D3-AC01-2C9C87BA805D@holtmann.org>
References: <20200414160758.v1.1.Idab9dcdc7da549ed1fd5c66341fb8baffaee8d10@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Whenever we disconnect a L2CAP connection, we would immediately
> report a disconnection event (EPOLLHUP) to the upper layer, without
> waiting for the response of the other device.
> 
> This patch offers an option to wait until we receive a disconnection
> response before reporting disconnection event, by using the "how"
> parameter in l2cap_sock_shutdown(). Therefore, upper layer can opt
> to wait for disconnection response by shutdown(sock, SHUT_WR).
> 
> This can be used to enforce proper disconnection order in HID,
> where the disconnection of the interrupt channel must be complete
> before attempting to disconnect the control channel.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> net/bluetooth/l2cap_sock.c | 30 +++++++++++++++++++++++-------
> 1 file changed, 23 insertions(+), 7 deletions(-)

the patch looks fine to me. Do we have something in l2cap-tester or l2test that we can verify this with before I apply it.

Regards

Marcel

