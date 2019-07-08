Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71020624AB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbfGHPW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:22:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:44182 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387959AbfGHPW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:22:27 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVTC-0000RV-Oc; Mon, 08 Jul 2019 17:22:22 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVTC-00051t-In; Mon, 08 Jul 2019 17:22:22 +0200
To:     bpf@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: bpf-next is CLOSED
Message-ID: <dc8650a5-f5d9-d3ee-6369-8cfb241ba89d@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:22:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks everyone for the contributions! Only bug fixes from this point forward
given the merge window is open. Still going through the remaining batch in
patchwork and will send our the bpf-next PR to David later today.

Thanks,
Daniel
