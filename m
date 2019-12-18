Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC39124D17
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLRQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:23:02 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44337 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfLRQXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:23:02 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so2163949iln.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1Wr6Hq1D0eY7mZXGA/t9Sfr06Dg2vH+3A8HP0lswKN8=;
        b=TtI457aTCyIQUDp/1Hn9Jyoa1UwKirm9Xk0hZllLmGx/ZzbGgbgFb2GRTJk/FOMj+r
         fAwsIjB48gBr34WeZ6N3U4+ZaolZGhMzRiTQujsbtdlW8ZUDnIkJUHYiS1005OJv0hh9
         O87N1NWThHwb0pbOEBwOi+wPdCg89nduBy3sgZ1+DBn6ZCcq2vi1VUNQYSYKmbvt96j2
         8dNaAT4yBYB8839gPu/RDc4ai4++c7o6hxWbSDeUPhkuOK+BKHl+/sqZAu2qcGuf4BtW
         Cfckk/M8jhISJlKs0bSA/3HDCl4Ohq4UPwlDIBW34pjYL8Oen4JYAozRbuaLQi0argcc
         sJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1Wr6Hq1D0eY7mZXGA/t9Sfr06Dg2vH+3A8HP0lswKN8=;
        b=iXCXyjaxgczb1AZH29g5F7QMmNyV1ZYvw/Qk4ga6g+3EfY3TB8RCx5/HSWCHLOJmpY
         ZDWRBYk75gShHPIOCzQq/31APE1/rnORWeuiHVG4FOQA4ncHguqasewAzuxbjyrKA+bV
         gwsGutR+WFv0okY+3tR/Kp+y2sC9ncA/7T5H4x5veSxqWh4AKnVpqX9AI5PDErzZ0wG/
         GJcQN9ShtduHcXqyN/CXzpqUY0UbslquwonGf8klrz5yYBMRz6faIj40U2RAiXfQ67H8
         zSU99N3fW/3tZ2CB+ZEx/8QxLP2xm38PVQLvDnBtuGsDA60yJgTJ3PNBZ63UddVIRI+2
         w9Rw==
X-Gm-Message-State: APjAAAUeY3ZmyRdS17mydY2wb1LYD9ZASmDBUXbxin/306BhCrcg511D
        yKcNXoAkIUrN+YqZoITpngk=
X-Google-Smtp-Source: APXvYqyJYwLxItVBOQeflPNVBq35SyOfLAJ0v5qU2S/OQcHcKCf2eZLJVbbLrFjh6bw90/5CwPA8Jw==
X-Received: by 2002:a92:d708:: with SMTP id m8mr2545309iln.244.1576686181273;
        Wed, 18 Dec 2019 08:23:01 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v72sm802414ili.22.2019.12.18.08.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 08:23:00 -0800 (PST)
Date:   Wed, 18 Dec 2019 08:22:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Petr Machata <petrm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Message-ID: <5dfa525bc3674_2dca2afa496f05b86e@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
Subject: RE: [PATCH net-next mlxsw v2 00/10] Add a new Qdisc, ETS
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata wrote:
> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
> transmission selection algorithms: strict priority, credit-based shaper,
> ETS (bandwidth sharing), and vendor-specific. All these have their
> corresponding knobs in DCB. But DCB does not have interfaces to configure
> RED and ECN, unlike Qdiscs.

So the idea here (way back when I did this years ago) is that marking ECN
traffic was not paticularly CPU intensive on any metrics I came up with.
And I don't recall anyone ever wanting to do RED here. The configuration
I usually recommended was to use mqprio + SO_PRIORITY + fq per qdisc. Then
once we got the BPF egress hook we replaced SO_PRIORITY configurations with
the more dynamic BPF action to set it. There was never a compelling perf
reason to offload red/ecn.

But these use cases were edge nodes. I believe this series is mostly about
control path and maybe some light control traffic? This is for switches
not for edge nodes right? I'm guessing because I don't see any performance
analaysis on why this is useful, intuitively it makes sense if there is
a small CPU sitting on a 48 port 10gbps box or something like that.

> 
> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
> transmission selection algorithm can then be modeled by having e.g. TBF or
> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
> placing a DRR Qdisc under the last PRIO band.
> 
> The problem with this approach is that DRR on its own, as well as the
> combination of PRIO and DRR, are tricky to configure and tricky to offload
> to 802.1Qaz-compliant hardware. This is due to several reasons:

I would argue the trick to configure part could be hid behind tooling to
simplify setup. The more annoying part is it was stuck behind the qdisc
lock. I was hoping this would implement a lockless ETS qdisc seeing we
have the infra to do lockless qdiscs now. But seems not. I guess software
perf analysis might show prio+drr and ets here are about the same performance
wise.

offload is tricky with stacked qdiscs though ;)

> 
> - As any classful Qdisc, DRR supports adding classifiers to decide in which
>   class to enqueue packets. Unlike PRIO, there's however no fallback in the
>   form of priomap. A way to achieve classification based on packet priority
>   is e.g. like this:
> 
>     # tc filter add dev swp1 root handle 1: \
> 		basic match 'meta(priority eq 0)' flowid 1:10
> 
>   Expressing the priomap in this manner however forces drivers to deep dive
>   into the classifier block to parse the individual rules.
> 
>   A possible solution would be to extend the classes with a "defmap" a la
>   split / defmap mechanism of CBQ, and introduce this as a last resort
>   classification. However, unlike priomap, this doesn't have the guarantee
>   of covering all priorities. Traffic whose priority is not covered is
>   dropped by DRR as unclassified. But ASICs tend to implement dropping in
>   the ACL block, not in scheduling pipelines. The need to treat these
>   configurations correctly (if only to decide to not offload at all)
>   complicates a driver.
> 
>   It's not clear how to retrofit priomap with all its benefits to DRR
>   without changing it beyond recognition.
> 
> - The interplay between PRIO and DRR is also causing problems. 802.1Qaz has
>   all ETS TCs as a last resort. Switch ASICs that support ETS at all are
>   likely to handle ETS traffic this way as well. However, the Linux model
>   is more generic, allowing the DRR block in any band. Drivers would need
>   to be careful to handle this case correctly, otherwise the offloaded
>   model might not match the slow-path one.

Yep, although cases already exist all over the offload side.

> 
>   In a similar vein, PRIO and DRR need to agree on the list of priorities
>   assigned to DRR. This is doubly problematic--the user needs to take care
>   to keep the two in sync, and the driver needs to watch for any holes in
>   DRR coverage and treat the traffic correctly, as discussed above.
> 
>   Note that at the time that DRR Qdisc is added, it has no classes, and
>   thus any priorities assigned to that PRIO band are not covered. Thus this
>   case is surprisingly rather common, and needs to be handled gracefully by
>   the driver.
> 
> - Similarly due to DRR flexibility, when a Qdisc (such as RED) is attached
>   below it, it is not immediately clear which TC the class represents. This
>   is unlike PRIO with its straightforward classid scheme. When DRR is
>   combined with PRIO, the relationship between classes and TCs gets even
>   more murky.
> 
>   This is a problem for users as well: the TC mapping is rather important
>   for (devlink) shared buffer configuration and (ethtool) counters.
> 
> So instead, this patch set introduces a new Qdisc, which is based on
> 802.1Qaz wording. It is PRIO-like in how it is configured, meaning one
> needs to specify how many bands there are, how many are strict and how many
> are ETS, quanta for the latter, and priomap.
> 
> The new Qdisc operates like the PRIO / DRR combo would when configured as
> per the standard. The strict classes, if any, are tried for traffic first.
> When there's no traffic in any of the strict queues, the ETS ones (if any)
> are treated in the same way as in DRR.
> 
> The chosen interface makes the overall system both reasonably easy to
> configure, and reasonably easy to offload. The extra code to support ETS in
> mlxsw (which already supports PRIO) is about 150 lines, of which perhaps 20
> lines is bona fide new business logic.

Sorry maybe obvious question but I couldn't sort it out. When the qdisc is
offloaded if packets are sent via software stack do they also hit the sw
side qdisc enqueue logic? Or did I miss something in the graft logic that
then skips adding the qdisc to software side? For example taprio has dequeue
logic for both offload and software cases but I don't see that here.

> 
> Credit-based shaping transmission selection algorithm can be configured by
> adding a CBS Qdisc under one of the strict bands (e.g. TBF can be used to a
> similar effect as well). As a non-work-conserving Qdisc, CBS can't be
> hooked under the ETS bands. This is detected and handled identically to DRR
> Qdisc at runtime. Note that offloading CBS is not subject of this patchset.

Any performance data showing how accurate we get on software side? The
advantage of hardware always to me seemed to be precision in the WRR algorithm.
Also data showing how much overhead we get hit with from basic mq case
would help me understand if this is even useful for software or just a
exercise in building some offload logic.

FWIW I like the idea I meant to write an ETS sw qdisc for years with
the expectation that it could get close enough to hardware offload case
for most use cases, all but those that really need <5% tolerance or something.

Thanks!
John

> 
> The patchset proceeds in four stages:
> 
> - Patches #1-#3 are cleanups.
> - Patches #4 and #5 contain the new Qdisc.
> - Patches #6 and #7 update mlxsw to offload the new Qdisc.
> - Patches #8-#10 add selftests for ETS.
> 
> Examples:
> 
> - Add a Qdisc with 6 bands, 3 strict and 3 ETS with 45%-30%-25% weights:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 
> 
> - Tweak quantum of one of the classes of the previous Qdisc:
> 
>     # tc class ch dev swp1 classid 1:4 ets quantum 1000
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 1000 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 
>     # tc class ch dev swp1 classid 1:3 ets quantum 1000
>     Error: Strict bands do not have a configurable quantum.
> 
> - Purely strict Qdisc with 1:1 mapping between priorities and TCs:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets strict 8 priomap 7 6 5 4 3 2 1 0
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 
> 
> - Use "bands" to specify number of bands explicitly. Underspecified bands
>   are implicitly ETS and their quantum is taken from MTU. The following
>   thus gives each band the same weight:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets bands 8 priomap 7 6 5 4 3 2 1 0
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 
> 
> v2:
> - This addresses points raised by David Miller.
> - Patch #4:
>     - sch_ets.c: Add a comment with description of the Qdisc and the
>       dequeuing algorithm.
>     - Kconfig: Add a high-level description to the help blurb.
> 
> v1:
> - No changes, first upstream submission after RFC.
> 
> v3 (internal):
> - This addresses review from Jiri Pirko.
> - Patch #3:
>     - Rename to _HR_ instead of to _HIERARCHY_.
> - Patch #4:
>     - pkt_sched.h: Keep all the TCA_ETS_ constants in one enum.
>     - pkt_sched.h: Rename TCA_ETS_BANDS to _NBANDS, _STRICT to _NSTRICT,
>       _BAND_QUANTUM to _QUANTA_BAND and _PMAP_BAND to _PRIOMAP_BAND.
>     - sch_ets.c: Update to reflect the above changes. Add a new policy,
>       ets_class_policy, which is used when parsing class changes.
>       Currently that policy is the same as the quanta policy, but that
>       might change.
>     - sch_ets.c: Move MTU handling from ets_quantum_parse() to the one
>       caller that makes use of it.
>     - sch_ets.c: ets_qdisc_priomap_parse(): WARN_ON_ONCE on invalid
>       attribute instead of returning an extack.
> - Patch #6:
>     - __mlxsw_sp_qdisc_ets_replace(): Pass the weights argument to this
>       function in this patch already. Drop the weight computation.
>     - mlxsw_sp_qdisc_prio_replace(): Rename "quanta" to "zeroes" and
>       pass for the abovementioned "weights".
>     - mlxsw_sp_qdisc_prio_graft(): Convert to a wrapper around
>       __mlxsw_sp_qdisc_ets_graft(), instead of invoking the latter
>       directly from mlxsw_sp_setup_tc_prio().
>     - Update to follow the _HIERARCHY_ -> _HR_ renaming.
> - Patch #7:
>     - __mlxsw_sp_qdisc_ets_replace(): The "weights" argument passing and
>       weight computation removal are now done in a previous patch.
>     - mlxsw_sp_setup_tc_ets(): Drop case TC_ETS_REPLACE, which is handled
>       earlier in the function.
> - Patch #3 (iproute2):
>     - Add an example output to the commit message.
>     - tc-ets.8: Fix output of two examples.
>     - tc-ets.8: Describe default values of "bands", "quanta".
>     - q_ets.c: A number of fixes in error messages.
>     - q_ets.c: Comment formatting: /*padding*/ -> /* padding */
>     - q_ets.c: parse_nbands: Move duplicate checking to callers.
>     - q_ets.c: Don't accept both "quantum" and "quanta" as equivalent.
> 
> v2 (internal):
> - This addresses review from Ido Schimmel and comments from Alexander
>   Kushnarov.
> - Patch #2:
>     - s/coment/comment in the commit message.
> - Patch #4:
>     - sch_ets: ets_class_is_strict(), ets_class_id(): Constify an argument
>     - ets_class_find(): RXTify
> - Patch #3 (iproute2):
>     - tc-ets.8: some spelling fixes
>     - tc-ets.8: add another example
>     - tc.8: add an ETS to "CLASSFUL QDISCS" section
> 
> v1 (internal):
> - This addresses RFC reviews from Ido Schimmel and Roman Mashak, bugs found
>   by Alexander Petrovskiy and myself, and other improvements.
> - Patch #2:
>     - Expand the explanation with an explicit example.
> - Patch #4:
>     - Kconfig: s/sch_drr/sch_ets/
>     - sch_ets: Reorder includes to be in alphabetical order
>     - sch_ets: ets_quantum_parse(): Rename the return-pointer argument
>       from pquantum to quantum, and use it directly, not going through a
>       local temporary.
>     - sch_ets: ets_qdisc_quanta_parse(): Convert syntax of function
>       argument "quanta" from an array to a pointer.
>     - sch_ets: ets_qdisc_priomap_parse(): Likewise with "priomap".
>     - sch_ets: ets_qdisc_quanta_parse(), ets_qdisc_priomap_parse(): Invoke
>       __nla_validate_nested directly instead of nl80211_validate_nested().
>     - sch_ets: ets_qdisc_quanta_parse(): WARN_ON_ONCE on invalid attribute
>       instead of returning an extack.
>     - sch_ets: ets_qdisc_change(): Make the last band the default one for
>       unmentioned priomap priorities.
>     - sch_ets: Fix a panic when an offloaded child in a bandwidth-sharing
>       band notified its ETS parent.
>     - sch_ets: When ungrafting, add the newly-created invisible FIFO to
>       the Qdisc hash
> - Patch #5:
>     - pkt_cls.h: Note that quantum=0 signifies a strict band.
>     - Fix error path handling when ets_offload_dump() fails.
> - Patch #6:
>     - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function arguments
>       "quanta" and "priomap" from arrays to pointers.
> - Patch #7:
>     - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function argument
>       "weights" from an array to a pointer.
> - Patch #9:
>     - mlxsw/sch_ets.sh: Add a comment explaining packet prioritization.
>     - Adjust the whole suite to allow testing of traffic classifiers
>       in addition to testing priomap.
> - Patch #10:
>     - Add a number of new tests to test default priomap band, overlarge
>       number of bands, zeroes in quanta, and altogether missing quanta.
> - Patch #1 (iproute2):
>     - State motivation for inclusion of this patch in the patcheset in the
>       commit message.
> - Patch #3 (iproute2):
>     - tc-ets.8: it is now December
>     - tc-ets.8: explain inactivity WRT using non-WC Qdiscs under ETS band
>     - tc-ets.8: s/flow/band in explanation of quantum
>     - tc-ets.8: explain what happens with priorities not covered by priomap
>     - tc-ets.8: default priomap band is now the last one
>     - q_ets.c: ets_parse_opt(): Remove unnecessary initialization of
>       priomap and quanta.
> 
> Petr Machata (10):
>   net: pkt_cls: Clarify a comment
>   mlxsw: spectrum_qdisc: Clarify a comment
>   mlxsw: spectrum: Rename MLXSW_REG_QEEC_HIERARCY_* enumerators
>   net: sch_ets: Add a new Qdisc
>   net: sch_ets: Make the ETS qdisc offloadable
>   mlxsw: spectrum_qdisc: Generalize PRIO offload to support ETS
>   mlxsw: spectrum_qdisc: Support offloading of ETS Qdisc
>   selftests: forwarding: Move start_/stop_traffic from mlxsw to lib.sh
>   selftests: forwarding: sch_ets: Add test coverage for ETS Qdisc
>   selftests: qdiscs: Add test coverage for ETS Qdisc
> 
>  drivers/net/ethernet/mellanox/mlxsw/reg.h     |  11 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  21 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
>  .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |   8 +-
>  .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 219 +++-
>  include/linux/netdevice.h                     |   1 +
>  include/net/pkt_cls.h                         |  36 +-
>  include/uapi/linux/pkt_sched.h                |  17 +
>  net/sched/Kconfig                             |  17 +
>  net/sched/Makefile                            |   1 +
>  net/sched/sch_ets.c                           | 828 +++++++++++++++
>  .../selftests/drivers/net/mlxsw/qos_lib.sh    |  46 +-
>  .../selftests/drivers/net/mlxsw/sch_ets.sh    |  67 ++
>  tools/testing/selftests/net/forwarding/lib.sh |  18 +
>  .../selftests/net/forwarding/sch_ets.sh       |  44 +
>  .../selftests/net/forwarding/sch_ets_core.sh  | 300 ++++++
>  .../selftests/net/forwarding/sch_ets_tests.sh | 227 +++++
>  .../tc-testing/tc-tests/qdiscs/ets.json       | 940 ++++++++++++++++++
>  18 files changed, 2732 insertions(+), 71 deletions(-)
>  create mode 100644 net/sched/sch_ets.c
>  create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
>  create mode 100755 tools/testing/selftests/net/forwarding/sch_ets.sh
>  create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_core.sh
>  create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_tests.sh
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.json
> 
> -- 
> 2.20.1
> 


