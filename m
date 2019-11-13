Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6AFB3FD
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfKMPoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:44:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:38046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfKMPoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 10:44:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9453AB1FD;
        Wed, 13 Nov 2019 15:44:05 +0000 (UTC)
Message-ID: <1573659842.16112.7.camel@suse.com>
Subject: [RFC] race condition between firmware load and device disconnect in
 r871xu
From:   Oliver Neukum <oneukum@suse.com>
To:     Larry.Finger@lwfinger.net
Cc:     Himadri Pandya <himadri18.07@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org
Date:   Wed, 13 Nov 2019 16:44:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

syzbot reported this issue but the test was inconclusive, as it
reported a different crash.

https://lore.kernel.org/linux-usb/0000000000001145b10590b5d5bc@google.c
om/T/
