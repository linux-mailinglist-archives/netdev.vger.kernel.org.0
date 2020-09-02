Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D9A25ADFC
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgIBO4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:56:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:38062 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgIBO4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:56:30 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUBY-0001W5-Gd; Wed, 02 Sep 2020 16:56:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDUBY-000Urm-Ay; Wed, 02 Sep 2020 16:56:28 +0200
Subject: Re: [PATCH bpf-next v4 0/2] bpf: avoid iterating duplicated files for
 task_file iterator
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com
References: <20200902023112.1672735-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b14d7e6f-5b55-0132-b9b6-613d5ed138d2@iogearbox.net>
Date:   Wed, 2 Sep 2020 16:56:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200902023112.1672735-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 4:31 AM, Yonghong Song wrote:
[...]
>    v3 -> v4:
>      - avoid using empty string in the CHECK macro. (Andrii)

Applied, thanks!
