Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FF064CE74
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiLNQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiLNQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:56:09 -0500
X-Greylist: delayed 584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Dec 2022 08:56:05 PST
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA7615FFF
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:56:05 -0800 (PST)
Message-ID: <7a1a4af9-bdb1-cd8d-0b7e-8d6fe9cdc0ed@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1671036378;
        bh=kZvwkM0oPoLelxbf+s/tPphVuErvHalUK6ZkfbDP1M0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=cm1LNeqKQgicSN5wHsMC2PT3HIIC1AFaRN3uzry17Tdm2BAaDu+b6ifV+KnCmpMJp
         ga2s1ph1gsLvWCiAzzR2NTpyzNwH0Os8zMHEGczEn0UKwdbR4boLrSNC72EPEYbEEq
         bRI93Ji6gxd7Wv0cAdTO6DD9l+osKfgs/ijGC8z624DYSmIKzOyihC5+ARQLRMDzB9
         LDwR9obyM9gyUpRxY24ejLXbZwMA2AtcW9vFuB6X4orlclFUm1lUDkCa7wW+MjAwph
         91nlKjy8SgkFwfArJuVHXOPcuIuChayAIWDGU3dLyMsWbpEdgTzmzOKzlTMFUZ0gMI
         r+x7fq+X8eKDA==
Date:   Wed, 14 Dec 2022 17:46:16 +0100
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] iproute2 6.1 release
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20221214082705.5d2c2e7f@hermes.local>
From:   Nick <vincent@systemli.org>
In-Reply-To: <20221214082705.5d2c2e7f@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The naming changed to "iproute2-v6.1.0.tar.gz" (so the link is wrong)?

On 12/14/22 17:27, Stephen Hemminger wrote:
> This is the release of iproute2 corresponding to the 6.1 kernel.
> Nothing major; lots of usual set of small fixes.
>
> Download:
>      https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.1.tar.gz
>
> Repository for current release
>      https://github.com/shemminger/iproute2.git
>      git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
>
> And future release (net-next):
>      git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
>
> Contributions:
>
> Andrea Claudi (4):
>        man: ss.8: fix a typo
>        testsuite: fix build failure
>        genl: remove unused vars in Makefile
>        json: do not escape single quotes
>
> Benjamin Poirier (1):
>        ip-monitor: Do not error out when RTNLGRP_STATS is not available
>
> Daniel Xu (1):
>        ip-link: man: Document existence of netns argument in add command
>
> David Ahern (4):
>        Update kernel headers
>        Update kernel headers
>        Update kernel headers
>        Update kernel headers
>
> Emeel Hakim (2):
>        macsec: add Extended Packet Number support
>        macsec: add user manual description for extended packet number feature
>
> Eyal Birger (2):
>        ip: xfrm: support "external" (`collect_md`) mode in xfrm interfaces
>        ip: xfrm: support adding xfrm metadata as lwtunnel info in routes
>
> Hangbin Liu (5):
>        ip: add NLM_F_ECHO support
>        libnetlink: add offset for nl_dump_ext_ack_done
>        tc/tc_monitor: print netlink extack message
>        rtnetlink: add new function rtnl_echo_talk()
>        ip: fix return value for rtnl_talk failures
>
> Ido Schimmel (1):
>        iplink_bridge: Add no_linklocal_learn option support
>
> Jacob Keller (4):
>        devlink: use dl_no_arg instead of checking dl_argc == 0
>        devlink: remove dl_argv_parse_put
>        mnlg: remove unnused mnlg_socket structure
>        utils: extract CTRL_ATTR_MAXATTR and save it
>
> Jiri Pirko (6):
>        devlink: expose nested devlink for a line card object
>        devlink: load port-ifname map on demand
>        devlink: fix parallel flash notifications processing
>        devlink: move use_iec into struct dl
>        devlink: fix typo in variable name in ifname_map_cb()
>        devlink: load ifname map on demand from ifname_map_rev_lookup() as well
>
> Junxin Chen (1):
>        dcb: unblock mnl_socket_recvfrom if not message received
>
> Lahav Schlesinger (1):
>        libnetlink: Fix memory leak in __rtnl_talk_iov()
>
> Lai Peter Jun Ann (2):
>        tc_util: Fix no error return when large parent id used
>        tc_util: Change datatype for maj to avoid overflow issue
>
> Matthieu Baerts (4):
>        ss: man: add missing entries for MPTCP
>        ss: man: add missing entries for TIPC
>        ss: usage: add missing parameters
>        ss: re-add TIPC query support
>
> Michal Wilczynski (1):
>        devlink: Fix setting parent for 'rate add'
>
> Nicolas Dichtel (1):
>        link: display 'allmulti' counter
>
> Paolo Lungaroni (1):
>        seg6: add support for flavors in SRv6 End* behaviors
>
> Roi Dayan (1):
>        tc: ct: Fix invalid pointer dereference
>
> Stephen Hemminger (14):
>        uapi: update from 6.1 pre rc1
>        u32: fix json formatting of flowid
>        tc_stab: remove dead code
>        uapi: update for in.h and ip.h
>        remove #if 0 code
>        tc: add json support to size table
>        tc: put size table options in json object
>        tc/basic: fix json output filter
>        iplink: support JSON in MPLS output
>        tc: print errors on stderr
>        ip: print mpls errors on stderr
>        tc: make prefix const
>        man: add missing tc class show
>        6.1.0
>
> Vincent Mailhol (1):
>        iplink_can: add missing `]' of the bitrate, dbitrate and termination arrays
>
> Vladimir Oltean (1):
>        ip link: add sub-command to view and change DSA conduit interface
>
