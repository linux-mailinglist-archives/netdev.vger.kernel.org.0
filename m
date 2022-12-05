Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025666420F4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiLEBDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiLEBDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:03:15 -0500
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9600BFCD1;
        Sun,  4 Dec 2022 17:03:13 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id ZDI00008;
        Mon, 05 Dec 2022 09:03:08 +0800
Received: from localhost.localdomain (10.180.204.101) by
 jtjnmail201608.home.langchao.com (10.100.2.8) with Microsoft SMTP Server id
 15.1.2507.16; Mon, 5 Dec 2022 09:03:08 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <simon.horman@corigine.com>
CC:     <kuba@kernel.org>, <echaudro@redhat.com>,
        <alexandr.lobakin@intel.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <wangpeihui@inspur.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH v6 net-next] net: openvswitch: Add support to count upcall packets
Date:   Sun, 4 Dec 2022 20:03:04 -0500
Message-ID: <20221205010304.3957617-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.204.101]
tUid:   20221205090308d87a14f1f4cba43584f08aeb5f98dc0d
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon,
    I see that! Thank you for review! 

Best regards!
wangchuanlei

--------------------------------------------------------
Hi,

On Thu, Dec 01, 2022 at 03:46:01AM -0500, wangchuanlei wrote:
> Hi, Jakub,
> 
> 	Thank you for review, the comments below is a little confusing, can 
> you give a explanation?
> 
> Best regards!
> wangchuanlei
> 
> --------------------------------------------------------
> On Wed, 30 Nov 2022 04:15:59 -0500 wangchuanlei wrote:
> > +/**
> > + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> > + *
> > + * @vport: vport from which to retrieve the stats
> > + * @ovs_vport_upcall_stats: location to store stats
> 
> s/ovs_vport_upcall_//

I believe Jakub is asking for "ovs_vport_upcall_" to be removed.
Or, in other words, to refer to the parameter as "stats", (which matches the name in the function signature below).

> 
> > + *
> > + * Retrieves upcall stats for the given device.
> > + *
> > + * Must be called with ovs_mutex or rcu_read_lock.
> > + */
> > +void ovs_vport_get_upcall_stats(struct vport *vport, struct 
> > +ovs_vport_upcall_stats *stats)
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 

