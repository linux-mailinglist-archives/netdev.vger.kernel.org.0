Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133A423076F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgG1KPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:15:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:42900 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbgG1KPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:15:15 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Mdb-0000Dj-Ue; Tue, 28 Jul 2020 12:15:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Mdb-000C7q-KL; Tue, 28 Jul 2020 12:15:11 +0200
Subject: Re: [PATCH v3 bpf-next] fold test_current_pid_tgid_new_ns into
 test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>, netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org
References: <20200723015447.42958-1-cneirabustos@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <542a5d08-b497-81df-4621-7372a57b71db@iogearbox.net>
Date:   Tue, 28 Jul 2020 12:15:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200723015447.42958-1-cneirabustos@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25886/Mon Jul 27 16:48:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 3:54 AM, Carlos Neira wrote:
> Changes from V2:
>   - Test not creating a new namespace has been included in test_progs.
>   - Test creating a new pid namespace has been added as a standalone test.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

In your commit message you only have the version change but no proper writeup
for the patch itself (e.g. what it does & why it's needed). Please fix, thx.
