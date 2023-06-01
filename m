Return-Path: <netdev+bounces-7011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7B6719300
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8151C20EEC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE17AA950;
	Thu,  1 Jun 2023 06:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37566FC8
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:07:02 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6D99;
	Wed, 31 May 2023 23:06:59 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aef03.dynamic.kabel-deutschland.de [95.90.239.3])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1686E61E4052B;
	Thu,  1 Jun 2023 08:06:17 +0200 (CEST)
Message-ID: <7cd22df9-6c26-8d8d-b132-9c36756a32e6@molgen.mpg.de>
Date: Thu, 1 Jun 2023 08:06:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Failed delivery to smtp.kernel.org: blocked using dbl.spamhaus.org;
 Error: open resolver; (was: [Intel-wired-lan] [PATCH net-next 0/5] Improve
 the taprio qdisc's relationship with its children)
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
 Pedro Tammela <pctammela@mojatatu.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 intel-wired-lan@lists.osuosl.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Peilin Ye <yepeilin.cs@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>
References: <20230531182758.5u5hv5leobeinxih@skbuf>
 <20230531183323.eozihhbax4tzho6w@skbuf>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230531183323.eozihhbax4tzho6w@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[Cc: postmaster@kernel.org]


Dear Vladimir,


I have not seen this message. Maybe the postmasters know more.


Kind regards,

Paul


Am 31.05.23 um 20:33 schrieb Vladimir Oltean:
> Has anyone received this message? I guess at least vger and kuba@kernel.org
> rejected it, because I got this bounce email:
> 
> kernel.org suspects your message is spam and rejected it.
> 
> Error:
> 550 5.7.350 Remote server returned message detected as spam -> 554 5.7.1
> Service unavailable; Helo command [EUR04-DB3-obe.outbound.protection.outlook.com]
> blocked using dbl.spamhaus.org; Error: open resolver;
> https://www.spamhaus.org/returnc/pub/34.216.226.155
> 
> Message rejected by: smtp.kernel.org
> 
> Interestingly, if I click the link above, it says "This is not due to an
> issue with your email set-up", so I'm not sure what to believe...
> 
> ----- Forwarded message from Vladimir Oltean <vladimir.oltean@nxp.com> -----
> 
> Date: Wed, 31 May 2023 20:39:23 +0300
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> To: netdev@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
>   <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
>   <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
>   <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Vinicius Costa
>   Gomes <vinicius.gomes@intel.com>, linux-kernel@vger.kernel.org,
>   intel-wired-lan@lists.osuosl.org, Muhammad Husaini Zulkifli
>   <muhammad.husaini.zulkifli@intel.com>, Peilin Ye <yepeilin.cs@gmail.com>,
>   Pedro Tammela <pctammela@mojatatu.com>
> Subject: [PATCH net-next 0/5] Improve the taprio qdisc's relationship with
>   its children
> X-Mailer: git-send-email 2.34.1
> 
> Prompted by Vinicius' request to consolidate some child Qdisc
> dereferences in taprio:
> https://lore.kernel.org/netdev/87edmxv7x2.fsf@intel.com/
> 
> I remembered that I had left some unfinished work in this Qdisc, namely
> commit af7b29b1deaa ("Revert "net/sched: taprio: make qdisc_leaf() see
> the per-netdev-queue pfifo child qdiscs"").
> 
> This patch set represents another stab at, essentially, what's in the
> title. Not only does taprio not properly detect when it's grafted as a
> non-root qdisc, but it also returns incorrect per-class stats.
> Eventually, Vinicius' request is addressed too, although in a different
> form than the one he requested (which was purely cosmetic).
> 
> Review from people more experienced with Qdiscs than me would be
> appreciated. I tried my best to explain what I consider to be problems.
> I am deliberately targeting net-next because the changes are too
> invasive for net - they were reverted from stable once already.
> 
> Vladimir Oltean (5):
>    net/sched: taprio: don't access q->qdiscs[] in unoffloaded mode during
>      attach()
>    net/sched: taprio: keep child Qdisc refcount elevated at 2 in offload
>      mode
>    net/sched: taprio: try again to report q->qdiscs[] to qdisc_leaf()
>    net/sched: taprio: delete misleading comment about preallocating child
>      qdiscs
>    net/sched: taprio: dump class stats for the actual q->qdiscs[]
> 
>   net/sched/sch_taprio.c | 60 ++++++++++++++++++++++++------------------
>   1 file changed, 35 insertions(+), 25 deletions(-)
> 

