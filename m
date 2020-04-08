Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927811A2B64
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgDHVsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:48:25 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:20078 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgDHVsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:48:24 -0400
Date:   Wed, 08 Apr 2020 21:48:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=proton;
        t=1586382502; bh=CK5BJ5IYf8vYEacgqeHy5n0FsUoPfe1BipswSDkcMkk=;
        h=Date:To:From:Reply-To:Subject:From;
        b=hEOM/kXyveheiOrUL57r0gRQ4yAhUN+FrYZwZ/BnoHhOvRspPfzQ1afxnSPDOokYN
         w5zBi0MnEpOdxjc8H8z6CWEI8eEb1asyheeca8rLfLyn1gdrLORqySUwTazJRqIQr4
         gapLgWwqWHyu7DKBcJg5t0q/3yjaFgeC8Lr1APf9q/vZkFZpzJ+fGWeLBNhZIH2aT3
         MG4kHrkPyGcgRIIICogO6sWANqIzUwHWmQCm5HdeoudOGJtZIRMPgXNdr+ziRnAjx1
         RzD+qqI1N6+VZHYtz4gQdBxCm/rffuOP42NaATxw/MR5RHi0Pzl1fz+xebV5FQCfPZ
         DXd/ZOfhowAHA==
To:     netdev@vger.kernel.org
From:   Yadunandan Pillai <thesw4rm@pm.me>
Reply-To: Yadunandan Pillai <thesw4rm@pm.me>
Subject: Including Bluetooth in Netfilter/eBPF for packet tracing and manipulation
Message-ID: <98a782fe-bf17-c84a-1470-3f29d5b4d946@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Are there any active efforts on creating packet=20
interception/modification hooks
for Bluetooth in Netfilter or eBPF? It would be pretty useful so you can=20
bridge
the two protocols for IoT networks and the like. I've started looking=20
into it
but don't want to step on anyone else's work if it's already an ongoing
project.



