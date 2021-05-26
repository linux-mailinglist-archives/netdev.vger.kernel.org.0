Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB62391B86
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhEZPTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:19:25 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57501 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbhEZPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:19:23 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7CC7BCED1D;
        Wed, 26 May 2021 17:25:45 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v2] Bluetooth: disable filter dup when scan for adv
 monitor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210520131145.v2.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
Date:   Wed, 26 May 2021 17:17:49 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Yun-Hao Chung <howardchung@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <AE7453FB-1E39-422A-91FB-C136343B2991@holtmann.org>
References: <20210520131145.v2.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Disable duplicates filter when scanning for advertisement monitor for
> the following reasons. The scanning includes active scan and passive
> scan.
> 
> For HW pattern filtering (ex. MSFT), Realtek and Qualcomm controllers
> ignore RSSI_Sampling_Period when the duplicates filter is enabled.
> 
> For SW pattern filtering, when we're not doing interleaved scanning, it
> is necessary to disable duplicates filter, otherwise hosts can only
> receive one advertisement and it's impossible to know if a peer is still
> in range.
> 
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> 
> Signed-off-by: Yun-Hao Chung <howardchung@chromium.org>
> 
> ---
> 
> Changes in v2:
> - include the vendor name in the comment and commit messages
> 
> net/bluetooth/hci_request.c | 46 +++++++++++++++++++++++++++++++++----
> 1 file changed, 41 insertions(+), 5 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

