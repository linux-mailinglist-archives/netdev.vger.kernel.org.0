Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E53265A10
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKHIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:08:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42702 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgIKHIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 03:08:49 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id CBB8FCED19;
        Fri, 11 Sep 2020 09:15:42 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3 2/2] Bluetooth: sco: new getsockopt options
 BT_SNDMTU/BT_RCVMTU
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200910140342.v3.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
Date:   Fri, 11 Sep 2020 09:08:46 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <758FB16C-5210-4790-8B54-6BA400CB208D@holtmann.org>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <20200910140342.v3.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch defines new getsockopt options BT_SNDMTU/BT_RCVMTU
> for SCO socket to be compatible with other bluetooth sockets.
> These new options return the same value as option SCO_OPTIONS
> which is already present on existing kernels.
> 
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> Changes in v3:
> - Fixed the commit message.
> 
> Changes in v2:
> - Used BT_SNDMTU/BT_RCVMTU instead of creating a new opt name.
> - Used the existing conn->mtu instead of creating a new member
>  in struct sco_pinfo.
> - Noted that the old SCO_OPTIONS in sco_sock_getsockopt_old()
>  would just work as it uses sco_pi(sk)->conn->mtu.
> 
> net/bluetooth/sco.c | 6 ++++++
> 1 file changed, 6 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

