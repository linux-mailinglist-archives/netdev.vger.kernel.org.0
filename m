Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7076A29A760
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895383AbgJ0JJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:09:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51198 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509679AbgJ0JJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:09:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kXKz8-0007nE-8i; Tue, 27 Oct 2020 09:09:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] vsock: minor clean up of ioctl error handling
Date:   Tue, 27 Oct 2020 09:09:40 +0000
Message-Id: <20201027090942.14916-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Two minor changes to the ioctl error handling.

Colin Ian King (2):
  vsock: remove ratelimit unknown ioctl message
  vsock: fix the error return when an invalid ioctl command is used

 net/vmw_vsock/af_vsock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.27.0

