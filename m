Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F693114DB
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhBEWQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:16:36 -0500
Received: from mout.gmx.net ([212.227.17.22]:51759 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231597AbhBEOdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612541403;
        bh=zUCI8Ypd/xfX4FSR3qtqItGWSz7+x8Nvb3ALXYzZoWg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WECwIWEE9BJ/TxBTSGrhxo/VAjbRIQRzjeK495cLRdqWVHh7uO3xFswMU8sEB0yWq
         oMFNobT1hCLFSCDLVb6r4fNpgLA0Idd7f9fNhxvwiOCuh4XLoWaggBlcC8SBMue5gv
         FLX1Jvhku7aDnESj2uUIybJoJJeGW+5DUXAUmNhQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.123.206.138] ([87.123.206.138]) by web-mail.gmx.net
 (3c-app-gmx-bap12.server.lan [172.19.172.82]) (via HTTP); Fri, 5 Feb 2021
 16:02:20 +0100
MIME-Version: 1.0
Message-ID: <trinity-d2590cd7-50a1-4b89-824b-61f2d8a24aed-1612537340705@3c-app-gmx-bap12>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     kuba@kernel.org, sgarzare@redhat.com, alex.popov@linux.com,
        eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer dereference
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 5 Feb 2021 16:02:20 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:/F8jEMxPy/YDXqeScJFSNAdN2JmO547mkl2iOp/otTwyA1Jwyve+D//z8f3CiG2VcAsKO
 b1CmHeKa0iTslS70R2My5+rjENr5CL2U5JezmqiQrkSgRL+l7Q5j117xeaQQkPsyCr6odbh8BFp4
 oYbb1wPxke1puPduvvGBUzFSRtuxP70nIulMw3hlWmFvMeHrSrYm+TQR6psvH9P6hxCYJ/xWlp3h
 V+98nP5sCLtp4edg0EBMBTxN8jDqIzjbdF040EZQFORdjz8yF6x8BO2uXZcVW6NF4qTjB01Ma0ID
 Ww=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ojZVnsh307c=:NR1Q/bvP4DLx7MbgbiRQBf
 tMQBKx0SSXXZJrMNzbaVhDuMFZOt3fyzjZkhmjT1ZTj1w6E2qcwv+TfmY9jWL/aGs4YlaGuf6
 G6S+Y0eZmvayyjM8R1rAh18rDQpTimeDrVpiNirYtCkoPmcCFGM2QDQOdD9+M/VaP0F8Rx+Ga
 T2CSC6+47bmVjnM3wPiEYcxZZzmynsHcLWgfpbMoBMNl7lwhFumKfan0RQIUVDOG8EYe+Yay8
 0ILMxPJAO+A9cSfrK+Z7r9dRE9PSKn5BpaXm81JVeRbREl3A++V8dxNLRqtMQp+1VM5p/TcJt
 F1wMU9mS55Fj0vt6aRVlxCoZZizpADN6D3E0vLTY4CC5AscQVxG6/IXO34BwMW265A8goA43d
 AdUL9tm8CpA6esfFGP6eiTsLylewCivgYpG4xGRmZNEUGo9Py3ZVjbLqWzbmEBWU26v+p5v5i
 VbOmNJmDj+dNulXw+Zg/QX7xH680nn1vy7MNukHGaBDr92SOC6KH+midFxKDs0uqymlRBzF8Z
 48NQml0NHdS0EO4X04GSLpehReJ1/F7CcDjoAw0pTIYT65XkRNNx0w1fgHeq5fW4Cd6Q48EZc
 0xMH6AhetRpiE=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forgot to send it to the networking maintainer, +CC Jakub Kicinski <kuba@kernel.org>
