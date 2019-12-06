Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A33114FA8
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLFLQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:16:52 -0500
Received: from fd.dlink.ru ([178.170.168.18]:47898 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfLFLQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 06:16:52 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 589DE1B21576; Fri,  6 Dec 2019 14:16:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 589DE1B21576
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1575631008; bh=zIdiCpZ9XY3JaavuKzuAL4SRBQIiU9MNH/ZkKIXD2sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Etb4tzTiRapJgflytgB73OE15LbikSU+13GDwA3Qt0eurWvZLzN6Tix8V3Dc/GIQV
         al5zXWqDCI7TZNjq5Rki4L3wAUozoBAzxIdTzAmPUHSm/qMDTxqxLIrgOVC2TKjwA9
         jrMYtdctepzTrajZEoQ/ZPSRGx/gec3hzaCcD6tE=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id CC1A01B202CB;
        Fri,  6 Dec 2019 14:16:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru CC1A01B202CB
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 7F3241B22664;
        Fri,  6 Dec 2019 14:16:40 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri,  6 Dec 2019 14:16:40 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 06 Dec 2019 14:16:40 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Tony Ambardar <itugrok@yahoo.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: BPF: Restore MIPS32 cBPF JIT; disable MIPS32 eBPF
 JIT
In-Reply-To: <20191205182318.2761605-1-paulburton@kernel.org>
References: <20191205182318.2761605-1-paulburton@kernel.org>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <84c74e399e854b3b17232cd605b6c9e9@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Burton wrote 05.12.2019 21:23:
> [...]

> Note that this does not undo the changes made to the eBPF JIT by that
> commit, since they are a useful starting point to providing MIPS32
> support - they're just not nearly complete.

BTW, would be very nice to see eBPF JIT support for not only MIPS32R2+,
but also pre-R2 CPUs in future.

> [...]

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
