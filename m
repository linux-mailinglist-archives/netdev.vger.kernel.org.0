Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6950B51BE5D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbiEELtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiEELtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:49:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94B35418C;
        Thu,  5 May 2022 04:46:03 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nmZvk-00074M-Bt; Thu, 05 May 2022 13:46:00 +0200
Date:   Thu, 5 May 2022 13:46:00 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_cthelper 1.0.1 release
Message-ID: <YnO4+K+GhiQ4sKU8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rWWChI9JZTcReYjR"
Content-Disposition: inline
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rWWChI9JZTcReYjR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_cthelper 1.0.1

This release contains only fixes:

* Allow build on uclinux
* Use after free in nfct_helper_free()
* Double free in nfct-helper-add example
* Invalid argument error in nftc-helper-add
* Incorrect netlink message building with multiple nfct helper policies

You can download the new release from:

https://netfilter.org/projects/libnetfilter_cthelper/downloads.html#libnetfilter_cthelper-1.0.1

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--rWWChI9JZTcReYjR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="changes-libnetfilter_cthelper-1.0.1.txt"

Christopher Horler (1):
  src: fix use after free

Felix Janda (1):
  include: Sync with kernel headers

Gustavo Zacarias (1):
  configure: uclinux is also linux

Jan Engelhardt (2):
  build: resolve automake-1.12 warnings
  Update .gitignore

Kevin Cernekee (1):
  Use __EXPORTED rather than EXPORT_SYMBOL

Liping Zhang (3):
  examples: fix double free in nftc-helper-add
  examples: kill the "invalid argument" error in nftc-helper-add
  src: fix incorrect building and parsing of the NFCTH_POLICY_SETX
    attribute


--rWWChI9JZTcReYjR--
