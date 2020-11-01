Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F402A2253
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgKAXXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:23:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55342 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgKAXXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:23:18 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604272995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GY07dyr1ktODYPTraPNveVQnlQ6ID2DdAqKH5wOkDgM=;
        b=MyMk5jUP5ADc8U7jk+dKX+356XHjXWJ74RZ5V846EokugOwA/g8JdNyufJjhblLledgiKX
        VeVcheald4gsoyqOZlNnye/8XMm+s4w8Lt47znzvpqp0FfjR4eZ1jbKSwEWTqBX9VuSK7o
        ZZi6jCDGSuqzl46EDt+jtImWu4Ur2oGLqNyDDVV3O7XR8TMFEd7BQhFDeYKT37oCK4Db8S
        oCclw29wT1gmPXTNOE+RCCqSnSHDuijsMDma4aPlz0/yZhymRceKoRCxoZLxPX15G1mFTb
        Ud2HT3B+hCuPbBWfFFkZgcAP0+wRsrbBJtv47p/aXLWo6UzTfFtwPyoKONw+Ng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604272995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GY07dyr1ktODYPTraPNveVQnlQ6ID2DdAqKH5wOkDgM=;
        b=6t+1s6NSGKASvUBps/41xiYYBPNdSiBLVyxSffAEHs2HIROpa6DLVP3vshC0o5ylZXRCc3
        y71qo8F0tt16uiCQ==
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Date:   Mon,  2 Nov 2020 00:22:54 +0100
Message-Id: <20201101232257.3028508-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the in_interrupt() clean for FSL DPAA framework and the two
users.=20

The `napi' parameter has been renamed to `sched_napi', the other parts
are same as in the previous post [0].

[0] https://lkml.kernel.org/r/20201027225454.3492351-1-bigeasy@linutronix.de

Sebastian
