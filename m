Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7BC8DF91
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfHNU7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:59:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:42874 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbfHNU7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:59:02 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hy0MG-00047Q-Go; Wed, 14 Aug 2019 22:59:00 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hy0MG-000KxW-7F; Wed, 14 Aug 2019 22:59:00 +0200
Subject: Re: [PATCH bpf-next] tools: bpftool: compile with $(EXTRA_WARNINGS)
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190814113724.20884-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9d404595-88fe-dc06-33f0-9c8d513deb7b@iogearbox.net>
Date:   Wed, 14 Aug 2019 22:58:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190814113724.20884-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25541/Wed Aug 14 10:26:08 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 1:37 PM, Quentin Monnet wrote:
> Compile bpftool with $(EXTRA_WARNINGS), as defined in
> scripts/Makefile.include, and fix the new warnings produced.
> 
> Simply leave -Wswitch-enum out of the warning list, as we have several
> switch-case structures where it is not desirable to process all values
> of an enum.
> 
> Remove -Wshadow from the warnings we manually add to CFLAGS, as it is
> handled in $(EXTRA_WARNINGS).
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!
