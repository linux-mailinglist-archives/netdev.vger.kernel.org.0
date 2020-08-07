Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890F823F1A1
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgHGRDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:03:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:42486 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGRDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:03:30 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45m9-00063H-Jw; Fri, 07 Aug 2020 19:03:26 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45m9-000W3A-EG; Fri, 07 Aug 2020 19:03:25 +0200
Subject: Re: [PATCH] kernel: bpf: delete repeated words in comments
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200807033141.10437-1-rdunlap@infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f8411d64-9265-ced6-d5db-ff6d604a3fb8@iogearbox.net>
Date:   Fri, 7 Aug 2020 19:03:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200807033141.10437-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25897/Fri Aug  7 14:45:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/20 5:31 AM, Randy Dunlap wrote:
> Drop repeated words in kernel/bpf/.
> {has, the}
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org

Applied, thanks!
