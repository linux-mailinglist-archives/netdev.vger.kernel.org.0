Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD67F24C06D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgHTOSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:18:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:52042 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHTOSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:18:43 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lOn-0003bT-A8; Thu, 20 Aug 2020 16:18:37 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lOn-000Jl7-1N; Thu, 20 Aug 2020 16:18:37 +0200
Subject: Re: [PATCH bpf-next] libbpf: simplify the return expression of
 build_map_pin_path()
To:     Xu Wang <vulab@iscas.ac.cn>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200819025324.14680-1-vulab@iscas.ac.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <720bda25-0fa9-dc17-ac9c-2c96a4ab0988@iogearbox.net>
Date:   Thu, 20 Aug 2020 16:18:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200819025324.14680-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25905/Thu Aug 20 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 4:53 AM, Xu Wang wrote:
> Simplify the return expression.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied, thanks!
