Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23B104E9E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUI7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:59:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:37476 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUI7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:59:07 -0500
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXiIr-0002uy-MS; Thu, 21 Nov 2019 09:59:05 +0100
Date:   Thu, 21 Nov 2019 09:59:05 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf-next 0/2] selftests: bpftool: skip build tests if not
 in tree
Message-ID: <20191121085905.GD31576@pc-11.home>
References: <20191119105010.19189-1-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119105010.19189-1-quentin.monnet@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25639/Wed Nov 20 11:02:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 10:50:08AM +0000, Quentin Monnet wrote:
> The build test script for bpftool attempts to detect the toplevel path of
> the kernel repository and attempts to build bpftool from there.
> 
> If it fails to find the correct directory, or if bpftool files are missing
> for another reason (e.g. kselftests built on a first machine and copied
> onto another, without bpftool sources), then it is preferable to skip the
> tests entirely rather than dumping useless error messages.
> 
> The first patch moves the EXIT trap in the script lower down in the code,
> to avoid tampering with return value on early exits at the beginning of the
> script; then the second patch makes sure that we skip the build tests if
> bpftool's Makefile is not found at its expected location.
> 
> Jakub Kicinski (1):
>   selftests: bpftool: skip the build test if not in tree
> 
> Quentin Monnet (1):
>   selftests: bpftool: set EXIT trap after usage function
> 
>  .../selftests/bpf/test_bpftool_build.sh       | 30 +++++++++++--------
>  1 file changed, 17 insertions(+), 13 deletions(-)

Applied, thanks!
