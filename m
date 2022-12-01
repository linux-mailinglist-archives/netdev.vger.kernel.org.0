Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9D63EB81
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiLAIrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLAIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:47:20 -0500
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D28EE5E;
        Thu,  1 Dec 2022 00:46:10 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id WMW00002;
        Thu, 01 Dec 2022 16:46:02 +0800
Received: from localhost.localdomain (10.180.206.146) by
 jtjnmail201603.home.langchao.com (10.100.2.3) with Microsoft SMTP Server id
 15.1.2507.12; Thu, 1 Dec 2022 16:46:02 +0800
From:   wangchuanlei <wangchuanlei@inspur.com>
To:     <kuba@kernel.org>
CC:     <echaudro@redhat.com>, <alexandr.lobakin@intel.com>,
        <pabeni@redhat.com>, <pshelar@ovn.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <wangpeihui@inspur.com>,
        <netdev@vger.kernel.org>, <dev@openvswitch.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH v6 net-next] net: openvswitch: Add support to count upcall packets
Date:   Thu, 1 Dec 2022 03:46:01 -0500
Message-ID: <20221201084601.3598586-1-wangchuanlei@inspur.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.180.206.146]
tUid:   20221201164602824ffe32c6994f19eee192ef09416773
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

Hi, Jakub, 

	Thank you for review, the comments below is a little confusing, can you
give a explanation?

Best regards!
wangchuanlei

--------------------------------------------------------
On Wed, 30 Nov 2022 04:15:59 -0500 wangchuanlei wrote:
> +/**
> + *	ovs_vport_get_upcall_stats - retrieve upcall stats
> + *
> + * @vport: vport from which to retrieve the stats
> + * @ovs_vport_upcall_stats: location to store stats

s/ovs_vport_upcall_//

> + *
> + * Retrieves upcall stats for the given device.
> + *
> + * Must be called with ovs_mutex or rcu_read_lock.
> + */
> +void ovs_vport_get_upcall_stats(struct vport *vport, struct ovs_vport_upcall_stats *stats)

