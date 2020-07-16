Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A1222B69
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgGPTDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:03:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:36736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgGPTDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:03:42 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9AR-0007wI-3g; Thu, 16 Jul 2020 21:03:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9AQ-000RfX-Ul; Thu, 16 Jul 2020 21:03:38 +0200
Subject: Re: [PATCH] bpf: bpf.h: drop duplicated words in comments
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
References: <6b9f71ae-4f8e-0259-2c5d-187ddaefe6eb@infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bcee7775-fafd-624c-b55f-73a691bdec9f@iogearbox.net>
Date:   Thu, 16 Jul 2020 21:03:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6b9f71ae-4f8e-0259-2c5d-187ddaefe6eb@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 3:29 AM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Drop doubled words "will" and "attach".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org

Applied & fixed up also tooling infra header, thanks!
