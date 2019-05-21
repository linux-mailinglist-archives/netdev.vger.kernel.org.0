Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8043E258EB
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfEUUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:31:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:33292 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfEUUbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:31:55 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTBQP-0004FF-I9; Tue, 21 May 2019 22:31:53 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTBQP-00078F-9T; Tue, 21 May 2019 22:31:53 +0200
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org,
        iovisor-dev@lists.iovisor.org
Cc:     lpc-bpf@vger.kernel.org, alexei.starovoitov@gmail.com
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: Linux Plumbers BPF micro-conference CFP
Message-ID: <2e9f33c9-b772-396e-1e70-2e2d5027cac5@iogearbox.net>
Date:   Tue, 21 May 2019 22:31:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a call for proposals for the BPF micro-conference at this
years' Linux Plumbers Conference (LPC) 2019 which will be held in
Lisbon, Portugal for September 9-11.

The goal of the BPF micro-conference is to bring BPF developers
together to discuss topics around Linux kernel work related to
the BPF core infrastructure as well as its many subsystems under
tracing, networking, security, and BPF user space tooling (LLVM,
libbpf, bpftool and many others).

The format of the micro-conference has a main focus on discussion,
therefore each accepted topic will provide a short 1-2 slide
introduction with subsequent discussion for the rest of the given
time slot.

The BPF micro-conference is a community-driven event and open to
all LPC attendees, there is no additional registration required.

Please submit your discussion proposals to the LPC BPF micro-conference
organizers at:

        lpc-bpf@vger.kernel.org

Proposals must be submitted until August 2nd, and submitters will
be notified of acceptance at latest by August 9. (Please note that
proposals must not be sent as html mail as they are otherwise dropped
by vger.)

The format of the submission and many other details can be found at:

        http://vger.kernel.org/lpc-bpf.html

Looking forward to seeing you all in Lisbon in September!
