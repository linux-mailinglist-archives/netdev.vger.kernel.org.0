Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9E25852A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIABfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIABfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:35:31 -0400
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca [IPv6:2620:101:f000:4901:c5c:0:caff:e12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7DFC061757;
        Mon, 31 Aug 2020 18:35:31 -0700 (PDT)
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 46D4F4611C8; Mon, 31 Aug 2020 21:35:19 -0400 (EDT)
Date:   Mon, 31 Aug 2020 21:35:19 -0400
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] VRRP not working on i40e X722 S2600WFT
Message-ID: <20200901013519.rfmavd4763gdzw4r@csclub.uwaterloo.ca>
References: <20200827183039.hrfnb63cxq3pmv4z@csclub.uwaterloo.ca>
 <20200828155616.3sd2ivrml2gpcvod@csclub.uwaterloo.ca>
 <20200831103512.00001fab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831103512.00001fab@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 10:35:12AM -0700, Jesse Brandeburg wrote:
> Thanks for the report Lennart, I understand your frustration, as this
> should probably work without user configuration.
> 
> However, please give this command a try:
> ethtool --set-priv-flags ethX disable-source-pruning on

Hmm, our 4.9 kernel is just a touch too old to support that.  And yes
that really should not require a flag to be set, given the card has no
reason to ever do that pruning.  There is no justification you could
have for doing it in the first place.

-- 
Len Sorensen
