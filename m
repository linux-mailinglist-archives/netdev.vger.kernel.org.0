Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105E81BFDB
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEMXez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:34:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:60332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEMXez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:34:55 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKT7-0002lW-IZ; Tue, 14 May 2019 01:34:53 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKT7-0009ig-DO; Tue, 14 May 2019 01:34:53 +0200
Subject: Re: [bpf PATCH 0/3] sockmap fixes
To:     John Fastabend <john.fastabend@gmail.com>,
        jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f427b2a0-9407-aeb7-1a65-cf7c339eb452@iogearbox.net>
Date:   Tue, 14 May 2019 01:34:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/13/2019 04:19 PM, John Fastabend wrote:
> A couple fixes for sockmap code. Previously this was bundled with a tls
> fix for unhash() path however, that is becoming a larger fix so push
> these on their own.

Agree, applied, thanks!
