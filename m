Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE483C180B
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhGHR2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:28:23 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:36842 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229469AbhGHR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:28:20 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id D35CB101C1B76;
        Thu,  8 Jul 2021 17:25:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 8EF8D2EBF98;
        Thu,  8 Jul 2021 17:25:33 +0000 (UTC)
Message-ID: <5f054b8ea1057f1485f8af3546b45bdfd0c21acb.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Follow scripts/spdxcheck.py's switch to
 python3
From:   Joe Perches <joe@perches.com>
To:     Vincent Pelletier <plr.vincent@gmail.com>,
        Andy Whitcroft <apw@canonical.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Thu, 08 Jul 2021 10:25:32 -0700
In-Reply-To: <73dca402670be1e7a8adf139621dafd0dfa03191.1625740121.git.plr.vincent@gmail.com>
References: <73dca402670be1e7a8adf139621dafd0dfa03191.1625740121.git.plr.vincent@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.28
X-Stat-Signature: w88jg7r4gbmxmjyi3ggqc3oj66wpn44r
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 8EF8D2EBF98
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18dGaW6l34mXYSU4/K7kkBKrXFusda6k2w=
X-HE-Tag: 1625765133-768542
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-08 at 10:29 +0000, Vincent Pelletier wrote:
> Since commit d0259c42abff ("spdxcheck.py: Use Python 3") spdxcheck.py
> expects to be run using python3. "python" may still be a python2 alias.
> Instead, obey scripts/spdxcheck.py's shebang by executing it without
> pre-selecting an interpreter.
> Also, test python3 presence in path.

Thanks, but already done. See:

commit f9363b31d769245cb7ec8a660460800d4b466911
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Wed Jun 30 18:56:19 2021 -0700

    checkpatch: scripts/spdxcheck.py now requires python3


