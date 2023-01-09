Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390F0661FC4
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjAIIOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjAIIOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:14:41 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB676457;
        Mon,  9 Jan 2023 00:14:37 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 1BED758957AAE; Mon,  9 Jan 2023 09:14:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5306160BC6B00;
        Mon,  9 Jan 2023 09:14:34 +0100 (CET)
Date:   Mon, 9 Jan 2023 09:14:34 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jiri Slaby <jirislaby@kernel.org>
cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Suma Hegde <suma.hegde@amd.com>, Chen Yu <yu.c.chen@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kees Cook <keescook@chromium.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Qing <wangqing@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
In-Reply-To: <07786498-2209-3af0-8d68-c34427049947@kernel.org>
Message-ID: <po9s7-9snp-9so3-n6r5-qs217ss1633o@vanv.qr>
References: <20220818004357.375695-1-stephen@networkplumber.org> <07786498-2209-3af0-8d68-c34427049947@kernel.org>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Monday 2023-01-09 08:04, Jiri Slaby wrote:
> On 18. 08. 22, 2:43, Stephen Hemminger wrote:
>> DECnet is an obsolete network protocol
>
> this breaks userspace. Some projects include linux/dn.h:
>
>  https://codesearch.debian.net/search?q=include.*linux%2Fdn.h&literal=0
>
> I found Trinity fails to build:
> net/proto-decnet.c:5:10: fatal error: linux/dn.h: No such file or directory
>     5 | #include <linux/dn.h>
>
> Should we provide the above as empty files?

Not a good idea. There may be configure tests / code that merely checks for
dn.h existence without checking for specific contents/defines. If you provide
empty files, this would fail to build:

#include "config.h"
#ifdef HAVE_LINUX_DN_H
#	include <linux/dn.h>
#endif
int main() {
#ifdef HAVE_LINUX_DN_H
	socket(AF_DECNET, 0, DNPROTO_NSP); // or whatever
#else
	...
#endif
}

So, with my distro hat on, outright removing header files feels like the
slightly lesser of two evils. Given the task to port $arbitrary software
between operating systems, absent header files is something more or less
"regularly" encountered, so one could argue we are "trained" to deal with it.
But missing individual defines is a much deeper dive into the APIs and
software to patch it out.
