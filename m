Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36E2027F4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 04:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgFUCWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 22:22:37 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:32509 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbgFUCWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 22:22:36 -0400
Date:   Sun, 21 Jun 2020 02:22:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592706155;
        bh=KCH/ToTMOZkHvnpkT8LvCTGV7xNV6lgn36v8EDlySi0=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=iK7a0Mo4FPluOx5Uxcq55YZZ18bT7ljtcy/KGO7GhHrWrtoXDkklYFDvQZh7fFeKp
         EWRC+CuzS/fnwO9167azOLvFrQdGv7tKO425J9yzonCFq+PngZWunpZq3NASe7xhEt
         PPy4Ol9PLQRRe/6lvhBK89xZey4Vw6xoR7PBdK4A=
To:     davem@davemloft.net
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: Patch to correct kernel-doc comments in networking subsystem
Message-ID: <20200621022209.11814-1-colton.w.lewis@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch was sent to Dave last week, but I fear it may have been
ignored because I forgot to set the subject line. Please accept or
comment on this patch.

