Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2E641FAA0
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhJBJbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 05:31:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63907 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhJBJbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 05:31:48 -0400
Received: from fsav115.sakura.ne.jp (fsav115.sakura.ne.jp [27.133.134.242])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1929Tqpr040350;
        Sat, 2 Oct 2021 18:29:52 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav115.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp);
 Sat, 02 Oct 2021 18:29:52 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1929Tqbt040346
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 2 Oct 2021 18:29:52 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Two ath9k_htc fixes
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     ath9k-devel@qca.qualcomm.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <77b76ac8-2bee-6444-d26c-8c30858b8daa@i-love.sakura.ne.jp>
Message-ID: <dfe7d982-2f6a-325a-c257-6d039033a2ed@i-love.sakura.ne.jp>
Date:   Sat, 2 Oct 2021 18:29:51 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <77b76ac8-2bee-6444-d26c-8c30858b8daa@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, David.

I don't know whether these patches can fix all races.
But since no response from ath9k maintainers/developers,
can you directly pick up these patches via your tree?

Regards.

