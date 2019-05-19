Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762712283C
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfESSHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:07:35 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55773 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbfESSHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:07:35 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hSQDc-00089l-K1
        for netdev@vger.kernel.org; Sun, 19 May 2019 20:07:32 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Subject: [[PATCH net-next] 0/2] Convert mdio wait function to use readx_poll_timeout()
Date:   Sun, 19 May 2019 19:59:35 +0200
Message-Id: <20190519175937.3955-1-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On loaded systems with a preemptible kernel both functions
axienet_mdio_wait_until_ready() and xemaclite_mdio_wait() may report a
false positive error return.
Convert both functions to use readx_poll_timeout() to handle the
situation in a safe manner.

Regards
    Benedikt Spranger

Kurt Kanzenbach (2):
  net: axienet: use readx_poll_timeout() in mdio wait function
  net: xilinx_emaclite: use readx_poll_timeout() in mdio wait function

 drivers/net/ethernet/xilinx/xilinx_axienet.h     |  5 +++++
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c    | 16 ++++++----------
 drivers/net/ethernet/xilinx/xilinx_emaclite.c    | 16 ++++++----------
 3 files changed, 17 insertions(+), 20 deletions(-)

-- 
2.20.1

