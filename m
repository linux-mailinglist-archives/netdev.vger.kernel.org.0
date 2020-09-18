Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61F270914
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIRXLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:11:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:48090 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgIRXLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 19:11:08 -0400
X-Greylist: delayed 9585 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 19:11:07 EDT
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJPX0-0005YC-3T; Sat, 19 Sep 2020 01:11:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJPWz-0005lr-Ur; Sat, 19 Sep 2020 01:11:05 +0200
Subject: Re: [PATCH bpf v1] tools/bpftool: support passing BPFTOOL_VERSION to
 make
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f82613f1-9c61-4ccd-0d7c-5cec3b0c1604@iogearbox.net>
Date:   Sat, 19 Sep 2020 01:11:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200917115833.1235518-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25932/Fri Sep 18 15:48:08 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 1:58 PM, Tony Ambardar wrote:
> This change facilitates out-of-tree builds, packaging, and versioning for
> test and debug purposes. Defining BPFTOOL_VERSION allows self-contained
> builds within the tools tree, since it avoids use of the 'kernelversion'
> target in the top-level makefile, which would otherwise pull in several
> other includes from outside the tools tree.
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>

Applied, thanks!
