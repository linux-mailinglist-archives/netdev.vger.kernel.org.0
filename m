Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A776DCA13E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbfJCPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:39:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:50702 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfJCPjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:39:39 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iG3Ca-0005Qn-5h; Thu, 03 Oct 2019 17:39:36 +0200
Date:   Thu, 3 Oct 2019 17:39:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     shuah@kernel.org, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/2] selftest/bpf: remove warns for
 enable_all_controllers
Message-ID: <20191003153935.GA18067@pc-63.home>
References: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25591/Thu Oct  3 10:30:38 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 03:04:02PM +0300, Ivan Khoronzhuk wrote:
> This micro series fixes annoying warn described in patches
> while samples/bpf build. Second patch fixes new warn that
> comes after fixing warn of first patch, that was masked.
> 
> Ivan Khoronzhuk (2):
>   selftests/bpf: add static to enable_all_controllers()
>   selftests/bpf: correct path to include msg + path
> 
>  tools/testing/selftests/bpf/cgroup_helpers.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks!
