Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8884B218C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348506AbiBKJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:20:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348572AbiBKJUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:20:13 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA65102A
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:20:11 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1nIS60-00GkoZ-MB; Fri, 11 Feb 2022 10:20:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@osmocom.org>)
        id 1nIRxv-004xg7-Qx;
        Fri, 11 Feb 2022 10:11:43 +0100
Date:   Fri, 11 Feb 2022 10:11:43 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v3 1/5] gtp: Allow to create GTP device
 without FDs
Message-ID: <YgYoT4UWw0Efq33K@nataraja>
References: <20220127163749.374283-1-marcin.szycik@linux.intel.com>
 <20220127163900.374645-1-marcin.szycik@linux.intel.com>
 <Yf6nBDg/v1zuTf8l@nataraja>
 <fd23700b-4269-a615-a73d-10476ffaf82d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd23700b-4269-a615-a73d-10476ffaf82d@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Wed, Feb 09, 2022 at 07:04:01PM +0100, Marcin Szycik wrote:
> On 05-Feb-22 17:34, Harald Welte wrote:
> > Hi Marcin, Wojciech,
> > 
> > thanks for the revised patch. In general it looks fine to me.
> > 
> > Do you have a public git tree with your patchset applied?  I'm asking as
> > we do have automatic testing in place at https://jenkins.osmocom.org/ where I
> > just need to specify a remote git repo andit will build this kernel and
> > run the test suite.
> 
> I've created a public fork with our patchset applied, please see [1].

Thanks, I've triggered a build, let's hope it works out.  Results should
be at https://jenkins.osmocom.org/jenkins/job/ttcn3-ggsn-test-kernel-git/20/
and detailed logs at https://jenkins.osmocom.org/jenkins/job/ttcn3-ggsn-test-kernel-git/20/console

The same testsuite executed  against master can be seen at
https://jenkins.osmocom.org/jenkins/job/ttcn3-ggsn-test-kernel-latest-torvalds/
[the high amount of test cases failing is due to the lack of IPv6 support in the kernel GTP].

Let's hope your forked repo renders identical test results to upstream!

Regards,
	Harald
-- 
- Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
