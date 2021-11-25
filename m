Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DB045E164
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356954AbhKYUOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 15:14:37 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:41263 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356979AbhKYUMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 15:12:34 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id E3D51CECC7;
        Thu, 25 Nov 2021 21:09:21 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3 2/2] Bluetooth: Limit duration of Remote Name Resolve
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211125150430.v3.2.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
Date:   Thu, 25 Nov 2021 21:09:21 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <81B90E0B-E88E-45F6-9B84-C7DB369E5DC0@holtmann.org>
References: <20211125150430.v3.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
 <20211125150430.v3.2.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> When doing remote name request, we cannot scan. In the normal case it's
> OK since we can expect it to finish within a short amount of time.
> However, there is a possibility to scan lots of devices that
> (1) requires Remote Name Resolve
> (2) is unresponsive to Remote Name Resolve
> When this happens, we are stuck to do Remote Name Resolve until all is
> done before continue scanning.
> 
> This patch adds a time limit to stop us spending too long on remote
> name request.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> Changes in v3:
> * Add units in comment
> * change debug log to warn
> 
> include/net/bluetooth/hci_core.h | 3 +++
> net/bluetooth/hci_event.c        | 7 +++++++
> 2 files changed, 10 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

