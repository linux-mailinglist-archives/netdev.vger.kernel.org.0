Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A8269F4D
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 01:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbfGOXEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 19:04:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:40130 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731690AbfGOXEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 19:04:01 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hnA0l-00050r-8c; Tue, 16 Jul 2019 01:03:59 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hnA0k-000S3H-Nv; Tue, 16 Jul 2019 01:03:59 +0200
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: remove logic duplication in
 test_verifier.c
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Krzesimir Nowak <krzesimir@kinvolk.io>
References: <20190712174441.4089282-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2cec6d13-bfbf-bc04-0245-273a6652900b@iogearbox.net>
Date:   Tue, 16 Jul 2019 01:03:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712174441.4089282-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 7:44 PM, Andrii Nakryiko wrote:
> test_verifier tests can specify single- and multi-runs tests. Internally
> logic of handling them is duplicated. Get rid of it by making single run
> retval/data specification to be a first run spec.
> 
> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
