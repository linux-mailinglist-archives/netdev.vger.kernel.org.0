Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B49FE10A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfKOPTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:19:08 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:10909 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfKOPTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:19:07 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAFFIxUn023083;
        Fri, 15 Nov 2019 07:19:00 -0800
Date:   Fri, 15 Nov 2019 20:40:47 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 2/2] cxgb4: add TC-MATCHALL classifier
 ingress offload
Message-ID: <20191115151046.GA14367@chelsio.com>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <418c2bbf879fa75a8a3170d8523235f9b16af595.1573818409.git.rahul.lakkireddy@chelsio.com>
 <20191115135318.GB2158@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115135318.GB2158@nanopsycho>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 11/15/19, 2019 at 14:53:18 +0100, Jiri Pirko wrote:
> Fri, Nov 15, 2019 at 01:14:21PM CET, rahul.lakkireddy@chelsio.com wrote:
> 
> [...]
> 
> 
> >@@ -26,9 +37,13 @@ struct cxgb4_tc_matchall {
> > };
> > 
> > int cxgb4_tc_matchall_replace(struct net_device *dev,
> >-			      struct tc_cls_matchall_offload *cls_matchall);
> >+			      struct tc_cls_matchall_offload *cls_matchall,
> >+			      bool ingress);
> > int cxgb4_tc_matchall_destroy(struct net_device *dev,
> >-			      struct tc_cls_matchall_offload *cls_matchall);
> >+			      struct tc_cls_matchall_offload *cls_matchall,
> >+			      bool ingress);
> >+int cxgb4_tc_matchall_stats(struct net_device *dev,
> >+			    struct tc_cls_matchall_offload *cls_matchall);
> 
> Hmm, you only add stats function in this second patch. Does that mean
> you don't care for stats in egress?
> From looking at cxgb_setup_tc_matchall() looks like I'm right.
> Why?
> 

We're currently missing support to fetch these stats from hardware/
firmware on egress side. So, I could only implement it for the ingress
side for now.

> > 
> > int cxgb4_init_tc_matchall(struct adapter *adap);
> > void cxgb4_cleanup_tc_matchall(struct adapter *adap);
> >-- 
> >2.24.0
> >

Thanks,
Rahul
