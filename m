Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9789856BFA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfFZObB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:31:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:44276 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFZObA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:31:00 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8ws-0000Ts-J0; Wed, 26 Jun 2019 16:30:58 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hg8ws-000VN7-CF; Wed, 26 Jun 2019 16:30:58 +0200
Subject: Re: [PATCH bpf] tools: bpftool: use correct argument in cgroup errors
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        alexei.starovoitov@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, guro@fb.com, sdf@google.com,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20190625165631.18928-1-jakub.kicinski@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b1c8e472-6b89-5cb7-3d3e-9397f770a3d0@iogearbox.net>
Date:   Wed, 26 Jun 2019 16:30:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190625165631.18928-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25492/Wed Jun 26 10:00:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 06:56 PM, Jakub Kicinski wrote:
> cgroup code tries to use argv[0] as the cgroup path,
> but if it fails uses argv[1] to report errors.
> 
> Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied, thanks!
