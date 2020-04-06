Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D279B19FEEE
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDFURG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:17:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:51256 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFURF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 16:17:05 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLYB3-0000rL-Pe; Mon, 06 Apr 2020 22:17:01 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLYB3-000BtZ-HI; Mon, 06 Apr 2020 22:17:01 +0200
Subject: Re: [PATCH] bpf: fix a typo "inacitve" -> "inactive"
To:     Qiujun Huang <hqjagain@gmail.com>, ast@kernel.org
Cc:     kafai@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1585901254-30377-1-git-send-email-hqjagain@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eca9a48a-83f8-8bd8-6e19-fb125a1fb809@iogearbox.net>
Date:   Mon, 6 Apr 2020 22:17:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1585901254-30377-1-git-send-email-hqjagain@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25774/Mon Apr  6 14:53:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 10:07 AM, Qiujun Huang wrote:
> There is a typo, fix it.
> s/inacitve/inactive
> 
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

Applied, thanks!
