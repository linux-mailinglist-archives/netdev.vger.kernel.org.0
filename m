Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29075F802
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfGDMZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:25:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58915 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfGDMZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:25:04 -0400
Received: from [5.158.153.52] (helo=kurt.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1hj0nO-00025J-Ov; Thu, 04 Jul 2019 14:25:02 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH iproute2 0/1] Fix s64 argument parsing
Date:   Thu,  4 Jul 2019 14:24:26 +0200
Message-Id: <20190704122427.22256-1-kurt@linutronix.de>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while using the TAPRIO Qdisc on ARM32 I've noticed that the base_time parameter is
incorrectly configured. The problem is the utility function get_s64() used by
TAPRIO doesn't parse the value correctly.

Thanks,
Kurt

Kurt Kanzenbach (1):
  utils: Fix get_s64() function

 lib/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.11.0

