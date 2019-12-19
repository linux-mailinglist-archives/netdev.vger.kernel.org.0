Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47605126FB3
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLSV02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:26:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:60496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSV02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:26:28 -0500
Received: from 31.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.31] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii3JS-0005a8-Jf; Thu, 19 Dec 2019 22:26:26 +0100
Date:   Thu, 19 Dec 2019 22:26:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bpf: Remove unnecessary assertion on fp_old
Message-ID: <20191219212626.GA19344@pc-9.home>
References: <20191219175735.19231-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219175735.19231-1-pakki001@umn.edu>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:57:35AM -0600, Aditya Pakki wrote:
> The two callers of bpf_prog_realloc - bpf_patch_insn_single and
> bpf_migrate_filter dereference the struct fp_old, before passing
> it to the function. Thus assertion to check fp_old is unnecessary
> and can be removed.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied, thanks!
