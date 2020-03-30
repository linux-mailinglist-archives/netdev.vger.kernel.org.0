Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B502D1986CB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgC3Vt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:49:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:48266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgC3Vt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:49:26 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJ2Hc-0004py-6W; Mon, 30 Mar 2020 23:49:24 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJ2Hb-000Iz1-Vn; Mon, 30 Mar 2020 23:49:24 +0200
Subject: bpf-next is CLOSED
References: <d677c08c-51fa-7bb3-9f0e-a021ae3d9d72@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, alexei.starovoitov@gmail.com,
        davem@davemloft.net
From:   Daniel Borkmann <daniel@iogearbox.net>
X-Forwarded-Message-Id: <d677c08c-51fa-7bb3-9f0e-a021ae3d9d72@iogearbox.net>
Message-ID: <419714c2-e170-5aac-efb0-70aef726bc74@iogearbox.net>
Date:   Mon, 30 Mar 2020 23:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d677c08c-51fa-7bb3-9f0e-a021ae3d9d72@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The merge window is open right now, therefore please send bug fixes only
at this point. bpf-next will open back up in roughly 2 weeks after the
merge window is closed. The last bpf-next PR will go out today to David.

Thank you,
Daniel
